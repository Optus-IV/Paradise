    giveUserWeapon(weapon, akimbo, camo) 
    {      
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
        attachments = getattachments(weapon);
        
        for(a=0;a<attachments.size;a++)
            if(attachments[a] == attachment)      
                return true;
        
        return false;
    }  

    takeWpn()
    {
        self takeweapon(self getcurrentweapon());
    }

    #ifndef IW
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
    #endif

    dropWpn() 
    {
        self method_80B8(self getcurrentweapon());//method_80B8 = DropItem
    }

    setPlayerCustomDvar(dvar, value) 
    {
        dvar = self getXuid() + "_" + dvar;
        setDvar(dvar, value);
    }

    getPlayerCustomDvar(dvar) 
    {
        dvar = self getXuid() + "_" + dvar;
        return getDvar(dvar);
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

    GetWeaponValidAttachments(weapon)
    {
        attachments = [];
        
        for(a = 9;; a++)
        {
            column = TableLookUp("mp/statsTable.csv", 4, weapon, a);
            
            if(!isDefined(column) || column == "")
                break;
            
            attachments[attachments.size] = column;
        }
        
        return attachments;
    }

    getbaseweaponname(param_00) 
    {
        var_01 = strtok(param_00,"_");

        if(var_01[0] == "iw5" || var_01[0] == "iw6" || var_01[0] == "iw7") 
            param_00 = var_01[0] + "_" + var_01[1];

        else if(var_01[0] == "alt") 
            param_00 = var_01[1] + "_" + var_01[2];

        return param_00;
    }  

    arrayContains(array, value)
    {
        for (i = 0; i < array.size; i++)
        {
            if (array[i] == value)
                return true;
        }

        return false;
    }

    IsOptic(attachment)
    {
        return isSubStr(attachment, "acog")
            || isSubStr(attachment, "reflex")
            || isSubStr(attachment, "phase")
            || isSubStr(attachment, "hybrid")
            || isSubStr(attachment, "elo")
            || isSubStr(attachment, "smart")
            || isSubStr(attachment, "scope");
    }

    IsSecondaryWeapon(baseWeapon)
    {
        weaponType = TableLookup("mp/statsTable.csv", 4, baseWeapon, 1);

        return weaponType == "weapon_pistol"
            || weaponType == "weapon_launcher"
            || weaponType == "weapon_melee";
    }

    AddAttachment(attachment)
    {
        currentWeapon = self getCurrentWeapon();
        baseWeapon = getBaseWeaponName(currentWeapon);

        if (!isDefined(self.attachmentBaseWeapon) || self.attachmentBaseWeapon != baseWeapon)
        {
            self.attachmentBaseWeapon = baseWeapon;
            self.selectedOptic = undefined;
            self.selectedAttachments = [];
        }

        if (IsOptic(attachment))
        {
            self.selectedOptic = attachment;
        }
        else
        {
            maxAttachments = IsSecondaryWeapon(baseWeapon) ? 4 : 5;

            if (!arrayContains(self.selectedAttachments, attachment))
            {
                if (self.selectedAttachments.size >= maxAttachments)
                {
                    self iprintln("^1Maximum non-optic attachments reached.");
                    return;
                }

                self.selectedAttachments[self.selectedAttachments.size] = attachment;
            }
        }
        self ApplyAttachments(baseWeapon);
    }

    ApplyAttachments(baseWeapon)
    {
        weapon = baseWeapon + "_mp";

        if (isDefined(self.selectedOptic))
            weapon += "+" + self.selectedOptic;

        for (i = 0; i < self.selectedAttachments.size; i++)
            weapon += "+" + self.selectedAttachments[i];

        if (isDefined(self.selectedCamo))
            weapon += "+camo" + self.selectedCamo;

        self takeWeapon(self getCurrentWeapon());
        self giveWeapon(weapon);
        self giveMaxAmmo(weapon);
        self switchToWeapon(weapon);
    }

    EquipCamo(camo)
    {
        currentWeapon = self getCurrentWeapon();
        weaponParts = strTok(currentWeapon, "+");
        weapon = weaponParts[0];

        // Keep the equipped custom variant and every attachment. Replace only camo###.
        for (i = 1; i < weaponParts.size; i++)
        {
            attachment = weaponParts[i];

            if (attachment.size >= 4 && getSubStr(attachment, 0, 4) == "camo")
                continue;

            weapon += "+" + attachment;
        }

        self.selectedCamo = camo;
        weapon += "+camo" + camo;

        self takeWeapon(currentWeapon);
        self giveWeapon(weapon);
        self giveMaxAmmo(weapon);
        self switchToWeapon(weapon);

        self iprintln("^2Applied Camo " + camo);
    }
