printOrigin()
{
    ilog(self getorigin());
}

printmapname()
{
    ilog(level.currentMapName );
}

menuOptions()
{
    player = self.selected_player;        
    menu = self getCurrentMenu();
    
    player_names = [];

    foreach( players in level.players )
        player_names[player_names.size] = players.name;

    switch(menu)
    {
        case "main":
            if(self.access > 0)
            {
                self addMenu("main", "Main Menu");
                self addOpt("Log mapname", ::printmapname, undefined, undefined);
                self addOpt("Log origin", ::printOrigin, undefined, undefined);
                self addOpt("Trickshot Menu", ::newMenu, "ts", undefined);
                self addOpt("Binds Menu", ::newMenu, "sK", undefined);
                self addOpt("Teleport Menu", ::newMenu, "tp", undefined);
                self addOpt("Class Menu", ::newMenu, "class", undefined);
                self addOpt("Afterhits Menu", ::newMenu, "afthit", undefined);
                self addOpt("Killstreak Menu", ::newMenu, "kstrks", undefined);

                if(self ishost() || self isDeveloper())
                    self addOpt("Host Options", ::newMenu, "host", undefined);
            }
            break;

        case "ts":
            self addMenu("ts", "Trickshot Menu");
            self addToggle("Noclip [{+frag}]", self.NoClip, ::initNoClip);

            if( level.currentGametype == "dm" )
                self addOpt("Go for Two Piece", ::doTwoPiece, undefined, undefined);
            
            canOpts = ["Current", "Infinite"];
            self addSliderString("Canswaps", canOpts, canOpts, ::SetCanswapMode);

            //self addToggle("Instashoots", self.instashoot, ::instashoot);
            self addOpt("Spawn Slide @ Crosshairs", ::slide, undefined, undefined);

            spawnOptionsActions = ["Bounce","Platform","Crate"];
            spawnOptionsIDs     = ["bounce","platform","crate"];
            self addSliderString("Spawn @ Feet", spawnOptionsIDs, spawnOptionsActions, ::doSpawnOption);
            break;

        case "sK":
            self addMenu("sK", "Binds Menu");
            self addOpt("Option 1", ::test, undefined, undefined);
            self addOpt("Option 2", ::test, undefined, undefined);
            self addOpt("Option 3", ::test, undefined, undefined);
            self addOpt("Option 4", ::test, undefined, undefined);
            self addOpt("Option 5", ::test, undefined, undefined);
            break;

        case "tp":
            self addMenu("tp", "Teleport Menu");
            self addOpt("Set Spawn",::setSpawn, undefined, undefined);
            self addOpt("Unset Spawn", ::unsetSpawn, undefined, undefined);
            self addToggle("Save Position", self.posSaved, ::savepos);
            self addOpt("Load Saved Position", ::loadpos, undefined, undefined);

            if( level.currentMapName == "mp_urban" )
            {
                tpNames = [ "Diaylser Roof", "Burning Roof", "Bridge" ];
                tpCoords = [
                    (2450.33, -4818.56, 1288.13),
                    (2840.32, -14859.1, 2528.13),
                    (-1059.83, -11946.2, 682.125)
                ];
            }

            else if( level.currentMapName == "mp_firingrange2" )
            {
                tpNames = [ "Fake Wall" ];
                tpCoords = [
                    (-984.138, 2770.91, 352.125)
                ];
            }

            else if( level.currentMapName == "mp_gridlock" )
            {
                tpNames = [ "Skyscraper", "Rooftop 1", "Rooftop 2" ];
                tpCoords = [
                    (-6050.89, -1504.37, 5248.13),
                    (-3942.97, 2507.15, 3150.16),
                    (5346.97, -1371.38, 1561.13)
                ];
            }

            else if( level.currentMapName == "mp_hacienda" )
            {
                tpNames = [ "Top of Ridge" ];
                tpCoords = [
                    (3863.79, 16918.8, 2300.19)
                ];
            }

            else if( level.currentMapName == "mp_icebreaker" )
            {
                tpNames = [ "Ship Crane", "Top of Ship", "Sub Fin", "Cliff" ];
                tpCoords = [
                    (-6925.67, -5941.42, 1536.13),
                    (-4416.57, -4158.66, 2440.34),
                    (-5834.78, 6017.78, 439.146),
                    (8755.7, 9489.74, 4558.17)
                ];
            }

            else if( level.currentMapName == "mp_morocco" )
            {
                tpNames = [ "OOM Wall" ];
                tpCoords = [
                    (3404.08, 3542.47, 504.125)
                ];
            }

            else if( level.currentMapName == "mp_silo" )
            {
                tpNames = [ "Silo Roof 1", "Silo Roof 2", "Undermap" ];
                tpCoords = [
                    (-5707.78, -13806.4, 3228.71),
                    (-6413.69, -4671.71, 2233.13),
                    (-10254.5, -7305.75, 184.056)
                ];
            }

            else if( level.currentMapName == "mp_seaside" )
            {
                tpNames = [ "Bridge Spot" ];
                tpCoords = [
                    (3322.95, -1148.41, 584.125)
                ];
            }

            else if( level.currentMapName == "" )
            {
                tpNames = [];
                tpCoords = [

                ];
            }

            else if( level.currentMapName == "" )
            {
                tpNames = [];
                tpCoords = [

                ];
            }

            break;

        case "class":
            self addMenu("class", "Class Menu");
            self addOpt("Weapons", ::newMenu, "wpns", undefined);
            self addOpt("Attachments", ::test, undefined, undefined);
            self addOpt("Camos", ::test, undefined, undefined);
            self addOpt("Lethals", ::test, undefined, undefined);
            self addOpt("Tacticals", ::test, undefined, undefined);
            //self addDvarToggle("Save Loadout", "loadoutSaved", ::test);
            self addOpt("Take Weapon", ::takeWpn, undefined, undefined);
            self addOpt("Drop Weapon", ::dropWpn, undefined, undefined);
            break;

        case "wpns":
            self addMenu("wpns", "Weapons");

            arIDs = ["ar_accurate_t8","ar_damage_t8","ar_modular_t8","ar_stealth_t8","ar_fastfire_t8","ar_standard_t8","ar_galil_t8","ar_peacekeeper_t8","ar_an94_t8","ar_doublebarrel_t8"];
            arNames = ["ICR-7","Rampart 17","KN-57","VAPR-XKG","Maddox RFB","SWAT RFT","Grav","Peacekeeper","AN-94","Doublecross"];
            self addsliderstring("Assault Rifles", arIDs, arNames, ::giveUserWeapon);

            smgIDs = ["smg_standard_t8","smg_accurate_t8","smg_fastfire_t8","smg_capacity_t8","smg_handling_t8","smg_fastburst_t8","smg_folding_t8","smg_vmp_t8","smg_minigun_t8"];
            smgNames = ["MX9","GKS","Spitfire","Cordite","SAUG 9mm","Daemon 3XB","Switchblade X9","VMP","Micromg 9mm"];
            self addsliderstring("Submachine Guns", smgIDs, smgNames, ::giveUserWeapon);

            trIDs = ["tr_powersemi_t8","tr_midburst_t8","tr_longburst_t8","tr_flechette_t8","tr_damageburst_t8"];
            trNames = ["Auger DMR","ABR 223","Swordfish","S6 Stingray","M16"];
            self addsliderstring("Tactical Rifles", trIDs, trNames, ::giveUserWeapon);

            lmgIDs = ["lmg_standard_t8","lmg_spray_t8","lmg_heavy_t8","lmg_stealth_t8"];
            lmgNames = ["Titan","Hades","VKM 750","Tigershark"];
            self addsliderstring("Light Machine Guns", lmgIDs, lmgNames, ::giveUserWeapon);

            srIDs = ["sniper_powerbolt_t8","sniper_fastrechamber_t8","sniper_powersemi_t8","sniper_quickscope_t8","sniper_mini14_t8","sniper_locus_t8","sniper_damagesemi_t8"];
            srNames = ["Paladin HB50","Outlaw","SDM","Koshka","Vendetta","Locus","Havelina AA50"];
            self addsliderstring("Sniper Rifles", srIDs, srNames, ::giveUserWeapon);

            pstlIDs = ["pistol_standard_t8","pistol_burst_t8","pistol_revolver_t8","pistol_fullauto_t8"];
            pstlNames = ["Strife","RK7 Garrison","Mozu","KAP-45"];
            self addsliderstring("Pistols", pstlIDs, pstlNames, ::giveUserWeapon);

            sgIDs = ["shotgun_pump_t8","shotgun_semiauto_t8","shotgun_fullauto_t8","shotgun_precision_t8"];
            sgNames = ["MOG 12","SG12","Rampage","Argus"];
            self addsliderstring("Shotguns", sgIDs, sgNames, ::giveUserWeapon);

            lnchrIDs = ["launcher_standard_t8"];
            lnchrNames = ["Hellion Salvo"];
            self addsliderstring("Launchers", lnchrIDs, lnchrNames, ::giveUserWeapon);

            meleeIDs = ["knife_loadout","melee_secretsanta_t8","melee_slaybell_t8","melee_demohammer_t8","melee_coinbag_t8","melee_club_t8","melee_cutlass_t8","melee_stopsign_t8","melee_zombiearm_t8","melee_actionfigure_t8","melee_amuletfist_t8"];
            meleeNames = ["Combat Knife","Secret Santa","Slay Bell","Home Wrecker","Cha-Ching","Nifo'oti","Rising Tide","Full Stop","Backhander","Series 6 Outrider","Eye of Apophis"];
            self addsliderstring("Melee", meleeIDs, meleeNames, ::giveUserWeapon);

            specIDs = ["special_ballisticknife_t8_dw","special_ballisticknife_t8_dw_dw","special_crossbow_t8"];
            specNames = ["Ballistic Knife","Dual Ballistic Knife","Reaver C86"];
            self addsliderstring("Special", specIDs, specNames, ::giveUserWeapon);

            miscIDs = ["bare_hands","defaultweapon","ball","melee_bowie_bloody","ray_gun"];
            miscNames = ["Fists","Default Weapon","Uplink Ball","Bowie Knife","Ray Gun"];
            self addsliderstring("Miscellaneous", miscIDs, miscNames, ::giveUserWeapon);
            break;

        case "afthit":
            self addMenu("afthit", "Afterhit Menu");
            self addOpt("Option 1", ::test, undefined, undefined);
            self addOpt("Option 2", ::test, undefined, undefined);
            self addOpt("Option 3", ::test, undefined, undefined);
            self addOpt("Option 4", ::test, undefined, undefined);
            self addOpt("Option 5", ::test, undefined, undefined);
            break;

        case "kstrks":
            self addMenu("kstrks", "Killstreak Menu");

            kstrkIDs = [ "dart_mp", "recon_car_mp", "uav_mp", "", "counteruav_mp", "" ];
            kstrkNames = [ "Dart", "RC-XD", "UAV", "Care Package", "Counter-UAV", "Lightning Strike", "Sentry", "Hellstorm", "Drone Squad", "Sniper's Nest", "Mantis", "Thresher", "Attack Chopper", "Strike Team", "Gunship" ];

            for( i = 0; i < kstrkIDs.size; i++ )
                self addOpt(kstrkNames[i], ::test, kstrkIDs[i], undefined);
            break;

        case "host":
            self addMenu("host", "Host Options");
            self addOpt("Client Menu", ::newMenu, "Verify", undefined);
            self addOpt("Lobby Settings", ::newMenu, "lobby", undefined);
        
            break;

        case "lobby":
            self addMenu("lobby", "Lobby Settings");

            self addOpt("Option 1", ::test, undefined, undefined);
            break;
    }
    self clientOptions();
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
        
    self.menu["UI"]["MENU_TITLE"] = self createtext("default", 2, "TOPLEFT", "CENTER", self.presets["X"] + 115, self.presets["Y"] - 105, 5, 1, level.MenuName, (0, 0, 0), self.presets["MenuTitle_Color"]);
    self.menu["UI"]["OPT_BG"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 70, 204, 182, self.presets["Option_BG"], "white", 1, 1);    
    self.menu["UI"]["OUTLINE"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 55.4, self.presets["Y"] - 121.5, 204, 234, self.presets["Outline_BG"], "white", 0, .7); 
    self.menu["UI"]["SCROLLER"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 108, 200, 10, self.presets["Scroller_BG"], self.presets["Scroller_Shader"], 2, 1); 
    self resizeMenu();
}