#include < amxmodx >
#include < CC_ColorChat >

#pragma semicolon 1


#define PLUGIN "Slot Reservations"
#define VERSION "1.0"


new g_iMaxPlayers;
public plugin_init( )
{
	
	register_plugin( PLUGIN, VERSION, "Askhanar" );
	register_cvar( "amx_sr_type", "4" );
		
	register_clcmd( "please_kickme", "ClCmdPleaseKickMe" );
		
	g_iMaxPlayers = get_maxplayers( );
		
	
}

public ClCmdPleaseKickMe( id )
{
	server_cmd( "kick #%i ^"Ai primit kick pentru ca acest slot este rezervat!^"", get_user_userid( id ) );
	
}

public client_authorized( id )
{

	new iRSType = get_cvar_num( "amx_rs_type" );
	if( !iRSType )
		return 0;
		
	new iPlayers = get_playersnum( 1 );
	new iPlayersLimit = g_iMaxPlayers - 1;
	
	if( iPlayers > iPlayersLimit )
	{
		
		if( get_user_flags( id ) & ADMIN_RESERVATION )
		{
			
			switch( iRSType )
			{
				case 1:	KickPlayerWithShortestTime( );
				case 2:	KickPlayerWithLongestTime( );
				case 3:	KickPlayerWithBiggestLag( );
				case 4:	KickPlayerWithLowestFrags( );
			}
			
		}
		else
			client_cmd( id, "please_kickme" );
			
	}
	
	return 0;
}


KickPlayerWithShortestTime( )
{
	
	new iWho, iTime, iShortest = 0x7fffffff;
	
	for(new id = 1; id <= g_iMaxPlayers; ++id )
	{
		if( !is_user_connected( id ) && !is_user_connecting( id ) )
			continue;
		if( get_user_flags( id ) & ADMIN_RESERVATION )
			continue;
		iTime = get_user_time( id );
		if( iShortest > iTime )
		{
			iShortest = iTime;
			iWho = id;
		}
	}
	if( iWho )
	{
		new szName[ 32 ];
		get_user_name( iWho, szName, sizeof ( szName ) -1 );
		ColorChat( 0, RED, "^x04[Reservation]^x03 %s^x01 a primit kick pentru a-i face loc unui^x03 Slot^x01 !", szName );
		server_cmd( "kick #%i ^"Ai primit kick pentru a-i face loc unui Slot^"", get_user_userid( iWho ) );
	}
	
}

KickPlayerWithLongestTime( )
{
	
	new iWho, iTime, iLongest = -1;
	
	for(new id = 1; id <= g_iMaxPlayers; ++id )
	{
		if( !is_user_connected( id ) && !is_user_connecting( id ) )
			continue;
		if( get_user_flags( id ) & ADMIN_RESERVATION )
			continue;
		iTime = get_user_time( id );
		if( iLongest < iTime )
		{
			iLongest = iTime;
			iWho = id;
		}
	}
	if( iWho )
	{
		new szName[ 32 ];
		get_user_name( iWho, szName, sizeof ( szName ) -1 );
		ColorChat( 0, RED, "^x04[Reservation]^x03 %s^x01 a primit kick pentru a-i face loc unui^x03 Slot^x01 !", szName );
		server_cmd( "kick #%i ^"Ai primit kick pentru a-i face loc unui Slot^"", get_user_userid( iWho ) );
	}
	
}	

KickPlayerWithBiggestLag( )
{ 
	new iWho = 0, iPing, iLoss, iWorst = -1;
	for(new id = 1; id <= g_iMaxPlayers; ++id )
	{
		if( !is_user_connected( id ) && !is_user_connecting( id ) )
			continue;
		if( get_user_flags( id ) & ADMIN_RESERVATION )
			continue;
		get_user_ping( id , iPing, iLoss );
		if( iPing > iWorst )
		{
			iWorst = iPing;
			iWho = id;
		}
	}
	if( iWho )
	{
		new szName[ 32 ];
		get_user_name( iWho, szName, sizeof ( szName ) -1 );
		ColorChat( 0, RED, "^x04[Reservation]^x03 %s^x01 a primit kick pentru a-i face loc unui^x03 Slot^x01 !", szName );
		server_cmd( "kick #%i ^"Ai primit kick pentru a-i face loc unui Slot^"", get_user_userid( iWho ) );
	}
}

KickPlayerWithLowestFrags( )
{
	new iWho =0;
	
	for(new id = 1; id <= g_iMaxPlayers; ++id )
	{
		if( !is_user_connected( id ) && !is_user_connecting( id ) )
			continue;
		if( get_user_flags( id ) & ADMIN_RESERVATION )
			continue;
		new iFrags = get_user_frags( id );  
		new iDeaths = get_user_deaths( id );
		if( iFrags < iDeaths )
		{
			iWho = id;
		}
	}
	if( iWho )
	{
		new szName[ 32 ];
		get_user_name( iWho, szName, sizeof ( szName ) -1 );
		ColorChat( 0, RED, "^x04[Reservation]^x03 %s^x01 a primit kick pentru a-i face loc unui^x03 Slot^x01 !", szName );
		server_cmd( "kick #%i ^"Ai primit kick pentru a-i face loc unui Slot^"", get_user_userid( iWho ) );
	}
}