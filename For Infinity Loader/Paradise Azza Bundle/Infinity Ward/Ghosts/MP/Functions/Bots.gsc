addOneBot(team)
{
    level thread spawnBots(1 , team, undefined, undefined, "spawned_player", "recruit");
}

/*
spawnBots1(count, team, callback, stopWhenFull, notifyWhenDone, difficulty)
{
    if (!isDefined(level.botnames))
    {
        level.botnames = ["Hawkfeet", "TricksyCantNac", "FemboyLew", "WetCucumber69", "XxtrikXxruthl3ssXx",
                          "AFK Dang", "HelloWorld('Print')", "DiddysBabyOil", "NickGurr36", "Joe Rogaine",
                          "TicklishAltarBoy", "Chief Slapahoe", "Queef Jerky", "Jenna Tolls", "Higger Nater",
                          "RimReaperAssAtak", "DougDimmadome", "GrandmasDealDoe"];
    }

    if (!isDefined(level.botcount))
        level.botcount = 0;

    level endon("game_ended");

    function_wait_time = GetTime() + 15000;
    connectingArray = [];
    squad_index = 0;

    while(level.players.size < maps\mp\bots\_bots_util::bot_get_client_limit() && connectingArray.size < count && gettime() < function_wait_time)
    {
        name = level.botnames[level.botcount % level.botnames.size];
        level.botcount++;

        bot = AddBot(name, 0, 0, 0);

        if (isDefined(bot))
        {
            bot.pers["team"] = team;
            bot.pers["isBot"] = true;

            connecting = SpawnStruct();
            connecting.bot = bot;
            connecting.ready = false;
            connecting.abort = false;
            connecting.index = squad_index;
            connecting.difficulty = difficulty;

            connectingArray[connectingArray.size] = connecting;

            bot thread maps\mp\bots\_bots::spawn_bot_latent(team, callback, connecting);
            squad_index++;

            wait 0.3; 
        }
        
        else
        {
            if (isDefined(stopWhenFull) && stopWhenFull)
            {
                if (isDefined(notifyWhenDone))
                    self notify(notifyWhenDone);
                return;
            }
            wait 0.5;
            continue;
        }
    }

    connectedComplete = 0;

    while (connectedComplete < connectingArray.size && GetTime() < function_wait_time)
    {
        connectedComplete = 0;
        foreach (connecting in connectingArray)
        {
            if (connecting.ready || connecting.abort)
                connectedComplete++;
        }
        wait 0.05;
    }

    if (isDefined(notifyWhenDone))
        self notify(notifyWhenDone);

    foreach (connecting in connectingArray)
    {
        if (isDefined(connecting.bot))
        {
            connecting.bot.pers["isBot"] = true;
        }
    }

}
*/

spawnBots(count, team)
{
    thread maps\mp\bots\_bots::spawn_bots( count, team, undefined, undefined, "spawned", BotGetTeamDifficulty( 1 ) );

    if(!self.botMon)
    {
        self.botMon = 1;

        for (;;)
        {
            self notify( "bot_connect_monitor" );
            level notify( "bot_connect_monitor" );
            wait 0.1;
        }
    }
}