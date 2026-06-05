    endGame()
    {
        level thread maps\mp\gametypes\_gamelogic::forceEnd();
    }

    LowGravity()
    {
        if( isDefined( level.lowGrav ) )
        {
            WriteByte( 0x821D264E, 0x03 );
            level.lowGrav = undefined;
        }

        else
        {
            WriteByte( 0x821D264E, 0x02 );
            level.lowGrav = true;
        }
    }