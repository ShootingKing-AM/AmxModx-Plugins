#include < amxmodx >
#include < amxmisc >

#include < fakemeta >
#include < hamsandwich >

#include <CC_ColorChat  >

#define PLUGIN "Fps Shower"
#define VERSION "0.1.5"

#pragma semicolon 1

new Float:GameTime[ 33 ]; 
new Float:BlockFps[ 33 ];

new FramesPer[ 33 ];
new CurFps[ 33 ];
new Fps[ 33 ];

new bool:IsUserAlive[ 33 ];
new bool:IsUserConnected[ 33 ];

new cvar_tag;

/*======================================= - | Askhanar | - =======================================*/

public plugin_init( ) 
{
	
	register_plugin( PLUGIN, VERSION, "Askhanar" );
	
	register_clcmd( "say", "hookSay" );
	register_clcmd( "say /allfps","sayAllFps" );
	register_concmd( "amx_fps", "sayFps" );
	
	cvar_tag = register_cvar( "fs_tag", "[Fps Shower]" );
	
	RegisterHam( Ham_Spawn, "player", "hamPlayerSpawn", 1 );
	RegisterHam( Ham_Killed, "player", "hamPlayerKilled", 1 );
	register_forward( FM_PlayerPreThink, "fwdPlayerPreThink" );
		
}

/*======================================= - | Askhanar | - =======================================*/

public client_connect( id ) 
{
	if( is_user_bot( id ) || is_user_hltv( id ) ) return 0;
	
	IsUserAlive[ id ] = false;
	IsUserConnected[  id ] = true;
	
	return 0;
	
}

/*======================================= - | Askhanar | - =======================================*/

public client_disconnect( id ) 
{
	if( is_user_bot( id ) || is_user_hltv( id ) ) return 0;
	
	IsUserAlive[ id ] = false;
	IsUserConnected[ id ] = false;
	
	return 0;
	
}
	

/*======================================= - | Askhanar | - =======================================*/

public sayFps( id )  
{
	
	if( ( get_gametime( ) - BlockFps[ id ] < 10.0 ) ) 
	{
		ColorChat( id, RED, "^x04%s^x01 Comanda blocata pentru^x03 %.1f ^x01 secunde!", get_tag( ), 10.0 - ( get_gametime( ) - BlockFps[ id ] ) );
		client_cmd( id, "echo %s Comanda blocata pentru 10 secunde!" );
		return 1;
	}
	
	new target[ 32 ];
    	read_argv( 1, target, sizeof ( target ) -1 );

	if( equali( target, "" ) ) 
	{
		
		if( !IsUserAlive[ id ] ) 
		{
			
			ColorChat( id, RED, "^x04%s^x01 Trebuie sa fii in viata !", get_tag( ) );
			client_cmd( id, "echo %s Trebuie sa fii in viata !" );
			return 1;
			
		}
		
		BlockFps[ id ] = get_gametime( );
		ColorChat( id,RED, "^x04%s^x03 %s^x01 are^x03 %d^x01 fps !", get_tag( ), get_name( id ), CurFps[ id ] );
		client_cmd( id, "echo %s %s are %d fps !", get_tag( ), get_name( id ), CurFps[ id ]  );
		
		return 1;
	}
	
    	new player = cmd_target( id, target, 8 );
    	if(!player || player == id ) return 1;

	BlockFps[ id ] = get_gametime( );
	ColorChat( id,RED, "^x04%s^x03 %s^x01 are^x03 %d^x01 fps !", get_tag( ), get_name( player ), CurFps[ player ] );
	client_cmd( id, "echo %s %s are %d fps !", get_tag( ), get_name( player ), CurFps[ player ] );
		
	return 1;
}

/*======================================= - | Askhanar | - =======================================*/

public hookSay( id ) 
{
	
	static args[ 192 ], command[ 192 ];
	read_args( args, sizeof ( args ) -1 );
	
	if( !args[ 0 ]) return 0;	
	remove_quotes( args[ 0 ] );
	
	if( equal( args, "/fps", strlen("/fps") ) )
	{
		
		replace( args, sizeof ( args ) -1, "/", "" );
		formatex( command, sizeof ( command ) -1 , "amx_%s", args );
		
		client_cmd( id, command );
		return 1;
	}
	

	return 0;
}
	
/*======================================= - | Askhanar | - =======================================*/

public hamPlayerSpawn( id )
{
	if( !is_user_alive( id ) ) return HAM_IGNORED;

	IsUserAlive[ id ] = true;
	
	return HAM_IGNORED;
}

/*======================================= - | Askhanar | - =======================================*/

public hamPlayerKilled( id )
{
	
	IsUserAlive[ id ] = false;
	
	return HAM_IGNORED;
}

/*======================================= - | Askhanar | - =======================================*/

public fwdPlayerPreThink( id ) 
{
	
	if( IsUserConnected[ id ] )
	{

		GameTime[ id ] = get_gametime( );
				
		if( FramesPer[ id ] >= GameTime[ id ] )
			Fps[ id ] += 1;
		
		else 
		{
			FramesPer[ id ]	+= 1;
			CurFps[ id ]	= Fps[ id ];
			Fps[ id ]	= 0;
		}
			
	}
	
	return FMRES_IGNORED;
}
/*======================================= - | Askhanar | - =======================================*/

public sayAllFps( id )
{	
	
	static buffer[ 2368 ], len;
	
	len = format( buffer[ len ], 2367 - len,"<STYLE>body{background-color:#000000; font-family:Tahoma; font-size:12px; color:#FFFFFF;}table{border-style:solid; border-width:1px; border-color:#FFFFFF; font-family:Tahoma; font-size:10px; color:#FFFFFF; }</STYLE><table align=center width=28%% cellpadding=1 cellspacing=0" );
	len += format( buffer[ len ], 2367 - len, "<tr align=center bgcolor=#292929><th width=5%% > # <th width=15%%> Nume <th width=8%%>Fps" );
	
	static Players[ 32 ], Num, Player;
	get_players( Players, Num, "ch" );
	
	for( new x = 0; x < Num ; x++ ) 
	{   
		
		Player = Players[ x ];
		
		new Pname[ 32 ];
		get_user_name( Player, Pname, sizeof ( Pname ) -1 );
		
		if( containi( Pname, "<" ) != -1 )
		{
			replace( Pname, 129, "<", "&lt;" );
		}
		if( containi( Pname, ">" ) != -1 )
		{
			replace( Pname, 129, ">", "&gt;" );
		}
		
		if( Player == id ) {
			
			len += format( buffer[ len ], 2367 - len, "<tr align=center bgcolor=#2D2D2D><td> %d <td> %s <td> %d", ( x + 1 ), Pname, CurFps[ Player ] );
	
		}
		else {
			
			len += format( buffer[ len ], 2367 - len, "<tr align=center bgcolor=#000000><td> %d <td> %s <td> %d", ( x + 1 ), Pname, CurFps[ Player ] );
			
		}
	}
	len += format( buffer[ len ], 2367 - len, "</table>" );
	
	static strin[ 20 ];
	format( strin, sizeof ( strin ) -1 , "Fps-ul jucatorilor" );
	
	show_motd( id, buffer, strin );
	return 1;
}

/*======================================= - | Askhanar | - =======================================*/

stock get_name( id ) 
{
	
	new name[ 32 ];
	get_user_name( id, name,sizeof ( name ) -1 );
   
	return name;
}

/*======================================= - | Askhanar | - =======================================*/

stock get_tag( )
{
	new tag[ 32 ];
	get_pcvar_string( cvar_tag, tag, sizeof ( tag ) -1 );

	return tag;
}