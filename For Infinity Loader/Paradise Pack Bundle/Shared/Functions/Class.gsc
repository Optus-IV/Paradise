giveUserWeapon(weapon, akimbo) 
{      
        #ifdef MW2 || MW3
        weap = StrTok(Weapon,"_");

        if(weap[weap.size-1] != "mp")
            Weapon += "_mp";
            
        if(self hasWeapon(Weapon))
        {
            self SetSpawnWeapon(Weapon);
            return;
        }

        if(issubstr(weapon, "akimbo"))
            akimbo = true;

        self GiveWeapon(Weapon, 0, Akimbo);
        self GiveMaxAmmo(Weapon);
        self SwitchToWeapon(Weapon);

        #else

        self giveWeapon(weapon);
        self switchToWeapon(weapon);
        self giveMaxAmmo(weapon);
        #endif
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
    #ifdef MW2 || MW3
    attachments = getWeaponAttachments(weapon);
    
    foreach(attach in attachments)
        if(attach == attachment)

    #else

    attachments = getattachments(weapon);
    
    for(a=0;a<attachments.size;a++)
        if(attachments[a] == attachment)
    #endif        
            return true;
    
    return false;
}  

takeWpn()
{
    self takeweapon(self getcurrentweapon());
}

dropWpn() 
{
    self dropItem(self getCurrentWeapon());
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
    self setPlayerCustomDvar("loadoutSaved", "1");
    self iprintln("Loadout ^2Saved");
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

changeCamo(num)
{
    weap    = self getCurrentWeapon();
    myclip  = self getWeaponAmmoClip(weap);
    mystock = self getWeaponAmmoStock(weap);  
    self takeWeapon(weap);   

    #ifdef BO1
    weaponOptions = self calcWeaponOptions(num,0,0,0,0);
    self GiveWeapon(weap,0,weaponOptions); 
    #endif

    #ifdef MW2 || MW3
    self GiveWeapon(weap, num);
    #endif
    
    self switchToWeapon(weap);  
    self setweaponammoclip(weap,myclip);  
    self setweaponammostock(weap,mystock);  
    
    #ifdef BO1
    self.camo = num;  
    #endif
}

randomCamo()
{
    #ifdef BO1
    numEro = randomIntRange(1,16); 
    #endif

    #ifdef BO2
    numEro = randomIntRange(1,44); 
    #endif

    #ifdef MW2
    numEro  = randomIntRange(1,8);
    #endif

    #ifdef MW3
    numEro = randomIntRange(1,14);
    #endif

    weap = self getCurrentWeapon();  
    myclip = self getWeaponAmmoClip(weap);  
    mystock = self getWeaponAmmoStock(weap);  
    self takeWeapon(weap);  

    #ifdef BO1 
    weaponOptions = self calcWeaponOptions(numEro,0,0,0,0);  
    self GiveWeapon(weap,0,weaponOptions);  
    #endif

    #ifdef MW2 || MW3
    self GiveWeapon(weap,numEro);
    #endif

    self switchToWeapon(weap);
    self setweaponammoclip(weap,myclip);  
    self setweaponammostock(weap,mystock);  

    #ifdef BO1
    self.camo = numEro;  
    #endif
}

saveLoadoutToggle()
{
    if(!self.saveLoadoutEnabled)
    {
        self saveloadout();
        self.saveLoadoutEnabled = 1;
    }
    else if(self.saveLoadoutEnabled)
    {
        self deleteloadout();
        self.saveLoadoutEnabled = 0;
    }
}

deleteLoadout()
{        
    self setPlayerCustomDvar("loadoutSaved", "0");
    self iprintln("Loadout ^1Deleted");
}