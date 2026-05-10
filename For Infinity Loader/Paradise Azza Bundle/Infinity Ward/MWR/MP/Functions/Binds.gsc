    bombBind(num)
    {
        if( isDefined( self.bomb ))
        {
            self iPrintLn("Bomb bind [^1OFF^7]");
            self.bomb = undefined; 
        }

        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] to Give ^2Bomb");
            self.bomb = true;

            while(isDefined(self.bomb))
            {
                if(self isbuttonpressed("+actionslot " + num) && !self.menu["isOpen"])
                    self thread giveselfweapon("briefcase_bomb_defuse_mp");
                
                wait .001;
            } 
        } 
    }

    classBind(classNum)
    {
        if( isDefined(self.ChangeClass ))
        {
            self iPrintLn("Change Class Bind [^1OFF^7]");
            self.ChangeClass = undefined;
        }

        if( !isDefined(self.ChangeClass ))
        {
            self iPrintLn("Press [{+Actionslot 2}] to ^2Change Class");

            self.ChangeClass = true;

            while(isDefined(self.ChangeClass))
            {
                if(self isbuttonpressed("+actionslot 2"))
                {
                    self maps\mp\gametypes\_class::setclass("custom" + classNum);
                    self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],"custom" + classNum);
                    self maps\mp\gametypes\_class::applyloadout();
                }
                wait .001;
            }
        }
    }