LoadSettings()
{
    self.presets = [];

    self.presets["X"] = 155; // 145
    self.presets["Y"] = -20; // 0

    self.presets["Option_BG"] = dividecolor(0, 0, 0);
    self.presets["Title_BG"] = dividecolor(255, 255, 255); 
    self.presets["Outline_BG"] = dividecolor(0, 0, 0);
    self.presets["Text"] = dividecolor(255, 255, 255);
    self.presets["Option_Font"] = "default";

    #ifdef MW1
    self.presets["Font_Scale"] = 1.4;
    #else
    self.presets["Font_Scale"] = 1;
    #endif

    #ifdef WAW
	self.presets["Toggle_BG"] = dividecolor(230, 150, 80); 
    self.presets["MenuTitle_Color"] = dividecolor(230, 150, 80); 
    self.presets["Scroller_BG"] = dividecolor(230, 150, 80); 
    self.presets["Scroller_Shader"] = "hudsoftline";
    #endif
    
    #ifdef BO1
    self.presets["Toggle_BG"] = dividecolor(45, 114, 178);
    self.presets["MenuTitle_Color"] = dividecolor(45, 114, 178);
    self.presets["Scroller_BG"] = dividecolor(45, 114, 178); 
    self.presets["Scroller_Shader"] = "hudsoftline";
    #endif

    #ifdef BO2
    #ifdef MP
        self.presets["Toggle_BG"] = dividecolor(26, 148, 49);
        self.presets["MenuTitle_Color"] = dividecolor(26, 148, 49);
        self.presets["Scroller_BG"] = dividecolor(26, 148, 49);
        self.presets["Scroller_Shader"] = "line_horizontal";
    #endif
    #ifdef ZM
        self.presets["Toggle_BG"] = dividecolor(26, 148, 49);
        self.presets["MenuTitle_Color"] = dividecolor(26, 148, 49);
        self.presets["Scroller_BG"] = dividecolor(26, 148, 49);
        self.presets["Scroller_Shader"] = "line_horizontal";
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
    #endif

    #ifdef MW3
    self.presets["Toggle_BG"] = dividecolor(255, 0, 0);
    self.presets["MenuTitle_Color"] = dividecolor(255, 0, 0);
    self.presets["Scroller_BG"] = dividecolor(255, 0, 0);
    self.presets["Scroller_Shader"] = "hudsoftline";
    #endif
}

displayVer()
{
    self endon( "disconnect");

    #ifdef MW2 || MW3 || MWR || BO3
    fontScale = 1;
    x = -10;
    y = 10;
    #endif

    #ifdef MW1
    fontScale = 1.4;
    x = 15;
    y = -25;
    #endif

    #ifdef BO1 || BO2
    fontScale = 1.2;
    x = 15;
    y = -25;
    #endif

    #ifdef WAW
    fontScale = 1.2;

    #ifdef XBOX
    x = 15;
    y = -25;
    #else
    x = -10;
    y = 10;
    #endif
    #endif  

    #ifndef BO3
    Instructions = createFontString("objective", fontScale);
    Instructions setPoint("TOPRIGHT", "TOPRIGHT", x, y);
    #else
    Instructions = self hud::CreateFontString("objective", fontScale);
    Instructions hud::SetPoint("TOPRIGHT", "TOPRIGHT", x, y);
    #endif

    Instructions.alpha = 0.5;
    Instructions.hidewheninmenu = true;
    Instructions.hideWhenInKillcam = true;

    #ifndef BO3
        for( ;; )
        {
            #ifdef MW1 || MWR
                #ifdef MWR
                Instructions setsafetext("Paradise");
                #else
                Instructions _settext("Paradise");
                #endif
            #else
            Instructions settext("Paradise");
            #endif

            wait 2;
        }
    #else
    Instructions settextstring("Paradise");
    #endif
}

initstrings()
{
   game["strings"]["pregameover"]       = "Paradise";
   game["strings"]["waiting_for_teams"] = "Paradise";
   game["strings"]["intermission"]      = "Paradise";
   game["strings"]["score_limit_reached"] = "Discord.gg^0/^7ProjectParadise";
   game["strings"]["time_limit_reached"]  = "Discord.gg^0/^7ProjectParadise";
   game["strings"]["draw"]               = "Paradise";
   game["strings"]["round_draw"]         = "Paradise";
   game["strings"]["round_win"]          = "Paradise";
   game["strings"]["round_loss"]         = "Paradise";
   game["strings"]["round_tie"]          = "Paradise";
   game["strings"]["victory"]            = "Paradise";
   game["strings"]["defeat"]             = "Paradise";
   game["strings"]["game_over"]          = "Paradise";
   game["strings"]["halftime"]           = "Paradise";
   game["strings"]["overtime"]            = "Paradise";
   game["strings"]["roundend"]            = "Paradise";
   game["strings"]["side_switch"]         = "Paradise";
}

doWelcomeMessage()
{
    if(level.currentGametype == "dm")
        self iprintlnbold("Welcome ^2" + self.name + " ^7to ^1Paradise FFA!");

    else if(level.currentGametype == "sd")
        self iprintlnbold("Welcome ^2" + self.name + " ^7to ^1Paradise SND!");

    else if(level.currentGametype == "war" || level.currentGametype == "tdm")
        self iprintlnbold("Welcome ^2" + self.name + " ^7to ^1Paradise TDM!");
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
