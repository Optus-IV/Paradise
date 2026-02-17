spawnBots(num, team)
{
    if(!isDefined(team))
        team = "autoassign";

	for(a = 0; a < num; a++)
	{
		bot::add_bot(team);
        wait 0.1;
	}
}