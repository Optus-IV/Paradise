    endGame()
    {
        level thread maps\mp\gametypes\_gamelogic::forceEnd();
    }

    azzaLobby()
    {
        if( isDefined( level.azzaLobby ))
        {
            setDvar("xblive_privatematch", "1");
            setDvar("onlinegame", "0");
            setDvar("systemlink", "0");
            level.azzaLobby = undefined;
        }

        else
        {
            setDvar("xblive_privatematch", "0");
            setDvar("onlinegame", "1");
            setDvar("systemlink", "0");
            level.azzaLobby = true;
        }
    }

    mapRot(type)
    {
        switch(type)
        {
            case "bestBase":
            level.mapRot = 1;
            mapArray = ["mp_favela","mp_highrise","mp_quarry","mp_boneyard","mp_terminal","mp_underpass"];
            break;

            case "bestDLC":
            level.mapRot = 1;
            mapArray = ["mp_complex","mp_crash","mp_overgrown","mp_storm","mp_abandon","mp_fuel2"];
            break;

            case "baseDLC":
            level.mapRot = 1;
            mapArray = ["mp_favela","mp_complex","mp_highrise","mp_crash","mp_quarry","mp_overgrown","mp_boneyard","mp_storm","mp_terminal","mp_abandon","mp_underpass","mp_fuel2"];
            break;

            case "off":
            level.mapRot = 0;
            break;
        }

        if(level.mapRot)
        {
            //level waittill("game_ended");
            //level waittill( "killcam_ended" );
            iprintlnbold("^1Changing ^2map^7...");
            wait 3;

        }
    }

    /*
    //Base
    mp_afghan       (Afghan)
    mp_derail       (Derail)
    mp_estate       (Estate)
    mp_favela       (Favela)
    mp_highrise     (Highrise)
    mp_invasion     (Invasion)
    p_checkpoint   (Karachi)
    mp_quarry       (Quarry)
    mp_rundown      (Rundown)
    mp_rust         (Rust)
    mp_boneyard     (Scrapyard)
    mp_nightshift   (Skidrow)
    mp_subbase      (Sub Base)
    mp_terminal     (Terminal)
    mp_underpass    (Underpass)
    mp_brecourt     (Wasteland)

    //Stimulus
    mp_complex      (Bailout)
    mp_crash        (Crash)
    mp_overgrown    (Overgrown)
    mp_compact      (Salvage)
    mp_storm        (Storm)

    //Resurgence
    mp_abandon      (Carnival)
    mp_fuel2        (Fuel)
    mp_strike       (Strike)
    mp_trailerpark  (Trailer Park)
    mp_vacant       (Vacant)
    */