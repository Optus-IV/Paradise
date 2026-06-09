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

    equip_camo(camo) 
    {
        weapon = getBaseWeaponName(self getCurrentWeapon()) + "_mp";
        weapon_attachment = strtok(self getCurrentWeapon(), "+")[1];

        weapon_painted = weapon + "+" + weapon_attachment + "+camo" + camo;
        
        self takeweapon(self getCurrentWeapon());
        self giveweapon(weapon_painted);
        self switchToWeapon(weapon_painted);

        iprintln("^1" + camo);
        iprintln("^2" + weapon_painted);
    }

    CamoNameTable(a)
    {
        return TableLookupIString("mp/camoTable.csv", 0, a, 6);
    }