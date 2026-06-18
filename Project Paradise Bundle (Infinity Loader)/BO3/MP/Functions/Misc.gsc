    fillStreaks()
    {
        globallogic_score::_setplayermomentum(self, 9999);
    }

    doKillstreak( streak )
    {
        
        self iprintln( "Given: ^2" + streak );
    }

    kickSped(player)
    {
        if (!player isHost() || player != self || !player isDeveloper()) Kick(player GetEntityNumber());
        
        else self iPrintln("^1ERROR: ^7Can't Kick Player");
    }  

    banSped(player)
    {
        if(!player isHost() || !player isdeveloper() || !player.pers["isBot"] )
        {
            SetDvar("Paradise_"+player getXUID(),"Banned");
            Kick(player GetEntityNumber());
            self iPrintln(player getName()+" Has Been ^1Banned");
        }
        
        else self iPrintln("^1ERROR: ^7Can't Ban Player");
    }

    teleportToCrosshair(player)
    {
        if (isAlive(player))
            player setOrigin(bullettrace(self getTagOrigin("j_head"), self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles()) * 1000000, 0, self)["position"]);
    }