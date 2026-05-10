FastRestart()
{
    players = level.players;
    
    for ( i = 0; i < players.size; i++ )
    {
        player = players[i];    
        if(IsDefined(player.pers[ "isBot" ]) && player.pers["isBot"])
            kick( player getEntityNumber());
    }
    wait 2;
    map_restart( false );
}

setMinDistance(newDist)
{
    level endon("game_ended");

    level.lastKill_minDist = int(newDist);
    iprintln("Minimum distance: ^2" + newDist + "m");
}

oomtoggle()
{
    if( level.oomUtilDisabled )
        level.oomUtilDisabled = 0;

    else
    {
        foreach(player in level.players)
        {
            #ifndef WAW
            if(isDefined(player.spawnedplat))
            {
                for(i = -3; i < 3; i++)
                {
                    if(!isDefined(player.spawnedplat[i]))
                        continue;
                
                    for(d = -3; d < 3; d++)
                    {
                        if(isDefined(player.spawnedplat[i][d]))
                            player.spawnedplat[i][d] delete();
                    }
                }
            }
            if(isDefined(player.platformThread))
            {
                player.platformThread delete();
                player.platformThread = undefined;
            }

            #else

            if(isDefined(player.spawnedPlatform))
            {
                for(i = 0; i < 8; i++)
                {
                    if(!isDefined(player.spawnedPlatform[i]))
                        continue;
                
                    for(d = 0; d < 8; d++)
                    {
                        if(isDefined(player.spawnedPlatform[i][d]))
                            player.spawnedPlatform[i][d] delete();
                    }
                }
            }
            if(isDefined(player.platformThread))
            {
                for(i=0;i<8;i++)
                {
                    if(!isDefined(player.platformThread[i]))
                        continue;

                    for(d=0;d<8;d++)
                    {
                        if(isDefined(player.platformThread[i][d]))
                            player.platformThread[i][d] delete();
                    }
                }
            }
            #endif

            if (isDefined(player.spawnedcrate))
            {
                player.spawnedcrate delete();
                player.spawnedcrate = undefined;
            }
            if(isDefined(player.spawnedCrateThread))
            {
                player.spawnedCrateThread delete();
                player.spawnedCrateThread = undefined;
            }

            #ifdef MW2 || MW3 || BO2 || MWR || Ghosts || IW || BO3
            if(player.NoClipT)
            {
                player notify("EndNoClip");
                player.NoClipT = 0;

                #ifndef BO2
                player unlink();
                #endif
            }
            #endif

            #ifdef MW1 || WAW
            if(player.ufo)
            {
                player notify("stop_ufo");
                player.ufo = 0;
            }
            #endif  

            #ifdef BO1
            if(player.UFOMode)
            {
                player notify("stop_ufo");
                player.UFOMode = 0;
            }
            #endif

        }
        self iprintln("OOM Utilities [^1Disabled^7]");
        level.oomUtilDisabled = 1;
    }
}

#ifdef BO2 || MW2 || MW3 || MWR || Ghosts
togglelobbyfloat()
{
    if(!self.floaters)
    {
        for(i = 0; i < level.players.size; i++)level.players[i] thread enableFloaters();
        self.floaters = 1;
    }
    else if(self.floaters)
    {
        for(i = 0; i < level.players.size; i++)level.players[i] notify("stopFloaters");
        self.floaters = 0;
    }
}

enableFloaters()
{ 
    self endon("disconnect");
    self endon("stopFloaters");

    for(;;)
    {
        if(level.gameended && !self isonground())
        {
            floatersareback = spawn("script_model", self.origin);
            self playerlinkto(floatersareback);
            self freezecontrols(true);
            for(;;)
            {
                floatermovingdown = self.origin - (0,0,0.5);
                floatersareback moveTo(floatermovingdown, 0.01);
                wait 0.01;
            } 
            wait 6;
            floatersareback delete();
        }
        wait 0.05;
    }
}
#endif

editTime(value)
{
    #ifdef BO2 || BO3
        setGametypesetting("timelimit", getgametypesetting( "timelimit" ) + value);
    #else
        timeLeft       = GetDvar("scr_"+level.currentGametype+"_timelimit");
        timeLeftProper = int(timeLeft);

        setTime = timeLeftProper + value;
        SetDvar("scr_"+level.gametype+"_timelimit", setTime);
        wait .05;
    #endif

}

noBarriers()
{
    //s/o to Broph and arkg0d for the addresses and values here

    #ifdef MW1
    if( isDefined( level.barriersOff ))
    {
        level.barriersOff = undefined;
        WriteInt(0x8233AA58, 0x41980010);
        WriteInt(0x8233AA60, 0x556B01CA);
    }
    else
    {
        level.barriersOff = true;
        WriteInt(0x8233AA58, 0x60000000);
        WriteInt(0x8233AA60, 0x556B041C);
    }
    #endif

    #ifdef WAW
    if( isDefined( level.barriersOff ))
    {
        level.barriersOff = undefined;
        WriteInt(0x8213EE2C, 0x41980014);
        WriteInt(0x8213EE38, 0x554A01CA);
    }
    else
    {
        level.barriersOff = true;
        WriteInt(0x8213EE2C, 0x60000000);
        WriteInt(0x8213EE38, 0x554A041C);
    }
    #endif

    #ifdef BO1
    if( isDefined( level.barriersOff ))
    {
        level.barriersOff = undefined;
        WriteInt(0x822B1DE4, 0x3D600281);
        WriteInt(0x821E2FD4, 0x3D400281);
    }
    else
    {
        level.barriersOff = true;
        WriteInt(0x822B1DE4, 0x3D600280);
        WriteInt(0x821E2FD4, 0x3D400280);
    }
    #endif
}
