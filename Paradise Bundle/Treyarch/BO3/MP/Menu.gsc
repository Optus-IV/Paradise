printOrigin()
{
    self iprintln("^1" + self getorigin());
}

menuOptions()
{
    player = self.selected_player;        
    menu = self getCurrentMenu();
    
    player_names = [];

    foreach( players in level.players )
        player_names[player_names.size] = players.name;

    switch( menu )
    {
        case "main":
            if(self.access > 0) // Verified
            {
                self addMenu("main", "Main Menu");
                self addOpt("Trickshot Menu", ::newMenu, "ts");
                self addOpt("Binds Menu", ::newMenu, "sK");
                self addOpt("Teleport Menu", ::newMenu, "tp");
                self addOpt("Class Menu", ::newMenu, "class");
                self addOpt("Afterhits Menu", ::newMenu, "afthit");
                self addOpt("Killstreak Menu", ::newMenu, "kstrks");

                if(self ishost() || self isDeveloper()) 
                    self addOpt("Host Options", ::newMenu, "host");
            }
            break;

        case "ts":
            self addMenu("ts", "Trickshot Menu");
            self addToggle("Noclip [{+frag}]", self.NoClipT, ::initNoClip);
            self addOpt("Go for Two Piece", ::dotwopiece);

            canOpts = ["Current", "Infinite"];
            self addSliderString("Canswaps", canOpts, canOpts, ::SetCanswapMode);

            self addToggle("Instashoots", self.instashoot, ::instashoot);
            self addOpt("Spawn Slide @ Crosshairs", ::slide);

            spawnOptionsActions = ["Bounce","Platform","Crate"];
            spawnOptionsIDs     = ["bounce","platform","crate"];
            self addSliderString("Spawn @ Feet", spawnOptionsIDs, spawnOptionsActions, ::doSpawnOption);
            break;

        case "sK":
            self addMenu("sK", "Binds Menu");
            self addOpt("Change Class Bind", ::newMenu, "cb");
            self addOpt("Mid Air GFlip Bind", ::newMenu, "gflip");
            self addOpt("Nac Mod Bind", ::newMenu, "nmod");
            self addOpt("Skree Bind", ::newMenu, "skree");
            self addOpt("Can Zoom Bind", ::newMenu, "cnzm");
            break;

        case "gflip":
            self addMenu("gflip", "Mid Air GFlip Bind");
            self addOpt("GFlip: [{+actionslot 1}]",  ::gFlipBind,1);
            self addOpt("GFlip: [{+actionslot 2}]",  ::gFlipBind,2);
            self addOpt("GFlip: [{+actionslot 3}]",  ::gFlipBind,3);
            self addOpt("GFlip: [{+actionslot 4}]",  ::gFlipBind,4);
            break;

        case "nmod":
            self addMenu("nmod", "Nac Mod Bind");
            self addOpt("Save Nac Weapon 1", ::nacModSave, 1);
            self addOpt("Save Nac Weapon 2", ::nacModSave, 2);
            self addOpt("Nac Bind: [{+actionslot 1}]", ::nacModBind,1);
            self addOpt("Nac Bind: [{+actionslot 2}]", ::nacModBind,2);
            self addOpt("Nac Bind: [{+actionslot 3}]", ::nacModBind,3);
            self addOpt("Nac Bind: [{+actionslot 4}]", ::nacModBind,4);
            break;

        case "skree":
            self addMenu("skree", "Skree Bind");
            self addOpt("Save Skree Weapon 1", ::skreeModSave, 1);
            self addOpt("Save Skree Weapon 2", ::skreeModSave, 2);
            self addOpt("Skree Bind: [{+actionslot 1}]", ::skreeBind,1);
            self addOpt("Skree Bind: [{+actionslot 2}]", ::skreeBind,2);
            self addOpt("Skree Bind: [{+actionslot 3}]", ::skreeBind,3);
            self addOpt("Skree Bind: [{+actionslot 4}]", ::skreeBind,4);
            break;

        case "cnzm":
            self addMenu("cnzm", "Can Zoom Bind");
            self addOpt("Canzoom: [{+actionslot 1}]", ::Canzoom,1);
            self addOpt("Canzoom: [{+actionslot 2}]", ::Canzoom,2);
            self addOpt("Canzoom: [{+actionslot 3}]", ::Canzoom,3);
            self addOpt("Canzoom: [{+actionslot 4}]", ::Canzoom,4);
            break;

        case "cb":
            self addMenu("cb", "Change Class Bind");
            self addOpt("Bind Class 1: [{+actionslot 2}]",  ::classBind,1);
            self addOpt("Bind Class 2: [{+actionslot 2}]",  ::classBind,2);
            self addOpt("Bind Class 3: [{+actionslot 2}]",  ::classBind,3);
            self addOpt("Bind Class 4: [{+actionslot 2}]",  ::classBind,4);
            self addOpt("Bind Class 5: [{+actionslot 2}]",  ::classBind,5);
            break;

        case "tp":
            self addMenu("tp", "Teleport Menu");
            self addOpt("Set Spawn",::setSpawn);
            self addOpt("Unset Spawn", ::unsetSpawn);
            self addToggle("Save & Load", self.snl, ::saveandload);
            break;

        case "class":
            self addMenu("class", "Class Menu");
            self addOpt("Weapons", ::newMenu, "wpns");
            self addOpt("Attachments", ::newMenu, "attach");
            self addOpt("Camos", ::newMenu, "camos");
            self addOpt("Lethals", ::newMenu, "lethals");
            self addOpt("Tacticals", ::newMenu, "tacticals");
            self addtoggle("Save Loadout", self.saveLoadoutEnabled, ::saveLoadoutToggle);
            self addOpt("Take Weapon", ::takewpn);
            self addOpt("Drop Weapon", ::dropWpn);
            break;

        case "wpns":
            self addMenu("wpns", "Weapons");

            smgIDs = ["smg_standard","smg_versatile","smg_capacity","smg_fastfire","smg_burst","smg_longrange","smg_mp40","smg_nailgun","smg_rechamber","smg_ppsh","smg_ak74u","smg_msmc","smg_sten2"];
            smgNames = ["Kuda","VMP","Weevil","Vesper","Pharo","Razorback","HG-40","DIY 11 Renovator","HLX 4","PPSH-41","AK-74u","XMC","Sten"];
            self addsliderstring("Submachine Guns", smgIDs, smgNames, ::giveuserweapon);

            arIDs = ["ar_standard","ar_fastburst","ar_cqb","ar_accurate","ar_damage","ar_marksman","ar_longburst","ar_garand","ar_famas","ar_peacekeeper","ar_pulse","ar_m16","ar_galil","ar_an94","ar_m14"];
            arNames = ["KN-44","XR-2","HVK-30","ICR-1","Man-O-War","Sheiva","M8A7","MX Garand","FFAR","Peacekeeper MK2","LV8 Basilisk","M16","Galil","KVK 99m","M14"];
            self addsliderstring("Assault Rifles", arIDs, arNames, ::giveuserweapon);

            sgIDs = ["shotgun_pump","shotgun_semiauto","shotgun_fullauto","shotgun_precision","shotgun_energy","shotgun_olympia"];
            sgNames = ["KRM-262","205 Brecci","Haymaker 12","Argus","Banshii","Olympia"];
            self addsliderstring("Shotguns", sgIDs, sgNames, ::giveuserweapon);

            lmgIDs = ["lmg_light","lmg_cqb","lmg_slowfire","lmg_heavy","lmg_infinite","lmg_rpk"];
            lmgNames = ["BRM","Dingo","Gorgon","48 Dredge","R70 Ajax","RPK"];
            self addsliderstring("Lightmachine Guns", lmgIDs, lmgNames, ::giveuserweapon);

            srIDs = ["sniper_fastsemi","sniper_fastbolt","sniper_chargeshot","sniper_powerbolt","sniper_quickscope","sniper_double","sniper_xpr50","sniper_mosin"];
            srNames = ["Drakon","Locus","P-06","SVG-100","RSA Interdiction","DBSR-50","XPR-50","Dragoon"];
            self addsliderstring("Sniper Rifles", srIDs, srNames, ::giveuserweapon);

            pstlIDs = ["pistol_standard","pistol_burst","pistol_fullauto","pistol_shotgun","pistol_energy","pistol_m1911"];
            pstlNames = ["MR6","RK5","L-CAR 9","Marshal 16","Rift E9","1911"];
            self addsliderstring("Pistols", pstlIDs, pstlNames, ::giveuserweapon);

            lnchrIDs = ["launcher_standard","launcher_lockonly","launcher_multi","launcher_ex41"];
            lnchrNames = ["XM-53","Blackcell","L4 Siege","MAX GL"];
            self addsliderstring("Launchers", lnchrIDs, lnchrNames, ::giveuserweapon);

            meleeIDs = ["knife_loadout","bare_hands","melee_boxing","melee_butterfly","melee_wrench","melee_knuckles","melee_crowbar","melee_sword","melee_bat","melee_dagger","melee_bowie","melee_mace","melee_fireaxe","melee_boneglass","melee_improvise","melee_shockbaton","melee_nunchuks","melee_katana","melee_shovel","melee_prosthetic","melee_chainsaw","melee_crescent"];
            meleeNames = ["Combat Knife","Bare Hands","Prizefighters","Butterfly Knife","Wrench","Brass Knuckles","Iron Jim","Fury's Song","MVP","Malice","Carver","Skull Splitter","Slash n Burn","Nightbreaker","Buzz Cut","Enforcer","Nunchuks","Path of Sorrows","Ace of Spades","L3ft E.","Bushwhacker","Ravens Eye"];
            self addsliderstring("Melee", meleeIDs, meleeNames, ::giveuserweapon);

            specIDs = ["special_crossbow","special_discgun","knife_ballistic"];
            specNames = ["NX Shadowclaw","D13 Sector","Ballistic Knife"];
            self addsliderstring("Specials", specIDs, specNames, ::giveuserweapon);

            heroIDs = ["hero_annihilator","hero_chemicalgelgun","hero_flamethrower","hero_minigun_body3","hero_minigun","hero_pineapplegun"];
            heroNames = ["Annihilator","HIVE","Purifier","White Scythe","Default Scythe","War Machine"];
            self addSliderString("Specialist Weapons", heroIDs, heroNames, ::giveuserweapon);

            miscIDs = ["baseweapon","ball","defaultweapon","ball_world","bowie_knife"];
            miscNames = ["Baseweapon","Ball","Default Weapon","Ball Offhand","Bowie as Melee"];
            self addsliderstring("Miscellaneous", miscIDs, miscNames, ::giveuserweapon);
            break;

        case "attach":
            self addMenu("attach", "Attachments");
            for(a=0;a<44;a++)
                if(TableLookup("gamedata/weapons/common/attachmenttable.csv", 0, a, 1) != "camo")
                    if(TableLookup("gamedata/weapons/common/attachmenttable.csv", 0, a, 2) != "mod")
                        self addOpt(TableLookupIString("gamedata/weapons/common/attachmenttable.csv", 0, a, 3), ::givePlayerAttachment, TableLookup("gamedata/weapons/common/attachmenttable.csv", 0, a, 4));
            break;

        case "camos":
            self addMenu("camos", "Camos");
            for(a=0;a<138;a++)
                if(TableLookup("gamedata/weapons/common/attachmenttable.csv", 0, a, 1) == "camo")
                    if(TableLookupIString("gamedata/weapons/common/attachmenttable.csv", 0, a, 3) != "")
                        self addOpt(TableLookupIString("gamedata/weapons/common/attachmenttable.csv", 0, a, 3), ::changeCamo, a);
            break;

        case "lethals":
            self addMenu("lethals", "Lethals");
            
            lthlIDs = ["frag_grenade","sticky_grenade","bouncingbetty","hatchet","satchel_charge"];
            lthlNames = ["Frag","Semtex","Trip Mine", "Thermite","Combat Axe","C4"];
            
            for(a=0;a<lthlIDs.size;a++)
            self addOpt(lthlNames[a], ::giveUserWeapon, lthlIDs[a]);
            break;

        case "tacticals":
            self addMenu("tacticals", "Tacticals");

            tacIDs = ["concussion_grenade","willy_pete","emp_grenade","trophy_system","proximity_grenade_aoe","flash_grenade","pda_hack"];
            tacNames = ["Concussion","Smoke Screen","EMP","Trophy System","Shock Charge","Flashbang","Black Hat"];

            for(a=0;a<tacIDs.size;a++)
            self addOpt(tacNames[a], ::giveUserWeapon, tacIDs[a]);
            break;

        case "afthit":
            self addMenu("afthit", "Afterhits Menu");

            smgIDs = ["smg_standard","smg_versatile","smg_capacity","smg_fastfire","smg_burst","smg_longrange","smg_mp40","smg_nailgun","smg_rechamber","smg_ppsh","smg_ak74u","smg_msmc","smg_sten2"];
            smgNames = ["Kuda","VMP","Weevil","Vesper","Pharo","Razorback","HG-40","DIY 11 Renovator","HLX 4","PPSH-41","AK-74u","XMC","Sten"];
            self addsliderstring("Submachine Guns", smgIDs, smgNames, ::AfterHit);

            arIDs = ["ar_standard","ar_fastburst","ar_cqb","ar_accurate","ar_damage","ar_marksman","ar_longburst","ar_garand","ar_famas","ar_peacekeeper","ar_pulse","ar_m16","ar_galil","ar_an94","ar_m14"];
            arNames = ["KN-44","XR-2","HVK-30","ICR-1","Man-O-War","Sheiva","M8A7","MX Garand","FFAR","Peacekeeper MK2","LV8 Basilisk","M16","Galil","KVK 99m","M14"];
            self addsliderstring("Assault Rifles", arIDs, arNames, ::AfterHit);

            sgIDs = ["shotgun_pump","shotgun_semiauto","shotgun_fullauto","shotgun_precision","shotgun_energy","shotgun_olympia"];
            sgNames = ["KRM-262","205 Brecci","Haymaker 12","Argus","Banshii","Olympia"];
            self addsliderstring("Shotguns", sgIDs, sgNames, ::AfterHit);

            lmgIDs = ["lmg_light","lmg_cqb","lmg_slowfire","lmg_heavy","lmg_infinite","lmg_rpk"];
            lmgNames = ["BRM","Dingo","Gorgon","48 Dredge","R70 Ajax","RPK"];
            self addsliderstring("Lightmachine Guns", lmgIDs, lmgNames, ::AfterHit);

            srIDs = ["sniper_fastsemi","sniper_fastbolt","sniper_chargeshot","sniper_powerbolt","sniper_quickscope","sniper_double","sniper_xpr50","sniper_mosin"];
            srNames = ["Drakon","Locus","P-06","SVG-100","RSA Interdiction","DBSR-50","XPR-50","Dragoon"];
            self addsliderstring("Sniper Rifles", srIDs, srNames, ::AfterHit);

            pstlIDs = ["pistol_standard","pistol_burst","pistol_fullauto","pistol_shotgun","pistol_energy","pistol_m1911"];
            pstlNames = ["MR6","RK5","L-CAR 9","Marshal 16","Rift E9","1911"];
            self addsliderstring("Pistols", pstlIDs, pstlNames, ::AfterHit);

            lnchrIDs = ["launcher_standard","launcher_lockonly","launcher_multi","launcher_ex41"];
            lnchrNames = ["XM-53","Blackcell","L4 Siege","MAX GL"];
            self addsliderstring("Launchers", lnchrIDs, lnchrNames, ::AfterHit);

            meleeIDs = ["knife_loadout","melee_boxing","melee_butterfly","melee_wrench","melee_knuckles","melee_crowbar","melee_sword","melee_bat","melee_dagger","melee_bowie","melee_mace","melee_fireaxe","melee_boneglass","melee_improvise","melee_shockbaton","melee_nunchuks","melee_katana","melee_shovel","melee_prosthetic","melee_chainsaw","melee_crescent"];
            meleeNames = ["Combat Knife","Prizefighters","Butterfly Knife","Wrench","Brass Knuckles","Iron Jim","Fury's Song","MVP","Malice","Carver","Skull Splitter","Slash n Burn","Nightbreaker","Buzz Cut","Enforcer","Nunchuks","Path of Sorrows","Ace of Spades","L3ft E.","Bushwhacker","Ravens Eye"];
            self addsliderstring("Melee", meleeIDs, meleeNames, ::AfterHit);

            specIDs = ["special_crossbow","special_discgun","knife_ballistic"];
            specNames = ["NX Shadowclaw","D13 Sector","Ballistic Knife"];
            self addsliderstring("Specials", specIDs, specNames, ::AfterHit);

            heroIDs = ["hero_annihilator","hero_chemicalgelgun","hero_flamethrower","hero_minigun_body3","hero_minigun","hero_pineapplegun"];
            heroNames = ["Annihilator","HIVE","Purifier","White Scythe","Default Scythe","War Machine"];
            self addSliderString("Specialist Weapons", heroIDs, heroNames, ::AfterHit);

            miscIDs = ["baseweapon","ball","defaultweapon"];
            miscNames = ["Baseweapon","Ball","Default Weapon"];
            self addsliderstring("Miscellaneous", miscIDs, miscNames, ::AfterHit);
            break;

        case "kstrks":
            self addMenu("kstrks", "Killstreaks");

            break;

        case "host":
            self addMenu("host", "Host Options");
            self addOpt("Client Menu", ::newMenu, "Verify");

            minDistVal = ["15","25","50","100","150","200","250"];
            self addsliderstring("Minimum Distance", minDistVal, undefined, ::setMinDistance);
            self addSliderValue("Game Timer", 0, -10, 10, 1, ::editTime);
            
            //self addOpt("Fast Restart", ::FastRestart);
            self addToggle("Freeze Bots", self.frozenbots, ::toggleFreezeBots);
            self addSliderValue("Spawn Bots", 1, 1, 18, 1);

            botOptNames = ["Teleport to Crosshairs","Kick All Bots"];
            botOptIDs = ["teleport","kick"];
            self addSliderString("Bot Controls", botOptIDs, botOptNames, ::botControls);

            self addToggle("Disable OOM Utilities", level.oomUtilDisabled, ::oomToggle);
            break;
    }   
    self clientoptions();
}

drawMenu()
{
    if(!isDefined(self.menu["UI"]))
        self.menu["UI"] = [];
    if(!isDefined(self.menu["UI_TOG"]))
        self.menu["UI_TOG"] = [];    
    if(!isDefined(self.menu["UI_SLIDE"]))
        self.menu["UI_SLIDE"] = [];
    if(!isDefined(self.menu["UI_STRING"]))
        self.menu["UI_STRING"] = [];    
        
    self.menu["UI"]["MENU_TITLE"] = self createtext("default", 2, "TOPLEFT", "CENTER", self.presets["X"] + 125, self.presets["Y"] - 105, 5, 1, level.MenuName, self.presets["MenuTitle_Color"]);
    self.menu["UI"]["OPT_BG"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 70, 204, 182, self.presets["Option_BG"], "white", 1, 1);    
    self.menu["UI"]["OUTLINE"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 56.4, self.presets["Y"] - 121.5, 204, 234, self.presets["Outline_BG"], "white", 0, .7); 
    self.menu["UI"]["SCROLLER"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 108, 200, 10, self.presets["Scroller_BG"], self.presets["Scroller_Shader"], 2, 1); 
    self resizeMenu();
}