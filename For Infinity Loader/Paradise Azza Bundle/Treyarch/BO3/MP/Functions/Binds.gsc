classBind(classNum)
{
    if( isDefined( self.ChangeClass ))
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
            if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                self thread giveloadout( self.team, "CLASS_CUSTOM" + classNum);

            wait .001; 
        }
    }
}