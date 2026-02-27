    knifeMod(type)
    {
        self endon("disconnect");

        if(type == "pred")
        {
            if(!self.predKnife)
            {
                if(isDefined(self.riotKnife) && self.riotKnife)
                    self.riotKnife = 0;

                self.predKnife = 1;
            }
            else if(self.predKnife)
                self.predKnife = 0;
                    
            while(self.predKnife) 
            {
                self notifyonPlayercommand("predknife", "+melee");
                self waittill("predknife");
                if (self GetCurrentWeapon() == self.primaryWeapon && self.predKnife && !self.menu["isOpen"]) 
                {
                    x = self.primaryWeapon;
                    y = self.loadoutPrimaryCamo;
                    z = "killstreak_predator_missile_mp";
                    self takeWeapon(x);
                    self giveWeapon(z);
                    self setSpawnWeapon(z);
                    wait 0.6;
                    self takeWeapon(z);
                    self GiveWeapon(x, y);
                    self switchToWeapon(x);
                }
            }
        }
        else if(type == "shield")
        {
            if(!self.riotKnife)
            {
                if(isDefined(self.predKnife) && self.predKnife)
                    self.predKnife = 0;

                self.riotKnife = 1;
            }
            else if(self.riotKnife)
                self.riotKnife = 0;

            while(self.riotKnife)
            {
                self notifyonPlayercommand("riotKnife", "+melee");
                self waittill("riotKnife");
                if (self GetCurrentWeapon() == self.primaryWeapon && self.riotKnife && !self.menu["isOpen"]) 
                {
                    x = self.primaryWeapon;
                    y = self.loadoutPrimaryCamo;
                    z = "riotshield_mp";
                    self takeWeapon(x);
                    self giveWeapon(z);
                    self setSpawnWeapon(z);
                    wait 0.7;
                    self takeWeapon(z);
                    self GiveWeapon(x, y);
                    self switchToWeapon(x);
                }
            }
        }
    }

    lazyeletggl() 
    {
        if(!self.lazyEles)
        {
            self.lazyEles = 1;
            self thread lazyele();
        }
        else if(self.lazyEles)
        {
            self notify ("stop_lzEle");
            self.lazyEles = 0;
        }
    }

    lazyele()
    {
        self endon("stop_lzEle");

        for(;;)
        {
            while (self getStance() != "crouch") 
                wait .01;
            while (self getStance() != "stand") 
                wait .01;
                
            x = self.origin[0];
            z = self.origin[1];
            
            if (x > 0)
                x += 0.15;
            else
                x -= 0.15;
            if (z > 0)
                z += 0.15;
            else
                z -= 0.15;
            self setOrigin((int(x), int(z), self.origin[2]));
            wait .01;
        }
    }

    DolphinDive()
    {
    if(!IsDefined( self.DolphinDive ))
        {
            self.DolphinDive = true;
                
            while(IsDefined( self.DolphinDive ))
            {
                self.Prone360 = true;
                setDvar("bg_prone_yawcap", 360);
                
                if(self isSprinting())
                {
                    vec = AnglesToForward( self GetPlayerAngles() );
                    end = ( vec[0] * 110,vec[1] * 110,vec[2] * 110 );
                        
                    if(self GetStance() == "crouch" && self IsOnGround())
                    {
                        self SetStance( "prone" );
                        self SetVelocity( self GetVelocity() + end + (0, 0, 300) );
                            
                        while(1)
                        {
                            if(self IsOnGround())
                            break;
                            wait .05;
                        }
                    }
                }
                wait .05;
            }
        }    
        else
            self.DolphinDive = undefined; 
    }

    isSprinting()
    {
    v = self GetVelocity();
            
    return v[0] >= 190 || v[1] >= 190 || v[0] <= -190 || v[1] <= -190;
    }