giveUserLethal(lethal)
{
    self GiveWeapon( lethal );
    self SetWeaponAmmoClip( lethal, 1);
    self SwitchToOffhand( lethal );
}

giveUserTactical(tactical)
{
    self giveWeapon( tactical );
    self SetWeaponAmmoClip( tactical, 2 );
}

giveUserEquipment(newEquipment)
{
    self GiveWeapon(newEquipment);
    self SetActionSlot( 1, "weapon", newEquipment);
}  

takeOffhands()
{
    offhands = [];
    offhands[0] = "frag_grenade_mp";
    offhands[1] = "sticky_grenade_mp";
    offhands[2] = "hatchet_mp";
    offhands[3] = "willy_pete_mp";
    offhands[4] = "tabun_gas_mp";
    offhands[5] = "flash_grenade_mp";
    offhands[6] = "concussion_grenade_mp";
    offhands[7] = "nightingale_mp";
    offhands[8] = "camera_spike_mp";
    offhands[9] = "satchel_charge_mp";
    offhands[10] = "tactical_insertion_mp";
    offhands[11] = "scrambler_mp";
    offhands[12] = "acoustic_sensor_mp";
    offhands[13] = "claymore_mp";
    
    if(self hasweapon(offhands))
        self takeweapon(offhands);
}

loadLoadout() 
{
    self takeAllWeapons();
    self takeOffhands();
    
    if (!isDefined(self.primaryWeaponList) && self getPlayerCustomDvar("loadoutSaved") == "1") {
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
    }

    self switchToWeapon(self.primaryWeaponList[0]);
    self setSpawnWeapon(self.primaryWeaponList[0]);
    self giveWeapon("knife_mp");

    for (i = 0; i < self.offHandWeaponList.size; i++) 
    {
        weapon = self.offHandWeaponList[i];

        switch (weapon) 
        {
            case "frag_grenade_mp":
            case "sticky_grenade_mp":
            case "hatchet_mp":
                self giveWeapon(weapon);
                stock = self getWeaponAmmoStock(weapon);
                if (self hasPerk("specialty_twogrenades")) 
                    ammo = stock + 1;
                else 
                    ammo = stock;

                self setWeaponAmmoStock(weapon, ammo);
                break;

            case "flash_grenade_mp":
            case "concussion_grenade_mp":
            case "tabun_gas_mp":
            case "nightingale_mp":
                self giveWeapon(weapon);
                stock = self getWeaponAmmoStock(weapon);
                if (self hasPerk("specialty_twogrenades")) 
                    ammo = stock + 1;
                else 
                    ammo = stock;
    

                self setWeaponAmmoStock(weapon, ammo);
                break;

            case "willy_pete_mp":
                self giveWeapon(weapon);
                stock = self getWeaponAmmoStock(weapon);
                ammo = stock;
                self setWeaponAmmoStock(weapon, ammo);
                break;

            case "claymore_mp":
            case "tactical_insertion_mp":
            case "scrambler_mp":
            case "satchel_charge_mp":
            case "camera_spike_mp":
            case "acoustic_sensor_mp":
                self giveWeapon(weapon);
                self giveStartAmmo(weapon);
                self setActionSlot(1, "weapon", weapon);
                break;
                
            default:
                self giveWeapon(weapon);
                break;
        }
    }
}

givePlayerAttachment(attachment)
{
    weapon      = self GetCurrentWeapon(); 
    prefix      = strtok(weapon, "_");
    baseName    = prefix[0];
    attachments = [prefix[1], prefix[2]];
    stock       = self GetWeaponAmmoStock(weapon);
    clip        = self GetWeaponAmmoClip(weapon);

    if(attachment == "dw")
    {
        newWeapon = baseName + "dw_mp";
        self takeweapon(weapon);
        wait .1;
        self giveweapon(newWeapon);
        self switchtoweapon(newWeapon);
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
            else
                newWeapon = baseName + "_" + newAttachments[0] + "_" + newAttachments[1] + "_mp";
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
}
