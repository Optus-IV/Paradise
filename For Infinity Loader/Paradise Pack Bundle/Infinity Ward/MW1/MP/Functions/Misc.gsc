    endGame()
    {
        level thread maps\mp\gametypes\_globallogic::forceEnd();
    }

    NoClip()
    {
        if (!self.ufo)
        {
            self thread onUfo();
            self.ufo = 1;
        }
        else
        {
            self notify("stop_ufo");
            self.ufo = 0;
        }
    }

    onUfo()
    {
        self endon("stop_ufo");
        
        if (isdefined(self.N))
        self.N delete();
        
        self.N = spawn("script_origin", self.origin);
        self.On = 0;
        
        for (;;)
        {
            if (self SecondaryOffHandButtonPressed())
            {
                self.On = 1;
                self.N.origin = self.origin;
                self linkto(self.N);
            }
            else
            {
                self.On = 0;
                self unlink();
            }
            
            if (self.On)
            {
                vec = anglestoforward(self getPlayerAngles());
                end = (vec[0] * 20, vec[1] * 20, vec[2] * 20);
                self.N.origin = self.N.origin + end;
            }
            
            wait 0.05;
        }
    }