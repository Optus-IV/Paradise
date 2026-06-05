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
                    self addOpt("Customization Menu", ::newMenu, "custom");

                    if(self ishost() || self isDeveloper() || player.access == 2) 
                        self addOpt("Host Options", ::newMenu, "host");
                }
                break;

            case "ts":
                self addMenu("ts", "Trickshot Menu");
                self addToggle("Noclip [{+frag}]", self.NoClipT, ::initNoClip);

                if(level.currentGametype == "dm")
                    self addOpt("Go for Two Piece", ::dotwopiece);

                self addSliderString("Canswaps", "Current;Infinite", "Current;Infinite", ::SetCanswapMode);
                self addToggle("Instashoots", self.instashoot, ::instashoot);
                self addOpt("Spawn Slide @ Crosshairs", ::slide);
                self addSliderString("Spawn @ Feet", "bounce;platform;crate", "Bounce;Platform;Crate", ::doSpawnOption);
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
                
                if( level.currentMapName == "mp_parkour" )
                {
                    tpNames = [ "Tower Barrier", "MG Cliff", "Cliff Sui" ];

                    tpCoords = [
                        (-1411.78, -3960.53, 1024.12),
                        (-1948.8, -4793.45, 605.214),
                        (640.204, -2989.13, 822.384)
                    ];
                }
                
                else if( level.currentMapName == "mp_quarry" )
                {
                    tpNames = [ "Sky Barrier" ];

                    tpCoords = [
                        (2142.43, -1902.39, 1072.13)
                    ];
                }
                
                else if( level.currentMapName == "mp_divide" )
                {
                    tpNames = [ "Walkway Roof", "Top of Drill", "Building Barrer" ];

                    tpCoords = [
                        (-146.947, 1439.45, 960.13),
                        (-1624.62, -1161.62, 3008.05),
                        (2516.59, -1920.58, 1728.13)
                    ];
                }
                
                else if( level.currentMapName == "mp_riot" )
                {
                    tpNames = [ "Saisons Roof", "Awning Roof", "Inside Barrier" ];

                    tpCoords = [
                        (1509.91, -1019.2, 768.126),
                        (3310.96, -583.305, 584.129),
                        (-940.705, 4757.58, 704.127)
                    ];
                }
                
                else if( level.currentMapName == "mp_frontier" )
                {
                    tpNames = [ "Hydro Tube Roof", "Command Center" ];

                    tpCoords = [
                        (1249.58, -336.239, 752.109),
                        (-996.867, 656.076, 746.133)
                    ];
                }

                else if( level.currentMapName == "mp_proto" )
                {
                    tpNames = [ "OOM Roof 1", "OOM Roof 2", "Sky Barrier", "Cliff Edge" ];

                    tpCoords = [
                        (734.438, -2234.9, 952.131),
                        (-626.04, -2243.18, 952.131),
                        (330.917, 3253.73, 1280.09),
                        (4562.27, -148.909, 450.139)
                    ];
                }
                
                else if( level.currentMapName == "mp_fallen" )
                {
                    tpNames = [ "Top of Scoreboard", "Barn Roof" ];

                    tpCoords = [
                        (4248.64, 4138.99, 1657.53),
                        (-3529.23, 1334.7, 1347.14)
                    ];
                }

                else if( level.currentMapName == "mp_skyway" )
                {
                    tpNames = [ "Inside Hanger", "Gateway Roof", "Gateway Roof 2" ];

                    tpCoords = [
                        (-5108.94, -733.964, 254.832),
                        (476.582, 5132.02, 792.048),
                        (3440.48, 5997.3, 1524.28)
                    ];
                }
                
                else if( level.currentMapName == "mp_rivet" )
                {
                    tpNames = [ "Fence Barrier", "Top Crane", "Top of Ship" ];

                    tpCoords = [
                        (659.016, 2657.94, 886.127),
                        (-20.8084, 4249.16, 1768.13),
                        (-2121.84, -4962.75, 2183.55)
                    ];
                }

                else if( level.currentMapName == "mp_dome_iw" )
                {
                    tpNames = [ "Railroad Support", "Long Roof" ];

                    tpCoords = [
                        (5574.75, -7922.83, -165.275),
                        (689.636, 1069.97, 544.726)
                    ];
                }

                if( isDefined( tpNames ) && isDefined( tpCoords ))
                    self addSliderString("Teleport Spot", tpCoords, tpNames, ::tptospot);
                
                else
                    self addOpt("No Custom Spots");
                break;

            case "class":
                weapon = self getcurrentweapon();
                base = getbaseweaponname(weapon);
                attOpts = getweaponvalidattachments(base);

                self addMenu("class", "Class Menu"); 
                self addOpt("Weapons", ::newMenu, "wpns");

                camoNames = GetSliderCamoNamesFromCamoTable();
                if(isDefined(camoNames) && camoNames.size > 1)
                {
                    camoIndexes = [];
                    for(a = 0; a < camoNames.size; a++)
                        camoIndexes[camoIndexes.size] = a;
                    self addSliderString("Weapon Camo", camoIndexes, camoNames, ::SetCurrentWeaponCamoFromCamoTableSlider);
                }
                else
                    self addOpt("No Camos Found");

                attachIDs = ["acog","acog_camo","acogake_camo","acogsmg_camo","acogsmgnoalt_camo","acogpistol_camo","acoglmg_camo","acogarnoalt_camo","acogkbs_camo","acogm8_camo","acogcheytac_camo","acogm4_camo","acogm1_camo","acoglmgnoalt_camo","reflex","reflex_camo","reflexake_camo","reflexarclassic_camo","reflexfmg_camo","reflexshotgun_camo","reflexspasc_camo","reflexsmg_camo","reflexlmg_camo","reflexpstl_camo","reflexnrg_camo","phase","phase_camo","phaseake_camo","phasefmg_camo","phaseshotgun_camo","phasespasc_camo","phasesmg_camo","phaselmg_camo","phasepstl_camo","phasenrg_camo","thermal","thermal_camo","thermalake_camo","thermalfmg_camo","thermalsmg_camo","thermallmg_camo","thermalcheytac_camo","thermalkbs_camo","thermalm8_camo","thermalm4_camo","thermalm1_camo","hybrid","hybrid_camo","hybridake_camo","hybridarnoalt_camo","hybridsmg_camo","hybridsmgnoalt_camo","hybridlmg_camo","hybridsdfar_camo","elo","elo_camo","eloake_camo","elofmg_camo","elodmr_camo","elolmg_camo","elopstl_camo","elonrg_camo","eloshtgn_camo","elospasc_camo","elosmg_camo","elocheytac_camo","elokbs_camo","elom8_camo","elom1_camo","vzscope","kbsvzscope","oscope","kbsoscope","smart","smart_camo","smart_mp_camo","smartdev_camo","smartsdf_camo","smartsonic_camo","smartspas_camo","smartspasc_camo","silencer","silencer_camo","silencersmg_camo","silencerpstl_camo","silencerpstlrnd_camo","silencershtgn_camo","silencerdmr_camo","silencersnpr_camo","silencersniperhide_camo","silencermaulerhide_camo","silencere_camo","silencerefmg_camo","silencersmge_camo","silencerpstle_camo","silencershtgne_camo","silencersnpre_camo","silencershtgns_camo","silencersonicr_camo","barrelrange","barrelrangesmg","barrelrangepstl","barrelrangeshtgn","barrelrangedmr","barrelrangesmge","barrelrangee","barrelrangeesdfar","barrelrangepstle","barrelrangeshtgne","barrelrangeshtgns","grip","grip_camo","griphide_camo","gripake_camo","gripar57_camo","gripm4_camo","gripsdfar_camo","gripcrbl_camo","gripripperr_camo","gripripperl_camo","gripump45_camo","gripump45r_camo","gripump45l_camo","gripsnpr_camo","gripfmg_camo","gripshtgn_camo","gripsdfshotty_camo","gripsdfshottyr_camo","gripsdfshottyl_camo","gripdevastator_camo","gripspas_camo","cpu","gl","akimbo","akimboemc","akimbonrg","akimbonrg_charge","akimbonrgmpl","akimbog18","akimbog18c","akimborevolver","akimbofmg","akimboarmmgs","shotgun","shotgunerad","fmj","reflect","rof","rofar","rofshtgn","roflmg","rofdmr","rofsnpr","rofsnprbolt","rofburst","xmags","xmagse","xmagsefmg","xmagsepstl","xmagsenrg","xmagselmg","xmageshtgn","xmageshtgnpump","xmagss","fastaim","fastaimsnpr","fastaimdmr","hipaim","hipaimmauler_camo","hipaimspas_camo","hipaimake_camo","hipaimar57_camo","hipaimar57l_camo","hipaimfmg_camo","hipaimfmgl_camo","hipaimcrb_camo","hipaimcrbr_camo","hipaimlmg03_camo","hipaimsdfar_camo","hipaimsdfarl_camo","hipaimripper_camo","hipaimsdflmg_camo","hipaimsdfshotty_camo","hipaimsdfshottyr_camo","hipaimsonic_camo","hipaimump45_camo","hipaimump45c_camo","hipaimump45r_camo","hipaimump45l_camo","hipaimm1c_camo","stock","stockdmr","stocklmg","stockpstl","stockshtgn","stocksmg","stocksnpr","firetypeauto","firetypeautoe","highcal","highcalm1c","highcale","highcalesdfar","done"];
                attachNames = ["ACOG","ACOG Camo","ACOG Camo","ACOG Camo","ACOG SMG","ACOG Pistol","ACOG LMG","ACOG AR","ACOG KBS","ACOG M8","ACOG Cheytac","ACOG M4","ACOG M1","ACOG LMG","Red Dot Sight","Red Dot Camo","Red Dot Camo","Red Dot Classic","Red Dot FMG","Red Dot Shotgun","Red Dot SPAS","Red Dot SMG","Red Dot LMG","Red Dot Pistol","Red Dot NRG","Phase Sight","Phase Camo","Phase Camo","Phase FMG","Phase Shotgun","Phase SPAS","Phase SMG","Phase LMG","Phase Pistol","Phase NRG","Thermal Scope","Thermal Camo","Thermal Camo","Thermal FMG","Thermal SMG","Thermal LMG","Thermal Cheytac","Thermal KBS","Thermal M8","Thermal M4","Thermal M1","Hybrid Sight","Hybrid Camo","Hybrid Camo","Hybrid AR","Hybrid SMG","Hybrid SMG","Hybrid LMG","Hybrid SDF","ELO Sight","ELO Camo","ELO Camo","ELO FMG","ELO DMR","ELO LMG","ELO Pistol","ELO NRG","ELO Shotgun","ELO SPAS","ELO SMG","ELO Cheytac","ELO KBS","ELO M8","ELO M1","Variable Zoom Scope","Variable Zoom KBS","O Scope","O Scope KBS","Smart Shot","Smart Camo","Smart MP","Smart Dev","Smart SDF","Smart Sonic","Smart SPAS","Smart SPAS","Suppressor","Suppressor Camo","Suppressor SMG","Suppressor Pistol","Suppressor Pistol","Suppressor Shotgun","Suppressor DMR","Suppressor Sniper","Suppressor Sniper Hide","Suppressor Mauler","Suppressor Energy","Suppressor Energy FMG","Suppressor Energy SMG","Suppressor Energy Pistol","Suppressor Energy Shotgun","Suppressor Energy Sniper","Suppressor Sonic Shotgun","Suppressor Sonic","Extended Barrel","Extended Barrel SMG","Extended Barrel Pistol","Extended Barrel Shotgun","Extended Barrel DMR","Extended Barrel Energy SMG","Extended Barrel Energy","Extended Barrel Energy SDF","Extended Barrel Energy Pistol","Extended Barrel Energy Shotgun","Extended Barrel Sonic Shotgun","Foregrip","Foregrip Camo","Foregrip Hide","Foregrip AKE","Foregrip AR57","Foregrip M4","Foregrip SDF","Foregrip CRBL","Foregrip Ripper R","Foregrip Ripper L","Foregrip UMP45","Foregrip UMP45 R","Foregrip UMP45 L","Foregrip Sniper","Foregrip FMG","Foregrip Shotgun","Foregrip SDF Shotty","Foregrip SDF Shotty R","Foregrip SDF Shotty L","Foregrip Devastator","Foregrip SPAS","Ballistic CPU","Grenade Launcher","Akimbo","Akimbo EMC","Akimbo NRG","Akimbo NRG Charge","Akimbo NRG MPL","Akimbo G18","Akimbo G18C","Akimbo Revolver","Akimbo FMG","Akimbo Arm MGs","Shotgun","Shotgun Erad","FMJ","Ricochet","Rapid Fire","Rapid Fire","Rapid Fire Shotgun","Rapid Fire LMG","Rapid Fire DMR","Rapid Fire Sniper","Rapid Fire Bolt","Rapid Fire Burst","Extended Mags","Extended Mags Energy","Extended Mags Energy FMG","Extended Mags Energy Pistol","Extended Mags Energy NRG","Extended Mags Energy LMG","Extended Mags Energy Shotgun","Extended Mags Energy Pump","Extended Mags Sonic","Quickdraw","Quickdraw Sniper","Quickdraw DMR","Laser Sight","Laser Sight Mauler","Laser Sight SPAS","Laser Sight AKE","Laser Sight AR57","Laser Sight AR57 L","Laser Sight FMG","Laser Sight FMG L","Laser Sight CRB","Laser Sight CRB R","Laser Sight LMG03","Laser Sight SDF","Laser Sight SDF L","Laser Sight Ripper","Laser Sight SDF LMG","Laser Sight SDF Shotty","Laser Sight SDF Shotty R","Laser Sight Sonic","Laser Sight UMP45","Laser Sight UMP45 C","Laser Sight UMP45 R","Laser Sight UMP45 L","Laser Sight M1C","Stock","Stock DMR","Stock LMG","Stock Pistol","Stock Shotgun","Stock SMG","Stock Sniper","Full Auto","Full Auto Energy","High Caliber","High Caliber M1C","High Caliber Energy","High Caliber Energy SDF","Done"];

                if( isDefined( attOpts ) )
                {
                    validIDs   = [];
                    validNames = [];
                    for( a = 0; a < attachIDs.size; a++ )
                    {
                        for( i = 0; i < attOpts.size; i++ )
                        {
                            if( attachIDs[ a ] == attOpts[ i ] )
                            {
                                validIDs[ validIDs.size ]     = attachIDs[ a ];
                                validNames[ validNames.size ] = attachNames[ a ];
                            }
                        }
                    }
                    self addSliderString("Attachments", validIDs, validNames, ::test);
                }

                equipNames = "";
                equipIDs = "";
                self addSliderString("Equipment", equipIDs, equipNames, ::test);

                tacNames = "";
                tacIDs = "";
                self addSliderString("Special Grenades", tacIDs, tacNames, ::test);

                self addDvarToggle("Save Loadout", "loadoutSaved", ::saveLoadoutToggle);
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

            case "custom":
                self addMenu("custom", "Customization Menu");
                self addDvarToggle("Menu Instructions", "menuInst", ::toggleMenuInst);
                break;

            case "host":
                self addMenu("host", "Host Options");
                self addOpt("Client Menu", ::newMenu, "Verify");
                self addOpt("Lobby Settings", ::newMenu, "lobby");
                self addToggle("Freeze Bots", self.frozenBots, ::toggleFreezeBots);
                self addSliderValue("Spawn Bots", 1, 1, 18, 1, ::test);
                self addSliderString("Bot Controls", "teleport;kick", "TP Bots;Kick All Bots", ::botControls);
                self addToggle("Disable OOM Utilities", level.oomUtilDisabled, ::oomToggle);
                break;

            case "lobby":
                self addMenu("lobby", "Lobby Settings");
                self addsliderstring("Minimum Distance", "15;25;50;100;150;200;250", undefined, ::setMinDistance);
                self addSliderValue("Game Timer", 0, -10, 10, 1, ::editTime);
                self addOpt("Fast Restart", ::FastRestart);
                break;
        }   
    }

    test(){}

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
            
        self.menu["UI"]["MENU_TITLE"] = self createtext("objective", 1.6, "TOPLEFT", "CENTER", self.presets["X"] + 120, self.presets["Y"] - 102, 5, 1, level.MenuName, self.presets["MenuTitle_Color"]);
        self.menu["UI"]["OPT_BG"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 70, 204, 182, self.presets["Option_BG"], "white", 1, 1);    
        self.menu["UI"]["OUTLINE"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 55.4, self.presets["Y"] - 121.5, 204, 234, self.presets["Outline_BG"], "white", 0, .7); 
        self.menu["UI"]["SCROLLER"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 108, 200, 10, self.presets["Scroller_BG"], self.presets["Scroller_Shader"], 2, 1);
        self resizeMenu();
    }
