    giveUserWeapon(weapon, akimbo, camo) 
    {      
        weapon = "iw6_" + weapon;
        
        if(self hasWeapon(Weapon))
        {
            self SetSpawnWeapon(Weapon);
            return;
        }

        if(issubstr(weapon, "akimbo"))
            akimbo = true;

        self giveWeapon(weapon);
        self switchToWeapon(weapon);
        self giveMaxAmmo(weapon);
    }

    getBaseName(weapon)
    {
        prefix = strtok(weapon, "_");
        base = prefix[0];
        return base;
    }

    getAttachments(weapon)
    {
        prefix = strtok(weapon, "_");
        attachments = [];
        attachments[0] = prefix[1];
        attachments[1] = prefix[2];

        return attachments;
    }

    HasAttachment(weapon, attachment)
    {
        attachments = getWeaponAttachments(weapon);

        foreach(attach in attachments)
            if(attach == attachment)
     
                return true;
        
        return false;
    }  

    takeWpn()
    {
        self takeweapon(self getcurrentweapon());
    }

    toggleInfEquip()
    {
        self.infEquipOn = !isDefined(self.infEquipOn) || !self.infEquipOn;

        if (self.infEquipOn)
            self thread InfEquipment();
        else
            self notify("noMoreInfEquip");
    }

    InfEquipment()
    {
        self endon("disconnect");
        self endon("noMoreInfEquip");

        for (;;)
        {
            wait 0.1;
            currentoffhand = self getcurrentoffhand();
            if (currentoffhand != "none")
                self givemaxammo(currentoffhand);
        }
    }

    dropWpn() 
    {
        self dropItem(self getCurrentWeapon());
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
    }

    isExclude(array, array_exclude)
    {
        newarray = array;

        if (inarray(array_exclude))
        {
            for (i = 0; i < array_exclude.size; i++)
            {
                exclude_item = array_exclude[i];
                removeValueFromArray(newarray, exclude_item);
            }
        }
        else
            removeValueFromArray(newarray, array_exclude);

        return newarray;
    }

    removeValueFromArray(array, valueToRemove)
    {
        newArray = [];
        for (i = 0; i < array.size; i++)
        {
            if (array[i] != valueToRemove)
                newArray[newArray.size] = array[i];
        }
        return newArray;
    }

    saveLoadoutToggle()
    {
        if( self getPlayerCustomDvar( "loadoutSaved" ) == "1" )
            self setPlayerCustomDvar( "loadoutSaved", "0" );

        else
        {
            self setPlayerCustomDvar( "loadoutSaved", "1" );
            self saveLoadout();
        }
    }
    
    GiveSelfWeapon(weapon)
    {
        weap = StrTok(Weapon,"_");
        if(weap[weap.size-1] != "mp")
            Weapon += "_mp";

        self GiveWeapon(weapon);    
        self GiveMaxAmmo(Weapon);
        self SwitchToWeapon(Weapon);
    }

    camoString(num)
    {
        weapon = self GetCurrentWeapon();
        
        if(num > 0)
        {
            if(isSubStr(weapon,"_camo"))
            {
                weapon1 = StrTok(weapon,"_");
                string  = "";
                for(a=0;a<weapon1.size;a++)
                    if(!isSubStr(weapon1[a],"camo"))
                        string += weapon1[a]+"_";
                
                string += "camo"+num;
            }
            else string = weapon+"_camo"+num;
        }
        else
        {
            weapon1 = StrTok(weapon,"_");
            string  = "iw6";
            
            for(a=1;a<weapon1.size;a++)
                if(!isSubStr(weapon1[a],"camo"))
                    string += "_"+weapon1[a];
        }
        
        self TakeWeapon(weapon);
        self GiveWeapon(string);
        self SetSpawnWeapon(string);
    }

    GivePlayerAttachment( attachment )
    {

    }

    GetWeaponValidAttachments(weapon)
    {
        attachments = [];
        
        for(a = 10;; a++)
        {
            column = TableLookUp("mp/statsTable.csv", 4, weapon, a);
            
            if(!isDefined(column) || column == "")
                break;
            
            attachments[attachments.size] = column;
        }
        
        return attachments;
    }

    loadLoadout() 
    {
        self takeAllWeapons();
        
        if(self hasperk("_specialty_blastshield"))
            self _unsetperk("_specialty_blastshield");
        wait .01;
        
        if (!isDefined(self.primaryWeaponList) && self getPlayerCustomDvar("loadoutSaved") == "1") 
        {
            for (i = 0; i < int(self getPlayerCustomDvar("primaryCount")); i++) 
                self.primaryWeaponList[i] = self getPlayerCustomDvar("primary" + i);

            for (i = 0; i < int(self getPlayerCustomDvar("secondaryCount")); i++) 
                self.offHandWeaponList[i] = self getPlayerCustomDvar("secondary" + i);
        }

        for (i = 0; i < self.primaryWeaponList.size; i++) 
        {
            weapon = self.primaryWeaponList[i];

            if(issubstr(weapon, "akimbo"))
                self giveuserweapon(weapon, true);
            else
                self giveWeapon(weapon, 0);

            if (weapon == "rpg_mp" || weapon == "m79_mp") 
                self giveMaxAmmo(weapon);
        }

        self switchToWeapon(self.primaryWeaponList[1]);
        self setSpawnWeapon(self.primaryWeaponList[1]);
        self giveWeapon("knife_mp");
        for (i = 0; i < self.offHandWeaponList.size; i++) 
        {
            offhand = self.offHandWeaponList[i];

                switch(offhand) 
                {
                    case "frag_grenade_mp":
                    case "semtex_mp":
                    case "throwingknife_mp":
                    case "proximity_explosive_mp":
                    case "c4_mp":
                    case "mortar_shell_mp":
                    self thread giveequipment(offhand);
                    break;

                    case "flash_grenade_mp":
                    case "concussion_grenade_mp":
                    case "smoke_grenade_mp":
                    case "trophy_mp":
                    case "motion_sensor_mp":
                    case "thermobaric_grenade_mp":
                    self thread givesecondaryoffhand(offhand);
                    break;

                    default:
                    self giveWeapon(offhand);
                    break;
            }
        }
    }

    GiveEquipment(equipment)
    {
        equip = StrTok(equipment, "_");
        
        if(equip[(equip.size - 1)] != "mp" && !IsSubStr(equipment, "specialty"))
            equipment += "_mp";
        
        lethals = ["frag_grenade_mp","semtex_mp","throwingknife_mp","proximity_explosive_mp","c4_mp","mortar_shell_mp"];
        hasEquipment     = self HasWeapon(equipment);

        for(a=0;a<lethals.size;a++)
        {
            if(self HasWeapon1(lethals[a]))
                self TakeWeapon(lethals[a] + "_mp");
            
            if(self _HasPerk(lethals[a] + "_mp"))
                self _UnsetPerk(lethals[a] + "_mp");
            
            self SetOffhandPrimaryClass("none");
        }
        
        if(!hasEquipment)
            self givePerkEquipment(equipment, false);
    }

    GiveSecondaryOffhand(offhand)
    {
        if(!IsSubStr(offhand, "specialty"))
        {
            equip = StrTok(offhand, "_");
            
            if(equip[(equip.size - 1)] != "mp")
                offhand += "_mp";
        }
        
        offhands = ["flash_grenade_mp","concussion_grenade_mp","smoke_grenade_mp","trophy_mp","motion_sensor_mp","thermobaric_grenade_mp"];
        hasEquipment       = self HasWeapon(offhand);
        
        for(a = 0; a < offhands.size; a++)
        {
            if(self HasWeapon1(offhands[a]))
                self TakeWeapon(offhands[a] + "_mp");
            
            if(self _HasPerk(offhands[a]))
                self _UnsetPerk(offhands[a]);
            
            self SetOffhandSecondaryClass("none");
        }
        
        if(!hasEquipment)
            self givePerkOffhand(offhand, false);
    }

    HasWeapon1(weapon)
    {
        foreach(weap in self GetWeaponsList())
            if(IsSubStr(weap, weapon) || weapon == weap)
                return true;
        
        return false;
    }