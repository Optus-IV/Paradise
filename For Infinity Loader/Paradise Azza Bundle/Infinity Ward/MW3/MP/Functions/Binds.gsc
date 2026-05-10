remSentryBind(num)
{
    if( isDefined( self.basedRemSentry ))
    {
        self iPrintLn("Walking Remote Sentry Bind [^1OFF^7]");
        self.basedRemSentry = undefined; 
    }

    else
    {
        self iPrintLn("Press [{+Actionslot " + num +"}] for ^2Walking Remote Sentry");
        self.basedRemSentry = true;

        while(isDefined(self.basedRemSentry))
        {
            if(self isbuttonpressed("+actionslot " + num) && !self.menu["isOpen"])
            {
                self thread maps\mp\killstreaks\_remoteTurret::tryUseRemoteMGTurret(self);
                self enableWeapons();
            }

            wait .1;
        }
    }
}

imsBind(num)
{
    if( isDefined( self.basedIMS ))
    {
        self iPrintLn("Walking IMS Bind [^1OFF^7]");
        self.basedIMS = undefined; 
    }

    else
    {
        self iPrintLn("Press [{+Actionslot " + num +"}] for ^2Walking IMS");
        self.basedIMS = true;

        while(isDefined(self.basedIMS))
        {
            if(self isbuttonpressed("+actionslot " + num) && !self.menu["isOpen"])
            {
                self thread maps\mp\killstreaks\_ims::tryUseIMS(self);
                self enableWeapons();
            }

            wait .1;
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
            if(self isbuttonpressed("+actionslot " + num) && !self.menu["isOpen"])
            {
                self thread maps\mp\killstreaks\_autosentry::tryUseAutoSentry(self);
                self enableWeapons();
            }

            wait .1;
        }
    }
}

predBind(num)
{
    if( isDefined( self.laptop ))
    {
        self iPrintLn("Laptop bind [^1OFF^7]");
        self.laptop = undefined; 
    }

    else
    {
        self iPrintLn("Press [{+Actionslot " + num +"}] to Give ^2Laptop");
        self.laptop = true;

        while(isDefined(self.laptop))
        {
            if(self isbuttonpressed("+actionslot " + num) && !self.menu["isOpen"])
                self thread giveuserweapon("killstreak_ac130_mp");

            wait .001;
        } 
    } 
}

trgrBind(num)
{
    if( isDefined( self.trgr ))
    {
        self iPrintLn("Trigger bind [^1OFF^7]");
        self.trgr = undefined; 
    }

    else
    {
        self iPrintLn("Press [{+Actionslot " + num +"}] to Give ^2Trigger");
        self.trgr = true;

        while(isDefined(self.trgr))
        {
            if(self isbuttonpressed("+actionslot " + num) && !self.menu["isOpen"])
                self thread giveuserweapon("c4_mp");
    
            wait .001;
        } 
    } 
}

classBind(classNum)
{
    if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Press [{+Actionslot 2}] to ^2Change Class");

        self.ChangeClass = true;

        while(isDefined(self.ChangeClass))
        {
            if(self isButtonPressed("+actionslot 2") && !self.menu["isOpen"])
                self notify( "menuresponse", "changeclass", "custom" + classNum);
            
            wait .001; 
        } 
    } 
    else if(isDefined(self.ChangeClass)) 
    { 
        self iPrintLn("Change Class Bind [^1OFF^7]");
        self.ChangeClass = undefined; 
    }
}

nightVision(num)
{
    if( isDefined( self.nightVision ))
    {   
        self iPrintLn("Night Vision Bind [^1OFF^7]");
        self _SetActionSlot(num, "");
        self.nightVision = undefined; 
    }

    else
    {
        self iPrintLn("Press [{+Actionslot " + num +"}] for ^2Night Vision");
        self.nightVision = true;

        while(isDefined(self.nightVision))
        {
            if(self isbuttonpressed("+actionslot " + num) && !self.menu["isOpen"])
                self _SetActionSlot(num, "nightvision");

            wait .1;
        }
    }
}