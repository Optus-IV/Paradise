#ifndef BO3
    #include maps\mp\_utility;
    #include common_scripts\utility;

    #ifdef MP
        #include maps\mp\gametypes\_hud_util;

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

    init()
    {
        level.strings = [];
        level.status = ["None","^2Verified","^5CoHost","^1Host"];
        level.MenuName = "Paradise";
        level.currentMapName       = getDvar("mapName");
        precacheshader("ui_arrow_right");

        #ifdef MP
        level.currentGametype      = getDvar("g_gametype");
        #endif

        #ifdef WAW  
        precacheshader("hudsoftline");
        precacheshader("rank_prestige9");
        #endif

        #ifdef BO1
        precacheshader("hudsoftline");
        precacheshader("rank_prestige15");
        #endif

        #ifdef MW1 || MWR

        #ifdef MW1
        precacheshader("hudsoftline");

        #else
        precacheshader("line_horizontal");

        #endif
        precacheshader("rank_prestige4");

        #endif

        #ifdef MW2
        precacheshader("hudsoftline");
        precacheshader("rank_prestige8");
        #endif

        #ifdef MW3
        precacheshader("hudsoftline");
        precacheshader("cardicon_prestige_classic9");
        #endif

        #ifdef BO2
        precacheshader("line_horizontal");

        #ifdef ZM
            precacheshader("specialty_fastreload_zombies");
        #else
            precacheshader("rank_prestige09");
        #endif
        #endif

        #ifdef Ghosts
        precacheshader("rank_prestige10");
        precacheshader("hudsoftline");
        #endif

        level thread onPlayerConnect();
    }

    onPlayerConnect()
    {
        for(;;)
        {
            level waittill( "connected", player );

            #ifdef MP
                #ifdef MW2 || MW3 || MWR || Ghosts
                player thread MonitorButtons();
                #endif
            #ifdef MWR || Ghosts
            player thread overflowInit();
            #endif
        
            #ifdef MW2 || MW3
            player thread ServerSettings();
            #endif

            #endif

            player thread onPlayerSpawned();
        }
    }

    onPlayerSpawned()
    {
        self endon( "disconnect" );

        for(;;)
        {
            self waittill( "spawned_player" );

            #ifdef MP
            //everything above this will run every spawn
            if(IsDefined( self.playerSpawned ))
                continue;   
            self.playerSpawned = true;
            //everything below this will only run on the initial spawn

            if(!self.pers["isBot"])
            {    
                self thread watermark();
                self FreezeControls(false);

                if(self isHost())
                {
                    self thread initializesetup(3, self);
                }

                else if(self isDeveloper() && !self isHost())
                    self thread initializesetup(2, self);

                else
                    self thread initializesetup(1, self);
            }
            else
                self thread initializesetup(0, self);
            #endif

            #ifdef ZM
            self thread watermark();
        
            if(self isHost())
                self thread initializesetup(3, self);

            else if(self isDeveloper() && !self isHost())
                self thread initializesetup(2, self);

            else
                self thread initializesetup(1, self);
            #endif
        }
    }

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

    #namespace infinityloader;

    init()
    {
        system::register("infinityloader", ::__init__, undefined, undefined);
    }

    __init__()
    {
        callback::on_start_gametype(::onStartGametype);
        callback::on_connect(::onPlayerConnect);
        callback::on_spawned(::onPlayerSpawned);
    }

    onStartGametype()
    {
        level.strings  = [];
        level.status = ["None","^2Verified","^5CoHost","^1Host"];
        level.MenuName = "Paradise";
        level.currentMapName       = getDvar("mapName");
        level.currentGametype      = getDvar("g_gametype");
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
                self freezecontrols(false);

                if(self isHost())
                {
                    self thread initializesetup(3, self);

                    if(level.currentgametype == "sd" || level.currentgametype == "tdm")
                        setDvar("host_team", self.team);
                }
                else if(self isDeveloper() && !self ishost())
                    self thread initializesetup(2, self);

                else
                    self thread initializesetup(1, self);

            }
            else
                self thread initializesetup(0, self);
        }
    }
#endif