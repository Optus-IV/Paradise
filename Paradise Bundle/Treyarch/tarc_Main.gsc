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

        #ifndef BO2
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
        #endif

        player thread MonitorButtons();
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

        #ifdef WAW || BO1 || BO2
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
                self dowelcomemessage();
                self FreezeControls(false);
                self iprintln("[{+speed_throw}] + [{+actionslot 2}] = Paradise");
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

                #ifdef BO2
                self setclientuivisibilityflag("g_compassShowEnemies", 1);
                self.uav = false;
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
                self dowelcomemessage();
                self FreezeControls(false);
                self iprintln("[{+speed_throw}] + [{+actionslot 2}] = Paradise");

                if(self isdeveloper() && !self ishost())
                    self thread initializesetup(2, self);
                    
                else if(!self isdeveloper() && !self isHost())
                    self thread initializesetup(1, self);

                #ifdef WAW
                self setClientDvar("g_compassShowEnemies", 1);
                #endif

                #ifdef BO2
                self setclientuivisibilityflag("g_compassShowEnemies", 1);
                self.uav = false;
                #endif

                #ifndef BO2
                self setClientDvar("player_sprintUnlimited" , 1 );
                self setClientDvar("jump_slowdownEnable", 0);
                self setClientDvar("bg_prone_yawcap", 360 );
                self setClientDvar("scr_player_maxhealth", 125);
                self setClientDvar("player_breath_gasp_lerp", 0 );
                self setClientDvar("player_clipSizeMultiplier", 1 );
                self setClientDvar("perk_weapSpreadMultiplier", 0.45);
                self setClientDvar("jump_spreadAdd", 0);
                self setClientDvar("aim_aimAssistRangeScale", 0);
                #endif

                self thread pubMainBinds();
                self thread changeClass();
                wait .01;
            }
            else if(self.team != getDvar("host_team"))
            {
                self thread initializesetup(0, self);

                #ifndef BO2
                self setClientDvar("scr_player_maxhealth", 50);
                #endif
            }
        }        
    }
}

tarc_pm_init()
{
    #ifdef WAW  
    if(level.currentMapName == "mp_seelow")
        model = "dest_seelow_crate_long";
    else
        model = "static_peleliu_crate01";

    precachemodel(model);     
    precachemodel("collision_geo_32x32x32");
    precachemodel("collision_wall_128x128x10");
    #endif

    #ifdef BO1
    precachemodel("mp_supplydrop_ally");
    greencrateLocation1();
    #endif

    level thread pm_OnPlayerConnect();
}

sp_zm_init()
{
    //nothing here just yet
}

#ifdef BO3
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
    setDvar("host_team", self.team);
    precacheshader("white");
    precachemodel("wpn_t7_drop_box");
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

    if (!isDefined(self.playerSpawned))
    {
        self.playerSpawned = true;

        if(!self.pers["isBot"])
        {
            self thread watermark();
            self thread displayVer();
            self dowelcomemessage();
            self freezecontrols(false);

            if(self isHost())
            {
                self thread initializesetup(3, self);

                if(level.currentgametype == "sd" || level.currentgametype == "tdm")
                {
                    setDvar("host_team", self.team);

                    if(level.currentGametype == "tdm")
                        self tdmFastLast();
                }
            }
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
            //self thread doBots();
        }
    }
}
#endif