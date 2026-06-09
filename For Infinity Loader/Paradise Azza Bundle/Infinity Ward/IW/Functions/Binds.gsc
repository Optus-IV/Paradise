    classBind(classNum)
    {
        if( isDefined(self.ChangeClass ))
        {
            self iPrintLn("Change Class Bind [^1OFF^7]");
            self.ChangeClass = undefined;
        }

        else
        {
            self iPrintLn("Press [{+Actionslot 2}] to ^2Change Class");

            self.ChangeClass = true;

            while(isDefined(self.ChangeClass))
            {
                className = scripts\mp\_menus::func_7E2A( classNum );

                if(self isbuttonpressed("+actionslot 2"))
                {
                    self.class    = className;
                    self.var_4004 = className;

                    scripts\mp\_class::func_F691( self.class );
                    scripts\mp\_class::func_8379( self.pers["team"], self.class );
                }
                wait .001;
            }
        }
    }