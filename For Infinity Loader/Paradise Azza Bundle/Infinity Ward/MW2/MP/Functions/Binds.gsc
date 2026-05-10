sentryBind(num)
{
    if( isDefined( self.basedSentry ))
    {
        self iPrintLn("Walking Sentry Bind [^1OFF^7]");
        self.basedSentry = undefined; 
    }

    else
    {
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
                self thread giveselfweapon("killstreak_ac130_mp");

            wait .001;
        } 
    } 
}

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
                self thread giveselfweapon("c4_mp");
    
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
            if(self isButtonPressed("+actionslot 2") && !self.menu["isOpen"])
                self notify( "menuresponse", "changeclass", "custom" + classNum);
            
            wait .001; 
        } 
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
        self.nvPressCount = 0;
        self thread nvSound("+actionslot " + num);

        while(isDefined(self.nightVision))
        {
            if(self isbuttonpressed("+actionslot " + num) && !self.menu["isOpen"])
                self _SetActionSlot(num, "nightvision");
            wait .1;
        }
    }
}

nvSound(button)
{
    self endon("disconnect");
    self endon("stop_nvSound");

    self notifyonplayercommand("nvSound", button);

    for(;;)
    {
        self waittill("nvSound");
        self.nvPressCount++;

        if(self.nvPressCount % 2 == 1)
            self PlaySoundToPlayer( "item_nightvision_on", self);

        else if(self.nvPressCount % 2 == 0)
            self PlaySoundToPlayer( "item_nightvision_off", self);
    }
}

hostMigration(num)
{
    if( isDefined( self.hostMigrate ))
    {
        self iPrintLn("Host Migration Bind [^1OFF^7]");
        self notify("stopHostMigrate");
        self.hostMigrate = undefined; 
    }
    
    else
    {
        self iPrintLn("Press [{+Actionslot " + num +"}] for ^2Host Migration");
        self.hostMigrate = true;

        while(isDefined(self.hostMigrate))
        {
            if(self isbuttonpressed("+actionslot " + num) && !self.menu["isOpen"])
                self thread hostmigratelogic();

            wait .1;
        }
    }
}

hostmigrateLogic()
{
    self endon("disconnect");
    self endon("game_ended");
    self endon("stopHostMigrate");

    for (;;)
    {
        foreach(player in level.players)
        {
            setDvar("HostMigrationState", "0");
            player openPopupMenu(game["menu_hostmigration"]);
            player freezeControlsWrapper(true);
            wait .1;
            setDvar("HostMigrationState", 1);
            wait .1;
            player closePopupMenu();
            thread maps\mp\gametypes\_gamelogic::matchStartTimer("match_resuming_in", 5.0);
            wait 5.0;
            player freezeControlsWrapper(false);
            wait 1; 
        }
        wait 0.01;
    }
}