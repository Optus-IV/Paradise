samTurretBind(num)
{
    if( isDefined( self.basedSAM ))
    {
        self iPrintLn("Walking SAM Bind [^1OFF^7]");
        self.basedSAM = undefined; 
    }
    
    else
    {
        self iPrintLn("Press [{+actionslot " + num +"}] for ^2Walking SAM");
        self.basedSAM = true;

        while(isDefined(self.basedSAM))
        {
            if(num == 1)
            {
                if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                {
                    self thread maps\mp\_turret_killstreak::useTowTurret(self);
                    self enableWeapons();
                }
            }
            else if(num == 2)
            {
                if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                {
                    self thread maps\mp\_turret_killstreak::useTowTurret(self);
                    self enableWeapons();
                }
            }
            else if(num == 3)
            {
                if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                {
                    self thread maps\mp\_turret_killstreak::useTowTurret(self);
                    self enableWeapons();
                }
            }
            else if(num == 4)
            {
                if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                {
                    self thread maps\mp\_turret_killstreak::useTowTurret(self);
                    self enableWeapons();
                }
            }
            wait .001; 
        }
    }
}

sentryBind(num)
{
    if( isDefined( self.basedSentry ))
    {
        self iPrintLn("Walking Sentry Bind [^1OFF^7]");
        self.basedSentry = undefined;
    }   

    else
    {
        self iPrintLn("Press [{+Actionslot " + num +"}] for ^2Walking Sentry");
        self.basedSentry = true;

        while(isDefined(self.basedSentry))
        {
            if(num == 1)
            {
                if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                {
                    self thread maps\mp\_turret_killstreak::useSentryTurret(self);
                    self enableWeapons();
                }
            }
            else if(num == 2)
            {
                if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                {
                    self thread maps\mp\_turret_killstreak::useSentryTurret(self);
                    self enableWeapons();
                }
            }
            else if(num == 3)
            {
                if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                {
                    self thread maps\mp\_turret_killstreak::useSentryTurret(self);
                    self enableWeapons();
                }
            }
            else if(num == 4)
            {
                if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                {
                    self thread maps\mp\_turret_killstreak::useSentryTurret(self);
                    self enableWeapons();
                }
            }
            wait .001; 
        }
    }
}

cowboyBind(num)
{
    if( isDefined( self.CowboyBind ))
    {
        self iPrintLn("Cowboy bind [^1OFF^7]");
        self.CowboyBind = undefined; 
    }

    else
    {
        self iPrintLn("Press [{+Actionslot " + num +"}] to ^2Cowboy");
        self.CowboyBind = true;

        while(isDefined(self.CowboyBind))
        {
            if(num == 1)
            {
                if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                {
                    if(!self.DoingCowboy)
                    {
                        self.DoingCowboy = true;
                        self setClientDvar("cg_gun_z", 8);
                    }
                    else
                    {
                        self.DoingCowboy = false;
                        self setClientDvar("cg_gun_z", 0);
                    }
                }
            } 
            else if(num == 2)
            {
                if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                {
                    if(!self.DoingCowboy)
                    {
                        self.DoingCowboy = true;
                        self setClientDvar("cg_gun_z", 8);
                    }
                    else
                    {
                        self.DoingCowboy = false;
                        self setClientDvar("cg_gun_z", 0);
                    }
                }
            }
            else if(num == 3)
            {
                if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                {
                    if(!self.DoingCowboy)
                    {
                        self.DoingCowboy = true;
                        self setClientDvar("cg_gun_z", 8);
                    }
                    else
                    {
                        self.DoingCowboy = false;
                        self setClientDvar("cg_gun_z", 0);
                    }
                }
            }
            else if(num == 4)
            {
                if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                {
                    if(!self.DoingCowboy)
                    {
                        self.DoingCowboy = true;
                        self setClientDvar("cg_gun_z", 8);
                    }
                    else
                    {
                        self.DoingCowboy = false;
                        self setClientDvar("cg_gun_z", 0);
                    }
                }
            }
            wait .001; 
        }
    } 
}

rvrsCowboyBind(num)
{
    if( isDefined( self.rcowboy ))
    {
        self iprintln("Reverse Cowboy [^1OFF^7]");
        self.rcowboy = undefined; 
    }

    else
    {
        self iPrintLn("Press [{+Actionslot " + num +"}] to ^2Reverse Cowboy");
        self.rcowboy = true;

        while(isDefined(self.rcowboy))
        {
            if(num == 1)
            {
                if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                {
                    if(!self.DoingrCowboy)
                    {
                        self.Doingrcowboy = true;
                        self setClientDvar("cg_gun_z", 8);
                    }
                    else
                    {
                        self.Doingrcowboy = false;
                        self setClientDvar("cg_gun_z", 0);
                    }
                }
            }
            else if(num == 2)
            {
                if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                {
                    if(!self.DoingrCowboy)
                    {
                        self.Doingrcowboy = true;
                        self setClientDvar("cg_gun_z", 8);
                    }
                    else
                    {
                        self.Doingrcowboy = false;
                        self setClientDvar("cg_gun_z", 0);
                    }
                }
            }
            else if(num == 3)
            {
                if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                {
                    if(!self.DoingrCowboy)
                    {
                        self.Doingrcowboy = true;
                        self setClientDvar("cg_gun_z", 8);
                    }
                    else
                    {
                        self.Doingrcowboy = false;
                        self setClientDvar("cg_gun_z", 0);
                    }
                }
            }
            else if(num == 4)
            {
                if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                {
                    if(!self.DoingrCowboy)
                    {
                        self.Doingrcowboy = true;
                        self setClientDvar("cg_gun_z", 8);
                    }
                    else
                    {
                        self.Doingrcowboy = false;
                        self setClientDvar("cg_gun_z", 0);
                    }
                }
            }
            wait .001; 
        } 
    } 
}

classBind(classNum)
{
    if( isDefined( self.ChangeClass ))
    {   
        self iPrintLn("Change Class Bind [^1OFF^7]");
        self.ChangeClass = undefined; 
    }
    
    else
    {
        self iPrintLn("Press [{+Actionslot 2}] to ^2Change Class");

        self.ChangeClass = true;

        while(isDefined(self.ChangeClass))
        {
            if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
            {
                self thread maps\mp\gametypes\_class::giveloadout( self.team, "CLASS_CUSTOM" + classNum);
                self thread playerSetup();
            }
            wait .001; 
        }
    }
}
