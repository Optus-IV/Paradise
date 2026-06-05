    instashoot()
    {
        if( isDefined( self.instashoot ))
        {
            self.instashoot = undefined;
            self notify( "stop_Instashoots" );
        }

        else
        {
            self.instashoot = true;
            self thread instaShootLoop();
        }
    }

    instaShootLoop()
    {
        self endon( "disconnect" );
        self endon( "stop_Instashoots" );

        for(;;)
        {
            self waittill( "weapon_change" );

            self disableweapons();
            wait .0001;
            self enableWeapons();
            wait .0001;
        }
    }

    SetCanswapMode(type)
    {
        if(type == "Current") 
        {
            if(!self.currCan)
            {
                self.currCan = 1;
                self.InfiniteCan = 0;
                self.currCanWpn = self getcurrentweapon();
                #ifndef BO3
                self iprintln("Canswap Weapon: [^2" + self.currCanWpn + "^7]");
                #else
                self iprintln("Canswap Weapon: [^2" + self.currCanWpn.name + "^7]");
                #endif
                self thread CurrCanswapLoop();
            }

            else if(self.currCan)
            {
                self.currCan = 0;
                self iprintln("Canswap Mode: [^1OFF^7]");
                return;
            }
        }
        else if(type == "Infinite") 
        {
            if(!self.InfiniteCan)
            {
                self.InfiniteCan = 1;
                self.currCan     = 0;       
                self iprintln("Canswap Mode: [^2Infinite^7]");
                self thread InfiniteCanswapLoop();
            }
            else if(self.InfiniteCan)
            {
                self.InfiniteCan = 0;
                self iprintln("Canswap Mode: [^1OFF^7]");
                return;
            }
        }
    }

    CurrCanswapLoop()
    {
        while(self.currCan)
        {
            self waittill("weapon_change", self.currCanWpn);
            self.WeapClip  = self getWeaponAmmoClip(self.currCanWpn);
            self.WeapStock = self getWeaponAmmoStock(self.currCanWpn);
            self takeWeapon(self.currCanWpn);
            waittillframeend;
            self giveWeapon(self.currCanWpn);
            self setWeaponAmmoStock(self.currCanWpn, self.WeapStock);
            self setWeaponAmmoClip(self.currCanWpn, self.WeapClip);
        }
    }

    InfiniteCanswapLoop()
    {
        while(self.InfiniteCan)
        {
            currentWeapon = self getCurrentWeapon();
            if(currentWeapon != "none")
            {
                self.WeapClip  = self getWeaponAmmoClip(currentWeapon);
                self.WeapStock = self getWeaponAmmoStock(currentWeapon);
                self takeWeapon(currentWeapon);
                waittillframeend;
                self giveWeapon(currentWeapon);
                self setWeaponAmmoStock(currentWeapon, self.WeapStock);
                self setWeaponAmmoClip(currentWeapon, self.WeapClip);
            }
            self waittill("weapon_change", currentWeapon);
        }
    }

    doTwoPiece()
    {
        #ifdef WAW || MW1
        if (level.currentGametype == "dm")
        {
            self.score = 140;
            self.pers[ "score" ] = 140;
            self.kills = 28;
            self.pers[ "kills" ] = 28;
        }
        #endif

        #ifdef MW2 || MW3 || BO1 || BO2
        if(level.currentGametype == "dm")
        {
            self.kills   = 28;
            self.score   = 1400;
            self.pers["pointstowin"] = 28;
            self.pers["kills"] = 28;
            self.pers["score"] = 1400;
        }
        #endif

        #ifdef MWR
        if(level.currentGametype == "dm")
        {
            self.kills   = 24;
            self.score   = 24;
            self.pers["pointstowin"] = 24;
            self.pers["kills"] = 24;
            self.pers["score"] = 24;
        }
        #endif

        #ifdef BO3
        if(level.currentGametype == "dm")
        {
            self.kills   = 28;
            self.score   = 28;
            self.pers["pointstowin"] = 28;
            self.pers["kills"] = 28;
            self.pers["score"] = 28;
        }
        #endif

        #ifdef Ghosts
        if(level.currentGametype == "dm")
        {
            self.kills   = 28;
            self.score   = 28;
            self.pers["pointstowin"] = 28;
            self.pers["kills"] = 28;
            self.pers["score"] = 28;
        }
        #endif
    }

    #ifdef MW1 || WAW || BO1 || BO2 || BO3
    getprimary()
    {
        class = self.class;
        class_num      = int( class[class.size-1] )-1; 
        primaryweapon  = self.custom_class[class_num]["primary"];
        return primaryweapon;
    }

    getsecondary()
    {
        class = self.class;
        class_num      = int( class[class.size-1] )-1; 
        secondaryweapon = self.custom_class[class_num]["secondary"];
        return secondaryweapon;
    }
    #endif

    dropCanswap()
    {
        #ifdef MW1 || MW2
        weap = "rpd_mp";
        #endif

        #ifdef MW3
        weap = "iw5_mk46_mp";
        #endif

        #ifdef BO1
        weap = "hk21_mp";
        #endif

        #ifdef BO2
        weap = "hamr_mp";
        #endif

        #ifdef WAW
        weap = "dp28_mp";
        #endif

        #ifdef MWR
        weap = "h1_rpd_mp_a#none_f#base";
        #endif

        #ifdef BO3
        weap = "lmg_cqb_mp";
        #endif

        #ifdef Ghosts
        weap = "iw6_m27_mp";
        #endif

        #ifdef IW
        weap = "iw7_unsalmg_mp";
        #endif

        self giveweapon(weap);
        #ifdef IW
        self method_80B8(weap);
        #else
        self dropitem(weap);
        #endif
    }