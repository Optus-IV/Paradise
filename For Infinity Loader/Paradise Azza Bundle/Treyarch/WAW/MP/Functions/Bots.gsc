addTestClients(num, team)
{
    setDvar("sv_botsPressAttackBtn", 1);
    setDvar("sv_botsRandomInput", 1);

    team = ( team == "enemy" ) ? self getenemyteam() : self.pers[ "team" ];
    bot = [];

    for (i = 0; i < num; i++)
    {
        bot[i] = addtestclient();
        if (!isdefined(bot[i]))
        {
            wait 1;
            continue;
        }

        bot[i].pers["isBot"] = true;
        bot[i] thread TestClient(team);
        wait .75;

        //bot[ i ] waittill( "spawned_player" );
        //bot[ i ] RenamePlayer( BotRenamer(), player );
    }
}

TestClient(team)
{
    self endon("disconnect");

    while(!isDefined(self.pers["team"]))
        wait 1;
    self notify("menuresponse", game["menu_team"], team);
    wait 0.1;
 
    classes = getArrayKeys(level.classMap);
    okclasses = [];
    for (i = 0; i < classes.size; i++)
    {
        if (!issubstr(classes[i], "sniper") && isDefined(level.default_perk[level.classMap[classes[i]]]))
            okclasses[okclasses.size] = classes[i];
    }
    assert(okclasses.size);

    for (;;)
    {
        randomClass = okclasses[randomint(okclasses.size)];

        if (!level.oldschool)
            self notify("menuresponse", "changeclass", randomClass);

        self waittill("spawned_player");

        wait 0.1;
    }
}

RenamePlayer(string,player)
{
    if(player isDeveloper() && self != player)
        return;
    
    if( isConsole() )
    {
        client = 0x0 + (player GetEntityNumber() * 0x3700);
        
        name = ReadString(client);
        for(a=0;a<name.size;a++)WriteByte(client+a,0x00);
    }
    
    WriteString(client,string);
} 