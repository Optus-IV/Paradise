    spawnBots(count, team, callback, stopWhenFull, notifyWhenDone, difficulty)
    {
        level.botnames = [
                    "AgreedBog",
                    "SyGnUs",
                    "XeSoftware",
                    "Broph",
                    "Moxah",
                    "Deprecated",
                    "Torq",
                    "Kurt",
                    "MrFrosty",
                    "XeDevn",
                    "DougDimmadome",
                    "Aciph",
                    "Snowman",
                    "BigDaddyCosby",
                    "arkg0d",
                    "Ticklish Alter Boy",
                    "dursoh",
                    "NickGurr69"
                    ];
                    
        name = level.botnames[level.botcount];

        if(level.botcount == (level.botnames.size - 1)) level.botcount = 0;
        
        else level.botcount++;
        
        time = gettime() + 10000;
        connectingArray = [];
        squad_index = connectingArray.size;

        while(level.players.size < scripts\mp\bots\_bots_util::func_2DA6() && connectingArray.size < count && gettime() < time) //bot_get_client_limit
        {
            scripts\mp\_hostmigration::func_13708(0.05); //waitlongdurationwithhostmigrationpause

            botent                 = function_0005(name, 0, 0, 0); //addBot
            
            connecting             = spawnstruct();
            connecting.bot         = botent;
            connecting.ready       = 0;
            connecting.abort       = 0;
            connecting.index       = squad_index;
            connecting.difficultyy = difficulty;
            connectingArray[connectingArray.size] = connecting;
            connecting.bot thread scripts\mp\bots\_bots::func_10655(team,callback,connecting); //spawn_bot_latent
            squad_index++;
        }

        connectedComplete = 0;
        time = gettime() + -5536;

        while(connectedComplete < connectingArray.size && gettime() < time)
        {
            connectedComplete = 0;
            foreach(connecting in connectingArray)
            {
                if(connecting.ready || connecting.abort)
                    connectedComplete++;
            }
            wait 0.05;
        }

        if(isdefined(notifyWhenDone)) self notify(notifyWhenDone);

        botent.pers["isBot"] = true;
        wait .5;
    }

    hook scripts\mp\bots\_bots::func_2D68() //bot_drop
    {
        wait(0.1);
        return;
    }