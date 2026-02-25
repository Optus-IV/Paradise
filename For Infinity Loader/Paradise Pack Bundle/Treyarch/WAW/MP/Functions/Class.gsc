
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

    GetWeaponValidAttachments(weapon)
    {
        attachments = [];
        
        for(a = 11;; a++)
        {
            column = TableLookUp("mp/statsTable.csv", 4, weapon, a);
            
            if(!isDefined(column) || column == "")
                break;
            
            attachments[attachments.size] = column;
        }
        
        return attachments;
    }

    giveLethal(grenadeTypePrimary)
    {
        if(self hasWeapon("frag_grenade_mp"))
            self takeweapon("frag_grenade_mp");

        else if(self hasWeapon("sticky_grenade_mp"))
            self takeweapon("sticky_grenade_mp");

        else if(self hasWeapon("molotov_mp"))
            self takeweapon("molotov_mp");

        if(grenadeTypePrimary != "")
        {
            self GiveWeapon( grenadeTypePrimary );
            self SetWeaponAmmoClip( grenadeTypePrimary, 1 );
            self SwitchToOffhand( grenadeTypePrimary );
        }
    }

    giveTactical(grenadeTypeSecondary)
    {
        if(self hasWeapon("m8_white_smoke_mp"))
            self takeweapon("m8_white_smoke_mp");

        else if(self hasWeapon("tabun_gas_mp"))
            self takeweapon("tabun_gas_mp");

        else if(self hasWeapon("signal_flare_mp"))
            self takeweapon("signal_flare_mp");
        
        if(grenadeTypeSecondary != "")
        {	
            self TakeWeapon();
            self giveWeapon(grenadeTypeSecondary);
            self SetWeaponAmmoClip(grenadeTypeSecondary, 1);
        }
    }

    takeOffhands()
    {
        offhands = [];
        offhands[0] = "frag_grenade_mp";
        offhands[1] = "sticky_grenade_mp";
        offhands[2] = "molotov_mp";

        offhands[3] = "m8_white_smoke_mp";
        offhands[4] = "tabun_gas_mp";
        offhands[5] = "signal_flare_mp";
        
        if(self hasweapon(offhands))
            self takeweapon(offhands);
    }

    loadLoadout() 
    {
        self takeAllWeapons();
        self takeoffhands();
        
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

            switch (weapon) 
            {   
                case "frag_grenade_mp":
                case "sticky_grenade_mp":
                case "molotov_mp":
                    self GiveWeapon( weapon );
                    self SetWeaponAmmoClip( weapon, 1 );
                    self SwitchToOffhand( weapon );
                    break;

                case "m8_white_smoke_mp":
                case "tabun_gas_mp":
                case "signal_flare_mp":
                    self TakeWeapon();
                    self giveWeapon(weapon);
                    self SetWeaponAmmoClip(weapon, 1);
                    break;

                default:
                    self giveWeapon(weapon);
                    break;
            }
        }
    }