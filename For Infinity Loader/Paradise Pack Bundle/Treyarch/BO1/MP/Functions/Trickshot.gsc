    UFOMode()
    {
        if(!level.oomUtilDisabled)
        {
            if(!isDefined( self.UFOMode ))
            {
                self.UFOMode = true;
                self thread UFODude();
            }
            else
            {
                self.UFOMode = undefined;
                self notify("stop_ufo");
            }
        }
        else
            self iprintln("^1ERROR^7: UFO use is [^1Disabled^7]!");
    }

    UFODude()
    {
        self endon("stop_ufo");
        
        if(isdefined(self.N))
        self.N delete();
        self.N  = spawn("script_origin", self.origin);
        self.On = 0;
        for(;;)
        {
            if(self secondaryoffhandbuttonpressed())
            {
                self.On       = 1;
                self.N.origin = self.origin;
                self linkto(self.N);
            }
            else
            {
                self.On = 0;
                self unlink();
            }
            if(self.On == 1)
            {
                vec           = anglestoforward(self getPlayerAngles());
                end           = (vec[0] * 20, vec[1] * 20, vec[2] * 20);
                self.N.origin = self.N.origin+end;
            }
            wait 0.05;
        }
    }