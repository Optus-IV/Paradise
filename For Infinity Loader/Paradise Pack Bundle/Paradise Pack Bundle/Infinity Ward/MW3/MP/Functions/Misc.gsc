    doKillstreak(name)
    {
        self maps\mp\killstreaks\_killstreaks::giveKillstreak(name, false );
    }

    FakeNuke()
    {
        foreach(player in level.players)
        {
            player maps\mp\killstreaks\_nuke::tryUseNuke(1);

            while(!isdefined(level.nukedetonated))
            wait 0.5;

            setslowmotion(1, .25, .5);
            maps\mp\gametypes\_gamelogic::resumeTimer();
            level.timeLimitOverride = false;

            SetDvar( "ui_bomb_timer", 0 );
            level notify( "nuke_cancelled" );
            level.nukedetonated = undefined;
            level.nukeincoming  = undefined;
            
            wait 1;
            setSlowMotion( 0.25, 1, 2.0 );
            
            wait 1.5;
            VisionSetNaked(level.currentMapName, 0.5);
            
            wait .1;
            break;
        }
    }

    endGame()
    {
        level thread maps\mp\gametypes\_gamelogic::forceEnd();
    }