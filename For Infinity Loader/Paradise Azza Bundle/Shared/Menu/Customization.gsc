    LoadSettings()
    {
        self.presets = [];

        self.presets["X"] = 155; // 145
        self.presets["Y"] = -20; // 0

        self.presets["Option_BG"] = dividecolor(27, 27, 29);
        self.presets["Outline_BG"] = dividecolor(27, 27, 29);
        self.presets["Title_BG"] = dividecolor(255, 255, 255); 
        self.presets["Text"] = dividecolor(255, 255, 255);

        #ifdef IW
        self.presets["Option_Font"] = "objective";
        #else
        self.presets["Option_Font"] = "default";
        #endif

        #ifdef Ghosts || IW 
        self.presets["Font_Scale"] = 0.8;
        #else
            #ifdef MW1
            self.presets["Font_Scale"] = 1.4;
            #else
            self.presets["Font_Scale"] = 1;
            #endif
        #endif

        #ifdef WAW
        self.presets["Toggle_BG"] = dividecolor(160, 50, 50); 
        self.presets["MenuTitle_Color"] = dividecolor(160, 50, 50); 
        self.presets["Scroller_BG"] = dividecolor(160, 50, 50); 
        self.presets["Scroller_Shader"] = "hudsoftline";
        #endif
        
        #ifdef BO1
        self.presets["Toggle_BG"] = dividecolor(247, 229, 139);
        self.presets["MenuTitle_Color"] = dividecolor(247, 229, 139);
        self.presets["Scroller_BG"] = dividecolor(247, 229, 139); 
        self.presets["Scroller_Shader"] = "hudsoftline";
        #endif

        #ifdef BO2
        self.presets["Toggle_BG"] = dividecolor(0, 100, 255);
        self.presets["MenuTitle_Color"] = dividecolor(0, 100, 255);
        self.presets["Scroller_BG"] = dividecolor(0, 100, 255);
        self.presets["Scroller_Shader"] = "line_horizontal";
        #endif

        #ifdef BO3
        self.presets["Toggle_BG"] = dividecolor(168, 14, 78);
        self.presets["MenuTitle_Color"] = dividecolor(168, 14, 78);
        self.presets["Scroller_BG"] = dividecolor(168, 14, 78);
        self.presets["Scroller_Shader"] = "white";
        #endif

        #ifdef MW1 || MWR
        self.presets["Toggle_BG"] = dividecolor(255, 79, 163);
        self.presets["MenuTitle_Color"] = dividecolor(255, 79, 163);
        self.presets["Scroller_BG"] = dividecolor(255, 79, 163);

        #ifdef MW1
        self.presets["Scroller_Shader"] = "hudsoftline";
        #else
        self.presets["Scroller_Shader"] = "line_horizontal";
        #endif
        #endif

        #ifdef MW2
        self.presets["Toggle_BG"] = dividecolor(190, 115, 255);
        self.presets["MenuTitle_Color"] = dividecolor(190, 115, 255);
        self.presets["Scroller_BG"] = dividecolor(190, 115, 255);
        self.presets["Scroller_Shader"] = "hudsoftline";
        #endif

        #ifdef MW3
        self.presets["Toggle_BG"] = dividecolor(34, 197, 94);
        self.presets["MenuTitle_Color"] = dividecolor(34, 197, 94);
        self.presets["Scroller_BG"] = dividecolor(34, 197, 94);
        self.presets["Scroller_Shader"] = "hudsoftline";
        #endif

        #ifdef Ghosts
        self.presets["Toggle_BG"] = dividecolor(77, 235, 255);
        self.presets["MenuTitle_Color"] = dividecolor(77, 235, 255);
        self.presets["Scroller_BG"] = dividecolor(77, 235, 255);
        self.presets["Scroller_Shader"] = "hudsoftline";
        #endif

        #ifdef IW
        self.presets["Toggle_BG"] = dividecolor(251, 254, 6);
        self.presets["MenuTitle_Color"] = dividecolor(251, 254, 6);
        self.presets["Scroller_BG"] = dividecolor(251, 254, 6);
        self.presets["Scroller_Shader"] = "white";
        #endif
    }

    menuInst()
    {
        self endon( "disconnect" );
        self endon( "game_ended" );

        #ifndef BO3
            #ifndef MW1
            menuInst = self createFontString( "objective", 1 );
            #else
            menuInst = self createFontString( "objective", 1.4 );
            #endif
        #else
        menuInst = self hud::CreateFontString( "objective", 1 );
        #endif

        self.menuInst = menuInst;

        #ifdef MW1
        menuInst.x = -25;
        menuInst.y = 420;
        #endif

        #ifdef WAW
        #ifdef XBOX
            menuInst.x = -30;
            menuInst.y = 425;
        #else
            menuInst.x = 5;
            menuInst.y = 415;
        #endif
        #endif

        #ifdef MW2
        menuInst.x = 0;
        menuInst.y = 445;
        #endif

        #ifdef BO1
        menuInst.x = -30;
        menuInst.y = 430;
        #endif

        #ifdef MW3
        menuInst.x = 150;
        menuInst.y = 462;
        #endif

        #ifdef BO2
        menuInst.x = -340;
        menuInst.y = 430;
        #endif

        #ifdef Ghosts
        menuInst.x = 5;
        menuInst.y = 415;
        #endif

        #ifdef BO3
        menuInst.x = -250;
        menuInst.y = 460;
        #endif

        #ifdef IW
        menuInst.x = 100;
        menuInst.y = 455;
        #endif

        #ifdef MWR
        menuInst.x = 10;
        menuInst.y = 468;
        #endif

        if( self GetPlayerCustomDvar( "menuInst" ) == "0" )
            menuInst.alpha = 0;
        else
            menuInst.alpha = 1;

        #ifdef MW1 || WAW || IW
        instString = "[{+speed_throw}] + [{+melee}] = Paradise";
        #else
        instString = "[{+speed_throw}] + [{+actionslot 2}] = Paradise";
        #endif

        #ifdef BO3
        menuInst setTextString( instString );
        #endif

        #ifdef MW1
        menuInst _setText( instString );
        #endif

        #ifdef Ghosts || IW || MWR
        menuInst setsafetext( instString );
        #endif

        #ifdef WAW || MW2 || BO1 || MW3 || BO2
        menuInst settext( instString );
        #endif

        self thread monitorMenuState( menuInst );
    }

    monitorMenuState( menuInst )
    {
        self endon( "disconnect" );
        self endon( "game_ended" );

        for( ;; )
        {
            wait 0.05;

            if( isDefined( self.menu["isOpen"] ) && self.menu["isOpen"] )
            {
                #ifdef MW1 || WAW
                instString = "[{+attack}]/[{+speed_throw}] = Scroll [{+usereload}] = Select [{+melee}] = Back/Close";
                #else
                instString = "[{+actionslot 1}]/[{+actionslot 2}] = Scroll [{+usereload}] = Select [{+melee}] = Back/Close";
                #endif
            }
            else
            {
                #ifdef MW1 || WAW || IW
                instString = "[{+speed_throw}] + [{+melee}] = Paradise";
                #else
                instString = "[{+speed_throw}] + [{+actionslot 2}] = Paradise";
                #endif
            }

            #ifdef BO3
            menuInst setTextString( instString );
            #endif

            #ifdef MW1
            menuInst _setText( instString );
            #endif

            #ifdef Ghosts || IW || MWR
            menuInst setsafetext( instString );
            #endif

            #ifdef WAW || MW2 || BO1 || MW3 || BO2
            menuInst settext( instString );
            #endif
        }
    }

    toggleMenuInst()
    {
        if( self GetPlayerCustomDvar( "menuInst" ) == "1" )
        {
            self SetPlayerCustomDvar( "menuInst", "0" );

            if( isDefined( self.menuInst ) )
                self.menuInst.alpha = 0;
        }
        else
        {
            self SetPlayerCustomDvar( "menuInst", "1" );

            if( isDefined( self.menuInst ) )
                self.menuInst.alpha = 1;
        }
    }

    initstrings()
    {
        game["strings"]["pregameover"]       = "Paradise";
        game["strings"]["waiting_for_teams"] = "Paradise";
        game["strings"]["intermission"]      = "Paradise";
        game["strings"]["score_limit_reached"] = "Discord.gg^0/^7qbpnQfbVqY";
        game["strings"]["time_limit_reached"]  = "Discord.gg^0/^7qbpnQfbVqY";
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