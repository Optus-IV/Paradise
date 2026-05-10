    sentryBind(num)
    {
        if(isDefined(self.basedSentry))
        {
            self iPrintLn("Walking Sentry Bind [^1OFF^7]");
            self.basedSentry = undefined;
            return;
        }

        self iPrintLn("Press [{+Actionslot " + num + "}] for ^2Walking Sentry");
        self.basedSentry = true;

        while(isDefined(self.basedSentry))
        {
            if(self isbuttonpressed("+actionslot " + num) && !self.menu["isOpen"])
            {
                self thread maps\mp\killstreaks\_autosentry::tryUseAutoSentry(self);
                self enableWeapons();
            }

            wait .1;
        }
    }

    classBind(classNum)
    {
        if( isDefined( self.ChangeClass ))
        {
            self iprintln("Change Class Bind [^1OFF^7]");
            self.ChangeClass = undefined;
        }

        self iPrintLn("Press [{+Actionslot 2}] to ^2Change Class");
        self.ChangeClass = true;

        while(isDefined(self.ChangeClass))
        {
            if(self isbuttonpressed("+actionslot 2"))
            {
                self maps\mp\gametypes\_class::setclass("custom" + classNum);
                self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],"custom" + classNum);
            }
            wait .001;
        }

    }
