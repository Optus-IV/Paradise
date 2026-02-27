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
#endif