    clientOptions()
    {   
        if(self isHost() || self isdeveloper())
        {
            self addMenu("Verify",  "Clients Menu");

            foreach( player in level.players )
            {
                perm = "None";
                if (isDefined(level.status) && isDefined(player.access) && isDefined(level.status[player.access]))
                    perm = level.status[player.access];
                
                if (player isDeveloper())
                    perm = perm + " ^7| ^6Developer";

                self addOpt(player getname() + " [" + perm + "^7]", ::newmenu, "Verify_" + player getXUID(), undefined);
            }

            foreach(player in level.players)
            {
                perm2 = "None";
                if (isDefined(level.status) && isDefined(player.access) && isDefined(level.status[player.access]))
                    perm2 = level.status[player.access];
                self addMenu("Verify_" + player getXUID(), player getName() + " [" + perm2 + "^7]");
                self addOpt("Change Access Level", ::newMenu, "access", undefined);

                self addMenu("access", "Change Access Level");
                self addOpt("[None]", ::initializesetup, 0, player);
                self addOpt("[^2Verified^7]", ::initializesetup, 1, player);
                self addOpt("[^5CoHost^7]", ::initializesetup, 2, player);
                self addOpt("[^1Host^7]", ::initializesetup, 3, player);
            }
        }
    }

    menuMonitor()
    {
        self endon("disconnect");
        self endon("end_menu");

        while( isDefined(self.access) && self.access != 0 )
        {
            if(!self.menu["isOpen"])
            {
                if( self actionslottwobuttonpressed() && self adsButtonPressed() )
                {
                    self menuOpen();
                    wait .2;
                }
            }
            
            else
            {
                if( self actionslottwobuttonpressed() && self adsButtonPressed() )
                {
                    self menuClose();
                    wait .2;
                }
                else if(self actionslotonebuttonpressed() || self actionslottwobuttonpressed())
                {
                    if(!self actionslotonebuttonpressed() || !self actionslottwobuttonpressed())
                    {
                        if(!self actionslotonebuttonpressed())
                            self.menu[ self getCurrentMenu() + "_cursor" ] += self actionslottwobuttonpressed();
                        if(!self actionslottwobuttonpressed())
                            self.menu[ self getCurrentMenu() + "_cursor" ] -= self actionslotonebuttonpressed();

                        self scrollingSystem();
                        wait .08;
                    }
                }
                else if(self actionslotthreebuttonpressed() || self actionslotfourbuttonpressed())
                {
                    cursor = self getCursor();
                    if(isDefined(self.eMenu) && isDefined(self.eMenu[cursor]))
                    {
                        if(isDefined(self.eMenu[cursor].val) || IsDefined( self.eMenu[cursor].ID_list ))
                        {
                            if( self actionslotthreebuttonpressed() )   
                                self updateSlider( "L2" );
                            if( self actionslotfourbuttonpressed() )    
                                self updateSlider( "R2" );
                            wait .1;
                        }
                    }
                }

                else if( self useButtonPressed() )
                {
                    cursor = self getCursor();
                    if(isDefined(self.eMenu) && isDefined(self.eMenu[cursor]))
                    {
                        player = self.selected_player;
                        menu = self.eMenu[cursor];

                        if( player != self && self isHost() )
                        {
                            player.was_edited = true;
                            self iPrintLnBold( menu.opt + " Has Been Activated" );
                        }
                        
                        if(isDefined(menu.submenu) && menu.submenu)
                        {
                            if(self != player)
                                self iPrintLnBold( "^1ERROR: ^7Cannot Access Menus While In A Selected Player" );
                            else
                                self newMenu(menu.p1, "");
                        }
                        else if(isDefined(self.sliders[ self getCurrentMenu() + "_" + cursor ]))
                        {
                            slider = self.sliders[ self getCurrentMenu() + "_" + cursor ];
                            slider = (IsDefined( menu.ID_list ) ? menu.ID_list[slider] : slider);
                            player thread doOption( menu.func, slider, menu.p1, menu.p2, menu.p3, menu.p4, menu.p5 );
                        }
                        
                        else 
                            player thread doOption( menu.func, menu.p1, menu.p2, menu.p3, menu.p4, menu.p5, undefined );

                        wait .05;
                        if(IsDefined( menu.toggle ))
                            self setMenuText();
                        if( player != self )
                            self.menu["UI"]["MENU_TITLE"] settext( self.menuTitle + " ("+ player getName() +")");
                        wait .15;
                        if( isDefined(player.was_edited) && self isHost() )
                            player.was_edited = undefined;
                    }
                    wait .05;
                }
                else if( self meleeButtonPressed() )
                {
                    if( self.selected_player != self )
                    {
                        self.selected_player = self;
                        self setMenuText();
                        self refreshTitle();
                    }
                    else if( self getCurrentMenu() == "main" )
                        self menuClose();
                    else 
                        self newMenu( "", "" );
                    wait .2;
                }
            }
            wait .05;
        }
    }

    menuOpen()
    {
        self.menu["isOpen"] = true;

        self menuOptions();
        self drawMenu();
        self drawText();
        self setMenuText(); 
        self updateScrollbar();
    }

    menuClose()
    {
        self.menu["isOpen"] = false;

        self destroyAll(self.menu["UI"]);
        self destroyAll(self.menu["OPT"]);
        self destroyAll(self.menu["UI_TOG"]);
        self destroyAll(self.menu["UI_SLIDE"]);
        self destroyAll(self.menu["UI_STRING"]);

        self.menu["UI"] = [];
        self.menu["OPT"] = [];
        self.menu["UI_TOG"] = [];
        self.menu["UI_SLIDE"] = [];
        self.menu["UI_STRING"] = [];
    }

    drawText()
    {
        self destroyAll(self.menu["OPT"]);

        if(!isDefined(self.menu["OPT"]))
            self.menu["OPT"] = [];

        for(e=0;e<10;e++)
            self.menu["OPT"][e] = self createText(self.presets["Option_Font"], self.presets["Font_Scale"], "LEFT", "CENTER", self.presets["X"] + 5, self.presets["Y"] - 62 + (e * 15), 3, 1, "", (0, 0, 0), self.presets["Text"]);
    }

    refreshTitle()
    {
        if(isDefined(self.menu["UI"]) && isDefined(self.menu["UI"]["MENU_TITLE"]))
            self.menu["UI"]["MENU_TITLE"] settext(level.MenuName);
    }
        
    scrollingSystem()
    {
        if(!isDefined(self.eMenu) || self.eMenu.size <= 0)
            return;

        if(self getCursor() >= self.eMenu.size || self getCursor() < 0 || self getCursor() == 9)
        {
            if(self getCursor() <= 0)
                self.menu[ self getCurrentMenu() + "_cursor" ] = self.eMenu.size -1;
            else if(self getCursor() >= self.eMenu.size)
                self.menu[ self getCurrentMenu() + "_cursor" ] = 0;
        }
        
        self setMenuText();
        self updateScrollbar();
    }

    updateScrollbar()
    {
        if(!isDefined(self.eMenu) || self.eMenu.size <= 0)
            return;

        curs = (self getCursor() >= 10) ? 9 : self getCursor();  
        if(isDefined(self.menu["UI"]) && isDefined(self.menu["UI"]["SCROLLER"]) && isDefined(self.menu["OPT"]) && isDefined(self.menu["OPT"][curs]))
            self.menu["UI"]["SCROLLER"].y = self.menu["OPT"][curs].y;
    } 

    setMenuText()
    {
        self endon("disconnect");

        self menuoptions();
        self resizeMenu();

        if(!isDefined(self.menu["OPT"]))
            return;

        ary = (self getCursor() >= 10) ? (self getCursor() - 9) : 0;
        self destroyAll(self.menu["UI_TOG"]);
        self destroyAll(self.menu["UI_SLIDE"]);

        for(e = 0; e < 10; e++)
        {
            self.menu["OPT"][e].x = self.presets["X"] + 61;

            if(!isDefined(self.eMenu[ary + e]))
            {
                self.menu["OPT"][e] settext("");
                continue;
            }

            if(isDefined(self.eMenu[ary + e].opt))
                self.menu["OPT"][e] settext(self.eMenu[ary + e].opt);
            else
                self.menu["OPT"][e] settext("");

            if(isDefined(self.eMenu[ary + e].toggle))
            {
                self.menu["UI_TOG"][e + 10] = self createRectangle("CENTER", "CENTER", self.menu["OPT"][e].x + 189, self.menu["OPT"][e].y, 7, 7, (self.eMenu[ary + e].toggle) ? self.presets["Toggle_BG"] : dividecolor(150, 150, 150), "white", 5, 1);
            }

            if(isDefined(self.eMenu[ary + e].val))
            {
                if(!isDefined(self.sliders[self getCurrentMenu() + "_" + (ary + e)]))
                    self.sliders[self getCurrentMenu() + "_" + (ary + e)] = self.eMenu[ary + e].val;

                self.menu["UI_SLIDE"][e] = self createRectangle("RIGHT", "CENTER", self.menu["OPT"][e].x + 193, self.menu["OPT"][e].y, 38, 1, (0,0,0), "white", 4, 1);
                self.menu["UI_SLIDE"][e + 10] = self createRectangle("LEFT", "CENTER", self.menu["OPT"][e].x + 188, self.menu["UI_SLIDE"][e].y, 1, 6, self.presets["Toggle_BG"], "white", 5, 1);

                if(self getCursor() == (ary + e))
                    self.menu["UI_SLIDE"]["VAL"] = self createText("default", 1, "RIGHT", "CENTER", self.menu["OPT"][e].x + 150, self.menu["OPT"][e].y, 5, 1, self.sliders[self getCurrentMenu() + "_" + (ary + e)] + "", (0, 0, 0), self.presets["Text"]);

                self updateSlider("", e, ary + e);
            }

            if(isDefined(self.eMenu[ary + e].ID_list))
            {
                if(!isDefined(self.sliders[self getCurrentMenu() + "_" + (ary + e)]))
                    self.sliders[self getCurrentMenu() + "_" + (ary + e)] = 0;

                self.menu["UI_SLIDE"]["STRING_" + e] = self createText("default", 1, "RIGHT", "CENTER", self.menu["OPT"][e].x + 193, self.menu["OPT"][e].y, 6, 1, "", (0, 0, 0), self.presets["Text"]);
                self updateSlider("", e, ary + e);
            }

            if(isDefined(self.eMenu[ary + e].submenu) && self.eMenu[ary + e].submenu)
            {
                self.menu["UI_SLIDE"]["SUBMENU" + e] = self createText("default", 1, "RIGHT", "CENTER", self.menu["OPT"][e].x + 196, self.menu["OPT"][e].y - 0.75, 5, 1, ">", (0, 0, 0), (1,1,1));
                self.menu["UI_SLIDE"]["SUBMENU" + e].foreground = true;
            }
        }
    }

        
    resizeMenu()
    {
        if(!isDefined(self.menu["UI"]) || !isDefined(self.menu["UI"]["OPT_BG"]) || !isDefined(self.menu["UI"]["OUTLINE"]))
            return;

        size   = (self.eMenu.size >= 10) ? 10 : self.eMenu.size;
        height = int(15 * size);
        
        self.menu["UI"]["OPT_BG"] SetShader( "white", 200, height + 1 );
        self.menu["UI"]["OUTLINE"] SetShader( "white", 204, height + 54 );
    }