#include < amxmodx >
#include < fakemeta >
#include < hamsandwich >
#include <cstrike>
#include <fun>

#pragma semicolon 1

#define PLUGIN "Furien Anti-Camp"
#define VERSION "1.0"

#define TASK_SPAWN	06081993

enum Color
{
	NORMAL = 1,
	GREEN, 	
	TEAM_COLOR, 
	GREY, 
	RED, 	
	BLUE,
};

new TeamName[  ][  ] = 
{
	"",
	"TERRORIST",
	"CT",
	"SPECTATOR"
};

new const g_szTag[ ] = "[Furien Anti-Camp]";
new const g_szClassName[ ] = "AntiCampEntity";

new Float:g_fUserOrigin[ 33 ][ 3 ];
new Float:g_fUserOldOrigin[ 33 ][ 3 ];

new bool:g_bSpawnCheckEnabled = false;

new bool:g_bAlive[ 33 ];
new bool:g_bConnected[ 33 ];
new bool:g_bUserIsCamping[ 33 ];

new g_iUserCampSeconds[ 33 ];
new g_iMagicEntity;

public plugin_init( )
{
	register_plugin( PLUGIN, VERSION, "Shooting King & Askhanar" );
	
	register_event( "HLTV", "ev_HookRoundStart", "a", "1=0", "2=0" );
	
	RegisterHam( Ham_Spawn, "player", "Ham_PlayerSpawnPost", true );
	RegisterHam( Ham_Killed, "player", "Ham_PlayerKilledPost", true );
		
	new iEnt;
	CreateMagicEntity:
	
	iEnt = engfunc( EngFunc_CreateNamedEntity, engfunc( EngFunc_AllocString, "info_target" ) );
	if( !iEnt || !pev_valid( iEnt ) )
		goto CreateMagicEntity;
	
	set_pev( iEnt, pev_classname, g_szClassName );
	set_pev( iEnt, pev_nextthink, get_gametime(  ) + 0.3 );
	register_forward( FM_Think, "FM_MagicEntityThink" );
	
	g_iMagicEntity = iEnt;	
}

public client_putinserver( id )
{
	if( is_user_bot(id) && (id>0) && (id<33) )
		return PLUGIN_CONTINUE;
	
	g_bConnected[ id ] = true;
	g_bAlive[ id ] = false;
	g_bUserIsCamping[ id ] = false;
	set_user_rendering(id,kRenderFxNone,0,0,0,kRenderTransAlpha,255);

	return PLUGIN_CONTINUE;
}

public client_disconnect( id )
{
	if( is_user_bot(id) && (id>0) && (id<33) )
		return PLUGIN_CONTINUE;
		
	g_bConnected[ id ] = false;
	g_bAlive[ id ] = false;
	g_bUserIsCamping[ id ] = false;
	set_user_rendering(id,kRenderFxNone,0,0,0,kRenderTransAlpha,255);
	
	return PLUGIN_CONTINUE;
}

public Ham_PlayerSpawnPost( id )
{
	if( !is_user_alive(id) && (id>0) && (id<33) )
		return HAM_IGNORED;
	
	g_bAlive[ id ] = true;
	g_bUserIsCamping[ id ] = false;
	g_iUserCampSeconds[ id ] = 0;
	set_user_rendering(id,kRenderFxNone,0,0,0,kRenderTransAlpha,255);
	return HAM_IGNORED;
}

public Ham_PlayerKilledPost( id )
{
	g_bAlive[ id ] = false;
}

public ev_HookRoundStart( )
{
	remove_task( TASK_SPAWN );
	
	g_bSpawnCheckEnabled = true;
	set_task( 25.0, "TaskDisableSpawnCheck", TASK_SPAWN );
}

public TaskDisableSpawnCheck( )
{
	g_bSpawnCheckEnabled = false;
}

public FM_MagicEntityThink( iEnt )
{	
	if( iEnt != g_iMagicEntity || !pev_valid( iEnt ) )
		return FMRES_IGNORED;
		
	set_pev( iEnt, pev_nextthink, get_gametime(  ) + 1.0 );
	
	static iPlayers[ 32 ];
	static iPlayersNum;
	
	get_players( iPlayers, iPlayersNum, "ach" );
	if( !iPlayersNum )
		return FMRES_IGNORED;
		
	static id, i;
	for( i = 0; i < iPlayersNum; i++ )
	{
		id = iPlayers[ i ];
		
		if(g_bConnected[ id ] && g_bAlive[ id ] && id>0 && id<33 )
		{
			pev( id, pev_origin, g_fUserOrigin[ id ] );
	
			if( g_fUserOrigin[ id ][ 0 ] == g_fUserOldOrigin[ id ][ 0 ]
				&& g_fUserOrigin[ id ][ 1 ] == g_fUserOldOrigin[ id ][ 1 ]
				&& g_fUserOrigin[ id ][ 2 ] == g_fUserOldOrigin[ id ][ 2 ] )
			{
				if( get_user_team(id) == _:CS_TEAM_T )
				{
					set_user_rendering(id, kRenderFxNone, 0, 0, 0, kRenderTransAlpha, 0);
				}
				else if( get_user_team(id) == _:CS_TEAM_CT )
				{
					g_iUserCampSeconds[ id ]++;

					if( g_iUserCampSeconds[ id ] == 15 )
					{
						g_bUserIsCamping[ id ] = true;
						FadeScreen( id );
					}					
					else if( g_iUserCampSeconds[ id ] > 15 && g_bSpawnCheckEnabled )
					{
						if( g_iUserCampSeconds[ id ] == 16 )
						{
							new szName[ 32 ];
							get_user_name( id, szName, sizeof ( szName ) -1 );
							ColorChat( 0, RED, "^x04%s^x03 %s^x01 recieved a Slay for Camping !", g_szTag, szName );
							
							user_silentkill( id );
							
							g_bUserIsCamping[ id ] = false;
							g_iUserCampSeconds[ id ] = 0;
							
							ResetScreen( id );							
						}
						else
							ColorChat( id, RED, "^x04%s^x01 You will be slayed in ^x03%d ^x01second%s if you do not move now!",
								g_szTag, 16 - g_iUserCampSeconds[ id ], ( 16 - g_iUserCampSeconds[ id ]  ) == 1 ? "" : "s" );
					}
				}
			}	
			else
			{
				if( get_user_team(id) == _:CS_TEAM_T )
				{
					set_user_rendering(id, kRenderFxNone, 0, 0, 0, kRenderTransAlpha, 255);
				}
				else if( get_user_team(id) == _:CS_TEAM_CT )
				{
					if( g_bUserIsCamping[ id ] )
					{
						ResetScreen( id );
					}
					g_iUserCampSeconds[ id ] = 0;
					g_bUserIsCamping[ id ] = false;
				}
			}
		}
		g_fUserOldOrigin[ id ][ 0 ] = g_fUserOrigin[ id ][ 0 ];
		g_fUserOldOrigin[ id ][ 1 ] = g_fUserOrigin[ id][ 1 ];
		g_fUserOldOrigin[ id ][ 2 ] = g_fUserOrigin[ id ][ 2 ];
	}

	return FMRES_IGNORED;
}


FadeScreen( id )
{      
	message_begin(MSG_ONE, get_user_msgid( "ScreenFade" ), _, id );
	write_short(1<<0); // fade lasts this long duration 
	write_short(1<<0); // fade lasts this long hold time 
	write_short(1<<2); // fade type HOLD 
	write_byte(0); // fade red 
	write_byte(0); // fade green 
	write_byte(0); // fade blue  
	write_byte(255); // fade alpha  
	message_end();
}

ResetScreen( id )
{	
	message_begin(MSG_ONE, get_user_msgid( "ScreenFade" ), _, id );
	write_short(1<<12); // fade lasts this long duration  
	write_short(1<<8); // fade lasts this long hold time  
	write_short(1<<1); // fade type OUT 
	write_byte(0); // fade red  
	write_byte(0); // fade green  
	write_byte(0); // fade blue    
	write_byte(255); // fade alpha    
	message_end();
}


// --| ColorChat.
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
// --| ColorChat.