    kickSped(player)
    {
        if (!player isHost() || player != self || !player isDeveloper()) Kick(player GetEntityNumber());
        
        else self iPrintln("^1ERROR: ^7Can't Kick Player");
    }  

    banSped(player)
    {
        if(player isHost() || player isdeveloper())
        {
            self iPrintln("^1ERROR: ^7Can't Ban Player");
            return;
        }
        
        SetDvar("Paradise_"+player GetXUID(),"Banned");
        Kick(player GetEntityNumber());
        self iPrintln(player getName()+" Has Been ^1Banned");
    }

    banList(action, player)
    {
        if(player isHost() || player isdeveloper())
        self iPrintln("^1ERROR: ^7Can't Add Player to Ban List");
        return;

        if (!isDefined(level.banList))
            level.banList = [];

        if(action == "add")
        {
            xuid = player getxuid();

            for (i = 0; i < level.banList.size; i++)
            {
                if (level.banList[i] == xuid)
                    return;
            }

            level.banList[level.banList.size] = xuid;

            foreach(xuid in level.banList)
            {
                setDvar("Paradise_" + xuid, "Banned");
                Kick(player GetEntityNumber());
            }

            self iprintln("^1" + player getname() + " ^7added to ban list!");
        }

        else if(action == "clear")
        {
            level.banList = [];
            self iPrintLn("Ban List ^2Cleared");
        }
    }

    teleportToCrosshair(player)
    {
        if (isAlive(player))
            player setOrigin(bullettrace(self getTagOrigin("j_head"), self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles()) * 1000000, 0, self)["position"]);
    }