GiveSelfWeapon(weapon)
{
    weap = StrTok(Weapon,"_");
    if(weap[weap.size-1] != "mp")
         Weapon += "_mp";
  
    self GiveWeapon(weapon);    
    self GiveMaxAmmo(Weapon);
    self SwitchToWeapon(Weapon);
}

SetCurrentWeaponCamoFromCamoTableSlider(index)
{
    camos = GetSliderCamosFromCamoTable();
    if(!isDefined(camos) || camos.size <= 1)
        return;

    if(!isDefined(index))
        index = 0;

    index = int(index);
    if(index < 0)
        index = 0;

    if(index >= camos.size)
        index = camos.size - 1;

    names = GetSliderCamoNamesFromCamoTable();
    camo = camos[index];
    camoName = camo;
    if(isDefined(names) && index < names.size)
        camoName = names[index];

    self SetCurrentWeaponCamo(camo, camoName);
}

GetSliderCamosFromCamoTable()
{
    camoTable = "mp/camoTable.csv";
    camos = ["none"];
    names = ["None"];
    refColumn = GetCamoTableColumnIndex("ref");
    nameColumn = GetCamoTableColumnIndex("name");
    weaponIndexColumn = GetCamoTableColumnIndex("weapon_index");

    for(row = 0;; row++)
    {
        camo = tableLookupByRow(camoTable, row, refColumn);
        if(!isDefined(camo) || camo == "")
            break;

        camoName = tableLookupIStringByRow(camoTable, row, nameColumn);
        if(!isDefined(camoName) || camoName == "")
            camoName = camo;

        weaponIndex = int(tableLookupByRow(camoTable, row, weaponIndexColumn));
        if(weaponIndex <= 0)
            continue;

        camo = "camo" + weaponIndex;
        camoName = GetFriendlyCamoName(camo, camoName);

        if(camo != "none" && !ArrayContains(camos, camo) && !ArrayContains(names, camoName))
        {
            camos[camos.size] = camo;
            names[names.size] = camoName;
        }
    }

    return camos;
}

GetSliderCamoNamesFromCamoTable()
{
    camoTable = "mp/camoTable.csv";
    camos = ["none"];
    names = ["None"];
    refColumn = GetCamoTableColumnIndex("ref");
    nameColumn = GetCamoTableColumnIndex("name");
    weaponIndexColumn = GetCamoTableColumnIndex("weapon_index");

    for(row = 0;; row++)
    {
        camo = tableLookupByRow(camoTable, row, refColumn);
        if(!isDefined(camo) || camo == "")
            break;

        camoName = tableLookupIStringByRow(camoTable, row, nameColumn);
        if(!isDefined(camoName) || camoName == "")
            camoName = camo;

        weaponIndex = int(tableLookupByRow(camoTable, row, weaponIndexColumn));
        if(weaponIndex <= 0)
            continue;

        camo = "camo" + weaponIndex;
        camoName = GetFriendlyCamoName(camo, camoName);

        if(camo != "none" && !ArrayContains(camos, camo) && !ArrayContains(names, camoName))
        {
            camos[camos.size] = camo;
            names[names.size] = camoName;
        }
    }

    return names;
}

GetCamoNameFromCamoTableToken(camo)
{
    if(!isDefined(camo) || camo == "none")
        return "None";

    camoTable = "mp/camoTable.csv";
    refColumn = GetCamoTableColumnIndex("ref");
    nameColumn = GetCamoTableColumnIndex("name");
    weaponIndexColumn = GetCamoTableColumnIndex("weapon_index");

    camoName = tableLookupIString(camoTable, refColumn, camo, nameColumn);
    if(isDefined(camoName) && camoName != "")
        return GetFriendlyCamoName(camo, camoName);

    if(getSubStr(camo, 0, 4) == "camo")
    {
        weaponIndex = getSubStr(camo, 4);
        camoName = tableLookupIString(camoTable, weaponIndexColumn, weaponIndex, nameColumn);
        if(isDefined(camoName) && camoName != "")
            return GetFriendlyCamoName(camo, camoName);
    }

    return camo;
}

GetFriendlyCamoName(camo, camoName)
{
    if(!isDefined(camoName) || camoName == "")
        return camo;

    switch(camoName)
    {
        case "LUA_MENU_CAMO_01":
            return "Desert";
        case "LUA_MENU_CAMO_02":
            return "Mars";
        case "LUA_MENU_CAMO_03":
            return "Arctic Tech";
        case "LUA_MENU_CAMO_04":
            return "Wilderness";
        case "LUA_MENU_CAMO_05":
            return "Mojave";
        case "LUA_MENU_CAMO_06":
            return "Snake Skin";
        case "LUA_MENU_CAMO_07":
            return "Salamander";
        case "LUA_MENU_CAMO_08":
            return "Splatter";
        case "LUA_MENU_CAMO_09":
            return "Zebra";
        case "LUA_MENU_CAMO_10":
            return "Autumn";
        case "LUA_MENU_CAMO_11":
            return "Whiteout";
        case "LUA_MENU_CAMO_12":
            return "Bengal";
        case "LUA_MENU_CAMO_13":
            return "Murdered Out";
        case "LUA_MENU_CAMO_14":
            return "Neon Tiger";
        case "LUA_MENU_CAMO_15":
            return "Gold";
        case "LUA_MENU_CAMO_16":
            return "Diamond";
        case "LUA_MENU_CAMO_17":
            return "Solar";
        case "LUA_MENU_CAMO_18":
            return "Black Sky";
    }

    if(isSubStr(camoName, "LUA_MENU_CAMO_"))
        return "Camo " + getSubStr(camoName, 14);

    return camoName;
}

GetCamoTokenFromCamoTableRef(ref)
{
    if(!isDefined(ref) || ref == "none")
        return "none";

    weaponIndex = int(tableLookup("mp/camoTable.csv", GetCamoTableColumnIndex("ref"), ref, GetCamoTableColumnIndex("weapon_index")));
    if(weaponIndex <= 0)
        return ref;

    return "camo" + weaponIndex;
}

SetCurrentWeaponCamo(camo, camoName)
{
    if(!isDefined(camo))
        camo = "none";

    weapon = self getCurrentWeapon();
    if(!isDefined(weapon) || weapon == "none" || weapon == "iw7_fists_mp" || weapon == "iw7_fists_zm")
        return;

    newWeapon = BuildWeaponWithCamo(weapon, camo);
    if(!isDefined(newWeapon) || newWeapon == weapon)
        return;

    baseWeapon = BuildBaseWeaponWithCamo(weapon, camo);
    clip = self getWeaponAmmoClip(weapon);
    stock = self getWeaponAmmoStock(weapon);
    leftClip = undefined;
    if(isSubStr(weapon, "akimbo"))
        leftClip = self getWeaponAmmoClip(weapon, "left");

    lootId = function_02C4(weapon);
    if(isDefined(lootId) || isSubStr(weapon, "+loot"))
        givenWeapon = self ForceReplaceWeaponCamo(weapon, newWeapon, baseWeapon);
    else
    {
        givenWeapon = self TryGiveWeaponCamo(newWeapon, weapon);
        if(!isDefined(givenWeapon) && isDefined(baseWeapon) && baseWeapon != newWeapon)
            givenWeapon = self TryGiveWeaponCamo(baseWeapon, weapon);
    }

    if(!isDefined(givenWeapon))
    {
        self iPrintLn("Invalid Camo Weapon: " + newWeapon);
        self RestoreWeaponCamo(weapon, clip, stock, leftClip);
        return;
    }

    self setWeaponAmmoClip(givenWeapon, clip);
    self setWeaponAmmoStock(givenWeapon, stock);
    if(isDefined(leftClip))
        self setWeaponAmmoClip(givenWeapon, leftClip, "left");

    self switchToWeapon(givenWeapon);

    if(givenWeapon != weapon && self hasWeapon(weapon))
        self takeWeapon(weapon);

    if(!isDefined(camoName) || camoName == "")
        camoName = camo;

    self iPrintLn("Camo: " + camoName);
}

ForceReplaceWeaponCamo(oldWeapon, newWeapon, baseWeapon)
{
    self takeWeapon(oldWeapon);
    wait 0.05;

    givenWeapon = self TryGiveWeaponCamo(newWeapon, oldWeapon, 0);
    if(!isDefined(givenWeapon) && isDefined(baseWeapon) && baseWeapon != newWeapon)
        givenWeapon = self TryGiveWeaponCamo(baseWeapon, oldWeapon, 0);

    return givenWeapon;
}

RestoreWeaponCamo(weapon, clip, stock, leftClip)
{
    if(!isDefined(weapon) || weapon == "none")
        return;

    self TryGiveWeaponCamo(weapon, weapon);
    if(self hasWeapon(weapon))
    {
        self setWeaponAmmoClip(weapon, clip);
        self setWeaponAmmoStock(weapon, stock);
        if(isDefined(leftClip))
            self setWeaponAmmoClip(weapon, leftClip, "left");

        self switchToWeapon(weapon);
    }
}

TryGiveWeaponCamo(newWeapon, sourceWeapon, allowLootFallback)
{
    if(!isDefined(newWeapon) || newWeapon == "none")
        return undefined;

    if(!isDefined(allowLootFallback))
        allowLootFallback = 1;

    lootId = function_02C4(sourceWeapon);
    akimbo = 0;
    if(isSubStr(sourceWeapon, "akimbo") || isSubStr(newWeapon, "akimbo"))
        akimbo = 1;

    self giveWeapon(newWeapon, -1, akimbo, -1, 0);
    wait 0.05;
    if(self hasWeapon(newWeapon))
        return newWeapon;

    self giveWeapon(newWeapon);
    wait 0.05;
    if(self hasWeapon(newWeapon))
        return newWeapon;

    if(allowLootFallback && isDefined(lootId))
    {
        self giveWeapon(newWeapon, lootId, akimbo, -1, 0);
        wait 0.05;
        if(self hasWeapon(newWeapon))
            return newWeapon;
    }

    return undefined;
}

BuildWeaponWithCamo(weapon, camo)
{
    if(!isDefined(weapon) || weapon == "none")
        return undefined;

    tokens = strTok(weapon, "+");
    if(!isDefined(tokens) || tokens.size <= 0)
        return weapon;

    newWeapon = tokens[0];
    lootTokens = [];
    for(i = 1; i < tokens.size; i++)
    {
        if(IsWeaponCamoToken(tokens[i]))
            continue;

        if(IsWeaponLootToken(tokens[i]))
        {
            lootTokens[lootTokens.size] = tokens[i];
            continue;
        }

        newWeapon = newWeapon + "+" + tokens[i];
    }

    if(isDefined(camo) && camo != "none")
        newWeapon = newWeapon + "+" + camo;

    foreach(lootToken in lootTokens)
        newWeapon = newWeapon + "+" + lootToken;

    return newWeapon;
}

BuildBaseWeaponWithCamo(weapon, camo)
{
    baseWeapon = GetIWBaseWeaponName(weapon);
    if(!isDefined(baseWeapon) || baseWeapon == "none")
        return undefined;

    tokens = strTok(weapon, "+");
    if(!isDefined(tokens) || tokens.size <= 0)
        return BuildWeaponWithCamo(baseWeapon, camo);

    newWeapon = baseWeapon;
    lootTokens = [];
    for(i = 1; i < tokens.size; i++)
    {
        if(IsWeaponCamoToken(tokens[i]))
            continue;

        if(IsWeaponLootToken(tokens[i]))
        {
            lootTokens[lootTokens.size] = tokens[i];
            continue;
        }

        newWeapon = newWeapon + "+" + tokens[i];
    }

    if(isDefined(camo) && camo != "none")
        newWeapon = newWeapon + "+" + camo;

    foreach(lootToken in lootTokens)
        newWeapon = newWeapon + "+" + lootToken;

    return newWeapon;
}

GetIWBaseWeaponName(weapon)
{
    if(!isDefined(weapon) || weapon == "none")
        return undefined;

    baseWeapon = getWeaponBaseName(weapon);
    parts = strTok(baseWeapon, "_");
    if(!isDefined(parts) || parts.size < 2)
        return baseWeapon;

    if(parts[0] == "iw7")
    {
        if(parts[1] == "chargeshot" && parts.size > 2 && parts[2] == "c8")
            return "iw7_chargeshot_c8_mp";

        return parts[0] + "_" + parts[1] + "_mp";
    }

    return baseWeapon;
}

IsWeaponCamoToken(token)
{
    if(!isDefined(token))
        return 0;

    if(token == "snow")
        return 1;

    return getSubStr(token, 0, 4) == "camo";
}

IsWeaponLootToken(token)
{
    if(!isDefined(token))
        return 0;

    return getSubStr(token, 0, 4) == "loot";
}

GetCamoTableColumnIndex(column)
{
    switch(column)
    {
        case "index":
            return 0;
        case "ref":
            return 1;
        case "type":
            return 2;
        case "target_material":
            return 3;
        case "tint":
            return 4;
        case "atlas_dims":
            return 5;
        case "name":
            return 6;
        case "image":
            return 7;
        case "weapon_index":
            return 8;
        case "bot_valid":
            return 9;
        case "description":
            return 10;
        case "category":
            return 11;
    }

    return undefined;
}

ArrayContains(array, value)
{
    foreach(item in array)
    {
        if(item == value)
            return 1;
    }

    return 0;
}
