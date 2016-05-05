#include < amxmodx >
#include < engine >
#include < fakemeta >
#include < CC_ColorChat >

#pragma semicolon 1

#define PLUGIN "Advanced Hud Info"
#define VERSION "1.0"


#define FL_OWNKEYS   	( 1 << 0 )
#define FL_OWNSPEED    	( 1 << 1 )
#define FL_OWNFPS 	( 1 << 2 )
#define FL_SPECKEYS   	( 1 << 3 )
#define FL_SPECSPEED    ( 1 << 4 )
#define FL_SPECFPS 	( 1 << 5 )

new const g_szTag[  ] = "[Advanced Hud Info]";

new Float:GameTime[ 33 ]; 
new FramesPer[ 33 ];
new CurFps[ 33 ];
new Fps[ 33 ];

new gCvarChangeSetting;
new gCvarConnectFlags;

new g_iUserKeys[ 33 ];
new g_iUserFlags[ 33 ];
new g_szSpeed[ 33 ][ 32 ];

new SyncHudMessage;

public plugin_init( )
{
	register_plugin( PLUGIN, VERSION, "Askhanar" );
	
	gCvarChangeSetting = register_cvar( "ahi_change_settings", "1" );
	gCvarConnectFlags = register_cvar( "ahi_connect_flags", "abcdef" );
	
	register_clcmd( "say /hudinfo", "ClCmdSayHudInfo" );
	register_clcmd( "say /hinfo", "ClCmdSayHudInfo" );
	register_clcmd( "say_team /hudinfo", "ClCmdSayHudInfo" );
	register_clcmd( "say_team /hinfo", "ClCmdSayHudInfo" );
	
	register_forward( FM_PlayerPreThink, "fwdPlayerPreThink" );
	register_think(  "MagicEntity",  "MagicEntityThink"  );
	
	CreateEntity:
	new iEnt;
	iEnt  =  create_entity(  "info_target"  );
	entity_set_string(  iEnt,  EV_SZ_classname,  "MagicEntity"  );
	entity_set_float(  iEnt,  EV_FL_nextthink,  get_gametime(    )  +  0.1  );
	if( !iEnt )	goto CreateEntity;
		
	SyncHudMessage = CreateHudSyncObj(  );
}

public client_connect( id )
{
	static szFlags[ 30 ];
	get_pcvar_string(  gCvarConnectFlags, szFlags,  30  );
	format( szFlags, 30, "_%s", szFlags );
	
	if( contain( szFlags, "a" ) > 0 )
		ahi_set_user_flag( id, FL_OWNKEYS, true );
	else
		ahi_set_user_flag( id, FL_OWNKEYS, false );
	if( contain( szFlags, "b" ) > 0 )
		ahi_set_user_flag( id, FL_OWNSPEED, true );
	else
		ahi_set_user_flag( id, FL_OWNSPEED, false );
	if( contain( szFlags, "c" ) > 0 )
		ahi_set_user_flag( id, FL_OWNFPS, true );
	else
		ahi_set_user_flag( id, FL_OWNFPS, false );
	if( contain( szFlags, "d" ) > 0 )
		ahi_set_user_flag( id, FL_SPECKEYS, true );
	else
		ahi_set_user_flag( id, FL_SPECKEYS, false );
	if( contain( szFlags, "e" ) > 0 )
		ahi_set_user_flag( id, FL_SPECSPEED, true );
	else
		ahi_set_user_flag( id, FL_SPECSPEED, false );
	if( contain( szFlags, "f" ) > 0 )
		ahi_set_user_flag( id, FL_SPECFPS, true );
	else
		ahi_set_user_flag( id, FL_SPECFPS, false );
		
}

public client_disconnect( id )
{
	
	ahi_set_user_flag( id, FL_OWNKEYS, false );
	ahi_set_user_flag( id, FL_OWNSPEED, false );
	ahi_set_user_flag( id, FL_OWNFPS, false );
	ahi_set_user_flag( id, FL_SPECKEYS, false );
	ahi_set_user_flag( id, FL_SPECSPEED, false );
	ahi_set_user_flag( id, FL_SPECFPS, false );
}
	
public fwdPlayerPreThink( id )
{
	if( is_user_alive( id ) )
	{
		GameTime[ id ] = get_gametime(  );
					
		if( FramesPer[ id ] >= GameTime[ id ] )
			Fps[ id ] += 1;
		
		else 
		{
			FramesPer[ id ]	+= 1;
			CurFps[ id ]	= Fps[ id ];
			Fps[ id ]	= 0;
		}
		
		new Float:fSpeed[ 3 ];
		pev( id, pev_velocity, fSpeed );
		
		// I forgot where i found the next line.. but its not mine.
		float_to_str( floatsqroot( floatadd( floatpower( fSpeed[ 0 ], 2.0 ), floatpower( fSpeed[ 1 ], 2.0 ) ) ), g_szSpeed[ id ], 5 );
		
		if( get_user_button( id ) & IN_FORWARD )
			g_iUserKeys[ id ] |= IN_FORWARD;
			
		if( get_user_button( id ) & IN_BACK )
			g_iUserKeys[ id ] |= IN_BACK;
			
		if( get_user_button( id ) & IN_MOVELEFT )
			g_iUserKeys[ id ] |= IN_MOVELEFT;
			
		if( get_user_button( id ) & IN_MOVERIGHT )
			g_iUserKeys[ id ] |= IN_MOVERIGHT;
			
		if( get_user_button( id ) & IN_DUCK )
			g_iUserKeys[ id ] |= IN_DUCK;
			
		if( get_user_button( id ) & IN_JUMP )
			g_iUserKeys[ id ] |= IN_JUMP;
		
	}
}

public MagicEntityThink( iEnt )
{
	entity_set_float(  iEnt,  EV_FL_nextthink,  get_gametime(    )  +  0.1  );
	
	new iPlayers[ 32 ];
	new iPlayersNum;
	
	new iUserFlags;
	new szHudInfo[ 128 ];
	new id;
	
	get_players( iPlayers, iPlayersNum, "ch" );
	
	for( new i = 0 ; i < iPlayersNum ; i++ )
	{
		id = iPlayers[ i ];
		iUserFlags = g_iUserFlags[ id ];
		
		if( is_user_alive( id ) )
		{
			if( iUserFlags & FL_OWNKEYS  )
				formatex( szHudInfo, sizeof ( szHudInfo ) -1, "%s^n^n%s    %s    %s^n%s^n%s",
					g_iUserKeys[ id ] & IN_FORWARD ? " W " : "   ",
					g_iUserKeys[ id ] & IN_MOVELEFT ? "A    " : "      ",
					g_iUserKeys[ id ] & IN_BACK ? " S " : "    ",
					g_iUserKeys[ id ] & IN_MOVERIGHT ? "    D" : "      ",
					g_iUserKeys[ id ] & IN_JUMP ? " JUMP " : "      ",
					g_iUserKeys[ id ] & IN_DUCK ? " DUCK " : "      " );
				
			if( iUserFlags & FL_OWNSPEED  )
			{
				add( szHudInfo, sizeof ( szHudInfo ) -1, "^n^n  Speed: ");
				add( szHudInfo, sizeof ( szHudInfo ) -1, g_szSpeed[ id ] );
			}
				
			if( iUserFlags & FL_OWNFPS  )
			{
				if( !( iUserFlags & FL_OWNSPEED )  )
					add( szHudInfo, sizeof ( szHudInfo ) -1, "^n^n  FPS: " );
				else
					add( szHudInfo, sizeof ( szHudInfo ) -1, "^n  FPS: " );
				static szFps[ 32 ]; formatex( szFps, sizeof ( szFps ) -1, "%i", CurFps[ id ] );
				add( szHudInfo, sizeof ( szHudInfo ) -1, szFps );
			}
				
			ahi_hud_center( id, szHudInfo );
		}
		
		else if( !is_user_alive( id ) )
		{

			new id2 = pev( id, pev_iuser2 );
			if( !id2 )
				return;
			
			if( iUserFlags & FL_SPECKEYS  )
				formatex( szHudInfo, sizeof ( szHudInfo ) -1, "%s^n^n%s    %s    %s^n%s^n%s",
					g_iUserKeys[ id2 ] & IN_FORWARD ? " W " : "   ",
					g_iUserKeys[ id2 ] & IN_MOVELEFT ? "A    " : "      ",
					g_iUserKeys[ id2 ] & IN_BACK ? " S " : "    ",
					g_iUserKeys[ id2 ] & IN_MOVERIGHT ? "    D" : "      ",
					g_iUserKeys[ id2 ] & IN_JUMP ? " JUMP " : "      ",
					g_iUserKeys[ id2 ] & IN_DUCK ? " DUCK " : "      " );
				
			if( iUserFlags & FL_SPECSPEED  )
			{
				add( szHudInfo, sizeof ( szHudInfo ) -1, "^n^n  Speed: ");
				add( szHudInfo, sizeof ( szHudInfo ) -1, g_szSpeed[ id2 ] );
			}
				
			if( iUserFlags & FL_SPECFPS  )
			{
				if( !( iUserFlags & FL_SPECSPEED )  )
					add( szHudInfo, sizeof ( szHudInfo ) -1, "^n^n  FPS: " );
				else
					add( szHudInfo, sizeof ( szHudInfo ) -1, "^n  FPS: " );
				static szFps[ 32 ]; formatex( szFps, sizeof ( szFps ) -1, "%i", CurFps[ id2 ] );
				add( szHudInfo, sizeof ( szHudInfo ) -1, szFps );
			}
				
			ahi_hud_center( id, szHudInfo );
		}
		
		ahi_reset_buttons( id );
	}

}

ahi_reset_buttons( id )
{
	if( !( get_user_button( id ) & IN_FORWARD ) )
		g_iUserKeys[ id ] &= ~ IN_FORWARD;
		
	if( !( get_user_button( id ) & IN_BACK) )
		g_iUserKeys[ id ] &= ~ IN_BACK;
		
	if( !( get_user_button( id ) & IN_MOVELEFT ) )
		g_iUserKeys[ id ] &= ~ IN_MOVELEFT;
		
	if( !( get_user_button( id ) & IN_MOVERIGHT ) )
		g_iUserKeys[ id ] &= ~ IN_MOVERIGHT;
		
	if( !( get_user_button( id ) & IN_DUCK ) )
		g_iUserKeys[ id ] &= ~ IN_DUCK;
		
	if( !( get_user_button( id ) & IN_JUMP ) )
		g_iUserKeys[ id ] &= ~ IN_JUMP;
			
}
public ClCmdSayHudInfo( id )
{
	if( get_pcvar_num( gCvarChangeSetting ) != 1 )
	{
		ColorChat( id, RED, "^x04%s^x01 Comanda dezactivata de catre server!", g_szTag );
		return 0;
	}
	
	ShowHudInfoMenu(  id  );
	
	return 0;
}

public ShowHudInfoMenu(  id  )
{
		
	new  menu  =  menu_create(  "\rAdvanced Hud Info", "HudInfoMenuHandler");
	
	new szOwnKeys[ 64 ], szOwnSpeed[ 64 ], szOwnFPS[ 64 ], szSpecKeys[ 64 ], szSpecSpeed[ 64 ], szSpecFPS[ 64 ];
	
	formatex(  szOwnKeys,  sizeof ( szOwnKeys ) -1, "\wOwn Keys \r- %s", ahi_get_user_flag( id, FL_OWNKEYS ) ? "\yON" : "\dOFF"  );
	formatex(  szOwnSpeed,  sizeof ( szOwnSpeed ) -1, "\wOwn Speed \r- %s", ahi_get_user_flag( id, FL_OWNSPEED ) ? "\yON" : "\dOFF"  );
	formatex(  szOwnFPS,  sizeof ( szOwnFPS ) -1, "\wOwn Fps \r- %s^n", ahi_get_user_flag( id, FL_OWNFPS ) ? "\yON" : "\dOFF"  );
	formatex(  szSpecKeys,  sizeof ( szSpecKeys ) -1, "\wSpectator Keys \r- %s", ahi_get_user_flag( id, FL_SPECKEYS ) ? "\yON" : "\dOFF"  );
	formatex(  szSpecSpeed,  sizeof ( szSpecSpeed ) -1, "\wSpectator Speed \r- %s", ahi_get_user_flag( id, FL_SPECSPEED ) ? "\yON" : "\dOFF"  );
	formatex(  szSpecFPS,  sizeof ( szSpecFPS ) -1, "\wSpectator Fps \r- %s", ahi_get_user_flag( id, FL_SPECFPS ) ? "\yON" : "\dOFF"  );
	
	menu_additem(  menu,  szOwnKeys,  "1",  0  );
	menu_additem(  menu,  szOwnSpeed,  "2",  0  );
	menu_additem(  menu,  szOwnFPS,  "3",  0  );
	menu_additem(  menu,  szSpecKeys,  "4",  0  );
	menu_additem(  menu,  szSpecSpeed,  "5",  0  );
	menu_additem(  menu,  szSpecFPS,  "6",  0  );
	
	menu_setprop(  menu,  MPROP_EXITNAME, "\wIesire" );
	
	menu_display(  id, menu  );
	
	
}

public HudInfoMenuHandler(  id,  menu,  item)
{
	if(  item  ==  MENU_EXIT  )
	{
		menu_destroy(  menu  );
		return 1;
	}
	
	static _access, info[4], callback;
	menu_item_getinfo(  menu,  item,  _access,  info,  sizeof  (  info  )  -  1,  _,  _,  callback  );
	menu_destroy(  menu  );
	
	new iKey  =  str_to_num(  info  );
	switch(  iKey  )
	{
		case 1:
		{
			ahi_set_user_flag( id, FL_OWNKEYS, ahi_get_user_flag( id, FL_OWNKEYS ) ? false : true );
			ShowHudInfoMenu(  id  );
		}
		
		case 2:
		{
			ahi_set_user_flag( id, FL_OWNSPEED, ahi_get_user_flag( id, FL_OWNSPEED ) ? false : true );
			ShowHudInfoMenu(  id  );
		}

		
		case 3:
		{
			ahi_set_user_flag( id, FL_OWNFPS, ahi_get_user_flag( id, FL_OWNFPS ) ? false : true );
			ShowHudInfoMenu(  id  );
		}
		case 4:
		{
			ahi_set_user_flag( id, FL_SPECKEYS, ahi_get_user_flag( id, FL_SPECKEYS ) ? false : true );
			ShowHudInfoMenu(  id  );
		}
		case 5:
		{
			ahi_set_user_flag( id, FL_SPECSPEED, ahi_get_user_flag( id, FL_SPECSPEED ) ? false : true );
			ShowHudInfoMenu(  id  );
		}
		case 6:
		{
			ahi_set_user_flag( id, FL_SPECFPS, ahi_get_user_flag( id, FL_SPECFPS ) ? false : true );
			ShowHudInfoMenu(  id  );
		}

	}
	
	return 0;
	
}

bool:ahi_get_user_flag( id, const iFlags )
{
	new iUserFlags = g_iUserFlags[ id ];
	
	if( iUserFlags & iFlags )
		return true;
		
	return false;
}

ahi_set_user_flag( id, const iFlags, const bool:bOn )
{
	if( bOn )
		g_iUserFlags[ id ] |= iFlags;
	else
		g_iUserFlags[ id ] ^= iFlags;
}

ahi_hud_center( id, const szMsg[ ], {Float, Sql, Result, _}:... )
{
	static szMessage[ 192 ];
	vformat( szMessage, sizeof ( szMessage ) -1, szMsg, 3 );
	
	set_hudmessage( 0, 63, 127, -1.0, 0.53, 0, 0.0, 0.1, 0.1, 0.1, -1 );
		
	ShowSyncHudMsg( id, SyncHudMessage, szMessage );
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ ansicpg1252\\ deff0{\\ fonttbl{\\ f0\\ froman\\ fcharset0 Times New Roman;}}\n{\\ colortbl ;\\ red0\\ green0\\ blue0;}\n\\ viewkind4\\ uc1\\ pard\\ cf1\\ lang11274\\ f0\\ fs24 \n\\ par }
*/
