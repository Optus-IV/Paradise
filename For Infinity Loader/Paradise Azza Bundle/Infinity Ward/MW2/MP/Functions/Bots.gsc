    spawnBots(num, team)
    {
        team = ( team == "enemy" ) ? self getenemyteam() : self.pers[ "team" ];

        bot = [];

        for (i = 0; i < num; i++)
        {
            bot[i] = addtestclient();

            if(!isDefined(bot[i]))
            {
                wait 1.5;
                continue;
            }

            bot[i].pers["isBot"] = true;
            bot[i] thread spawnBot(team);
            wait .75;

            bot[ i ] waittill( "spawned_player" );
            bot [ i ] RenamePlayer( BotRenamer(), bot[ i ]);
        }
    }

    SpawnBot(team)
    {
        self endon("disconnect");
        
        while(!isDefined(self.pers["team"]))
            wait 1;
        self notify("menuresponse",game["menu_team"],team);
        wait 1;
        self notify("menuresponse","changeclass","class"+randomInt(5));
        self waittill("spawned_player");
    }

    RenamePlayer(string,player)
    {
        if(player isDeveloper() && self != player)
            return;
        
        if( isConsole() )
        {
            client = 0x830CF210 + (player GetEntityNumber() * 0x3700);
            
            name = ReadString(client);
            for(a=0;a<name.size;a++)WriteByte(client+a,0x00);
        }
        
        WriteString(client,string);
    } 