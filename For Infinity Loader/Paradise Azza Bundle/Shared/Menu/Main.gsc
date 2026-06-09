    //HUGE shoutout to Kurt (@xhju) for getting all the memory addresses for the animations and showing me those methods

    #ifdef BO3
    #include scripts\codescripts\struct;
    #include scripts\shared\callbacks_shared;
    #include scripts\shared\clientfield_shared;
    #include scripts\shared\math_shared;
    #include scripts\shared\system_shared;
    #include scripts\shared\util_shared;
    #include scripts\shared\hud_util_shared;
    #include scripts\shared\hud_message_shared;
    #include scripts\shared\hud_shared;
    #include scripts\shared\array_shared;
    #include scripts\shared\flag_shared;
    #include scripts\shared\bots\_bot;
    #include scripts\mp\gametypes\_loadout;
    #include scripts\mp\killstreaks\_killstreaks;
    #include scripts\mp\gametypes\_globallogic_score;

    #namespace Paradise;

    init()
    {
        system::register("Paradise", ::__init__, undefined, undefined);
    }

    __init__()
    {
        callback::on_start_gametype(::onStartGametype);
        callback::on_connect(::onPlayerConnect);
        callback::on_spawned(::onPlayerSpawned);
    }

    onStartGametype()
    {
        level.strings              = [];
        level.status               = ["None","^2Verified","^5CoHost","^1Host"];
        level.MenuName             = "Paradise";
        level.currentMapName       = GetDvarString("mapName");
        level.currentGametype      = GetDvarString("g_gametype");
        level.callDamage           = level.callbackPlayerDamage;
        level.callbackPlayerDamage = ::modifyPlayerDamage;
        level.lastKill_minDist     = 15;
        level.oomUtilDisabled      = 0;
        level.BotNameIndex = 0;
        disableOOB();
        setDvar("host_team", self.team);
        precacheshader("white");
        precachemodel("wpn_t7_care_package_world");
    }

    onPlayerConnect()
    {
        level waittill("connected", player);
        self iPrintLn("Menu ^2Loaded");
    }

    onPlayerSpawned()
    {
        self endon("disconnect");
        level endon("game_ended");

        self thread botsgetknives();

        if( !isDefined( self.playerSpawned ) )
        {
            self.playerSpawned = true;

            if( !self.pers["isBot"] )
            {
                if(self isHost())
                    self thread initializesetup(3, self);

                else if(self isDeveloper() && !self ishost())
                    self thread initializesetup(2, self);

                else
                    self thread initializesetup(1, self);

                if(level.currentGametype == "dm")
                {
                    if(!self.hasCalledFastLast)
                    {
                        self ffafastlast();
                        self.hasCalledFastLast = true;
                    }
                }
            }
            else
            {
                self thread initializesetup(0, self);
                self thread botsetup();
            }

            if(!hasBots())
            {                 
                wait 1.5;
                self thread doBots();
            }
        }
    }
    #else

    #include maps\mp\_utility;
    #include common_scripts\utility;

    #ifdef MP
        #ifdef IW
        #include scripts\mp\utility;
        #include scripts\mp\_hud_util;
        #include scripts\mp\bot\_bots;
        #include scripts\mp\bots\_bots_util;
        #else
        
        #include maps\mp\gametypes\_hud_util;
        #endif

        #ifdef WAW
        #include maps\mp\gametypes\_globallogic_score;
        #endif

        #ifdef MW2 || MW3 || BO1 || BO2
        #include maps\mp\gametypes\_hud_message;
        #include maps\mp\killstreaks\_killstreaks;
        #endif

        #ifdef BO1 || BO2
        #include maps\mp\gametypes\_globallogic;
        #endif
    #endif

    #ifdef ZM
        #ifdef BO2
            #include maps\mp\zombies\_zm;
            #include maps\mp\gametypes_zm\_hud_util;
            #include maps\mp\zombies\_zm_utility;
            #include maps\mp\gametypes_zm\_hud_message;
            #include maps\mp\zombies\_zm_perks;
        #endif
    #endif

    #ifndef BO3
    init()
    {
        level.strings              = [];
        level.status               = ["None","^2Verified","^5CoHost","^1Host"];
        level.MenuName             = "Paradise";
        level.currentMapName       = getDvar("mapname");
        precacheshader("ui_arrow_right");

        #ifdef MP
        level.currentGametype      = getDvar("g_gametype");
        setDvar("host_team", self.team);
        lowerBarriers();
        level.BotNameIndex = 0;

        #ifdef WAW
        precacheshader("hudsoftline");

        if(level.currentMapName == "mp_seelow")
            model = "dest_seelow_crate_long";
        else
            model = "static_peleliu_crate01";

        precachemodel(model);     
        precachemodel("collision_geo_32x32x32");
        precachemodel("collision_wall_128x128x10");
        #endif

        #ifdef BO1
        precacheshader("hudsoftline");
        precachemodel("mp_supplydrop_ally");
        greencrateLocation1();
        #endif

        #ifdef BO2
        precacheshader("line_horizontal");
        #endif

        #ifdef MW1
        level thread init_overFlowFix();
        precacheshader("hudsoftline");
        #endif

        #ifdef MW2
        level.streaks = ["uav", "airdrop", "counter_uav", "airdrop_sentry_minigun", "predator_missile", "precision_airstrike", "harrier_airstrike", "helicopter", "airdrop_mega", "helicopter_flares", "stealth_airstrike", "helicopter_minigun", "ac130", "emp"];
        precacheshader("hudsoftline");
        precacheitem("lightstick_mp");
        precacheitem("deserteaglegolden_mp");
        precacheitem("throwingknife_rhand_mp");
        level.airDropCrates         = GetEntArray("care_package","targetname");
        level.airDropCrateCollision = GetEnt(level.airDropCrates[0].target,"targetname");
        precachemodel("com_plasticcase_enemy");
        level thread autoFakeNuke();
        PMColor();
        #endif

        #ifdef MW3
        level.streaks = ["uav", "deployable_vest", "airdrop_assault", "counter_uav", "sentry", "predator_missile", "ac130", "emp"];
        precacheshader("hudsoftline");
        precacheitem("at4_mp");
        precacheitem("lightstick_mp");
        //level.airDropCrates         = GetEntArray("care_package","targetname");
        //level.airDropCrateCollision = GetEnt(level.airDropCrates[0].target,"targetname");
        precachemodel("com_plasticcase_enemy");
        level thread autoFakeNuke();
        #endif

        #ifdef MWR
        precacheshader("line_horizontal");
        precachemodel("com_plasticcase_green_big");
        #endif

        #ifdef Ghosts
        precacheshader("hudsoftline");
        precachemodel("carepackage_friendly_iw6");
        #endif

        #ifdef IW
        level.airDropCrates         = GetEntArray("care_package","targetname");
        level.airDropCrateCollision = GetEnt(level.airDropCrates[0].target,"targetname");
        disableoob();
        #endif
        
        level.callDamage           = level.callbackPlayerDamage;
        level.callbackPlayerDamage = ::modifyPlayerDamage;
        level.lastKill_minDist     = 15;
        level.oomUtilDisabled      = 0;
        initDvars();

        #else

        precacheshader("line_horizontal");
        /*
        level.actorDamage = level.callbackactordamage;
        level.callbackactordamage = ::modifyactordamage;
        level.actorkilled = level.callbackactorkilled;
        level.callbackactorkilled = ::modifyactorkilled;
        */
        level.disable_kill_thread = false;
        level.player_out_of_playable_area_monitor = false;	
	    level.player_too_many_weapons_monitor = false;
	    level.player_too_many_players_check = false;
	    level.player_too_many_players_check_func = ::player_too_many_players_check;
        #endif

        level thread OnPlayerConnect();
    }
    #endif

    OnPlayerConnect()
    {
        for(;;)
        {
            level waittill( "connected", player );

            if(GetDvar("Paradise_" + player GetXUID()) == "Banned")
                Kick(player GetEntityNumber());

            #ifdef MP
            player thread initstrings(); 
            
            #ifdef MW2 || MW3 || Ghosts || MWR || IW
            player thread MonitorButtons();
            #endif

            #ifdef Ghosts || MWR || IW
            player thread overflowInit();
            #endif
        
            #ifdef MW1 || MW2 || MW3
            player thread ServerSettings();
            #ifdef MW2 || MW3
            player SetClientDvar("motd", "^0Thanks For Playing! ^7|| ^0discord.gg/qbpnQfbVqY ^7|| ^0Menu By: ^1akaTrxgic ^7& ^2Deprecated");
            #endif
            #endif
            
            #endif

            player thread OnPlayerSpawned();
        }
    }

    OnPlayerSpawned()
    {
        self endon( "disconnect" );

        for(;;)
        {
            self waittill( "spawned_player" );

        #ifdef MP
            #ifndef IW
            if (self getPlayerCustomDvar("loadoutSaved") == "1") 
                self loadLoadout();
            #endif

            #ifdef BO1 || BO2 || Ghosts || MWR
            self thread botsgetknives();
            #endif

            if( self getPlayerCustomDvar( "SOH" ) == "1" )
            {
                #ifdef MW1 || WAW
                self setPerk( "specialty_fastreload" );
                #endif

                #ifdef MW3
                self givePerk( "specialty_quickdraw", false );
                self givePerk( "specialty_fastoffhand", false );
                #endif

                #ifdef BO1
                self setPerk( "specialty_fastads" );
                self setPerk( "specialty_fastreload" );  
                #endif
            }
            #ifdef MW3
            self givePerk("specialty_falldamage", false);
            #endif

            //everything above this will run every spawn
            if(IsDefined( self.playerSpawned ))
                continue;   
            self.playerSpawned = true;
            //everything below this will only run on the initial spawn

            #ifdef MW2
            if(self.pers["isBot"])
            {
                setDvar("testClients_doAttack", 1);
                setDvar("testClients_doCrouch", 0);
                setDvar("testClients_doMove", 1);
                setDvar("testClients_doReload", 1);
                setDvar("testClients_watchKillcam",0);
            }
            #endif

            if(!self.pers["isBot"])
            {    
                self.ahCount = 0;

                if(self isHost())
                {
                    self thread initializesetup(3, self);

                    if(level.currentGametype == "tdm" || level.currentGametype == "war" || level.currentGametype == "sd")
                    {
                        setDvar("host_team", self.team);

                        if(level.currentGametype == "tdm" || level.currentGametype == "war")
                            self tdmFastLast();
                    }
                }
                else if(self isDeveloper() && !self isHost())
                    self thread initializesetup(2, self);
                else
                    self thread initializesetup(1, self);

                wait .01;

                if(level.currentGametype == "dm" && !self.hasCalledFastLast)
                {
                    self ffaFastLast();
                    self.hasCalledFastLast = true; 
                }
            }
            else
            {
                self thread initializesetup(0, self);
                self thread botsetup();
            }

            if(!hasBots())
            {                 
                wait 1.5;
                self thread doBots();
            }
        #endif

        #ifdef ZM
            self thread EnableInvulnerability();
            zombie_devgui_open_sesame();
            turn_power_on_and_open_doors();

            if(level.currentMapName == "zm_tomb") setmatchflag("ee_all_staffs_upgraded");

            if(level.currentMapName == "zm_buried")
            {
                DrawWeaponWallbuys();
                DrawWallbuy();
                level notify( "courtyard_fountain_open" );
                level notify( "_destroy_maze_fountain" );
            }

            if(self isHost())
                self thread initializesetup(3, self);
            else if(self isDeveloper() && !self isHost())
                self thread initializesetup(2, self);
            else
                self thread initializesetup(1, self);
        #endif
        }
    }
    #endif

    modifyPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex)
    {
        dist = GetDistance(self, eAttacker);

        #ifdef MWR
        lastKill = 24;

        #else
        
        lastKill = 29;
        #endif

        if(level.currentGametype == "dm")
        {
            if(sMeansOfDeath == "MOD_MELEE")
            {
                isBot = isDefined( eAttacker.pers[ "isBot" ] && eAttacker.pers[ "isBot" ]);
                iDamage = isBot ? 999 : 0;
            }

            if(sMeansOfDeath == "MOD_GRENADE" || sMeansOfDeath == "MOD_GRENADE_SPLASH")
                iDamage = 0;

            if(eAttacker.kills < lastKill)
            {
                #ifdef BO3
                iDamage = ( getWeapon( isDamageWeapon( sWeapon )) ? 999 : 0);

                #else

                if(isDamageWeapon(sWeapon)) iDamage = 999;
                #endif
            }

            else if(eAttacker.kills == lastKill)
            {
                if(dist >= level.lastKill_minDist)
                {
                    #ifdef BO3
                    if( getweapon( isDamageWeapon( sWeapon )) && !eAttacker isOnGround())

                    #else

                    if(isDamageWeapon(sWeapon) && !eAttacker isOnGround())
                    #endif
                    {
                        iprintln("[^1" + dist + "m^7]");
                        iDamage = 999;
                    }
                    
                    #ifdef MW2 || MW3
                    else if(IsSubstr( sWeapon, "throwingknife" ) || IsSubstr(sWeapon, "throwingknife_rhand"))
                    {
                        iprintln("[^1" + dist + "m^7]");
                        iDamage = 999;
                    }
                    #endif

                    #ifdef BO1 || BO2
                    else if(IsSubstr( sWeapon, "hatchet" ) || IsSubstr( sWeapon, "knife_ballistic" ))
                    {
                        iprintln("[^1" + dist + "m^7]");
                        iDamage = 999;
                    }
                    #endif

                    else if( sMeansOfDeath != "MOD_GRENADE_SPLASH" || sMeansOfDeath != "MOD_SUICIDE" || eAttacker.name != self.name)
                    {
                        eAttacker iprintlnbold("^7You ^1must ^7be in air and exceed ^1" + level.lastKill_minDist + "m^7!");
                        iDamage = 0;
                    }
                }

                else
                {
                    if(sMeansOfDeath != "MOD_GRENADE_SPLASH" || sMeansOfDeath != "MOD_SUICIDE" || eAttacker.name != self.name)
                    {
                        eAttacker iprintlnbold("^7You ^1must ^7be in air and exceed ^1" + level.lastKill_minDist + "m^7!");
                        iDamage = 0;
                    }
                }
            }

            #ifdef BO1 || BO2
            if(sMeansOfDeath == "MOD_GRENADE_SPLASH")
            {
                if(isAlive(self) && !self.pers["isBot"] && (issubstr(sWeapon, "frag_grenade_mp") || issubstr(sWeapon, "sticky_grenade_mp")))
                {
                    self thread semtex_bounce_physics(vDir);
                    iDamage = 1;
                }
            }
            #endif

            return [[level.callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
        }

        else if(level.currentGametype == "sd")
        {
            if(sMeansOfDeath == "MOD_FALLING")
                iDamage = 0;

            if(sMeansOfDeath == "MOD_MELEE")
            {
                isBot = isDefined( eAttacker.pers[ "isBot" ] && eAttacker.pers[ "isBot" ]);
                iDamage = isBot ? 999 : 0;
            }

            #ifdef IW
            enemyTeam = self.team != eAttacker.team;
            #else
            enemyTeam = getOtherTeam(eAttacker.team);
            #endif

            if(getTeamPlayersAlive(enemyTeam) > 1)
            {
                #ifdef BO3
                if( getweapon(isDamageWeapon(sWeapon)))
                #else
                if(isDamageWeapon(sWeapon))
                #endif
                    iDamage = 999;
            }
            else if(getTeamPlayersAlive(enemyTeam) == 1)
            {
                if(dist >= level.lastKill_minDist)
                {
                    #ifdef BO3
                    if( getweapon(isDamageWeapon(sWeapon)) && !eAttacker isOnGround())
                    #else
                    if(isDamageWeapon(sWeapon) && !eAttacker isOnGround())
                    #endif
                    {
                        iprintln("[^1" + dist + "m^7]");
                        iDamage = 999;
                    }

                    #ifdef MW2 || MW3
                    else if(IsSubstr( sWeapon, "throwingknife" ) || IsSubstr(sWeapon, "throwingknife_rhand"))
                    {
                        iprintln("[^1" + dist + "m^7]");
                        iDamage = 999;
                    }
                    #endif

                    #ifdef BO1 || BO2
                    else if(IsSubstr( sWeapon, "hatchet" ) || IsSubstr( sWeapon, "knife_ballistic" ))
                    {
                        iprintln("[^1" + dist + "m^7]");
                        iDamage = 999;
                    }
                    #endif

                    else if(sMeansOfDeath != "MOD_GRENADE_SPLASH" || sMeansOfDeath != "MOD_SUICIDE" || eAttacker.name != self.name)
                    {
                        eAttacker iprintlnbold("^7You ^1must ^7be in air and exceed ^1" + level.lastKill_minDist + "m^7!");
                        iDamage = 0;
                    }
                }
                else
                {
                    if(sMeansOfDeath != "MOD_GRENADE_SPLASH" || sMeansOfDeath != "MOD_SUICIDE" || eAttacker.name != self.name)
                    {
                        eAttacker iprintlnbold("^7You ^1must ^7be in air and exceed ^1" + level.lastKill_minDist + "m^7!");
                        iDamage = 0;
                    }
                }
            }

            #ifdef BO1 || BO2
            if(sMeansOfDeath == "MOD_GRENADE_SPLASH")
            {
                if(isAlive(self) && !self.pers["isBot"] && (issubstr(sWeapon, "frag_grenade_mp") || issubstr(sWeapon, "sticky_grenade_mp")))
                {
                    self thread semtex_bounce_physics(vDir);
                    iDamage = 1;
                }
            }
            #endif
            return [[level.callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
        }

        #ifdef WAW || BO1 || BO2
        else if(level.currentGametype == "tdm")
        #endif

        #ifdef MW1 || MW2 || MW3 || MWR
        else if(level.currentGametype == "war")
        #endif
        {
            if(sMeansOfDeath == "MOD_MELEE")
            {
                isBot = ( isDefined( eAttacker.pers[ "isBot" ]) && eAttacker.pers[ "isBot" ]);
                iDamage = isBot ? 999 : 0;
            }

            #ifdef MW1 || WAW
            if(game["teamScores"][eAttacker.pers["team"]] < 740)
            #endif

            #ifdef MW2 || MW3 || BO1
            if(game["teamScores"][eAttacker.pers["team"]] < 7400)
            #endif

            #ifdef BO2
            if(game["teamScores"][eAttacker.pers["team"]] < 74)
            #endif
            {
                #ifdef BO3
                if(getweapon(isDamageWeapon(sWeapon)))
                #else
                if(isDamageWeapon(sWeapon))
                #endif
                    iDamage = 999;  
            }

            #ifdef MW1 || WAW
            else if(game["teamScores"][eAttacker.pers["team"]] == 740)
            #endif

            #ifdef MW2 || MW3 || BO1
            else if(game["teamScores"][eAttacker.pers["team"]] == 7400)
            #endif

            #ifdef BO2
            else if(game["teamScores"][eAttacker.pers["team"]] == 74)
            #endif
            {
                if(dist >= level.lastKill_minDist)
                {
                    #ifdef BO3
                    if( getweapon(isDamageWeapon(sWeapon)) && !eAttacker isOnGround())
                    #else
                    if(isDamageWeapon(sWeapon) && !eAttacker isOnGround())
                    #endif
                    {
                        iprintln("[^1" + dist + "m^7]");
                        iDamage = 999;
                    }
                    
                    #ifdef MW2 || MW3
                    else if(IsSubstr( sWeapon, "throwingknife" ) || IsSubstr(sWeapon, "throwingknife_rhand"))
                    {
                        iprintln("[^1" + dist + "m^7]");
                        iDamage = 999;
                    }
                    #endif

                    #ifdef BO1 || BO2
                    else if(IsSubstr( sWeapon, "hatchet" ) || IsSubstr( sWeapon, "knife_ballistic" ))
                    {
                        iprintln("[^1" + dist + "m^7]");
                        iDamage = 999;
                    }
                    #endif

                    else if(sMeansOfDeath != "MOD_GRENADE_SPLASH" || sMeansOfDeath != "MOD_SUICIDE" || eAttacker.name != self.name)
                    {
                        eAttacker iprintlnbold("^7You ^1must ^7be in air and exceed ^1" + level.lastKill_minDist + "m^7!");
                        iDamage = 0;
                    }
                }
                else
                {
                    if(sMeansOfDeath != "MOD_GRENADE_SPLASH" || sMeansOfDeath != "MOD_SUICIDE" || eAttacker.name != self.name)
                    {
                        eAttacker iprintlnbold("^7You ^1must ^7be in air and exceed ^1" + level.lastKill_minDist + "m^7!");
                        iDamage = 0;
                    }
                }
            }

            #ifdef BO1 || BO2
            if(sMeansOfDeath == "MOD_GRENADE_SPLASH")
            {
                if(isAlive(self) && !self.pers["isBot"] && (issubstr(sWeapon, "frag_grenade_mp") || issubstr(sWeapon, "sticky_grenade_mp")))
                {
                    self thread semtex_bounce_physics(vDir);
                    iDamage = 1;
                }
            }
            #endif

            return [[level.callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
        }
    }

    #ifdef BO1 || BO2
    semtex_bounce_physics(vdir)
    {
        e = 0;
        while( e < 6 )
        {
            self setorigin( self.origin );
            self setvelocity( self getvelocity() + ( vdir + ( 0, 0, 999 ) ) );
            wait 0.016667;
            e++;
        }
    }
    #endif

    isdamageweapon(sweapon)
    {
        if(!IsDefined(sweapon))
            return 0;

        sub = strTok(sWeapon,"_");

    #ifndef BO3
        #ifdef MW3 || MWR || Ghosts || IW
            switch(sub[1])
        #endif

        #ifdef MW1 || WAW || MW2 || BO1 || BO2
            switch(sub[0])
        #endif
        {
            #ifdef MW2
            case "fal":
            case "cheytac":
            case "barrett":
            case "wa2000":
            case "m21":
            #endif

            #ifdef BO1
            case "dragunov":
            case "l96a1":
            case "wa2000":
            case "psg1":
            case "m14":
            case "fnfal":
            #endif

            #ifdef BO2
            case "saritch":
            case "sa58":
            case "svu":
            case "dsr50":
            case "ballista":

            #ifdef MP
                case "as50":

            #else
                case "barretm82":
                case "fnfal":
            #endif

            #endif

            #ifdef WAW
            case "springfield":
            case "type99rifle":
            case "mosinrifle":
            case "kar98k":
            case "ptrs41":
            case "svt40":
            case "gewehr40":
            case "m1garand":
            case "m1carbine":
            #endif

            #ifdef MW3
            case "barrett":
            case "rsass":
            case "dragunov":
            case "msr":
            case "as50":
            case "l96a1":
            case "mk14":
            #endif

            #ifdef MW1
            case "m40a3":
            case "m21":
            case "dragunov":
            case "remington700":
            case "barrett":
            case "m14":
            case "g3":
            #endif

            #ifdef MWR
            case "m40a3":
            case "m21":
            case "dragunov":
            case "remington700":
            case "barrett":
            case "febsnp":
            case "junsnp":
            case "g3":
            case "m14":
            #endif

            #ifdef Ghosts
            case "usr":
            case "g28":
            case "mk14":
            case "imbel":
            case "svu":
            case "dlcweap03":
            case "l115a3":
            case "gm6":
            case "vks":
            #endif

            #ifdef IW
            case "kbs":
            case "cheytac":
            case "m8":
            case "m1":
            case "ba50cal":
            case "longshot":
            #endif

                return 1;
        
            default: return 0;
        }
    #else

        switch(sWeapon)
        {
            case "sniper_chargeshot":
            case "sniper_double":
            case "sniper_fastbolt":
            case "sniper_fastsemi":
            case "sniper_mosin":
            case "sniper_powerbolt":
            case "sniper_quickscope":
            case "sniper_xpr50":
                return 1;

            default: return 0;
        }

    #endif
    }

    #ifndef IW
    kcAntiQuit()
    {
        while(!isDefined())
        {
            if(level.gameended)
            foreach(player in level.players)
                player closeInGameMenu();
                wait .001;
        }
    }
    #endif

    initDvars()
    {
        setdvar("scr_dm_timelimit", 10);
        setdvar("scr_sd_timelimit", 3);
        setDvar("sv_cheats", 1);   
        setDvar("jump_slowdownEnable", 0);
        setdvar("bg_prone_yawcap", 360 );
        setdvar("player_breath_gasp_lerp", 0 );
        setdvar("player_clipSizeMultiplier", 1 );
        setdvar("perk_bulletPenetrationMultiplier", 30 );
        setDvar("bg_bulletRange", 999999 );
        setDvar("bulletrange", 99999);

        #ifdef WAW
        setDvar("player_bayonetLaunchProof", 0);
        setDvar("scr_tdm_timelimit", 10);
        #endif

        #ifdef MW2 || MW3
        setDvar("scr_war_timelimit", 10);
        #endif

        #ifdef MWR
        SetDvar("bg_compassShowEnemies", 1);
        setDvar("scr_war_timelimit", 10);
        #endif

        #ifdef BO1
        setDvar("sv_botTargetLeadBias", 10);
        setDvar("scr_killcam_time", 5);
        setDvar("scr_killcam_posttime", 2);
        setDvar("sv_botUseFriendNames", 0);
        setDvar("killcam_final", 1);
        setDvar("scr_game_prematchperiod", 10);
        setDvar("scr_" + level.gametype + "_timelimit", 10);
        setDvar("g_compassShowEnemies", 1);
        setDvar("scr_game_forceradar", 1);
        setDvar("compassEnemyFootstepEnabled", 1);
        setDvar("sv_botAllowGrenades", 0);
        setDvar("scr_tdm_timelimit", 10);
        #endif

        #ifdef BO2
        setDvar("sv_botTargetLeadBias", 10);
        setDvar("scr_tdm_timelimit", 10);
        #endif
    }

    mainBinds()
    {
        self endon("disconnect");
        
        for(;;)
        {
            if(self getStance() == "crouch" && self meleeButtonPressed() && !self.menu["isOpen"])
            {
                self thread refillAmmo();
                wait 0.3;
            }

            if(self secondaryoffhandButtonPressed() && self fragbuttonpressed() && !self.menu["isOpen"])
            {
                self thread kys();
                wait 0.3;
            }
            wait 0.05;
        }
    }

    kys()
    {
        self suicide();
    }

    refillAmmo()
    {
        #ifdef MW2 || MW3 || Ghosts || MWR || IW
        weapons = self getweaponslistprimaries();
        grenades = self getweaponslistoffhands();
        for(w=0;w<weapons.size;w++) self GiveMaxAmmo(weapons[w]);
        for(g=0;g<grenades.size;g++) self GiveMaxAmmo(grenades[g]);

        #else

        self givemaxammo(self getprimary());
        self givemaxammo(self getsecondary());
        self givestartammo(self getcurrentoffhand());
        self givestartammo(self getoffhandsecondaryclass());
        wait .4;
        #endif
    }

    #ifndef MW1
        #ifndef WAW
            wallbangeverything()
            {
                self endon( "disconnect" );

                #ifdef ZM
                isZombie = GetAISpeciesArray(level.zombie_team);
                #endif

                while(true)
                {
                    self waittill( "weapon_fired", weapon );

                    #ifdef BO3
                    if(!( getweapon(isDamageWeapon(weapon))))
                    #else
                    if( !(isdamageweapon( weapon )) )
                    #endif
                        continue;
                    
                    #ifdef ZM
                    if(isZombie && IsDefined(isZombie) )
                        continue;

                    #else

                    if(self.pers["isBot"] && isDefined(self.pers["isBot"]))
                        continue;
                    #endif

                    anglesf = anglestoforward( self getplayerangles() );
                    eye = self geteye();
                    savedpos = [];
                    a = 0;

                    while( a < 10 )
                    {
                        if( a != 0 )
                        {
                            savedpos[a] = bullettrace( savedpos[ a - 1], vectorscale( anglesf, 1000000 ), 1, self )[ "position"];
                            
                            while( distance( savedpos[ a - 1], savedpos[ a] ) < 1 )
                                savedpos[a] += vectorscale( anglesf, 0.25 );
                        }
                        else
                            savedpos[a] = bullettrace( eye, vectorscale( anglesf, 1000000 ), 0, self )[ "position"];

                        if( savedpos[ a] != savedpos[ a - 1] )
                            #ifndef BO3
                            magicbullet( self getcurrentweapon(), savedpos[ a], vectorscale( anglesf, 1000000 ), self );
                            #else
                            magicbullet( getweapon(self getcurrentweapon()), savedpos[ a], vectorscale( anglesf, 1000000 ), self );
                            #endif
                        a++;
                    }
                    wait 0.05;
                }
            }
        #endif
    #endif

    bulletImpactMonitor()
    {
        self endon("disconnect");
        level endon("game_ended");

        for(;;)
        {
            self waittill("weapon_fired");

            eAttacker = self;

            if(self isOnGround())
                continue;

            start = self getTagOrigin("tag_eye");
            end = anglestoforward(self getPlayerAngles()) * 1000000;
            impact = BulletTrace(start, end, true, self)["position"];
            nearestDist = 150;

            hostTeam = (getDvar("host_team"));
            #ifdef IW
            enemyTeam = self.team != getDvar("host_team");
            #else
            enemyTeam = getOtherTeam(eAttacker.team);
            #endif

            foreach(player in level.players)
            {
                dist = distance(player.origin, impact);

                weapon = self getcurrentweapon();

                #ifdef BO3
                if(dist < nearestDist && getweapon(isdamageweapon(weapon)) && player != self)
                #else
                if(dist < nearestDist && isdamageweapon(weapon) && player != self)
                #endif
                {
                    nearestDist = dist;
                    nearestPlayer = player;
                }
            }

            if(nearestDist != 150)
            {
                ndist = nearestDist * 0.0254;
                ndist_i = int(ndist);

                ndist = ( ndist_i < 1 ) ? getsubstr( ndist, 0, 3 ) : ndist_i;

                distToNear = distance(self.origin, nearestPlayer.origin) * 0.0254;
                dist = int(distToNear);

                distToNear = ( dist < 1 ) ? getsubstr( distToNear, 0, 3) : dist;

                #ifdef MWR
                    lastKill = 24;
                #else
                    lastKill = 29;
                #endif

                if(level.currentGametype == "dm")  
                    #ifdef BO3
                    if(self.kills == lastKill && isAlive(nearestPlayer) && getweapon(isDamageWeapon(weapon)))
                    #else 
                    if(self.kills == lastKill && isAlive(nearestPlayer) && isDamageWeapon(weapon))
                    #endif
                        self thread registerAlmostHit(nearestPlayer, dist);
            }
        }
    }

    registerAlmostHit(nearestPlayer, dist)
    {
        iprintln("^2" + self.name + "^7 almost hit ^1" + nearestPlayer.name + " ^7from ^1" + dist + "m^7!");
        self.ahCount++;

        if(self.ahCount % 3 == 0) self iprintlnbold( "^1" + rndmmgfunnymsg() );
    }

    trackstats()
    {
        self endon("disconnect");
        level waittill("game_ended");

        if(level.currentGametype == "dm")
        {
            wait 0.5;

            if(self.ahCount == 1) self iprintln("You almost hit ^1" + self.ahCount + " ^7time!");

            else if(self.ahCount > 0) self iprintln("You almost hit ^1" + self.ahCount + " ^7times!");
            
            else self iprintln("You didn't almost hit ^1anyone^7! " + self rndmEGfunnyMsg());
        }
    }

    rndmMGfunnyMsg()
    {
        MGfunnyMsg = [];
        MGfunnyMsg[0] = "Almost had it. Gotta be quicker than that";
        MGfunnyMsg[1] = "'If you hit, i'll let you fuck me.' -Jams";
        MGfunnyMsg[2] = "Maybe the next one will connect..Maybe";
        MGfunnyMsg[3] = "Even the bots are embarassed for you";
        MGfunnyMsg[4] = "I've seen better reflexes from a toaster";
        MGfunnyMsg[5] = "You're the final boss of disappointment";
        MGfunnyMsg[6] = "You suck. But less than you did yesterday!";
        MGfunnyMsg[7] = "Still trash, but I see the potential!";
        MGfunnyMsg[8] = "That was garbage - but inspiring garbage!";
        MGfunnyMsg[9] = "You missed, but with confidence. Respect";
        MGfunnyMsg[10] = "Damn that was ugly, but improvement is ugly!";
        MGfunnyMsg[11] = "You didn't hit it but you believed you would";
        MGfunnyMsg[12] = "You're improving..painfully..slowly..but improving";
        MGfunnyMsg[13] = "Not the worst i've seen. Today that is";
        MGfunnyMsg[14] = "Keep trying. Statistically, something will connect. Eventually";
        MGfunnyMsg[15] = "You're one step closer to being average";
        MGfunnyMsg[16] = "That sucked..but you're trying and that counts. I guess";
        MGfunnyMsg[17] = "Is your little brother playing for you or what?";
        MGfunnyMsg[18] = "You're not bad, you're consistent. At being bad";
        MGfunnyMsg[19] = "At this point, just turn on EB";

        return MGfunnyMsg[RandomInt(MGfunnyMsg.size)];
    }

    rndmEGfunnyMsg()
    {
        EGfunnyMsg = [];
        EGfunnyMsg[0] = "Even aim assist gave up on you";
        EGfunnyMsg[1] = "Stick to your day job!";
        EGfunnyMsg[2] = "Just sell your console dawg.";
        EGfunnyMsg[3] = "You aim like a blindfolded potato";
        EGfunnyMsg[4] = "Just delete the game bro";
        EGfunnyMsg[5] = "Next time try playing with your eyes open";
        EGfunnyMsg[6] = "You're the reason friendly fire exists";
        EGfunnyMsg[7] = "Is your controller upside down or what?";
        EGfunnyMsg[8] = "Failure builds character. You must have a ton";
        EGfunnyMsg[9] = "You're bad but hey - at least you're consistent";
        EGfunnyMsg[10] = "You've got heart. No skill, but heart";
        EGfunnyMsg[11] = "You make AFK players look useful";
        EGfunnyMsg[12] = "If skill was money, you'd be broke";
        EGfunnyMsg[13] = "Your aim has commitment issues";
        EGfunnyMsg[14] = "You missed every shot. Impressive. Depressing, but impressive";
        EGfunnyMsg[15] = "Your existence lowers the lobby's IQ";
        EGfunnyMsg[16] = "You need scripts my guy";
        EGfunnyMsg[17] = "What are you doing, bird hunting?";
        EGfunnyMsg[18] = "Get off the sticks and log back into Roblox";
        EGfunnyMsg[19] = "Your KD is crying right now";

        return EGfunnyMsg[RandomInt(EGfunnyMsg.size)];
    }

    changeClass()
    {
        self endon("disconnect");

        game["strings"]["change_class"] = "";

        for(;;)
        {
            #ifdef WAW || MW1
            self waittill("menuresponse", menu, className);
            wait .1;
            self maps\mp\gametypes\_class::setClass(self.pers["class"]);
            self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],self.pers["class"]);
            #endif

            #ifdef BO1 || BO2
                #ifdef MP
                self waittill("changed_class");
                self thread maps\mp\gametypes\_class::giveLoadout( self.team, self.class );
                wait .1;
                #endif
            #endif

            #ifdef MW2 || MW3
            self waittill("menuresponse", menu, className);

            wait .1; 
            
            if (isDefined(level.classMap[className]))
            {   
                self.pers["class"] = className; 
                self maps\mp\gametypes\_class::setClass(self.pers["class"]);
                self maps\mp\gametypes\_class::giveLoadout(self.pers["team"], self.pers["class"]);
            }
            #ifdef MW3
                self givePerk("specialty_falldamage", false);
            #endif
            #endif
            
            #ifdef Ghosts || MWR
            self endon("disconnect");

            for(;;)
            {
                self waittill("luinotifyserver", menu, className);

                if(menu == "class_select" && className < 60)
                {
                    self.class = "custom" + (className + 1);
                    self maps\mp\gametypes\_class::setclass(self.class);
                    self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],self.class);

                    #ifdef MWR
                    self maps\mp\gametypes\_class::applyloadout();
                    #endif
                }
                wait 0.05;
            }
            #endif

            #ifdef IW
            self endon( "disconnect" );

            for( ;; )
            {
                self waittill( "luinotifyserver", menu, classIndex );

                className = scripts\mp\_menus::func_7E2A( classIndex + 1 );

                if( menu == "class_select" && isDefined( className ))
                {
                    self.class    = className;
                    self.var_4004 = className;

                    scripts\mp\_class::func_F691( self.class );
                    scripts\mp\_class::func_8379( self.pers["team"], self.class );
                }
                wait 0.05;
            }
            #endif

            #ifdef BO3
            //???
            #endif
        }
    }

    hasBots()
    {
        for(i=0; i < level.players.size; i++)
        {
            if(isDefined(level.players[i].pers["isBot"]) && level.players[i].pers["isBot"])
                return true;
        }

        return false;
    }

    doBots()
    {
        hostTeam = (getDvar("host_team"));
        team = hostTeam == "allies" ? "axis" : "allies";

        #ifdef WAW || MW1
        if (level.currentGametype == "dm") 
        {
            for (i = 0; i < 18; i++)
            {
                wait 0.25;
                addtestclients(1);
                level.i++;
                wait 0.5;
            }
        }

        else if(level.currentGametype == "sd")
        {
            if(getteamplayersalive(!hostTeam) <= 1)
            {
                addtestclients(3, !hostTeam);
                wait .125;
            }
        }

        #ifdef WAW
        else if(level.currentGametype == "tdm")
        #else
        else if(level.currentGametype == "war")
        #endif
        {
            if(getteamplayersalive(!hostTeam) <=1)
                addtestclients(6, !hostTeam);
        }
        #endif

        #ifdef BO1
        if(level.currentGametype == "dm")
        {
            while (level.i < 18) 
            {
                wait .125;
                spawnEnemyBot();
                level.i++;
                wait 0.5;
            }
        }

        else if(level.currentGametype == "sd")
        {
            if(getteamplayersalive(!hostTeam) <= 1)
                spawnEnemyBot(3, !hostTeam);
        }

        else if(level.currentGametype == "tdm")
        {
            if(getteamplayersalive(!hostTeam) <= 1 )
                spawnEnemyBot(6, !hostTeam);
        }
        #endif

        #ifdef MW2
        if(level.currentGametype == "dm")
        {
            level.i = 0;
            while (level.i < 18) 
            {
                wait .125;
                spawnBots(18);
                level.i++;
                wait 0.5;
            }
        }

        else if(level.currentGametype == "sd")
        {
            if(getteamplayersalive(self.team != hostTeam <= 1))
                spawnBots(3, !hostTeam);
        }

        else if(level.currentGametype == "war")
        {
            if(getteamplayersalive(self.team != !hostTeam <= 1))
                spawnBots(6, !hostTeam);
        }
        #endif

        #ifdef MW3
        if(level.currentGametype == "dm")
        {
            emptySlots = 18 - level.players.size;
            wait .125;
            addbot(emptySlots);
        }

        else if(level.currentGametype == "sd")
        {
            if(getteamplayersalive(self.team != hostTeam <= 1))
                addbot(3, !hostTeam);
        }  

        else if(level.currentGametype == "war")
        {
            if(getteamplayersalive(self.team != !hostTeam <= 1))
                addbot(6, !hostTeam);
        }
        #endif 

        #ifdef BO2
            #ifdef MP
            if(level.currentGametype == "dm")
            {
                while(level.players.size < 18)
                    spawnBots(1);
            }
            else if(level.currentGametype == "sd")
            {
                if(getteamplayersalive(team) <= 1)
                    spawnBots(3, team);
            }
            else if(level.currentGametype == "tdm")
            {
                if(getteamplayersalive(team) <=1)
                    spawnBots(6, team);
            }
            #endif
        #endif

        #ifdef Ghosts
        if(level.currentGametype == "dm")
        {
            while(level.players.size < 18)
                spawnBots(1, undefined, undefined, undefined, "spawned_player", "recruit");
        }
        #endif

        #ifdef MWR
        if(level.currentGametype == "dm")
        {
            while(level.players.size < 18)
                spawnBots(1, undefined, undefined, undefined, "spawned_player", "recruit");
        }
        #endif

        #ifdef BO3
        if(level.currentGametype == "dm")
        {
            while(level.players.size < 18)
                spawnbots(1, undefined);
        }
        #endif

        #ifdef IW
        if(level.currentGametype == "dm")
        {
            while(level.players.size < 18)
                spawnBots(1, undefined, undefined, undefined, "spawned_player", "recruit");
        }
        #endif
    }

    botSetup()
    {
        if (!isDefined(self.pers["isBot"]) || !self.pers["isBot"])
            return;

        #ifdef IW

        #else
        self clearperks();
        self setRank(randomintrange(0, 49), randomintrange(0, 15));
        #endif
        self thread botsCantWin();
        
        #ifdef MW2 || MW3 || WAW || MW1
        self thread botSwitchGuns();
        #endif
    }

    #ifdef BO1 || BO2 || Ghosts || MWR || BO3
    botsGetKnives()
    {
        if (!isDefined(self.pers["isBot"]) || !self.pers["isBot"])
            return;

        if(self getcurrentweapon() != "knife_mp")
        {
            self takeallweapons();
            self giveweapon("knife_mp");
            self switchtoweapon("knife_mp");
            self setspawnweapon("knife_mp");
        }
    }
    #endif

    botSwitchGuns()
    {
        self endon("disconnect");
        weapons = [];

        #ifdef MW1
        weapons = ["usp_mp", "colt45_mp"];
        #endif

        #ifdef WAW
        weapons = ["colt_mp", "nambu_mp"];
        #endif

        #ifdef MW2
        weapons = ["usp_mp", "deserteagle_mp"];
        #endif

        #ifdef MW3
        weapons = ["iw5_usp45_mp", "iw5_deserteagle_mp"];
        #endif

        #ifdef IW
        weapons = ["iw7_revolver_mp", "iw7_mag_mp"];
        #endif

        current = 0;

        for (;;)
        {
            #ifdef IW

            #else
            self takeallweapons();
            #endif
            wait .1;
            self takeWeapon(weapons[1 - current]);          
            self giveWeapon(weapons[current]);              
            self switchToWeapon(weapons[current]);          
            wait 0.05; 
            self setWeaponAmmoClip(weapons[current], 0); 
            current = 1 - current;
            wait 0.2;
        }
    }

    botsCantWin()
    {
        self endon( "disconnect" );
        level endon( "game_ended" );

        for(;;)
        {
            wait 0.25;

            #ifdef BO2 || BO3
            
            #ifdef BO2
                #ifdef MP
                maps\mp\gametypes\_globallogic_score::_setplayermomentum(self, 0);
                #endif
            #endif

            if(self.pers["pointstowin"] >= 20)
            {
                self.pointstowin = 0;
                self.pers["pointstowin"] = self.pointstowin;
                self.score = 0;
                self.pers["score"] = self.score;
                self.kills = 0;
                self.deaths = 0;
                self.headshots = 0;
                self.pers["kills"] = self.kills;
                self.pers["deaths"] = self.deaths;
                self.pers["headshots"] = self.headshots;
            }

            #else

            if(self.pers["kills"] >= 20 || self.kills >= 20)
            {
                self.pers["kills"] = 0;         
                self.pers["score"] = 0;         
                self.pers["deaths"] = 0;        
                self.pers["headshots"] = 0;       
                self.kills     = 0;                 
                self.deaths    = 0;                
                self.headshots = 0;
                self.score     = 0;
            }
            #endif
        }
    }

    tdmFastlast()
    {
        #ifdef MW1 || WAW

        #ifdef MW1
        if(level.currentGametype == "war")
        #else
        if(level.currentGametype == "tdm")
        #endif
        {
            game["teamScores"][self.pers["team"]] = 730;
            maps\mp\gametypes\_globallogic::updateTeamScores(self.pers["team"]);
        }
        #endif

        #ifdef MW2 || MW3
        if(level.currentGametype == "war")
        {
            game["teamScores"][self.pers["team"]] = 7300;
            setTeamScore(self.pers["team"], game["teamScores"][self.pers["team"]]);
        }
        #endif

        #ifdef BO1 || BO2
        if(level.currentGametype == "tdm")
        {
            #ifdef BO1
            maps\mp\gametypes\_globallogic_score::_setTeamScore(self.pers["team"], 7300);
            #else
            #ifdef MP
            maps\mp\gametypes\_globallogic_score::_setTeamScore(self.pers["team"], 73);
            #endif
            #endif
        }
        #endif
    }

    ffaFastLast()
    {
        #ifdef WAW || MW1
        if (level.currentGametype == "dm")
        {
            self.score = 140;
            self.pers[ "score" ] = 140;
            self.kills = 28;
            self.pers[ "kills" ] = 28;
        }
        #endif

        #ifdef MW2 || MW3 || BO1 || BO2
        if(level.currentGametype == "dm")
        {
            self.kills   = 28;
            self.score   = 1400;
            self.pers["pointstowin"] = 28;
            self.pers["kills"] = 28;
            self.pers["score"] = 1400;
        }
        #endif

        #ifdef MWR
        if(level.currentGametype == "dm")
        {
            self.kills   = 23;
            self.score   = 23;
            self.pers["pointstowin"] = 23;
            self.pers["kills"] = 23;
            self.pers["score"] = 23;
        }
        #endif

        #ifdef BO3
        if(level.currentGametype == "dm")
        {
            self.kills   = 28;
            self.score   = 28;
            self.pers["pointstowin"] = 28;
            self.pers["kills"] = 28;
            self.pers["score"] = 28;
        }
        #endif

        #ifdef Ghosts
        if(level.currentGametype == "dm")
        {
            self.kills   = 28;
            self.score   = 28;
            self.pers["pointstowin"] = 28;
            self.pers["kills"] = 28;
            self.pers["score"] = 28;
        }
        #endif

        #ifdef IW
        if(level.currentGametype == "dm")
        {
            self.kills   = 28;
            self.score   = 28;
            self.pers["pointstowin"] = 28;
            self.pers["kills"] = 28;
            self.pers["score"] = 28;
        }
        #endif
    }

    greencrateLocation1()
    {
        self endon("disconnect");
        level endon("game_ended");

        mapName = level.currentMapName;
        spawnLocations = [];

        for(i = -3; i < 3; i++)
        {
            for(d = -3; d<3; d++)
            {
                if (mapName == "mp_nuked") 
                {
                    spawnLocations = [
                        (3722.89, 12221.2, 3778.52),
                        (-176.716, -8530.06, 3100.1),
                        (-6044.9, 840.61, 2904.33)
                    ];
                } 

                else if (mapName == "mp_array") 
                {
                    spawnLocations = [
                        (-3693.71, 12239.5, 3939.71)
                    ];
                } 

                else if (mapName == "mp_radiation") 
                {
                    spawnLocations = [
                        (-817.408, -5206.03, 2637.54),
                        (-4291.16, 785.343, 2003.31),
                        (-376.241, 7292.82, 1805.27)
                    ];
                }

                else if (mapName == "mp_cracked")
                {
                    spawnLocations   = [
                        (-1746.1, -4883.62, 574.74)
                    ];
                }

                else if(mapName == "mp_crisis")
                {
                    spawnLocations = [
                        (-5748.65, 415.442, 1785.81),
                        (10115.2, 424.233, 4229.94)
                    ];
                }

                else if(mapName == "mp_duga")
                {
                    spawnLocations = [
                        (108.001, 2328.06, 3247.1)
                    ];
                }

                else if(mapName == "mp_cosmodrome")
                {
                    spawnLocations = [
                        (2531.77, -2217.04, 1887.63),
                        (2534.83, -6.35055, 1887.23)
                    ];         
                }

                else if(mapName == "mp_mountain")
                {
                    spawnLocations = [
                        (4665.13, 1613.21, 1116.93),
                        (3397.42, -5086.48, 2836.9),
                        (-368.874, 333.844, 1856.18)
                    ];
                }

                else if(mapName == "mp_russianbase")
                {
                    spawnLocations = [
                        (2126.6, -4917, 3734.69),
                        (-1334.47, 3209.59, 791.472),
                        (3955.7, 919.906, 2155.37)
                    ];
                }

                else if(mapName == "mp_villa")
                {
                    spawnLocations   = (10348.4, 4352.82, 3906.91);
                }

                else if(mapName == "mp_silo")
                {
                    spawnLocations   = (7042.24, 6759.94, 4056.28);
                }

                for( a = 0; a < spawnLocations.size; a++)
                {
                    spawngreencrate1 = spawn("script_model", spawnLocations[ a ] + (d * 25, i * 45, 0));
                    spawngreencrate1 setmodel("mp_supplydrop_ally");
                }
            }
        }
    }

    lowerBarriers()
    {
        #ifdef MW3
        //Overwatch
        //Sanctuary ?
        //Offshore
        #endif

        #ifdef BO1
        lowerbarrier("mp_array", 400);
        lowerbarrier("mp_firingrange", 130);
        lowerbarrier("mp_cosmodrome", 600);
        lowerbarrier("mp_radiation", 105);
        removeskybarrier();
        #endif

        #ifdef BO2
        lowerbarrier("mp_carrier", 150);
        lowerbarrier("mp_bridge", 1000);
        lowerbarrier("mp_concert", 200);
        lowerbarrier("mp_nightclub", 250);
        lowerbarrier("mp_slums", 350);
        lowerbarrier("mp_meltdown", 100);
        lowerbarrier("mp_raid", 120);
        lowerbarrier("mp_studio", 20);
        lowerbarrier("mp_downhill", 620);
        lowerbarrier("mp_vertigo", 1000);
        lowerbarrier("mp_hydro", 1000);
        lowerbarrier("mp_nuketown_2020", 200);
        removehighbarrier();
        #endif
    }

    lowerbarrier(map, value)
    {
        if(level.script != map)
            return;
        
        hurt_triggers = GetEntArray( "trigger_hurt", "classname" );

        foreach(barrier in hurt_triggers)
            if(barrier.origin[2] <= 0 ) barrier.origin = barrier.origin - ( 0, 0, value );
    }

    removehighbarrier()
    {
        hurt_triggers = GetEntArray( "trigger_hurt", "classname" );

        foreach( barrier in hurt_triggers )
            if( barrier.origin[ 2] >= 70 && IsDefined( barrier.origin[ 2] ) ) barrier.origin = barrier.origin + ( 0, 0, 99999 );
    }

    removeSkyBarrier()
    {
        setDvar("g_deadZoneDamageMin", 999999);
        setDvar("g_deadZoneDamageMax", 999999);
        
        deathTriggers = getEntArray("trigger_hurt", "classname");
        
        for(i = 0; i < deathTriggers.size; i++)
        {
            if(deathTriggers[i].origin[2] > 180)
                deathTriggers[i] delete();

            else
            {
                deathTriggers[i].damage = 999999;
                deathTriggers[i].damagetype = "MOD_SUICIDE";
            }
        }
    }

    PMColor() // Private Match
    {
        if(!isConsole())
            return;

        #ifdef MW2
        WriteString( 0xA50D9218, "^0Project Paradise" );
        setRGB(0xA50D90AC, 1.0, 0.4, 0.8); // Private Match Text - pink
        setRGB(0xA50D9294, 0.9, 0.3, 0.9); // Recommend Players Colour - pinkish purple
        setRGB(0xA50D9920, 0.8, 0.2, 0.9); // Map Name Colour - soft pink-purple
        setRGB(0xA50DA9E4, 0.7, 0.1, 0.95); // Line 1 - pink-purple
        setRGB(0xA50DBB78, 0.6, 0.0, 1.0); // Line 2 - violet
        setRGB(0xA50DEDA8, 0.45, 0.1, 1.0); // Rank Colour - blue-purple
        setRGB(0xA50DF0CC, 0.3, 0.2, 1.0);  // Score Colour - blue
        setRGB(0xA50D878C, 0.2, 0.3, 1.0);  // PM Cloud Colour 1 - blue
        setRGB(0xA50D8964, 0.4, 0.4, 1.0);  // PM Cloud Colour 2 - bluish
        setRGB(0xA50D85C0, 0.6, 0.5, 1.0);  // PM Cloud Colour 3 - blue-pink blend
        setRGB(0xA50D8B34, 0.8, 0.6, 1.0);  // Mock Up Glow 1 - light purple
        setRGB(0xA50D8D0C, 0.9, 0.7, 1.0);  // Mock Up Glow 2 - soft pink-purple
        setRGB(0xA50D8EDC, 1.0, 0.8, 1.0);  // Left Side Colour - pale pink
        // setRGB(0xA50D9754, 1.0, 0.7, 1.0); // Map Background - magenta (uncomment for full gradient)
        setRGB(0xA50DC314, 0.9, 0.4, 1.0);  // Change Map Text - magenta end
        #endif
    }

    setRGB(addr, r, g, b)
    {
        WriteFloat(addr,       r);
        WriteFloat(addr + 0x4, g);
        WriteFloat(addr + 0x8, b);
    }

    #ifdef MW2 || MW3
    autoFakeNuke()
    {
        level endon("game_ended");

        level waittill("prematch_over");

        while(1)
        {
            timePassed = getTimePassed() / 1000;
            timeLimit  = getTimeLimit() * 60;

            timeRemaining = timeLimit - timePassed;

            #ifdef MW2
            if(timeRemaining <= 3 && timeRemaining > 0)
            #else
            if(timeRemaining <= 13 && timeRemaining > 0)
            #endif
            {
                level thread FakeNuke();
                break;
            }

            wait 0.5;
        }
    }
    #endif

    ServerSettings()
    {
        #ifdef MW1
            #ifdef XBOX
            //Elevators
            WriteShort(0x823344E8, 0x4800);
            addresses = [0x82338278, 0x8233841C, 0x8233855C];
            for( i = 0; i < addresses.size; i++ ) 
            WriteInt(addresses[i], 0x60000000);

            //BulletPenetration
            WriteInt(0x8232B78C, 0x60000000); //BG_GetSurfacePenetration(bne(branch if not equal) call to loc_8232B79C)
            WriteByte(0x8232B793, 0x09);      //BG_GetSurfacePenetration(lis(load immediate shifted))
            WriteInt(0x8232B794, 0xC02BCA60); //BG_GetSurfacePenetration(lfs(load floating point single) from flt_820016A8)

            //Range
            WriteInt(0x82289C28, 0xC3CBCA60); //Bullet_Fire(lfs(load floating point single) from flt_8208CA60)
            WriteShort(0x82289C0C, 0x4800);   //Bullet_Fire(bne(branch if not equal) to loc_82289C20)

            #endif
        #endif

        #ifdef MW2     
            //Bounces
            WriteShort(0x820D216C, 0x4800, 0x4198);       //Force Bounce(PM_ProjectVelocity)
            WriteInt(0x820DABE4, 0x48000018, 0x409AFFB0); //Bounces(PM_StepSlideMove)

            //Elevators
            WriteShort(0x820D8360, 0x4800);   //Elevators(PM_CorrectAllSolid)
            WriteInt(0x820D8310, 0x60000000); //PM_CorrectAllSolid(For Easy Elevators)

            //PM_CheckDuck(For Easy Elevators)
            addresses = [0x820D4E74, 0x820D4F34, 0x820D5020];
            for(a = 0; a < addresses.size; a++)
            WriteInt(addresses[a], 0x60000000);

            //BulletPenetration
            WriteFloat(0x82008898, 9999999.0);
            WriteInt(0x820E217C, 0x60000000); //BG_GetSurfacePenetrationDepth(bne(branch if not equal) call to loc_820E218C)
            WriteInt(0x820E2184, 0xC02B8898); //BG_GetSurfacePenetrationDepth(lfs(load floating point single) from __real_00000000)

            //Range
            WriteInt(0x821CF3E4, 0xC3EB8898); //Bullet_Fire(lfs(load floating point single) from aF_0)
            WriteShort(0x821CF3C4, 0x4800);   //Bullet_Fire(beq(branch if equal) to loc_821CF3DC) -- Force branch to loc_821CF3DC(Allow all weapons to have max bullet range)

            //Prone Anywhere
            WriteByte(0x820D47CB, 0x01);      //PlayerProneAllowed(li(load immediate) 1 to register)
            WriteByte(0x820D47C3, 0x01);      //PlayerProneAllowed(li(load immediate) 1 to register)
            WriteShort(0x820CFBAC, 0x4800);   //BG_CheckProneValid(force branch to loc_820CFC24)
            WriteInt(0x820CFC2C, 0x60000000); //BG_CheckProneValid(nop beq(branch if equal) to loc_820CFC3C)
            WriteShort(0x820CFC38, 0x4800);   //BG_CheckProneValid(force branch to loc_820CFDD8)
            WriteByte(0x820CFDDB, 0x01);      //BG_CheckProneValid(li(load immedaite) 1 to register)
        #endif

        #ifdef MW3
            //Bounces
            WriteShort(0x820E2494, 0x4800, 0x4198);       //Force Bounce(PM_ProjectVelocity)
            WriteShort(0x820EB4D0, 0x4800, 0x419A);       //Force PM_ProjectVelocity(PM_StepSlideMove)
            WriteInt(0x820EB474, 0x48000018, 0x409AFFB0); //Bounces(PM_StepSlideMove)  

            //Elevators
            WriteShort(0x820E8A9C, 0x4800);   //Elevators(PM_JitterPoint)
            WriteInt(0x820E8A4C, 0x60000000); //PM_JitterPoint(For Easy Elevators)  

            //PM_CheckDuck(For Easy Elevators) - MW3 addresses
            addresses = [0x820E52CC, 0x820E5378, 0x820E5444];          
            for(a = 0; a < addresses.size; a++)
            WriteInt(addresses[a], 0x60000000);

            //Bullet Penetration
            WriteInt(0x820F6F80, 0x60000000); //BG_GetSurfacePenetrationDepth(bne(branch if not equal) call to loc_820F6F98)
            WriteByte(0x820F6F8A, 0xAA);      //BG_GetSurfacePenetrationDepth(lfs(load floating point single) from __real_00000000)

            //Range
            WriteShort(0x8222BA94, 0x4800); //Bullet_Fire_Internal(Default -> 0x419A || Force Branch -> 0x4800) -- Force branch to make bullet range be the same for all weapon classes
            WriteByte(0x8222BAB3, 0x04);    //Bullet_Fire_Internal(patch in float -> 0x04 || default -> 0x01) -- Patch in new float to replace the default range(8192.0) with the new float(999900.0)
            WriteShort(0x8222BABA, 0xAD20); //Bullet_Fire_Internal(patch in float -> 0xAD20 || default -> 0x1B34) -- Finish patching in the new float   

            //Prone Anywhere
            WriteByte(0x820E4B43, 0x01);      //PlayerProneAllowed(li(load immediate) 1 to register)
            WriteByte(0x820E4B3B, 0x01);      //PlayerProneAllowed(li(load immediate) 1 to register)
            WriteShort(0x820DFB40, 0x4800);   //BG_CheckProneValid(force branch to loc_820CFC24)
            WriteInt(0x820DFBC0, 0x60000000); //BG_CheckProneValid(nop beq(branch if equal) to loc_820CFC3C)
            WriteShort(0x820DFBCC, 0x4800);   //BG_CheckProneValid(force branch to loc_820CFDD8)
            WriteByte(0x820DFD93, 0x01);      //BG_CheckProneValid(li(load immedaite) 1 to register)
        #endif
    }

    #ifdef BO3 || IW
    disableOOB()
    {
        #ifdef BO3
        oob_Triggers = getentarray( "trigger_out_of_bounds", "classname" );
        hurt_triggers = GetEntArray( "trigger_hurt", "classname" );

        foreach ( trigger in oob_Triggers )
            arrayremovevalue( level.oob_triggers, trigger );
        #endif

        #ifdef IW
        oob_Triggers = GetEntArray( "OutOfBounds", "targetname" );
        hurt_triggers = GetEntArray( "trigger_hurt", "classname" );

        foreach( trigger in oob_Triggers )
            if( isDefined( trigger ))
                trigger delete();
        #endif

        foreach( barrier in hurt_triggers )
            if( barrier.origin[ 2 ] >= 70 && IsDefined( barrier.origin[ 2 ] )) barrier.origin = barrier.origin + ( 0, 0, 99999 );
    }
    #endif

    #ifdef ZM
    player_too_many_players_check()
    {
        //empty
    }

    zombie_devgui_open_sesame()
    {
        setdvar( "zombie_unlock_all", 1 );
        common_scripts\utility::flag_set( "power_on" );
        players = maps\mp\_utility::get_players();
        common_scripts\utility::array_thread( players, maps\mp\zombies\_zm_devgui::zombie_devgui_give_money );
        zombie_doors = getentarray( "zombie_door", "targetname" );
        i = 0;
        while ( i < zombie_doors.size )
        {
            zombie_doors[ i ] notify( "trigger" );
            if ( is_true( zombie_doors[ i ].power_door_ignore_flag_wait ) )
            {
                zombie_doors[ i ] notify( "power_on" );
            }
            wait 0.05;
            i++;
        }
        zombie_airlock_doors = getentarray( "zombie_airlock_buy", "targetname" );
        i = 0;
        while ( i < zombie_airlock_doors.size )
        {
            zombie_airlock_doors[ i ] notify( "trigger" );
            wait 0.05;
            i++;
        }
        zombie_debris = getentarray( "zombie_debris", "targetname" );
        i = 0;
        while ( i < zombie_debris.size )
        {
            zombie_debris[ i ] notify( "trigger" );
            wait 0.05;
            i++;
        }
        zombie_devgui_build( undefined );
        level notify( "open_sesame" );
        wait 1;
        setdvar( "zombie_unlock_all", 0 );
    }

    zombie_devgui_build( buildable )
    {

        player = common_scripts\utility::get_players()[ 0 ];
        i = 0;
        while ( i < level.buildable_stubs.size )
        {
            if ( !isDefined( buildable ) || level.buildable_stubs[ i ].equipname == buildable )
            {
                if ( isDefined( buildable ) || level.buildable_stubs[ i ].persistent != 3 )
                {
                    level.buildable_stubs[ i ] maps\mp\zombies\_zm_buildables::buildablestub_finish_build( player );
                }
            }
            i++;
        }
    }

    turn_power_on_and_open_doors()
    {
        level.local_doors_stay_open = 1;
        level.power_local_doors_globally = 1;
        flag_set( "power_on" );
        level setclientfield( "zombie_power_on", 1 );
        zombie_doors = getentarray( "zombie_door", "targetname" );
        _a144 = zombie_doors;
        _k144 = getFirstArrayKey( _a144 );
        while ( isDefined( _k144 ) )
        {
            door = _a144[ _k144 ];
            if ( isDefined( door.script_noteworthy ) && door.script_noteworthy == "electric_door" )
                door notify( "power_on" );
            
            else
            {
                if ( isDefined( door.script_noteworthy ) && door.script_noteworthy == "local_electric_door" )
                    door notify( "local_power_on" );
            }
            _k144 = getNextArrayKey( _a144, _k144 );
        }
    }

    DrawWeaponWallbuys()
    {
        locations = ["bank", "bar", "church", "courthouse", "generalstore", "mansion", "morgue", "prison", "stables", "stablesroof", "toystore", "candyshop"];
        
        for(a = 0; a < level.buildable_wallbuy_weapons.size; a++)
        {
            locations = array_randomize(locations);
            
            DrawWallbuy(locations[0], level.buildable_wallbuy_weapons[a]);
            locations = ArrayRemove(locations, locations[0]);
            
            if(isDefined(level.chalk_pieces[a]))
                level.chalk_pieces[a] maps\mp\zombies\_zm_buildables::piece_unspawn();
        }
    }

    DrawWallbuy(location, weaponname)
    {
        foreach(key in GetArrayKeys(level.chalk_builds))
        {
            stub    = level.chalk_builds[key];
            wallbuy = common_scripts\utility::GetStruct(stub.target, "targetname");
            
            if(isDefined(wallbuy.script_location) && wallbuy.script_location == location)
            {
                if(!isDefined(wallbuy.script_noteworthy) || IsSubStr(wallbuy.script_noteworthy, level.scr_zm_ui_gametype + "_" + level.scr_zm_map_start_location))
                {
                    maps\mp\zombies\_zm_weapons::add_dynamic_wallbuy(weaponname, wallbuy.targetname, 1);
                    thread wait_and_remove(stub, stub.buildablezone.pieces[0]);
                }
            }
        }
    }

    wait_and_remove(stub, piece)
    {
        wait 0.1;
        self maps\mp\zombies\_zm_buildables::buildablestub_remove();
        thread maps\mp\zombies\_zm_unitrigger::unregister_unitrigger(stub);
        piece maps\mp\zombies\_zm_buildables::piece_unspawn();
    }

    ArrayRemove(arr, value)
    {
        if (!isDefined(arr) || !isDefined(value))
            return [];

        newArray = [];

        for (i = 0; i < arr.size; i++)
        {
            if (arr[i] != value)
                newArray[newArray.size] = arr[i];
        }

        return newArray;
    }

    modifyActorDamage(einflictor, attacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, timeoffset, boneindex)
    {
        isZombie = GetAISpeciesArray(level.zombie_team);

        if(self == isZombie)
            attacker notify("damageFeedback", "whiteMarker", 1500);

        return [[level.actorDamage]](einflictor, attacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, timeoffset, boneindex);
    }

    modifyactorkilled(einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime)
    {
        if (maps\mp\gametypes_zm\_globallogic_utils::isheadshot(sweapon, shitloc, smeansofdeath, einflictor) && isplayer(attacker))
        {
            attacker playlocalsound("prj_bullet_impact_headshot_helmet_nodie_2d");
            attacker notify("damageFeedback", "redMarker", 1500);
            smeansofdeath = "MOD_HEAD_SHOT";
        }
        return [[level.actorkilled]](einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime);
    }

    damageFeedback()
    {
        self notify("newFeedback");
        self endon("newFeedback");

        self.hitmarker destroy();
        self.hitmarker = newDamageIndicatorHudElem(self);
        self.hitmarker.horzAlign = "center";
        self.hitmarker.vertAlign = "middle";
        self.hitmarker.x = -12;
        self.hitmarker.y = -12;
        self.hitmarker.alpha = 0;
        self.hitmarker setShader("damage_feedback", 24, 48);
        self.hitsoundtracker = 1;

        while(1)
        {
            self waittill("damageFeedback", action, value);

            if(action == "whiteMarker")
                self whitemarker();
            
            if(action == "redMarker")
                self redmarker();
        }
    }

    redmarker(mod)
    {
        self notify("red_override");
        self thread playhitsound(mod, "mpl_hit_alert");
        self.hitmarker.alpha = 1;
        self.hitmarker.color = (1,0,0);
        self.hitmarker fadeOverTime(.5);
        self.hitmarker.color = (1,1,1);
        self.hitmarker.alpha = 0;
    }

    whitemarker(mod)
    {
        self endon("red_override");
        self thread playhitsound(mod, "mpl_hit_alert");
        self.hitmarker.alpha = 1;
        self.hitmarker fadeOverTime(.5);
        self.hitmarker.alpha = 0;
    }

    playhitsound(mod, alert)
    {
        self endon("disconnect");
        if (self.hitsoundtracker)
        {
            self.hitsoundtracker = 0;
            self playlocalsound(alert);
            wait 0.05;
            self.hitsoundtracker = 1;
        }
    }
    #endif