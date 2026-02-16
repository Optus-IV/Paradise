doGiveWeapon(weapon)
{
    if (!isdefined(weapon) || weapon == "")
        return;

    self giveWeapon(weapon);
    self switchToWeapon(weapon);
}

getBaseName(weapon)
{
    prefix = strtok(weapon, "_");
    base = prefix[0];
    return base;
}

HasAttachment(weapon, attachment)
{
    attachments = getattachments(weapon);
    
    for(a=0;a<attachments.size;a++)
        if(attachments[a] == attachment)
            return true;
    
    return false;
}

getAttachments(weapon)
{
    prefix = strtok(weapon, "_");
    attachments = [];
    attachments[0] = prefix[1];
    attachments[1] = prefix[2];

    return attachments;
}

givePlayerAttachment(attachment)
{
    weapon      = self GetCurrentWeapon(); 
    prefix      = strtok(weapon, "_");
    baseName    = prefix[0];
    attachments = [prefix[1], prefix[2]];
    stock       = self GetWeaponAmmoStock(weapon);
    clip        = self GetWeaponAmmoClip(weapon);

    if(HasAttachment(weapon, attachment))
    {
        for(a = 0; a < attachments.size; a++)
        {
            if(attachments[a] != attachment && attachments[a] != "mp")
            {
                keep = attachments[a];
                newWeapon = baseName + "_" + keep + "_mp";
            }
            else
            {
                keep = "";
                newWeapon = baseName + "_mp";
            }
        }
    }
    else
    {
        if(attachment != "none")
        {
                for(a = 0; a < attachments.size; a++)
                {
                    if(attachments[a] != "mp")
                        newAttachments = [attachment, attachments[a]];  
                    if(isDefined(newAttachments))
                        break;
                }
        }
    
        if(!isDefined(newAttachments) && newAttachments != "mp")
            newAttachments = [attachment, ""];
    
        if(newAttachments[1] == "")
            newWeapon = baseName + "_" + newAttachments[0] + "_mp";
    }
    
    self TakeWeapon(weapon);
    self GiveWeapon(newWeapon, 0);
    self SetWeaponAmmoClip(newWeapon, clip);
    self SetWeaponAmmoStock(newWeapon, stock);
    self SetSpawnWeapon(newWeapon);

    if(self getcurrentweapon() != newWeapon)
    {
        self iPrintln("^1Error: ^7Invalid attachment");
        self giveWeapon(weapon);
        self switchToWeapon(weapon);
    }
}       

giveEquipment(equipment)
{
    if(equipment == "c4_mp")
        self setperk("specialty_weapon_c4", false);

    else if(equipment == "claymore_mp")
        self setperk("specialty_weapon_claymore", false);

    else if(equipment == "rpg_mp")
        self setperk("specialty_weapon_rpg", false);

    self setactionslot(3, "weapon", equipment);
}

giveOffhand(offhand)
{
    self takeSecondaryOffhands();

    if (offhand == "flash_grenade_mp")
        self setOffhandSecondaryClass("flash");
    else
        self setOffhandSecondaryClass("smoke");
    
    self giveWeapon(offhand );
    self SetWeaponAmmoClip(offhand, 2);
}

saveLoadout() 
{
    wait .01;
        
    self.primaryWeaponList = self getWeaponsListPrimaries();
    self.offHandWeaponList = isExclude(self getWeaponsList(), self.primaryWeaponList);
    self.offHandWeaponList = removeValueFromArray(self.offHandWeaponList, "knife_mp");

    for (i = 0; i < self.primaryWeaponList.size; i++) 
        self setPlayerCustomDvar("primary" + i, self.primaryWeaponList[i]);

    for (i = 0; i < self.offHandWeaponList.size; i++)
        self setPlayerCustomDvar("secondary" + i, self.offHandWeaponList[i]);

    self setPlayerCustomDvar("primaryCount", self.primaryWeaponList.size);  
    self setPlayerCustomDvar("secondaryCount", self.offHandWeaponList.size);
    self setPlayerCustomDvar("loadoutSaved", "1");
    self iprintln("Loadout ^2Saved");
}

takeSecondaryOffhands()
{
    offhands = [];
    offhands[0] = "flash_grenade_mp";
    offhands[1] = "concussion_grenade_mp";
    offhands[2] = "smoke_grenade_mp";

    if(self hasweapon(offhands))
        self takeweapon(offhands);
}

loadLoadout() 
{
    self takeAllWeapons();
    self takeSecondaryOffhands();
    
    if (!isDefined(self.primaryWeaponList) && self getPlayerCustomDvar("loadoutSaved") == "1") 
    {
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
        self giveWeapon(weapon);
        self giveMaxAmmo(weapon);
    }

    self switchToWeapon(self.primaryWeaponList[0]);
    self setSpawnWeapon(self.primaryWeaponList[0]);
    self giveWeapon("knife_mp");

    for (i = 0; i < self.offHandWeaponList.size; i++) 
    {
        weapon = self.offHandWeaponList[i];

        switch(weapon)
        {
            case "flash_grenade_mp":
            case "concussion_grenade_mp":
            case "smoke_grenade_mp":
                self GiveWeapon( weapon );
                self SetWeaponAmmoClip( weapon, 1 );
                self SwitchToOffhand( weapon );
                break;

            default: return;
        }
    }
}