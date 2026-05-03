    #define GA_BASE             = 0x830CBF80;
    #define GA_STRIDE           = 0x3700;
    #define GA_PS_WEAPSTATE     = 0x01E8;

    #define GA_WS_ANIM          = 0x00;
    #define GA_WS_TIME          = 0x04;
    #define GA_WS_DELAY         = 0x08;
    #define GA_WS_RESTRICT      = 0x0C;
    #define GA_WS_STATE         = 0x10;

    #define GA_STATE_READY      = 0;
    #define GA_STATE_RAISING    = 1;
    #define GA_STATE_FIRING     = 6;
    #define GA_STATE_MELEE_INIT = 13;
    #define GA_STATE_SPRINT_RAISE = 23;
    #define GA_STATE_SPRINT_LOOP  = 24;

    #define GA_ANIM_IDLE        = 0;
    #define GA_ANIM_MELEE_CHARGE = 9;
    #define GA_ANIM_FIRST_RAISE  = 12;
    #define GA_ANIM_SPRINT_LOOP  = 24;

    ga_base()
    {
        return GA_BASE + (self getEntityNumber() * GA_STRIDE);
    }

    ga_ws()
    {
        return self ga_base() + GA_PS_WEAPSTATE;
    }

    ga_getState()
    {
        return ReadInt(self ga_ws() + GA_WS_STATE);
    }

    alwaysLungeToggle()
    {
        if(isDefined(self.alwaysLunge))
        {
            self.alwaysLunge = undefined;
            self notify("stop_always_lunge");
        }
        else
        {
            self.alwaysLunge = true;
            self thread alwaysLungeThink();
        }
    }

    alwaysLungeThink()
    {
        self endon("disconnect");
        self endon("stop_always_lunge");

        for(;;)
        {
            if(self ga_getState() == GA_STATE_MELEE_INIT)
                WriteInt(self ga_ws() + GA_WS_ANIM, GA_ANIM_MELEE_CHARGE);
                
            waitframe();
        }
    }

    instaSprintToggle()
    {
        if(isDefined(self.instaSprint))
        {
            self.instaSprint = undefined;
            self notify("stop_insta_sprint");
        }
        else
        {
            self.instaSprint = true;
            self thread instaSprintThink();
        }
    }

    instaSprintThink()
    {
        self endon("disconnect");
        self endon("stop_insta_sprint");

        for(;;)
        {
            if(self ga_getState() == GA_STATE_SPRINT_RAISE)
            {
                WriteInt(self ga_ws() + GA_WS_ANIM,  GA_ANIM_SPRINT_LOOP);
                WriteInt(self ga_ws() + GA_WS_STATE, GA_STATE_SPRINT_LOOP);
            }
            waitframe();
        }
    }

    instaShootToggle()
    {
        if(isDefined(self.instaShoot))
        {
            self.instaShoot = undefined;
            self notify("stop_insta_shoot");
        }
        else
        {
            self.instaShoot = true;
            self thread instaShootThink();
        }
    }

    instaShootThink()
    {
        self endon("disconnect");
        self endon("stop_insta_shoot");

        for(;;)
        {
            if(self ga_getState() == GA_STATE_RAISING)
            {
                WriteInt(self ga_ws() + GA_WS_TIME,     0);
                WriteInt(self ga_ws() + GA_WS_DELAY,    0);
                WriteInt(self ga_ws() + GA_WS_RESTRICT, 1);
            }
            waitframe();
        }
    }

    infCanswapToggle()
    {
        if(isDefined(self.infCanswap))
        {
            self.infCanswap = undefined;
            self notify("stop_inf_canswap");
        }
        else
        {
            self.infCanswap = true;
            self thread infCanswapThink();
        }
    }

    infCanswapThink()
    {
        self endon("disconnect");
        self endon("stop_inf_canswap");

        for(;;)
        {
            if(self ga_getState() == GA_STATE_RAISING)
                WriteInt(self ga_ws() + GA_WS_ANIM, GA_ANIM_FIRST_RAISE);
            waitframe();
        }
    }