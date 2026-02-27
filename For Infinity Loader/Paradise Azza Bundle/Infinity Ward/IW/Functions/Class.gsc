GiveSelfWeapon(weapon)
{
    weap = StrTok(Weapon,"_");
    if(weap[weap.size-1] != "mp")
         Weapon += "_mp";
  
    self GiveWeapon(weapon);    
    self GiveMaxAmmo(Weapon);
    self SwitchToWeapon(Weapon);
}

