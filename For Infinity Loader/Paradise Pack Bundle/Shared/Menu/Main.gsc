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
        level.onPlayerKilled = ::onPlayerKilled;
        level.killcam_style = 0;
        level.fk = false;
        level.showFinalKillcam = false;
        level.waypoint = false;
        level.doFK["axis"] = false;
        level.doFK["allies"] = false;
        level.slowmotstart = undefined;
        #endif

        #ifdef BO1
        precacheshader("hudsoftline");
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
        #endif

        #ifdef MW3
        level.killstreaks = ["uav", "deployable_vest", "airdrop_assault", "counter_uav", "sentry", "predator_missile", "ac130", "emp"];
        precacheshader("hudsoftline");
        precacheitem("at4_mp");
        precacheitem("lightstick_mp");
        #endif

        if(level.rankedMatch)
        {
            level.isOnlineMatch = true;

            #ifdef WAW || BO1
            level thread tarc_pub_init();
            #endif

            #ifdef MW1 || MW2 || MW3
            level thread iw_pub_init();
            #endif
        }
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

    bulletImpactMonitor(eAttacker)
    {
        self endon("disconnect");
        level endon("game_ended");

        for(;;)
        {
            self waittill("weapon_fired");

            if(self isOnGround())
                continue;

            start = self getTagOrigin("tag_eye");
            end = anglestoforward(self getPlayerAngles()) * 1000000;
            impact = BulletTrace(start, end, true, self)["position"];
            nearestDist = 150;

            hostTeam = (getDvar("host_team"));
            enemyTeam = getOtherTeam(eAttacker.team);

            foreach(player in level.players)
            {
                dist = distance(player.origin, impact);

                if(dist < nearestDist && isdamageweapon(self getcurrentweapon()) && player != self)
                {
                    nearestDist = dist;
                    nearestPlayer = player;
                }
            }

            if(nearestDist != 150)
            {
                ndist = nearestDist * 0.0254;
                ndist_i = int(ndist);

                if(ndist_i < 1) ndist = getsubstr(ndist, 0, 3);
                
                else ndist = ndist_i;

                distToNear = distance(self.origin, nearestPlayer.origin) * 0.0254;
                dist = int(distToNear);

                if(dist < 1) distToNear = getsubstr(distToNear, 0, 3);
                
                else distToNear = dist;

                lastKill = 29;

                if(level.currentGametype == "dm")  
                    if(self.kills == lastKill && isAlive(nearestPlayer) && isDamageWeapon(self getcurrentweapon()))
                        self thread registerAlmostHit(nearestPlayer, dist);
            }
        }
    }

    registerAlmostHit(nearestPlayer, dist)
    {
        self.ahCount++;

        if(self.ahCount % 3 == 0) self thread rainbowText(rndmMGfunnyMsg(), 2.5);
    }

    rainbowText(text, lifetime, yOffset)
    {
        hud = self createFontString("default", 1.6);
        hud setPoint("TOP", "TOP", 0, 250 + yOffset);
        hud.alpha = 1;

        #ifdef MW1
        hud _settext(text);

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

        wait 0.5;

        if(self.ahCount == 1) self iprintln("You almost hit ^1" + self.ahCount + " ^7time!");

        else if(self.ahCount > 0) self iprintln("You almost hit ^1" + self.ahCount + " ^7times!");
        
        else self iprintln("You didn't almost hit ^1anyone^7! " + self rndmEGfunnyMsg());
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

        #ifdef MW2 || MW3 || BO1
        if(level.currentGametype == "dm")
        {
            self.kills   = 28;
            self.score   = 1400;
            self.pers["pointstowin"] = 28;
            self.pers["kills"] = 28;
            self.pers["score"] = 1400;
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