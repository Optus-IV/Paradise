giveUserWeapon(weapon, akimbo, camo) 
{      
    #ifndef BO3
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

        #ifdef MWR
        weapon = "h1_"+weapon+"_mp_a#none_f#base";
        
        if(self hasWeapon(Weapon))
        {
            self SetSpawnWeapon(Weapon);
            return;
        }
        #endif

        #ifdef Ghosts
        weapon = "iw6_" + weapon;
        
        if(self hasWeapon(Weapon))
        {
            self SetSpawnWeapon(Weapon);
            return;
        }

        if(issubstr(weapon, "akimbo"))
            akimbo = true;
        #endif

        self giveWeapon(weapon);
        self switchToWeapon(weapon);
        self giveMaxAmmo(weapon);
        #endif

    #else

    weapon = getWeapon(weapon);
    self GiveWeapon(weapon);
    self GiveMaxAmmo(weapon);
    wait 0.1;
    self SwitchToWeapon(weapon);
    #endif
}

getBaseName(weapon)
{
    #ifndef BO2
    prefix = strtok(weapon, "_");
    base = prefix[0];
    return base;
    
    #else

    prefix = strtok(weapon, "+");
    prefix0 = prefix[0];
    weaponString = strtok(prefix0, "_");
    base = weaponString[0];
    return base;
    #endif
}

getAttachments(weapon)
{
    #ifdef BO2
    prefix = strtok(weapon, "+");
    attachments = [];
    attachments[0] = prefix[1];
    attachments[1] = prefix[2];
    attachments[2] = prefix[3];

    #else

    prefix = strtok(weapon, "_");
    attachments = [];
    attachments[0] = prefix[1];
    attachments[1] = prefix[2];
    #endif

    return attachments;
}

HasAttachment(weapon, attachment)
{
    #ifdef MW2 || MW3 || Ghosts || MWR
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
    #ifdef IW
    self method_80B8(self getcurrentweapon());//method_80B8 = DropItem
    #else
    self dropItem(self getCurrentWeapon());
    #endif
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

changeCamo(num)
{
    weap    = self getCurrentWeapon();
    myclip  = self getWeaponAmmoClip(weap);
    mystock = self getWeaponAmmoStock(weap);  
    self takeWeapon(weap);   

    #ifdef BO1 || BO2 || BO3
    weaponOptions = self calcWeaponOptions(num,0,0,0,0);
    self GiveWeapon(weap,0,weaponOptions); 
    #endif

    #ifdef MW2 || MW3 || Ghosts
    self GiveWeapon(weap, num);
    #endif
    
    self switchToWeapon(weap);  
    #ifndef IW
    self setSpawnWeapon(weap); 
    #endif 
    self setweaponammoclip(weap,myclip);  
    self setweaponammostock(weap,mystock);  
    self.camo = num;  
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

    #ifdef MWR
    numEro  = randomIntRange(1,368);
    #endif

    weap = self getCurrentWeapon();  
    myclip = self getWeaponAmmoClip(weap);  
    mystock = self getWeaponAmmoStock(weap);  
    self takeWeapon(weap);  

    #ifdef BO1 || BO2
    weaponOptions = self calcWeaponOptions(numEro,0,0,0,0);  
    self GiveWeapon(weap,0,weaponOptions);  
    #endif

    #ifdef MW2 || MW3 || MWR
    self GiveWeapon(weap,numEro);
    #endif

    self switchToWeapon(weap);

    #ifndef IW
    self setSpawnWeapon(weap);
    #endif  
    
    self setweaponammoclip(weap,myclip);  
    self setweaponammostock(weap,mystock);  

    #ifdef BO1 || BO2
    self.camo = numEro;  
    #endif
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