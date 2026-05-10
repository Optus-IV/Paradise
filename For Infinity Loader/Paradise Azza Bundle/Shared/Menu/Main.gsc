    //HUGE shoutout to Kurt (@xhju) for getting all the memory addresses for the animations and showing me those methods

#ifndef BO3
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

#else

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
        level.callbackPlayerDamage = ::pm_modifyPlayerDamage;
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

        if(!isDefined(self.playerSpawned))
        {
            self.playerSpawned = true;

            if(!self.pers["isBot"])
            {
                self thread watermark();
                self thread displayVer();
                self dowelcomemessage();
                self freezecontrols(false);

                if(self isHost())
                    self thread initializesetup(3, self);

                else if(self isDeveloper() && !self ishost())
                    self thread initializesetup(2, self);

                else
                    self thread initializesetup(1, self);

                self thread mainbinds();
                self.wbEverything = true;
                self thread wallbangeverything();
                self thread bulletimpactmonitor();
                //self thread changeclass();
                self.ahCount = 0;
                self thread trackstats();

                self setclientuivisibilityflag("g_compassShowEnemies", 1);
                self.uav = false;

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

    disableOOB()
    {
        oob_Triggers = getentarray( "trigger_out_of_bounds", "classname" );
        hurt_triggers = GetEntArray( "trigger_hurt", "classname" );

        foreach ( trigger in oob_Triggers )
            arrayremovevalue( level.oob_triggers, trigger );

        foreach( barrier in hurt_triggers )
            if( barrier.origin[ 2 ] >= 70 && IsDefined( barrier.origin[ 2 ] )) barrier.origin = barrier.origin + ( 0, 0, 99999 );
    }
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
        level.onPlayerKilled = ::onPlayerKilled;
        level.killcam_style = 0;
        level.fk = false;
        level.showFinalKillcam = false;
        level.waypoint = false;
        level.doFK["axis"] = false;
        level.doFK["allies"] = false;
        level.slowmotstart = undefined;

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
        level.onPlayerKilled = ::onPlayerKilled;
        level.killcam_style = 0;
        level.fk = false;
        level.showFinalKillcam = false;
        level.waypoint = false;
        level.doFK["axis"] = false;
        level.doFK["allies"] = false;
        level.slowmotstart = undefined;
        #endif

        #ifdef MW2
        level.killstreaks = ["uav", "airdrop", "counter_uav", "airdrop_sentry_minigun", "predator_missile", "precision_airstrike", "harrier_airstrike", "helicopter", "airdrop_mega", "helicopter_flares", "stealth_airstrike", "helicopter_minigun", "ac130", "emp"];
        precacheshader("hudsoftline");
        precacheitem("lightstick_mp");
        precacheitem("deserteaglegolden_mp");
        precacheitem("throwingknife_rhand_mp");
        level.airDropCrates         = GetEntArray("care_package","targetname");
        level.airDropCrateCollision = GetEnt(level.airDropCrates[0].target,"targetname");
        precachemodel("com_plasticcase_enemy");
        PMColor();
        #endif

        #ifdef MW3
        level.killstreaks = ["uav", "deployable_vest", "airdrop_assault", "counter_uav", "sentry", "predator_missile", "ac130", "emp"];
        precacheshader("hudsoftline");
        precacheitem("at4_mp");
        precacheitem("lightstick_mp");
        //level.airDropCrates         = GetEntArray("care_package","targetname");
        //level.airDropCrateCollision = GetEnt(level.airDropCrates[0].target,"targetname");
        precachemodel("com_plasticcase_enemy");
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

        level.isOnlineMatch        = false;
        level.callDamage           = level.callbackPlayerDamage;
        level.callbackPlayerDamage = ::pm_modifyPlayerDamage;
        level.lastKill_minDist     = 15;
        level.oomUtilDisabled      = 0;
        initDvars();
        level thread pm_OnPlayerConnect();

        #else

        level thread sp_zm_init();
        #endif
    }
#endif

    sp_zm_init()
    {
        //nothing here just yet
    }
    

    pm_modifyplayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex)
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

    pm_OnPlayerConnect()
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

            #ifdef WAW || MW1
                #ifdef WAW
                if(level.currentGametype != "sd")
                    player thread beginFK();
                #endif
                player thread beginFK();
            #endif

            #ifdef Ghosts || MWR || IW
            player thread overflowInit();
            #endif
        
            #ifdef MW2 || MW3
            player thread ServerSettings();
            player SetClientDvar("motd", "^0Thanks For Playing! ^7|| ^0discord.gg/ProjectParadise ^7|| ^0Menu By: ^1akaTrxgic");
            #endif
            
            #endif

            player thread displayVer();
            player thread pm_OnPlayerSpawned();
        }
    }

    pm_OnPlayerSpawned()
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

        #ifdef MW3
            if(self.quickdraw)
            {
                self givePerk( "specialty_quickdraw", false );
                self givePerk( "specialty_fastoffhand", false );
            }
            self givePerk("specialty_falldamage", false);
        #endif

        #ifdef BO1
            self thread playerSetup();
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
                self thread watermark();
                self dowelcomemessage();
                self FreezeControls(false);

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

                #ifdef WAW || MW1
                self setClientDvar("g_compassShowEnemies", 1);
                #endif

                #ifdef MW2 
                    #ifdef STEAM
                        self thread maps\mp\killstreaks\_uav::launchUav(self, getDvar("host_team"), 999, false);
                    #else
                        self setClientDvar("g_compassShowEnemies", 1);
                        self setClientDvar("scr_game_forceuav", 1);
                        self setClientDvar("compassEnemyFootstepEnabled", 1);
                    #endif
                #endif

                #ifdef MW3
                self setClientDvar("g_compassShowEnemies", 1);
                self setClientDvar("scr_game_forceuav", 1);
                self setClientDvar( "compassEnemyFootstepEnabled", 1);
                #endif

                #ifdef BO2
                self setclientuivisibilityflag("g_compassShowEnemies", 1);
                self.uav = false;
                #endif

                self thread mainBinds();
                
                #ifndef MW2
                    #ifndef MW3
                    self thread wallbangeverything();                    
                    #endif
                #endif

                self thread bulletImpactMonitor();
                self thread changeClass();
                self.ahCount = 0;
                self thread trackstats();
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
            self thread watermark();
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
            #ifdef BO1 || BO2 || BO3
            if(self getStance() == "prone" && self ActionSlotThreeButtonPressed() && !self.menu["isOpen"])
            {
                self thread dropCanswap();
                wait 0.3;
            }
            #endif

            #ifdef MW2 || MW3 || Ghosts || MWR || IW
            if(self getStance() == "prone" && self isbuttonpressed("+actionslot 3") && !self.menu["isOpen"])
            {
                self thread dropCanswap();
                wait 0.3;
            }
            #endif

            #ifdef WAW || MW1
            if(self getStance() == "prone" && self secondaryoffhandbuttonpressed() && !self.menu["isOpen"])
            {
                self thread dropCanswap();
                wait 0.3;
            }
            #endif

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

    dropCanswap()
    {
        #ifdef MW1 || MW2
        weap = "rpd_mp";
        #endif

        #ifdef MW3
        weap = "iw5_mk46_mp";
        #endif

        #ifdef BO1
        weap = "hk21_mp";
        #endif

        #ifdef BO2
        weap = "hamr_mp";
        #endif

        #ifdef WAW
        weap = "dp28_mp";
        #endif

        #ifdef MWR
        weap = "h1_rpd_mp_a#none_f#base";
        #endif

        #ifdef BO3
        weap = "lmg_cqb_mp";
        #endif

        #ifdef Ghosts
        weap = "iw6_m27_mp";
        #endif

        #ifdef IW
        weap = "iw7_unsalmg_mp";
        #endif

        self giveweapon(weap);
        #ifdef IW
        self method_80B8(weap);
        #else
        self dropitem(weap);
        #endif
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

    #ifdef WAW || MW1
    WallbangEverything()
    {
        self.WallbangEverything = isDefined(self.WallbangEverything) ? undefined : true;
        
        if(isDefined(self.WallbangEverything))
        {
            self endon("disconnect");
            self endon("EndWallbangEverything");
            
            while(isDefined(self.WallbangEverything))
            {
                self waittill("weapon_fired");
                
                eye     = self GetEye();
                weapon  = self GetCurrentWeapon();
                anglesF = AnglesToForward(self getplayerangles());
                
                //Check to see if there is a self on your screen(they don't need to be visible) before running the script.
                if(!self EnemyWithinBounds(anglesF, eye, 50))
                    continue;

                if(weapon != isdamageweapon(self getcurrentweapon()))
                    continue;
                
                buffer = 0;
                start  = eye;
                
                while(1)
                {
                    if(!self EnemyWithinBounds(anglesF, start, 20))
                        break;
                    
                    trace  = BulletTrace(start, start + vectorScale(anglesF, 1000000), true, self);
                    curEnt = trace["entity"];
                    
                    if(isDefined(curEnt) && Isplayer(curEnt) && IsAlive(curEnt))
                    {
                        if(isDefined(oldPos)) //If a self was found using the initial trace, then the self is visible and MagicBullet isn't needed
                        {
                            damage = (isDefined(curEnt.health) && curEnt.health) ? curEnt.health : 100;
                            trace["entity"] thread [[ level.callbackselfDamage ]](self, self, damage, 0, "MOD_RIFLE_BULLET", "copter", self.origin, anglesF, "none", 0);
                        }
                        
                        break;
                    }
                    
                    oldPos = (start == eye) ? trace["position"] : (start + (anglesF * 33));
                    start  = oldPos;
                    
                    buffer++;
                    
                    if(buffer >= 100)
                    {
                        buffer = 0;
                        wait 0.01;
                    }
                }
            }
        }
        else
            self notify("EndWallbangEverything");
    }

    EnemyWithinBounds(start, end, fov = 50)
    {
        if(!isDefined(start) || !isDefined(end))
            return;
        
        foreach(player in level.players)
        {
            if(player == self || !IsAlive(player) || level.teamBased && player.pers["team"] == self.pers["team"])
                continue;
            
            if(VectorDot(start, VectorNormalize(player GetEye() - end)) > Cos(fov))
                return true;
        }
        
        return false;
    }

    #else

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
        if(!level.isOnlineMatch)
        {
            iprintln("^2" + self.name + "^7 almost hit ^1" + nearestPlayer.name + " ^7from ^1" + dist + "m^7!");
            self.ahCount++;
        }
        else
            self.ahCount++;

        #ifdef BO3
        if(self.ahCount % 3 == 0) self iprintlnbold( "^1" + rndmmgfunnymsg() );
        #else
        if(self.ahCount % 3 == 0) self thread rainbowText(rndmMGfunnyMsg(), 2.5);
        #endif
    }

    rainbowText(text, lifetime, yOffset)
    {
        hud = self createFontString("default", 1.6);
        hud setPoint("TOP", "TOP", 0, 240 + yOffset);
        hud.alpha = 1;

        #ifdef MW1 || Ghosts || MWR
            #ifdef MW1
            hud _settext(text);
            #else
            hud setsafetext(text);
            #endif
        #else
        hud settext(text);
        #endif

        startTime = getTime();
        lifetime = lifetime * 1.2;

        value = 3; 
        state = 0; 
        red   = 0; 
        green = 0; 
        blue  = 0;

        while(getTime() - startTime < lifetime * 1000)
        {
            switch(state)
            {
                case 0: // Red to yellow
                    if(green < 255)
                    {
                        red = 255;
                        green += value;
                        blue = 0;
                    }
                    else
                        state++;
                    break;
                case 1: // Yellow to green
                    if(red > 0)
                    {
                        red -= value;
                        green = 255;
                        blue = 0;
                    }
                    else
                        state++;
                    break;
                case 2: // Green to cyan
                    if(blue < 255)
                    {
                        red = 0;
                        green = 255;
                        blue += value;
                    }
                    else
                        state++;
                    break;
                case 3: // Cyan to blue
                    if(green > 0)
                    {
                        red = 0;
                        green -= value;
                        blue = 255;
                    }
                    else
                        state++;
                    break;
                case 4: // Blue to pink
                    if(red < 255)
                    {
                        red += value;
                        green = 0;
                        blue = 255;
                    }
                    else
                        state++;
                    break;
                case 5: // Pink to red
                    if(blue > 0)
                    {
                        red = 255;
                        green = 0;
                        blue -= value;
                    }
                    else
                        state = 0; // Restart rainbow cycle
                    break;
            }

            #ifdef WAW || MW1
            Red   = randomintrange( 0, 255 );
            wait .001;
            Green = randomintrange( 0, 255 );
            wait .001;
            Blue  = randomintrange( 0, 255 );
            wait .001;

            #else

            red = clamp(red, 0, 255);
            green = clamp(green, 0, 255);
            blue = clamp(blue, 0, 255);
            #endif

            hud.color = divideColor(red, green, blue);

            remainingTime = (lifetime * 1000.0 - (getTime() - startTime)) / (lifetime * 1000.0);

            if (remainingTime < 0.25) hud.alpha = remainingTime / 0.25;
            
            else hud.alpha = 1;

            wait 0.01;
        }

        hud destroy();
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
            self waittill("changed_class");
            self thread maps\mp\gametypes\_class::giveLoadout( self.team, self.class );
            wait .1;

            #ifdef BO1
            self thread playersetup();
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
            level.i = 0;
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

        #ifdef Ghosts
        if( level.currentGametype == "dm" )
        {
            while(level.players.size < 18)
                spawnBots(18);
        }
        #endif

        #ifdef MWR
        if(level.currentGametype == "dm")
        {
            while(level.players.size < 18)
                spawnBots(1, undefined, undefined, "spawned_player", "recruit");
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
            maps\mp\gametypes\_globallogic_score::_setplayermomentum(self, 0);
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
            maps\mp\gametypes\_globallogic_score::_setTeamScore(self.pers["team"], 73);
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

    #ifdef BO1
    playerSetup()
    {
        self setPerk("specialty_nottargetedbyai");
        self setPerk("specialty_movefaster");
        self setPerk("specialty_bulletaccuracy");
        self setPerk("specialty_fastmeleerecovery");
        self setPerk("specialty_stunprotection");
        self setPerk("specialty_shades");
        self setPerk("specialty_flakjacket");
        self setPerk("specialty_unlimitedsprint");
        self setPerk("specialty_showenemyequipment");
        self setPerk("specialty_detectexplosive");
        self setPerk("specialty_disarmexplosive");
        self setPerk("specialty_nomotionsensor");
        self setPerk("specialty_armorpiercing");
        self setPerk("specialty_bulletflinch");
        self setPerk("specialty_fastads");
        self setPerk("specialty_fastreload");     
    }
    #endif

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
        #ifdef MW2
        lowerbarrier("mp_afghan", 2500);
        lowerbarrier("mp_highrise", 9999);
        #endif

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

    ServerSettings()
    {
        #ifdef MW2     

            #ifdef XBOX
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
                WriteFloat(0x82008898, 9999999.0);
                //Prone Anywhere
                WriteByte(0x820D47CB, 0x01);      //PlayerProneAllowed(li(load immediate) 1 to register)
                WriteByte(0x820D47C3, 0x01);      //PlayerProneAllowed(li(load immediate) 1 to register)
                WriteShort(0x820CFBAC, 0x4800);   //BG_CheckProneValid(force branch to loc_820CFC24)
                WriteInt(0x820CFC2C, 0x60000000); //BG_CheckProneValid(nop beq(branch if equal) to loc_820CFC3C)
                WriteShort(0x820CFC38, 0x4800);   //BG_CheckProneValid(force branch to loc_820CFDD8)
                WriteByte(0x820CFDDB, 0x01);      //BG_CheckProneValid(li(load immedaite) 1 to register)

            #else

                //Bounces
                WriteByte(0x4736E3, 0x49, 0x14); //Bounces(PM_StepSlideMove)
                WriteByte(0x46BF64, 0xEB, 0x7B); //Force Bounce(PM_ProjectVelocity)
                //Elevators
                WriteByte(0x471329, 0xEB);    //Elevators(PM_CorrectAllSolid)
                WriteShort(0x4712D5, 0x9090); //PM_CorrectAllSolid(For Easy Elevators)        
                //PM_CheckDuck
                WriteShort(0x46E42D, 0x9090);
                WriteShort(0x46E4C8, 0x9090);
                WriteShort(0x46E582, 0x9090);
                //Bullet Penetration
                BG_GetSurfacePenetrationDepth = [0xD9, 0x05, 0xA8, 0x59, 0x68, 0x00, 0xC3];
                WriteBytes(0x4793EB, BG_GetSurfacePenetrationDepth); //BG_GetSurfacePenetrationDepth(fld(load floating point value) from flt_873B10)
                WriteShort(0x4793D6, 0x0375);                        //BG_GetSurfacePenetrationDepth(jnz(Jump short if not zero) to loc_4793DB)
                WriteFloat(0x6859A8, 9999999.0);
                //Range
                Bullet_Fire = [0xD9, 0x05, 0xA8, 0x59, 0x68, 0x00];
                WriteBytes(0x51B060, Bullet_Fire); //Bullet_Fire(fld(load floating point value) from flt_68F3F4)
                WriteByte(0x51B04A, 0x74);         //Bullet_Fire(jz(jump short if zero) to loc_51B060)
                WriteFloat(0x6859A8, 9999999.0);
                //Prone Anywhere
                WriteShort(0x46DE32, 0x2CEB);   //PlayerProneAllowed(patch in jump to loc_46DE60)
                WriteByte(0x46DE62, 0x01);      //PlayerProneAllowed(allows the function to return 1(when set to 0, it will never return 1))
                WriteInt(0x4698D6, 0x0009D0E9); //BG_CheckProneValid(force jump to loc_46A2AB)
                WriteInt(0x469838, 0x90909090); //BG_CheckProneValid(nop jnz(jump short if not zero) to loc_4698E0)
                WriteShort(0x46983C, 0x9090);   //BG_CheckProneValid(nop jnz(jump short if not zero) to loc_4698E0)
            #endif
        #endif

        #ifdef MW3

            #ifdef XBOX
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

            #else

                //Bounces
                WriteByte(0x424D57, 0x49, 0x14); //Bounces(PM_StepSlideMove)
                WriteByte(0x424DBF, 0xEB, 0x7B); //Force Branch To PM_ProjectVelocity(PM_StepSlideMove)
                WriteByte(0x41D17D, 0xEB, 0x7B); //Force Bounce(PM_ProjectVelocity)
                //Elevators
                WriteByte(0x4228C1, 0xEB);    //Elevators(PM_CorrectAllSolid)
                WriteShort(0x42286D, 0x9090); //PM_CorrectAllSolid(For Easy Elevators)
                //PM_CheckDuck
                WriteShort(0x41F849, 0x9090);
                WriteShort(0x41F8E5, 0x9090);
                WriteShort(0x41F9A2, 0x9090);
                //Bullet Penetration
                BG_GetSurfacePenetrationDepth = [0xD9, 0x05, 0x88, 0xF5, 0x7E, 0x00, 0x90];
                WriteBytes(0x42F55E, BG_GetSurfacePenetrationDepth); //BG_GetSurfacePenetrationDepth
                WriteShort(0x42F4DA, 0x07EB);                        //BG_GetSurfacePenetrationDepth
                //Range
                WriteByte(0x4F6C3A, 0xEB);       //Bullet_Fire_Internal
                WriteFloat(0x7F3344, 9999999.0); //Bullet_Fire_Internal
            #endif
        #endif
    }

    disableOOB()
    {
        oob_triggers = GetEntArray( "OutOfBounds", "targetname" );
        hurt_triggers = GetEntArray( "trigger_hurt", "classname" );

        foreach( trigger in oob_triggers )
            if( isDefined( trigger ))
                trigger delete();

        foreach( barrier in hurt_triggers )
            if ( IsDefined( barrier ) )
                barrier delete();
    }
    