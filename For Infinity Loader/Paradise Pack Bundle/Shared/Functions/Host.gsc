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
    map_restart( 0 );
}

#ifdef  MW2 || MW3
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
    timeLeft       = GetDvar("scr_"+level.currentGametype+"_timelimit");
    timeLeftProper = int(timeLeft);

    setTime = timeLeftProper + value;
    SetDvar("scr_"+level.gametype+"_timelimit", setTime);
    wait .05;
}