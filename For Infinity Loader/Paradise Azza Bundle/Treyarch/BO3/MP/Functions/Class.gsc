loadLoadout()
{
    self takeAllWeapons();
    self giveWeapon("knife_mp");
    
    if (!isDefined(self.primaryWeaponList) && self getPlayerCustomDvar("loadoutSaved") == "1")
    {
        self.primaryWeaponList = [];

        for (i = 0; i < int(self getPlayerCustomDvar("primaryCount")); i++)
            self.primaryWeaponList[i] = self getPlayerCustomDvar("primary" + i);

        for (i = 0; i < int(self getPlayerCustomDvar("secondaryCount")); i++)
            self.offHandWeaponList[i] = self getPlayerCustomDvar("secondary" + i);
    }

    for (i = 0; i < self.primaryWeaponList.size; i++)
    {
        if (!isDefined(self.camo) || self.camo == 0)
            self.camo = randomcamo();

        weapon = self.primaryWeaponList[i];
        weaponOptions = self calcWeaponOptions(self.camo, self.currentLens, self.currentReticle, 0);

        self giveWeapon(weapon, 0, weaponOptions);
        self giveMaxAmmo(weapon);

        if(isDefined(level.primary_weapon_array[weapon]))
            self SwitchToWeapon(weapon);
    }

    for (i = 0; i < self.offHandWeaponList.size; i++)
    {
        weapon = self.offHandWeaponList[i];

        switch (weapon) 
        {
            case "flash_grenade_mp":
            case "concussion_grenade_mp":
            case "bouncingbetty_mp":
            case "sensor_grenade_mp":
            case "emp_grenade_mp":
            case "proximity_grenade_aoe_mp":
            case "pda_hack_mp":
            case "trophy_system_mp":
                self giveWeapon(weapon);
                self setWeaponAmmoStock(weapon, self getWeaponAmmoStock(weapon) + 1);
                break;

            case "willy_pete_mp":
            case "claymore_mp":
            case "hatchet_mp":
            case "frag_grenade_mp":
            case "sticky_grenade_mp":
                self giveWeapon(weapon);
                stock = self getWeaponAmmoStock(weapon);
                ammo = stock + 1;
                self setWeaponAmmoStock(weapon, ammo);
                break;

            case "tactical_insertion_mp":
            case "satchel_charge_mp":
                self giveWeapon(weapon);
                self giveStartAmmo(weapon);
                break;
            
            default:
                self giveWeapon(weapon);
                break;
        }
    }
}

giveOffhand(offhand)
{
    offhand = getWeapon(offhand);

    if(self HasWeapon(offhand))
    {
        self GiveStartAmmo(offhand);
        return;
    }
    
    self GiveWeapon(offhand);
    self GiveStartAmmo(offhand);
}

givePlayerAttachment(attachment)
{
    weapon = self getCurrentweapon();
    prefix = strtok(weapon.name, "+");
    baseName = prefix[0];
    attachments = weapon.attachments;

    if(attachment == "dw" && attachments.size < 0)
        newWeapon = getweapon(baseName + "_dw");

    else
    {
        if(HasAttachment(weapon, attachment))
        {
            for(a = 0; a < attachments.size; a++)
            {
                if(attachments[a] != attachment)
                {
                    keep = attachments[a];
                    newWeapon = baseName + "+" + keep;
                }
                else
                {
                    keep = "";
                    newWeapon = baseName;
                }
            }
        }
        else
        {
            if(HasAttachment(weapon, attachment))
            {
                for(a = 0; a < attachments.size; a++)
                {
                    if(attachments[a] != attachment && attachments[a] != "mp")
                    {
                        keep = attachments[a];
                        newWeapon = baseName + "+" + keep;
                    }
                    else
                    {
                        keep = "";
                        newWeapon = baseName;
                    }
                }
            }

            if(isinarray(attachments, attachment))
                attachments = ArrayRemove(attachments, attachment);

            else
            {
                if(attachments.size >= 8)
                    return self iprintln("^1Error: ^7Max Attachments Reached");

                array::add(attachments, attachment, 0);
            }

            newWeapon = getWeapon(baseName, attachments);
            if(newWeapon == level.weaponnone)
                return self iprintln("^1Error: ^7Attachment Swap Failed on " + baseName);
        }
        
        self TakeWeapon(weapon);
        self GiveWeapon(newWeapon);
        self SetSpawnWeapon(newWeapon, true);
        self switchtoweapon(newWeapon);
    }       
}