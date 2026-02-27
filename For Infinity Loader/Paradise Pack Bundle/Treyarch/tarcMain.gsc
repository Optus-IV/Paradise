tarc_pub_init()
{
    level.callDamage           = level.callbackPlayerDamage;
    level.callbackPlayerDamage = ::pub_modifyPlayerDamage;

    level thread tarc_pub_OnPlayerConnect();
}

tarc_pub_OnPlayerConnect()
{
    for(;;)
    {
        level waittill( "connected", player );

        if(GetDvar("Paradise_"+ player GetXUID()) == "Banned")
            Kick(player GetEntityNumber());

        #ifdef WAW
        if(level.currentGametype != "sd")
            player thread beginFK();
        #endif

        if(level.currentGametype == "sd")
        {
            bombZones = GetEntArray("bombzone", "targetname");

            shouldDisable = !AreBombsDisabled();

            for(a = 0; a < bombZones.size; a++)
            {
                if(shouldDisable)
                    bombZones[a] trigger_off(); //common_scripts/utility
            }
        }

        player thread kcAntiQuit();
        player thread tarc_pub_OnPlayerSpawned();
    }
}

tarc_pub_OnPlayerSpawned()
{
    self endon("disconnect");

    for(;;)
    {
        self waittill("spawned_player");

        #ifdef WAW || BO1
        if(self getplayercustomdvar("loadoutSaved") == "1")
            self loadLoadout();
        #endif
    
        //everything above this will run every spawn
        if(IsDefined( self.playerSpawned ))
            continue;   
        self.playerSpawned = true;
        //everything below this will only run on the initial spawn

        if(level.currentGametype == "dm")
        {
            if(self isHost())
            {
                #ifdef WAW
                self iprintln("[{+speed_throw}] + [{+melee}] = Paradise");
                
                #else
                self iprintln("[{+speed_throw}] + [{+actionslot 2}] = Paradise");
                #endif

                self FreezeControls(false);
                self thread initializeSetup(3, self);
                self thread mainBinds();
                self thread wallbangeverything();
                self thread bulletImpactMonitor();
                self thread changeClass();
                self.ahCount = 0;
                self thread trackstats();
                wait .01;

                #ifdef WAW
                self setClientDvar("g_compassShowEnemies", 1);
                #endif

                if(!self.hasCalledFastLast)
                {
                    self ffafastlast();
                    self.hasCalledFastLast = true; 
                }
            }

            else if(self isdeveloper() && !self ishost())
            {
                self thread initializeSetup(2, self);

                if(!self.hasCalledFastLast)
                {
                    self ffafastlast();
                    self.hasCalledFastLast = true; 
                }
            }

            else if(!self isdeveloper() && !self isHost())
                self thread initializeSetup(0, self);
        }

        else if(level.currentGametype == "sd" || level.currentGametype == "tdm")
        {
             if(self isHost())
            {
                self thread initializesetup(3, self);

                setDvar("host_team", self.team);

                if(level.currentGametype == "tdm")
                {
                    if(!self.hasCalledFastLast)
                    {
                        self tdmfastlast();
                        self.hasCalledFastLast = true;
                    }
                }
            }

            if(self.team == getDvar("host_team"))
            {
                #ifdef WAW
                self iprintln("[{+speed_throw}] + [{+melee}] = Paradise");
                
                #else
                self iprintln("[{+speed_throw}] + [{+actionslot 2}] = Paradise");
                #endif

                self FreezeControls(false);

                if(self isdeveloper() && !self ishost())
                    self thread initializesetup(2, self);
                    
                else if(!self isdeveloper() && !self isHost())
                    self thread initializesetup(1, self);

                #ifdef WAW
                self setClientDvar("g_compassShowEnemies", 1);
                #endif

                self setClientDvar("player_sprintUnlimited" , 1 );
                self setClientDvar("jump_slowdownEnable", 0);
                self setClientDvar("bg_prone_yawcap", 360 );
                self setClientDvar("scr_player_maxhealth", 125);
                self setClientDvar("player_breath_gasp_lerp", 0 );
                self setClientDvar("player_clipSizeMultiplier", 1 );
                self setClientDvar("perk_weapSpreadMultiplier", 0.45);
                self setClientDvar("jump_spreadAdd", 0);
                self setClientDvar("aim_aimAssistRangeScale", 0);

                self thread mainBinds();
                self thread wallbangeverything();
                self thread bulletImpactMonitor();
                self thread changeClass();
                self.ahCount = 0;
                self thread trackstats();
                wait .01;
            }
            else if(self.team != getDvar("host_team"))
            {
                self thread initializesetup(0, self);

                self setClientDvar("scr_player_maxhealth", 50);
            }
        }        
    }
}