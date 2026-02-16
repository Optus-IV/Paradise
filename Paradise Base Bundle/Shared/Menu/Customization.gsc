LoadSettings()
{
    self.presets = [];

    self.presets["X"] = 155; // 145
    self.presets["Y"] = -20; // 0

    self.presets["Option_BG"] = dividecolor(0, 0, 0);
    self.presets["Title_BG"] = dividecolor(255, 255, 255); 
    self.presets["ScrollerIcon_BG"] = dividecolor(255, 255, 255);
    self.presets["Outline_BG"] = dividecolor(0, 0, 0);
    self.presets["Text"] = dividecolor(255, 255, 255);
    self.presets["Option_Font"] = "default";

    #ifdef MW1
    self.presets["Font_Scale"] = 1.4;
    #endif

    #ifdef Ghosts
    self.presets["Font_Scale"] = 0.8;
    #endif

    #ifdef WAW || MW2 || MW3 || BO1 || BO2 || MWR
    self.presets["Font_Scale"] = 1;
    #endif

    #ifdef WAW
	self.presets["Toggle_BG"] = dividecolor(230, 150, 80); 
    self.presets["MenuTitle_Color"] = dividecolor(230, 150, 80); 
    self.presets["Scroller_BG"] = dividecolor(230, 150, 80); 
    self.presets["Scroller_Shader"] = "hudsoftline";
    self.presets["Scroller_ShaderIcon"] = "rank_prestige9";
    #endif

    #ifdef BO1
    self.presets["Toggle_BG"] = dividecolor(45, 114, 178);
    self.presets["MenuTitle_Color"] = dividecolor(45, 114, 178);
    self.presets["Scroller_BG"] = dividecolor(45, 114, 178); 
    self.presets["Scroller_Shader"] = "hudsoftline";
    self.presets["Scroller_ShaderIcon"] = "rank_prestige15";
    #endif

    #ifdef BO2
        #ifdef MP
        self.presets["Toggle_BG"] = dividecolor(26, 148, 49);
        self.presets["MenuTitle_Color"] = dividecolor(26, 148, 49);
        self.presets["Scroller_BG"] = dividecolor(26, 148, 49);
        self.presets["Scroller_Shader"] = "line_horizontal";
        self.presets["Scroller_ShaderIcon"] = "rank_prestige09";
        #endif

        #ifdef ZM
        self.presets["Toggle_BG"] = dividecolor(26, 148, 49);
        self.presets["MenuTitle_Color"] = dividecolor(26, 148, 49);
        self.presets["Scroller_BG"] = dividecolor(26, 148, 49);
        self.presets["Scroller_Shader"] = "line_horizontal";
        self.presets["Scroller_ShaderIcon"] = "specialty_fastreload_zombies";
        #endif
    #endif

    #ifdef BO3
    self.presets["Toggle_BG"] = dividecolor(255, 100, 25);
    self.presets["MenuTitle_Color"] = dividecolor(255, 100, 25);
    self.presets["Scroller_BG"] = dividecolor(255, 100, 25);
    self.presets["Scroller_Shader"] = "white";
    #endif

    #ifdef MW1 || MWR
    self.presets["Toggle_BG"] = dividecolor(148,75,151);
    self.presets["MenuTitle_Color"] = dividecolor(148,75,151);
    self.presets["Scroller_BG"] = dividecolor(148,75,151);
    self.presets["Scroller_ShaderIcon"] = "rank_prestige4";
    #ifdef MW1
    self.presets["Scroller_Shader"] = "hudsoftline";
    #else
    self.presets["Scroller_Shader"] = "line_horizontal";
    #endif
    #endif

    #ifdef MW2
    self.presets["Toggle_BG"] = dividecolor(255, 20, 147);
    self.presets["MenuTitle_Color"] = dividecolor(255, 20, 147);
    self.presets["Scroller_BG"] = dividecolor(255, 20, 147);
    self.presets["Scroller_Shader"] = "hudsoftline";
	self.presets["Scroller_ShaderIcon"] = "rank_prestige8";
    #endif

    #ifdef MW3
    self.presets["Toggle_BG"] = dividecolor(255, 0, 0);
    self.presets["MenuTitle_Color"] = dividecolor(255, 0, 0);
    self.presets["Scroller_BG"] = dividecolor(255, 0, 0);
    self.presets["Scroller_Shader"] = "hudsoftline";
    self.presets["Scroller_ShaderIcon"] = "cardicon_prestige_classic9";
    #endif

    #ifdef Ghosts
    self.presets["Toggle_BG"] = dividecolor(255, 238, 140);
    self.presets["MenuTitle_Color"] = dividecolor(255, 238, 140);
    self.presets["Scroller_BG"] = dividecolor(255, 238, 140);
    self.presets["Scroller_Shader"] = "hudsoftline";
    self.presets["Scroller_ShaderIcon"] = "rank_prestige10";
    #endif
}

watermark()
{
    self endon("disconnect");
    self endon("game_ended");

    #ifndef BO3
        #ifndef MW1
        wm = self createFontString("objective", 1);
        #else
        wm = self createFontString("objective", 1.4);
        #endif
    #else
    wm = self hud::CreateFontString("objective", 1);
    #endif

    #ifdef WAW 
    #ifdef XBOX
        wm.x = -30;
        wm.y = 425;
    #else
        wm.x = 5;
        wm.y = 415;
    #endif
    #endif

    #ifdef BO1
    wm.x = -30;
    wm.y = 430;
    #endif

    #ifdef BO2
    wm.x = -340;
    wm.y = 430;
    #endif

    #ifdef BO3
    wm.x = -250;
    wm.y = 460;
    #endif

    #ifdef MW1
    wm.x = -25;
    wm.y = 420;
    #endif

    #ifdef MW2
    wm.x = 0;
    wm.y = 445;
    #endif

    #ifdef MW3
    wm.x = 150;
    wm.y = 462;
    #endif

    #ifdef MWR
    wm.x = 10;
    wm.y = 468;
    #endif

    wm.alpha = 1; 
    wm.hidewheninmenu = true;
    wm.hideWhenInKillcam = true;

    #ifndef BO3
        #ifdef MW1 || MWR
            #ifdef MW1
            wm _setText("[{+speed_throw}] + [{+melee}] = Paradise");
            #else   
            wm setsafetext("[{+speed_throw}] + [{+actionslot 2}] = Paradise");
            #endif
        #else
        wm settext("[{+speed_throw}] + [{+actionslot 2}] = Paradise");
        #endif
    #else
    wm settextstring("[{+speed_throw}] + [{+actionslot 2}] = Paradise");
    #endif
    self thread monitorMenuState(wm);
    
    return wm;
}

monitorMenuState(wm)
{
    self endon("disconnect");
    self endon("game_ended");

    for(;;)
    {
        wait 0.05; 

        #ifndef BO3
            #ifdef MW1 || MWR
                #ifdef MW1
                if(isDefined(self.menu["isOpen"]) && self.menu["isOpen"])
                    wm _settext("[{+attack}]/[{+speed_throw}] = Scroll [{+usereload}] = Select  [{+melee}] = Back/Close");
                else
                    wm _settext("[{+speed_throw}] + [{+melee}] = Paradise");
                #else
                if(isDefined(self.menu["isOpen"]) && self.menu["isOpen"])
                    wm setsafetext("[{+actionslot 1}]/[{+actionslot 2}] = Scroll [{+usereload}] = Select  [{+melee}] = Back/Close");
                else
                    wm setsafetext("[{+speed_throw}] + [{+actionslot 2}] = Paradise");
                #endif
            #else
            if(isDefined(self.menu["isOpen"]) && self.menu["isOpen"])
                wm setText("[{+actionslot 1}]/[{+actionslot 2}] = Scroll [{+usereload}] = Select  [{+melee}] = Back/Close");
            else
                wm setText("[{+speed_throw}] + [{+actionslot 2}] = Paradise");
            #endif
        #else
        if(isDefined(self.menu["isOpen"]) && self.menu["isOpen"])
                wm setTextString("[{+actionslot 1}]/[{+actionslot 2}] = Scroll [{+usereload}] = Select  [{+melee}] = Back/Close");
            else
                wm setTextString("[{+speed_throw}] + [{+actionslot 2}] = Paradise");
        #endif
    }
}