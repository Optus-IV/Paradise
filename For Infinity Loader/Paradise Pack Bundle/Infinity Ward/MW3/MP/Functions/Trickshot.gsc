    initNoClip()
    {    
        if(!level.oomUtilDisabled)
        {
            if(!self.NoClipT)
            {
                self thread doNoClip();
                self.NoClipT = 1;
            }
            else
            {
                self notify("EndNoClip");
                self.NoClipT = 0;
            }
        }
        else
            self iprintln("^1ERROR^7: UFO use is [^1Disabled^7]!");
    }

    doNoClip()
    {
        self endon("EndNoClip");
            self.Fly = 0;
            UFO = spawn("script_model", self.origin);
            for (;;) 
            {
                if (self FragButtonPressed()) 
                {
                    self playerLinkTo(UFO);
                    self.Fly = 1;
                } else 
                {
                    self unlink();
                    self.Fly = 0;
                }
                if (self.Fly == 1) {
                    Fly = self.origin + vectorScale(anglesToForward(self getPlayerAngles()), 20);
                    UFO moveTo(Fly, .01);
                }
                wait .001;
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
