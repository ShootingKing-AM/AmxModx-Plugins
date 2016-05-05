    #include < amxmodx >
    #include < cstrike >
    #include < fakemeta >
    #include < engine >
    #include < fun >

    //#include < fcs >
    //#include < CC_ColorChat >

    #pragma semicolon 1

    #define PLUGIN "Furien Christmass Gifts"
    #define VERSION "0.6.3"

    /*
     * Returns a players credits
     * 
     * @param		client - The player index to get points of
     * 
     * @return		The credits client
     * 
     */

    native fcs_get_user_credits(client);

    /*
     * Sets <credits> to client
     * 
     * @param		client - The player index to set points to
     * @param		credits - The amount of credits to set to client
     * 
     * @return		The credits of client
     * 
     */

    native fcs_set_user_credits(client, credits);

    /*
     * Adds <credits> points to client
     * 
     * @param		client - The player index to add points to
     * @param		credits - The amount of credits to set to client
     * 
     * @return		The credits of client
     * 
     */

    stock fcs_add_user_credits(client, credits)
    {
    	return fcs_set_user_credits(client, fcs_get_user_credits(client) + credits);
    }

    /*
     * Subtracts <credits>  from client
     * 
     * @param		client - The player index to subtract points from
     * @param		credits - The amount of credits to set to client
     * 
     * @return		The credits of client
     * 
     */

    stock fcs_sub_user_credits(client, credits)
    {
    	return fcs_set_user_credits(client, fcs_get_user_credits(client) - credits);
    }

    enum Color
    {
    	NORMAL = 1, 		// Culoarea care o are jucatorul setata in cvar-ul scr_concolor.
    	GREEN, 			// Culoare Verde.
    	TEAM_COLOR, 		// Culoare Rosu, Albastru, Gri.
    	GREY, 			// Culoarea Gri.
    	RED, 			// Culoarea Rosu.
    	BLUE, 			// Culoarea Albastru.
    };

    new TeamName[  ][  ] = 
    {
    	"",
    	"TERRORIST",
    	"CT",
    	"SPECTATOR"
    };

    enum
    {
    	
    	GIFT_HP, 
    	GIFT_AP,
    	GIFT_HP_AP,
    	GIFT_MONEY,
    	GIFT_HE,
    	GIFT_CREDITS,
    	BADGIFT_MONEY,
    	BADGIFT_WEAPONS,
    	BADGIFT_SLAP
    	
    }

    new const g_szFmuGiftsModels[  7  ][   ]  =
    {
    	
    	"models/fmu_gift_cyan.mdl",
    	"models/fmu_gift_green.mdl",
    	"models/fmu_gift_orange.mdl",
    	"models/fmu_gift_pink.mdl",
    	"models/fmu_gift_red.mdl",
    	"models/fmu_gift_yellow.mdl",
    	"models/fmu_gift_random.mdl"
    	
    };

    new const g_iFmuGiftsColors[  7  ][  3  ]  =
    {
    	{ 0, 255, 255 },
    	{ 0, 255, 125 },
    	{ 255, 125, 65 },
    	{ 255, 0, 125 },
    	{ 255, 25, 25 },
    	{ 255, 255, 0 },
    	{ 255, 255, 255 }
    };

    new const FMU_TAG[    ]  =  "[Furien Gifts]";
    new const g_szGiftClassName[    ]  =  "FurienGift_byAskhanar";

    // Nu modifica !!
    new Float:fMaxs[ 3 ]  =  {  14.0, 14.0, 35.0  };
    new Float:fMins[ 3 ]  =  {  -14.0, -14.0, 0.0  };
    // Nu modifica !!

    new gCvarGiftHP;
    new gCvarGiftAP;
    new gCvarGiftMoney;
    new gCvarGiftCREDITS;
    new gCvarGiftChance;


    public plugin_precache(    )
    	for( new i = 0; i < 7; i++ )
    		precache_model( g_szFmuGiftsModels[ i ] );


    public plugin_init( )
    {
    	
    	register_plugin( PLUGIN, VERSION, "Askhanar" );
    	
    	gCvarGiftHP = register_cvar( "fmu_gifts_hp", "5" );
    	gCvarGiftAP = register_cvar( "fmu_gifts_ap", "5" );
    	gCvarGiftMoney = register_cvar( "fmu_gifts_money", "5500" );
    	gCvarGiftCREDITS = register_cvar( "fmu_gifts_credits", "35" );
    	gCvarGiftChance = register_cvar( "fmu_gifts_chance", "75" );
    	
    	register_event(  "DeathMsg",  "EventDeathMsg",  "a"  );
    	
    	register_event( "HLTV", "DeleteAllGifts", "a", "1=0", "2=0" );
    	register_event( "TextMsg", "DeleteAllGifts", "a", "2=#Game_will_restart_in" ); 

    	// Oprita.. ( cand omori ultimu jucator, pica cadoul dar e sters de chemarea eventului.. ).
    	//register_logevent( "DeleteAllGifts", 2, "0=World triggered", "1=Round_Draw", "1=Round_End" );
    	
    	register_touch( g_szGiftClassName, "player", "FwdPlayerTouchGift" );
    	
    	
    }

    public EventDeathMsg(  )
    {	
    	
    	new iKiller  = read_data(  1  );
    	new iVictim  = read_data(  2  );
    	
    	if( iVictim  !=  iKiller )
    	{
    		
    		static iRandomChance;
    		iRandomChance = random_num( 1, 100 );
    		
    		static iChance;
    		iChance = get_pcvar_num( gCvarGiftChance );
    		
    		if( iRandomChance <= iChance )
    		{
    			new iParm[ 3 ];
    			
    			new Float:fUserOrigin[ 3 ], iUserOrigin[ 3 ];
    			pev(iVictim, pev_origin, fUserOrigin );
    			FVecIVec( fUserOrigin, iUserOrigin );
    			
    			iParm[ 0 ] = iUserOrigin[ 0 ];
    			iParm[ 1 ] = iUserOrigin[ 1 ];
    			iParm[ 2 ] = iUserOrigin[ 2 ];
    			
    			set_task( 0.7, "CreateGift", _, iParm, 3 );
    		}
    		
    	}
    	
    	
    	
    	
    	return 0;
    }

    public CreateGift( iParm[ ] )
    {
    	new iOrigin[ 3 ], Float:fOrigin[ 3 ];
    	
    	
    	iOrigin[ 0 ] = iParm[ 0 ];
    	iOrigin[ 1 ] = iParm[ 1 ];
    	iOrigin[ 2 ] = iParm[ 2 ];
    	IVecFVec( iOrigin, fOrigin );
    	
    	new iEnt = create_entity( "info_target" );
    	if ( !is_valid_ent(iEnt) ) return 0;
    	
    	new iRandom = random_num( 0, 6 );
    	
    	entity_set_string(  iEnt, EV_SZ_classname, g_szGiftClassName  );
    	entity_set_origin(  iEnt, fOrigin  );
    	entity_set_model(  iEnt, g_szFmuGiftsModels[  iRandom  ]  );
    	entity_set_int(  iEnt, EV_INT_movetype, MOVETYPE_NONE  );
    	entity_set_int(  iEnt, EV_INT_solid, SOLID_BBOX );
    	entity_set_size(  iEnt, fMins, fMaxs  );
    	
    	set_rendering( iEnt,
    			kRenderFxGlowShell,
    			g_iFmuGiftsColors[ iRandom ][ 0 ],
    			g_iFmuGiftsColors[ iRandom ][ 1 ],
    			g_iFmuGiftsColors[ iRandom ][ 2 ],
    			kRenderNormal,
    			255 );
    	
    	drop_to_floor(  iEnt  );
    	
    	new Float:fVelocity[ 3 ];
    	fVelocity[ 0 ] = ( random_float( 0.0, 256.0 ) - 128.0 );
    	fVelocity[ 1 ] = ( random_float( 0.0, 256.0 ) - 128.0 );
    	fVelocity[ 2 ] = ( random_float( 0.0, 300.0 ) + 75.0 );
    	
    	entity_set_vector( iEnt, EV_VEC_velocity, fVelocity );
     
    	return 0;
    }

    public DeleteAllGifts( )
    {
    	new iFoundEntity;

    	while ( ( iFoundEntity = find_ent_by_class(  iFoundEntity, g_szGiftClassName  ) )  !=  0  )
    	{
    		engfunc( EngFunc_RemoveEntity, iFoundEntity );
    	}
    	
    }

    public FwdPlayerTouchGift(  const iEnt, const id  )
    {
    	
    	if( is_valid_ent(  iEnt  )  &&  is_user_alive(  id  )  )
    	{
    		
    		static iRandomChance;
    		iRandomChance = random_num( 1, 100 );
    		if( iRandomChance <= 90 )
    		{
    			new iRandomGift = random_num( GIFT_HP, GIFT_CREDITS );
    			while(  iRandomGift  ==  GIFT_HE   &&  user_has_weapon(  id,  CSW_HEGRENADE  )  )
    				iRandomGift = random_num( GIFT_HP, GIFT_CREDITS );
    			
    			GivePlayerGift( id, iRandomGift );
    		}
    		else
    		{
    			new iRandomGift = random_num( BADGIFT_MONEY, BADGIFT_SLAP );
    			while( iRandomGift == BADGIFT_MONEY && cs_get_user_money( id ) == 0 )
    				iRandomGift = random_num( BADGIFT_MONEY, BADGIFT_SLAP );
    				
    			GivePlayerGift( id, iRandomGift );
    		}
    		
    		remove_entity( iEnt  );
    			
    	}
    	
    	return 0;
    }

    public GivePlayerGift(  id, const  iGiftType  )
    {
    	
    	switch(  iGiftType  )
    	{
    		
    		case GIFT_HP:
    		{
    			set_user_health(  id,  get_user_health(  id  )  +  get_pcvar_num( gCvarGiftHP )  );
    			ColorChat(  id, RED,  "^x04%s^x01 Mosul ti-a oferit cadou^x03 %i HP^x01!",  FMU_TAG, get_pcvar_num( gCvarGiftHP )  );
    			
    		}
    		case GIFT_AP:
    		{
    			set_user_armor(  id,  get_user_armor(  id  )  +  get_pcvar_num( gCvarGiftAP ) );
    			ColorChat(  id, RED,  "^x04%s^x01 Mosul ti-a oferit cadou^x03 %i AP^x01!",  FMU_TAG, get_pcvar_num( gCvarGiftAP )  );
    			
    		}
    		case GIFT_HP_AP:
    		{
    			static iHP;
    			iHP = get_pcvar_num( gCvarGiftHP );
    			static iAP;
    			iAP = get_pcvar_num( gCvarGiftAP );
    			set_user_health(  id,  get_user_health(  id  )  +  iHP  );
    			set_user_armor(  id,  get_user_armor(  id  )  +  iAP  );
    			
    			ColorChat(  id, RED,  "^x04%s^x01 Mosul ti-a oferit cadou^x03 %i HP^x01 si^x03 %i AP^x01!",  FMU_TAG, iHP, iAP );
    		}
    		case GIFT_MONEY:
    		{
    			cs_set_user_money(  id,  clamp(  cs_get_user_money(  id  )  +  get_pcvar_num( gCvarGiftMoney ), 0, 16000  )  );
    			ColorChat(  id, RED,  "^x04%s^x01 Mosul ti-a oferit cadou^x03 %i$^x01!",  FMU_TAG, get_pcvar_num( gCvarGiftMoney ) );
    		}
    		case GIFT_HE:
    		{
    			
    			give_item(  id,  "weapon_hegrenade"  );
    			ColorChat(  id, RED,  "^x04%s^x01 Mosul ti-a oferit cadou un^x03 HE^x01!",  FMU_TAG  );
    			
    		}
    		case GIFT_CREDITS:
    		{
    			fcs_add_user_credits(  id, get_pcvar_num( gCvarGiftCREDITS )  );
    			ColorChat(  id, RED,  "^x04%s^x01 Mosul ti-a oferit cadou^x03 %i CREDITE^x01!",  FMU_TAG, get_pcvar_num( gCvarGiftCREDITS ) );
    		}
    		
    		case BADGIFT_MONEY:
    		{
    			cs_set_user_money( id, 0 );
    			ColorChat(  id, RED,  "^x04%s^x03 NU^x01 ai fost destul de^x03 cuminte^x01!",  FMU_TAG  );
    			ColorChat(  id, RED,  "^x04%s^x01 Mosul ti-a confiscat toti banii!",  FMU_TAG  );
    		}
    		case BADGIFT_WEAPONS:
    		{
    			strip_user_weapons( id );
    			give_item( id, "weapon_knife" );
    			ColorChat(  id, RED,  "^x04%s^x03 NU^x01 ai fost destul de^x03 cuminte^x01!",  FMU_TAG  );
    			ColorChat(  id, RED,  "^x04%s^x01 Mosul ti-a confiscat toate armele!",  FMU_TAG );
    		}
    		case BADGIFT_SLAP:
    		{
    			set_task( 0.1, "PunchUser", id );
    			set_task( 0.2, "PunchUser", id );
    			set_task( 0.3, "PunchUser", id );
    			
    			ColorChat(  id, RED,  "^x04%s^x03 NU^x01 ai fost destul de^x03 cuminte^x01!",  FMU_TAG  );
    			ColorChat(  id, RED,  "^x04%s^x01 Mosul ti-a dat^x03 3^x01 palme!",  FMU_TAG );
    		}
    	}
    }

    public PunchUser( id )
    {
    	if( !is_user_connected( id ) )
    		return 1;
    		
    	new Float:fRandomAngles[ 3 ];
    	for(new i = 0; i < 3; i++)
    		fRandomAngles[ i ] = random_float( 100.0, 150.0 );
    		
    	entity_set_vector(id, EV_VEC_punchangle, fRandomAngles );
    	user_slap( id, random_num( 1, 5 ) );
    	
    	return 0;
    }


    ColorChat(  id, Color:iType, const msg[  ], { Float, Sql, Result, _}:...  )
    {
    	
    	// Daca nu se afla nici un jucator pe server oprim TOT. Altfel dam de erori..
    	if( !get_playersnum( ) ) return;
    	
    	new szMessage[ 256 ];

    	switch( iType )
    	{
    		 // Culoarea care o are jucatorul setata in cvar-ul scr_concolor.
    		case NORMAL:	szMessage[ 0 ] = 0x01;
    		
    		// Culoare Verde.
    		case GREEN:	szMessage[ 0 ] = 0x04;
    		
    		// Alb, Rosu, Albastru.
    		default: 	szMessage[ 0 ] = 0x03;
    	}

    	vformat(  szMessage[ 1 ], 251, msg, 4  );

    	// Ne asiguram ca mesajul nu este mai lung de 192 de caractere.Altfel pica server-ul.
    	szMessage[ 192 ] = '^0';
    	

    	new iTeam, iColorChange, iPlayerIndex, MSG_Type;
    	
    	if( id )
    	{
    		MSG_Type  =  MSG_ONE_UNRELIABLE;
    		iPlayerIndex  =  id;
    	}
    	else
    	{
    		iPlayerIndex  =  CC_FindPlayer(  );
    		MSG_Type = MSG_ALL;
    	}
    	
    	iTeam  =  get_user_team( iPlayerIndex );
    	iColorChange  =  CC_ColorSelection(  iPlayerIndex,  MSG_Type, iType);

    	CC_ShowColorMessage(  iPlayerIndex, MSG_Type, szMessage  );
    		
    	if(  iColorChange  )	CC_Team_Info(  iPlayerIndex, MSG_Type,  TeamName[ iTeam ]  );

    }

    CC_ShowColorMessage(  id, const iType, const szMessage[  ]  )
    {
    	
    	static bool:bSayTextUsed;
    	static iMsgSayText;
    	
    	if(  !bSayTextUsed  )
    	{
    		iMsgSayText  =  get_user_msgid( "SayText" );
    		bSayTextUsed  =  true;
    	}
    	
    	message_begin( iType, iMsgSayText, _, id  );
    	write_byte(  id  );	
    	write_string(  szMessage  );
    	message_end(  );
    }

    CC_Team_Info( id, const iType, const szTeam[  ] )
    {
    	static bool:bTeamInfoUsed;
    	static iMsgTeamInfo;
    	if(  !bTeamInfoUsed  )
    	{
    		iMsgTeamInfo  =  get_user_msgid( "TeamInfo" );
    		bTeamInfoUsed  =  true;
    	}
    	
    	message_begin( iType, iMsgTeamInfo, _, id  );
    	write_byte(  id  );
    	write_string(  szTeam  );
    	message_end(  );

    	return 1;
    }

    CC_ColorSelection(  id, const iType, Color:iColorType)
    {
    	switch(  iColorType  )
    	{
    		
    		case RED:	return CC_Team_Info(  id, iType, TeamName[ 1 ]  );
    		case BLUE:	return CC_Team_Info(  id, iType, TeamName[ 2 ]  );
    		case GREY:	return CC_Team_Info(  id, iType, TeamName[ 0 ]  );

    	}

    	return 0;
    }

    CC_FindPlayer(  )
    {
    	new iMaxPlayers  =  get_maxplayers(  );
    	
    	for( new i = 1; i <= iMaxPlayers; i++ )
    		if(  is_user_connected( i )  )
    			return i;
    	
    	return -1;
    }