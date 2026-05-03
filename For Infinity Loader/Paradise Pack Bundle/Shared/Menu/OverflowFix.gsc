    #ifdef MW1
    init_overFlowFix()
    {
        level.overFlowFix_Started = true;
        level.strings             = [];
        
        level.overflowElem = createServerFontString("default",1.5);
        level.overflowElem setText("overflow");   
        level.overflowElem.alpha = 0;
        
        level thread overflowfix_monitor();
    }

    _setText(string)
    {
        self.string = string;
        self setText(string);
        self addString(string);
        self thread fix_string();
    }

    addString(string)
    {
        level.strings[level.strings.size] = string;
        level notify("string_added");
    }

    fix_string()
    {
        self notify("new_string");
        self endon("new_string");

        while(isDefined(self))
        {
            level waittill("overflow_fixed");
            
            if(isDefined(self.string))
            {
                self.hud_amount = 0;
                self _setText(self.string);
            }
        }
    }

    overflowfix_monitor()
    {  
        level endon("game_ended");
        for(;;)
        {

            level waittill("string_added");
            if(level.strings.size >= 10)
            {
                level.overflowElem clearalltextafterhudelem();
                level.overflowElem clearalltextafterhudelem();
                level.overflowElem clearalltextafterhudelem();
                level.strings = [];
                level notify("overflow_fixed");
            }
            wait 0.01; 
        }
    }
    
    #else

    settext_hook(text, nsettext = false) overrides settext
    {
        if(!isDefined(level.strings))
            level.strings = [];
        
        if(!isDefined(level.OverFlowFix))
            level thread overflowfix();

        self.text = text;
        
        if(nsettext)
            self settext(text);
        else
        {
            self notify("stop_TextMonitor");
            self addToStringArray(text);
            self thread watchForOverFlow(text);
        }
    }

    overflowfix()
    {
        if(isDefined(level.OverFlowFix))
            return;
        level.OverFlowFix = true;
        
        level.overflow       = NewHudElem();
        level.overflow.alpha = 0;
        level.overflow settext("marker");

        for(;;)
        {
            level waittill("CHECK_OVERFLOW");
            
            if(level.strings.size >= 45)
            {
                level.overflow ClearAllTextAfterHudElem();
                level.strings = [];
                level notify("FIX_OVERFLOW");
            }
        }
    }

    addToStringArray(text)
    {
        if(!InArray(level.strings, text))
        {
            level.strings[level.strings.size] = text;
            level notify("CHECK_OVERFLOW");
        }
    }

    watchForOverFlow(text)
    {
        self endon("stop_TextMonitor");

        while(isDefined(self))
        {
            if(isDefined(text.size))
                self SetText(text, true);
            else
            {
                self SetText(undefined, true);
                self.label = text;
            }
            
            level waittill("FIX_OVERFLOW");
        }
    }
    #endif