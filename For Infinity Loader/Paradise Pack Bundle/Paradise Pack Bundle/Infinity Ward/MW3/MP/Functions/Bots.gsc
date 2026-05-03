    addbot(num, team)
    {
        team = "enemy" ? self getenemyteam() : self.pers["team"];
        bot = [];
        number = int(num);

        for(i=0; i<number; i++)
        {
            bot[i] = addtestclient(BotRenamer());

            if (!isdefined(bot[i])) 
            {
                wait 1;
                continue;
            }
            
            bot[i].pers["isBot"] = true;
            bot[i] thread SpawnBot(team);
            wait 5;
        }
    }

    SpawnBot(team)
    {
        self endon("disconnect");

        while(!isdefined(self.pers["team"]))
            wait .05;

        self notify("menuresponse", game["menu_team"], team);
        wait .05;

        self notify("menuresponse", "changeclass", "class"+ randomint(5));
    }