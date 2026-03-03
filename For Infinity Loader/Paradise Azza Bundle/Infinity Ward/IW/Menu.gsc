    logOrigin()
    {
        ilog(self.origin);
    }

    logMapname()
    {
        ilog(getDvar("mapname"));
    }

    logwpn()
    {
        ilog(self getcurrentweapon());
    }
    
    menuOptions()
    {
        player = self.selected_player;        
        menu = self getCurrentMenu();
        
        player_names = [];
        foreach( players in level.players )
            player_names[player_names.size] = players.name;

        switch( menu )
        {
            case "main":
                if(player.access > 0) // Verified
                {
                    self addMenu("main", "Main Menu");
                    //self addOpt("Log Origin", ::logOrigin);
                    //self addOpt("Log Mapname", ::logMapname);
                    //self addOpt("Log WeaponName", ::logwpn);
                    self addOpt("Trickshot Menu", ::newMenu, "ts");
                    self addOpt("Binds Menu", ::newMenu, "sK");
                    self addOpt("Teleport Menu", ::newMenu, "tp");
                    self addOpt("Class Menu", ::newMenu, "class");
                    self addOpt("Afterhits Menu", ::newMenu, "afthit");
                    self addOpt("Killstreak Menu", ::newMenu, "kstrks");
                    self addOpt("Account Menu", ::newMenu, "acc");

                    if(self ishost() || self isDeveloper() || player.access == 2) 
                        self addOpt("Host Options", ::newMenu, "host");
                }
                break;

            case "ts":
                self addMenu("ts", "Trickshot Menu");
                self addToggle("Noclip [{+frag}]", self.NoClipT, ::initNoClip);

                if(level.currentGametype == "dm")
                self addOpt("Go for Two Piece", ::dotwopiece);

                canOpts = "Current;Infinite";
                self addSliderString("Canswaps", canOpts, canOpts, ::SetCanswapMode);

                self addToggle("Instashoots", self.instashoot, ::instashoot);

                self addOpt("Spawn Slide @ Crosshairs", ::slide);

                spawnOptionsActions = "Bounce;Platform;Crate";
                spawnOptionsIDs     = "bounce;platform;crate";
                self addSliderString("Spawn @ Feet", spawnOptionsIDs, spawnOptionsActions, ::doSpawnOption);
                break;

            case "sK":
                self addMenu("sK", "Binds Menu");
                for(a=0;a<6;a++)
                self addOpt("Option " + a);
                break;

            case "tp":
                self addMenu("tp", "Teleport Menu");

                self addOpt("Set Spawn", ::setSpawn);
                self addOpt("Unset Spawn", ::unsetSpawn);
                self addToggle("Save & Load", self.snl, ::saveandload);
                
                tpNames = [];
                tpCoords = [];
                break;

            case "class":
                self addMenu("class", "Class Menu"); 
                self addOpt("Weapons", ::newMenu, "wpns");
                self addOpt("Attachments", ::newMenu, "atchmnts");
                self addOpt("Camos", ::newMenu, "camos");
                self addOpt("Equipment", ::newMenu, "lethals");
                self addOpt("Special Grenades", ::newMenu, "tacticals");
                //self addToggle("Save Loadout", self.saveLoadoutEnabled, ::saveLoadoutToggle);
                self addOpt("Take Current Weapon", ::takeWpn);
                self addOpt("Drop Current Weapon", ::dropWpn);
                //self addToggle("Infinite Equipment", self.infEquipOn, ::toggleInfEquip);
                break;

            case "wpns":
                self addMenu("wpns", "Weapons");

                arIDs = ["iw7_m4_mp","iw7_sdfar_mp","iw7_ar57_mp","iw7_fmg_mp","iw7_ake_mp","iw7_rvn_mp","iw7_vr_mp","iw7_gauss_mp","iw7_m1c_mp"];
                arNames = ["NV4","R3K","KBAR-32","Type-2","Volk","R-VN","X-Eon","G-Rail","M1"];
                self addSliderString("Assault Rifles", arIDs, arNames, ::giveuserweapon);

                smgIDs = ["iw7_erad_mp","iw7_fhr_mp","iw7_crb_mp","iw7_ripper_mp","iw_ump45_mpr","iw7_crdb_mp","iw7_mp28_mp","iw7_tacburst_mp","iw7_arclassic_mp","iw7_ump45c_mp"];
                smgNames = ["Erad","FHR-40","Karma-45","RPR Evo","HVR","VPR","Trencher","Raijin-EMX","OSA","MacTav-45"];
                self addSliderString("Submachine Gune", smgIDs, smgNames, ::giveuserweapon);

                lmgIDs = ["iw7_sdflmg_mp","iw7_chargeshot_c8_mp","iw7_lmg03_mp","iw7_minilmg_mp","iw7_unsalmg_mp"];
                lmgNames = ["R.A.W.","Mauler","Titan","Auger","Atlas"];
                self addSliderString("Lightmachine Guns", lmgIDs, lmgNames, ::giveuserweapon);

                srIDs = ["iw7_kbs_mp+kbsscope_camo","iw7_kbs_mp","iw7_m8_mp+m8scope_camo","iw7_m8_mp","iw7_cheytac_mpr+cheytacrscope_camo","iw7_cheytac_mpr","iw7_m1_mp+m1scope_camo","iw7_m1_mp","iw7_ba50cal_mp+ba50calscope","iw7_ba50cal_mp","iw7_longshot_mp+longshotscope","iw7_longshot_mp","iw7_cheytacc_mp+cheytacscope_camo","iw7_cheytacc_mp"];
                srNames = ["KBS Longbow","Scopeless KBS","EBR-800","Scopeless EBR","Widowmaker","Scopeless Widowmaker","DMR-1","Scopeless DMR","Trek-50","Scopeless Trek-50","Proteus","Scopless Proteus","TF-141","Scopeless TF-141"];
                self addSliderString("Sniper Rifles", srIDs, srNames, ::giveuserweapon);

                sgIDs = ["iw7_devastator_mp","iw7_sonic_mp","iw7_sdfshotty_mp","iw7_spas_mpr","iw7_mod2187_mp","iw7_spasc_mp"];
                sgNames = ["Reaver","Banshee","DCM-8","Rack-9","M.2187","S-Ravage"];
                self addSliderString("Shotguns", sgIDs, sgNames, ::giveuserweapon);

                hgIDs = ["iw7_emc_mp","iw7_nrg_mp","iw7_g18_mpr","iw7_revolver_mp","iw7_udm45_mp","iw7_mag_mp","iw7_g18c_mp"];
                hgNames = ["EMC","Oni","Kendall 44","Hailstorm","UDM","Stallion .44","Hornet"];
                self addSliderString("Handguns", hgIDs, hgNames, ::giveuserweapon);

                lnchrIDs = ["iw7_lockon_mp","iw7_chargeshot_mp","iw7_glprox_mp","iw7_venomx_mp"];
                lnchrNames = ["Spartan SA3","P-LAW","Howitzer","Venom-X"];
                self addSliderString("Launchers", lnchrIDs, lnchrNames, ::giveuserweapon);

                meleeIDs = ["iw7_fists_mp","iw7_knife_mp","iw7_axe_mp","iw7_katana_mp","iw7_nunchucks_mp"];
                meleeNames = ["Fists","Combat Knife","Axe","Katana","Nunchucks"];
                self addSliderString("Melee", meleeIDs, meleeNames, ::giveuserweapon);

                rigIDs = ["iw7_steeldragon_mp","iw7_blackholegun_mp","iw7_penetrationrail_mp","iw7_armmgs_mp","iw7_atomizer_mp","iw7_claw_mp"];
                rigNames = ["Steel Dragon","Gavity Vortex Gun","Ballista EM3","ARM2","Atomizer","Claw"];
                self addSliderString("Combat Rigs", rigIDs, rigNames, ::giveuserweapon);

                miscIDs = ["iw7_uplinkball_mp","iw7_tdefball_mp","sentry_shock_grenade_mp","thorproj_mp","thorproj_tracking_mp","thorproj_zoomed_mp"];
                miscNames = ["Uplink Ball","Drone Ball","Shock Grenade Launcher","THOR Proj 1","THOR Proj 2","THOR Proj 3"];
                self addSliderString("Miscellaneous", miscIDs, miscNames, ::giveuserweapon);
                break;

            case "atchmnts":
        
                break;

            case "camo":

                break;

            case "lethals":
            
                break;

            case "tacticals":

                break;

            case "afthit":
                self addMenu("afthit", "Afterhits Menu");
                for(a=0;a<6;a++)
                self addOpt("Option " + a);
                break;

            case "kstrks":
                self addMenu("kstrks", "Killstreak Menu");
                streakIDs = ["venom", "uav", "dronedrop", "counter_uav", "ball_drone_backup", "drone_hive", "precision_airstrike", "bombardment", "sentry_shock", "jackal", "directional_uav", "thor", "remote_c8", "minijackal", "nuke"];
                streakNames = ["Scarab", "UAV", "Drone Package", "Counter UAV", "Vulture", "Trinity Rocket", "Scorchers", "Bombardment", "Shock Sentry", "Warden", "Advanced UAV", "T.H.O.R", "R-C8", "AP-3X", "De-Atomizer"];
                for(a=0;a<streakNames.size;a++)
                self addOpt(streakNames[a], ::give_killstreak, streakIDs[a]);

                break;

            case "acc":
                self addMenu("acc", "Account Menu");
                self addSliderValue("Prestige", 0, 0, 10, 1, ::setplayerprestige);
                self addOpt("Lvl 55", ::setplayerrank, 55);
                self addOpt("Lvl 1000", ::setplayerrank, 1000);
                self addOpt("Max Weapon Ranks", ::setplayermaxweaponranks);
                self addOpt("Unlock Achievements", ::unlockallachievements);

                break;

            case "host":
                self addMenu("host", "Host Options");
                for(a=0;a<6;a++)
                self addOpt("Option " + a);
                break;
        }   
    }

    drawMenu()
    {
        if(!isDefined(self.menu["UI"]))
            self.menu["UI"] = [];
        if(!isDefined(self.menu["UI_TOG"]))
            self.menu["UI_TOG"] = [];    
        if(!isDefined(self.menu["UI_SLIDE"]))
            self.menu["UI_SLIDE"] = [];
        if(!isDefined(self.menu["UI_STRING"]))
            self.menu["UI_STRING"] = [];    
            
        self.menu["UI"]["MENU_TITLE"] = self createtext("objective", 2, "TOPLEFT", "CENTER", self.presets["X"] + 109, self.presets["Y"] - 105, 5, 1, level.MenuName, self.presets["MenuTitle_Color"]);
        self.menu["UI"]["OPT_BG"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 70, 204, 182, self.presets["Option_BG"], "white", 1, 1);    
        self.menu["UI"]["OUTLINE"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 56.4, self.presets["Y"] - 121.5, 204, 234, self.presets["Outline_BG"], "white", 0, .7); 
        self.menu["UI"]["SCROLLER"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 108, 200, 10, self.presets["Scroller_BG"], self.presets["Scroller_Shader"], 2, 1);
        self resizeMenu();
    }
