    #include maps\mp\_utility;
    #include common_scripts\utility;

    #ifdef MP
        #include maps\mp\gametypes\_hud_util;

        #ifdef WAW
        #include maps\mp\gametypes\_globallogic_score;
        #endif

        #ifdef MW2 || MW3 || BO1 
        #include maps\mp\gametypes\_hud_message;
        #include maps\mp\killstreaks\_killstreaks;
        #endif

        #ifdef BO1
        #include maps\mp\gametypes\_globallogic;
        #endif
    #endif

    init()
    {
        level.strings              = [];
        level.status               = ["None","^2Verified","^5CoHost","^1Host"];
        level.MenuName             = "Paradise";
        level.currentMapName       = getDvar("mapname");
        level.currentGametype      = getDvar("g_gametype");
        level.onlineGame = getDvarInt("onlinegame");
        level.rankedMatch = ( !level.onlineGame || !getDvarInt( "xblive_privatematch" ) );
        setDvar("host_team", self.team);
        lowerBarriers();
        precacheshader("ui_arrow_right");

        #ifdef WAW
        precacheshader("hudsoftline");
        #endif

        #ifdef BO1
        precacheshader("hudsoftline");
        #endif

        #ifdef MW1
        level thread init_overFlowFix();
        precacheshader("hudsoftline");
        #endif

        #ifdef MW2
        level.killstreaks = ["uav", "airdrop", "counter_uav", "airdrop_sentry_minigun", "predator_missile", "precision_airstrike", "harrier_airstrike", "helicopter", "airdrop_mega", "helicopter_flares", "stealth_airstrike", "helicopter_minigun", "ac130", "emp"];
        precacheshader("hudsoftline");
        precacheitem("lightstick_mp");
        precacheitem("deserteaglegolden_mp");
        precacheitem("throwingknife_rhand_mp");
        #endif

        #ifdef MW3
        level.killstreaks = ["uav", "deployable_vest", "airdrop_assault", "counter_uav", "sentry", "predator_missile", "ac130", "emp"];
        precacheshader("hudsoftline");
        precacheitem("at4_mp");
        precacheitem("lightstick_mp");
        #endif

        #ifdef WAW || BO1
        level thread tarc_pub_init();
        #endif

        #ifdef MW1 || MW2 || MW3
        level.callDamage           = level.callbackPlayerDamage;
        level.callbackPlayerDamage = ::pub_modifyPlayerDamage;

        level thread iw_pub_OnPlayerConnect();
        #endif
    }

    pub_modifyPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex)
    {             
        if(level.currentGametype == "sd")
            if(sMeansOfDeath == "MOD_FALLING") 
                iDamage = 0;

        if(IsDamageWeapon(sWeapon)) 
            iDamage = 999;

        #ifdef MW1 || WAW
        thread maps\mp\gametypes\_globallogic::Callback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
        #endif

        #ifdef MW2 || MW3
        thread maps\mp\gametypes\_damage::Callback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
        #endif

        #ifdef BO1
        thread maps\mp\gametypes\_globallogic_player::Callback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
        #endif

        dist = GetDistance(self, eAttacker);

        if(level.currentGametype == "dm")
        {
            if(eAttacker.kills == 29 && isdamageweapon(sweapon))
                eAttacker iprintln("[^1" + dist + "m^7]");
        }
        
        else if(level.currentGametype == "sd")
        {
            if(self.team != getDvar("host_team"))
            {
                enemyCount = 0;

                foreach(player in level.players) 
                    if(player != self && IsAlive(player)) 
                        enemyCount++;

                if(enemyCount == 1 && isDamageWeapon(sWeapon)) 
                    foreach(player in level.players) 
                        if(player.team == getDvar("host_team")) 
                            player iprintln("[^1" + dist + "m^7]");
            }
        }

        else if(level.currentGametype == "war")
        {
            if(self.team != getDvar("host_team"))
            {
                #ifdef MW1
                if(game["teamScores"][eAttacker.pers["team"]] == 740)
                #endif

                #ifdef MW2 || MW3
                if(game["teamScores"][eAttacker.pers["team"]] == 7400)
                #endif
                    if(isDamageWeapon(sWeapon)) 
                        foreach(player in level.players) 
                            if(player.team == getDvar("host_team")) 
                                player iprintln("[^1" + dist + "m^7]");
            }
        }
    }

    isdamageweapon(sweapon)
    {
        if(!IsDefined(sweapon))
            return 0;

        sub = strTok(sWeapon,"_");

        #ifdef MW3
            switch(sub[1])
        #else
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

                return 1;
        
            default: return 0;
        }
    }

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

    mainBinds()
    {
        self endon("disconnect");
        
        for(;;)
        {
            #ifdef BO1
            if(self getStance() == "prone" && self ActionSlotThreeButtonPressed() && !self.menu["isOpen"])
            {
                self thread dropCanswap();
                wait 0.3;
            }
            #endif

            #ifdef MW2 || MW3
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

        #ifdef WAW
        weap = "dp28_mp";
        #endif

        self giveweapon(weap);
        self dropitem(weap);
    }

    refillAmmo()
    {
        #ifdef MW2 || MW3
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

        while(true)
        {
            self waittill( "weapon_fired", weapon );

            if( !(isdamageweapon( weapon )) )
                continue;

            if(self.pers["isBot"] && isDefined(self.pers["isBot"]))
                continue;

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
                    magicbullet( self getcurrentweapon(), savedpos[ a], vectorscale( anglesf, 1000000 ), self );
                a++;
            }
            wait 0.05;
        }
    }
    #endif

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

            #ifdef BO1
            self waittill("changed_class");
            self thread maps\mp\gametypes\_class::giveLoadout( self.team, self.class );
            wait .1;
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

        #ifdef BO1
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

    ffaFastLast(player)
    {
        #ifdef WAW || MW1
        if ( level.currentGametype == "dm" )
        {
            player.score = 140;
            player.pers[ "score" ] = 140;
            player.kills = 28;
            player.pers[ "kills" ] = 28;
        }
        #endif

        #ifdef MW2 || MW3 || BO1
        if( level.currentGametype == "dm" )
        {
            player.kills   = 28;
            player.score   = 1400;
            player.pers["pointstowin"] = 28;
            player.pers["kills"] = 28;
            player.pers["score"] = 1400;
        }
        #endif
    }

    lowerBarriers()
    {
        #ifdef MW2
        lowerbarrier("mp_afghan", 2500);
        lowerbarrier("mp_highrise", 9999);
        #endif

        #ifdef BO1
        lowerbarrier("mp_array", 400);
        lowerbarrier("mp_firingrange", 130);
        lowerbarrier("mp_cosmodrome", 600);
        lowerbarrier("mp_radiation", 105);
        removeskybarrier();
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

    removeSkyBarrier()
    {
        setDvar("g_deadZoneDamageMin", 999999);
        setDvar("g_deadZoneDamageMax", 999999);
        
        deathTriggers = getEntArray("trigger_hurt", "classname");
        for(i = 0; i < deathTriggers.size; i++)
        {
            if(deathTriggers[i].origin[2] > 180)
            {
                deathTriggers[i] delete();
            }
            else
            {
                deathTriggers[i].damage = 999999;
                deathTriggers[i].damagetype = "MOD_SUICIDE";
            }
        }
    }

    disableBombs()
    {
        bombZones = GetEntArray("bombzone", "targetname");
        
        if(!isDefined(bombZones) || !bombZones.size)
            return;
        
        shouldDisable = !AreBombsDisabled();
        
        for(a = 0; a < bombZones.size; a++)
        {
            if(shouldDisable)
                bombZones[a] trigger_off(); //common_scripts/utility
            else
                bombZones[a] trigger_on();  //common_scripts/utility
        }
    }

    AreBombsDisabled()
    {
        bombZones = GetEntArray("bombzone", "targetname");
        
        if(!isDefined(bombZones) || !bombZones.size)
            return false;
        
        for(a = 0; a < bombZones.size; a++)
            if(!isDefined(bombZones[a].trigger_off) || !bombZones[a].trigger_off)
                return false;
                self iprintln("Bomb planting [^2ON^7]");
            
        return true;
    }