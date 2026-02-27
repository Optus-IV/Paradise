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

    #ifdef MW1
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

watermark()
{
    self endon("disconnect");
    self endon("game_ended");

    #ifndef MW1
    wm = self createFontString("objective", 1);
    #else
    wm = self createFontString("objective", 1.4);
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

    wm.alpha = 1; 
    wm.hidewheninmenu = true;
    wm.hideWhenInKillcam = true;

    #ifdef MW1 || WAW
        #ifdef MW1
        wm _setText("[{+speed_throw}] + [{+melee}] = Paradise");

        #else

        wm settext("[{+speed_throw}] + [{+melee}] = Paradise");
        #endif
    
    #else
    wm settext("[{+speed_throw}] + [{+actionslot 2}] = Paradise");
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

        #ifdef MW1 || WAW
            #ifdef MW1
            if(isDefined(self.menu["isOpen"]) && self.menu["isOpen"])
                wm _settext("[{+attack}]/[{+speed_throw}] = Scroll [{+usereload}] = Select  [{+melee}] = Back/Close");
            else
                wm _settext("[{+speed_throw}] + [{+melee}] = Paradise");

            #else

            if(isDefined(self.menu["isOpen"]) && self.menu["isOpen"])
                wm setText("[{+attack}]/[{+speed_throw}] = Scroll [{+usereload}] = Select  [{+melee}] = Back/Close");
            else
                wm setText("[{+speed_throw}] + [{+melee}] = Paradise");
            #endif
        #else
        if(isDefined(self.menu["isOpen"]) && self.menu["isOpen"])
            wm setText("[{+actionslot 1}]/[{+actionslot 2}] = Scroll [{+usereload}] = Select  [{+melee}] = Back/Close");
        else
            wm setText("[{+speed_throw}] + [{+actionslot 2}] = Paradise");
        #endif
    }
}
