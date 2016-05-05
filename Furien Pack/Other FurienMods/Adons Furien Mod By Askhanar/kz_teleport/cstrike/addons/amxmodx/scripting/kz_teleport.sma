#include < amxmodx >
#include < amxmisc >
#include < fakemeta >

#pragma semicolon 1

#define PLUGIN "Kz Teleport"
#define VERSION "1.0"

public plugin_init( )
{
	register_plugin( PLUGIN, VERSION, "Askhanar" );
	
	register_clcmd( "kz_teleport", "ClCmdKzTeleport" );
	register_clcmd( "kz_tp", "ClCmdKzTeleport" );
}

public ClCmdKzTeleport( id )
{
	
	if( !( get_user_flags( id ) & ADMIN_BAN ) )
	{
		client_cmd( id, "echo NU ai acces la aceasta comanda!" );
		return 1;
	}
	
	new szFirstArg[ 32 ], szSecondArg[ 32 ];
	
	read_argv( 1, szFirstArg, sizeof ( szFirstArg ) -1 );
	read_argv( 2, szSecondArg, sizeof ( szSecondArg ) -1 );
	
	if( equal( szFirstArg, "" ) || equal( szSecondArg, "" ) )
	{
		client_cmd( id, "echo kz_teleport < jucator 1 > < jucator 2 > " );
			
		return 1;
	}
	
	new iPlayer = cmd_target( id, szFirstArg, 8 );
	
	if( !iPlayer || !is_user_connected( iPlayer ) )
	{
		client_cmd( id, "echo Jucatorul %s nu a fost gasit sau nu este conectat!", szFirstArg );
		return 1;
	}
	
	new iPlayerTwo = cmd_target( id, szSecondArg, 8 );
	
	if( !iPlayerTwo || !is_user_connected( iPlayerTwo ) )
	{
		client_cmd( id, "echo Jucatorul %s nu a fost gasit sau nu este conectat!", szSecondArg );
		return 1;
	}
	
	if( !is_user_alive( iPlayer ) || !is_user_alive( iPlayerTwo ) )
	{
		client_cmd( id, "echo Ambii jucatori trebuie sa fie in viata!" );
		return 1;
	}
	
	KzTeleportPlayers( id, iPlayer, iPlayerTwo );
	
	return 1;
	
}

KzTeleportPlayers( id, iPlayer, iPlayerTwo )
{
	
	new Float:fOrigin[ 3 ], Float:fNeedToAdd = 0.0;
	pev( iPlayerTwo, pev_origin, fOrigin );
	
	if( is_in_duck( iPlayerTwo ) && !is_in_duck( iPlayer ) ) fNeedToAdd = 18.0;
	if( !is_in_duck( iPlayerTwo ) && is_in_duck( iPlayer ) ) fNeedToAdd = -18.0;
	if( is_in_duck( iPlayerTwo ) && is_in_duck( iPlayer ) ) fNeedToAdd = 0.0;
	if( !is_in_duck( iPlayerTwo ) && !is_in_duck( iPlayer ) ) fNeedToAdd = 0.0;
	
	fOrigin[ 2 ] += fNeedToAdd;
	
	set_pev( iPlayer, pev_velocity, Float:{ 0.0, 0.0, 0.0 } );
	set_pev( iPlayer, pev_origin, fOrigin );
	
	client_print( 0, print_chat, "* ADMIN:%s teleported player %s to %s !", _get_user_name( id ),
		_get_user_name( iPlayer ), _get_user_name( iPlayerTwo ) );
		
	return 1;
	
}

// Stock luat din Kz-Arg Mod 1.7 by ReymonARG
stock bool:is_in_duck( iEnt ) 
{
	if( !pev_valid( iEnt ) )
		return false;

	static Float:fAbsMin[ 3 ], Float:fAbsMax[ 3 ];

	pev( iEnt, pev_absmin, fAbsMin );
	pev( iEnt, pev_absmax, fAbsMax );

	fAbsMin[ 2 ] += 64.0;
	
	if( fAbsMin[ 2 ] < fAbsMax[ 2 ] )
		return false;
		
	return true;
}

stock _get_user_name( id )
{
	static szName[ 32 ];
	get_user_name( id, szName, sizeof ( szName ) -1 );
	
	return szName;
}