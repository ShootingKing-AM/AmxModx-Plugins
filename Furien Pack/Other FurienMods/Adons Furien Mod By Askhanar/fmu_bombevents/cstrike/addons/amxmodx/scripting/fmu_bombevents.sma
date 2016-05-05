#include <amxmodx>
#include <csx>

#pragma semicolon 1


#define PLUGIN "FMU Bomb Events"
#define VERSION "1.0"

#define C4_TASK		112233

new const g_szBombPlantedSounds[ ][ ] =
{
	"fmu_bombplanted.mp3",
	"fmu_bombplanted2.mp3"
};

new const g_iRed[ ] =
{
	0,
	125,
	255
};

new const g_iGreen[ ] =
{
	255,
	125,
	10
};

new const g_iBlue[ ] =
{
	255,
	0,
	0
};

new gCvarOn;
new gCvarSound;
new gCvarDropped;
new gCvarPicked;

new g_C4Timer, g_iColor = 0, g_iSound = 0;
new g_pMpC4Timer;
new g_TextMsg;

new gSyncHudMessage;

public plugin_init( )
{
	register_plugin( PLUGIN, VERSION, "Askhanar" );
	
	gCvarOn = register_cvar( "fmu_be_on", "1" );
	gCvarSound = register_cvar( "fmu_be_sound", "1" );
	gCvarDropped = register_cvar( "fmu_be_dropped", "1" );
	gCvarPicked = register_cvar( "fmu_be_picked", "1" );
	
	
	register_event( "ResetHUD", "ev_ResetHUD", "be" );
	register_event( "SendAudio", "TeamWonOrRoundDraw", "a", "2&%!MRAD_terwin", "2&%!MRAD_ctwin", "2&%!MRAD_rounddraw" );
	
	register_logevent( "le_RoundStart", 2, "1=Round_Start");
	register_logevent( "le_RoundEnd", 2, "1=Round_End");
	register_logevent( "le_RoundEnd", 2, "1&Restart_Round_");
	
	
	g_pMpC4Timer = get_cvar_pointer( "mp_c4timer" );
	
	g_TextMsg = get_user_msgid( "TextMsg" );
	register_message( g_TextMsg, "Hook_TextMessages" );

	gSyncHudMessage = CreateHudSyncObj(  );
}

public bomb_planted( ) 
{
	if( get_pcvar_num( gCvarOn ) == 0 )
		return;
		
	if( get_pcvar_num( gCvarSound ) > 0 )
	{
		client_cmd( 0, "stopsound" );
		client_cmd( 0, "mp3 play ^"sound/fmu_sounds/%s^"", g_szBombPlantedSounds[ g_iSound ] );
		
		g_iSound++;
		if( g_iSound >= 2 )	g_iSound = 0;
	}
	
	g_C4Timer = get_pcvar_num( g_pMpC4Timer ) - 1;
	
	set_task(1.0, "ShowTimeUntilExplosion", C4_TASK, "", 0, "b" );
}

public ShowTimeUntilExplosion(  )
{
	if( g_C4Timer > 0 )
	{
		if ( g_C4Timer > 20 )
			g_iColor = 0;
		else if ( g_C4Timer > 10 )
			g_iColor = 1;
		else if ( g_C4Timer <= 10 )
			g_iColor = 2;
			
		set_hudmessage( g_iRed[ g_iColor ], g_iGreen[ g_iColor ], g_iBlue[ g_iColor ], -1.0, 0.83, 0, 1.0, 1.0, 0.01, 0.01, -1 );
		ShowSyncHudMsg( 0, gSyncHudMessage, "Bomba explodeaza in: %i secund%s!", g_C4Timer, g_C4Timer == 1 ? "a" : "e" );
		g_C4Timer--;
	}

	else 
		remove_task( C4_TASK );
		
}

public Hook_TextMessages( iMsgId, iMsgDest, id )
{
	if( get_pcvar_num( gCvarOn ) == 0 )
		return PLUGIN_CONTINUE;
    
	static szMsg[ 64 ];
	get_msg_arg_string( 2, szMsg, sizeof ( szMsg ) - 1 );
	
	new iDropped = get_pcvar_num( gCvarDropped );
	if( iDropped && equal( szMsg, "#Game_bomb_drop" ) )
	{
		set_hudmessage( 255, 0, 0, -1.0, 0.16, 0, 0.0, 3.5, 0.1, 0.1, -1 );
		ShowSyncHudMsg( 0, gSyncHudMessage, "Furienii au pierdut bomba !" );
		return PLUGIN_HANDLED;
	}
	
	new iPicked = get_pcvar_num( gCvarPicked );
	if( iPicked  && equal( szMsg, "#Game_bomb_pickup" ) || iPicked  && equal( szMsg, "#Got_bomb" ) )
	{
		set_hudmessage( 255, 0, 0, -1.0, 0.16, 0, 0.0, 3.5, 0.1, 0.1, -1 );
		ShowSyncHudMsg( 0, gSyncHudMessage, "Furienii au recuperat bomba!" );
		return PLUGIN_HANDLED;
	}
		
	return PLUGIN_CONTINUE;
}

public ev_ResetHUD( )
{
	g_C4Timer = 0;
}

public TeamWonOrRoundDraw( )
{
	RemoveTimerTask( );
}

public le_RoundStart( )
{
	RemoveTimerTask( );
}

public le_RoundEnd()
{
	RemoveTimerTask( );
}

public plugin_end()
{
	RemoveTimerTask( );
}

public RemoveTimerTask( )
{
	if( get_pcvar_num( gCvarOn ) == 0 )
		return;
		
	g_C4Timer = -1;
	remove_task( C4_TASK );
}

public plugin_precache() 
{
	new szSound[ 64 ];
	for( new i = 0; i < 2; i++ )
	{
		formatex( szSound, sizeof ( szSound ) -1, "sound/fmu_sounds/%s", g_szBombPlantedSounds[ i ] );
		precache_generic( szSound );
	}
	
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang3081\\ f0\\ fs16 \n\\ par }
*/
