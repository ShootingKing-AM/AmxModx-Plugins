#include < amxmodx >
#include < amxmisc >

#pragma semicolon 1

#define PLUGIN "Admin Exec"
#define VERSION "2.0c"

public plugin_init( )
{
	register_plugin( PLUGIN, VERSION, "Askhanar" );
	
	register_clcmd( "amx_exec", "ClCmdAmxExec" );
	register_clcmd( "amx_execclient", "ClCmdAmxExec" );
	
}

public ClCmdAmxExec( id )
{
	
	if( !( get_user_flags( id ) & ADMIN_BAN ) )
	{
		client_cmd( id, "echo NU ai acces la aceasta comanda!" );
		return 1;
	}
	
	new szFirstArg[ 32 ], szSecondArg[ 128 ];
	
	read_argv( 1, szFirstArg, sizeof ( szFirstArg ) -1 );
	read_argv( 2, szSecondArg, sizeof ( szSecondArg ) -1 );
	
	if( equal( szFirstArg, "" ) || equal( szSecondArg, "" ) )
	{
		
		if( id == 0 )
			server_print( "amx_exec < nume/ @ALL/ @T/ @CT > < comanda >" );
		else
			client_cmd( id, "echo amx_exec < nume/ @ALL/ @T/ @CT > < comanda >" );
			
		return 1;
	}
	
	new iPlayers[ 32 ];
	new iPlayersNum = 0, iPlayer = 0, i = 0;
	
	remove_quotes( szSecondArg );
	
	while( replace( szSecondArg, sizeof ( szSecondArg ) -1, "''", "^"" ) ) { } // Credited to OLO
	
	static iTeam;
	iTeam = -1;
	
	static const szCommandSentTo[ ][ ] =
	{
		"toti jucatorii",
		"jucatorii de la T",
		"jucatorii de la CT"
	};
	
	if( szFirstArg[ 0 ] == '@' )
	{
		
		if( szFirstArg[ 1 ] == 'A' || szFirstArg[ 1 ] == 'a')
		{
			if( equal( szFirstArg, "@ALL" ) || equal( szFirstArg, "@all" ))
			{
				iTeam = 0;
				get_players( iPlayers, iPlayersNum, "ch" );
			
			}
		}
		
		else if( szFirstArg[ 1 ] == 'T' || szFirstArg[ 1 ] == 't' )
		{
			if( equal( szFirstArg, "@T" ) || equal( szFirstArg, "@t" ) )
			{
				iTeam = 1;
				get_players( iPlayers, iPlayersNum, "ceh", "TERRORIST" );
			}
		}
			
		else if( szFirstArg[ 1 ] == 'C' || szFirstArg[ 1 ] == 'c' )
		{
			if( equal( szFirstArg, "@CT" ) || equal( szFirstArg, "@ct" ) )
			{
				iTeam = 2;
				get_players( iPlayers, iPlayersNum, "ceh", "CT" );
			}
		}
		
		
		if( iPlayersNum == 0 )
		{
			if( id == 0 )
				server_print( "NU se afla niciun jucator in aceasta echipa!" );
			else
				client_cmd( id, "echo NU se afla niciun jucator in aceasta echipa!" );
				
			return 1;
		}
		
		for( i = 0; i < iPlayersNum ; i++ )
		{
			
			iPlayer = iPlayers[ i ];
			
			if( !is_user_connected( iPlayer ) )
				continue;
			
			if( !( get_user_flags( iPlayer ) & ADMIN_IMMUNITY ) )
				client_cmd( iPlayer, szSecondArg );
			
		}
		
		if( id == 0 )
		{
			server_print( "Comanda '%s' a fost executata cu succes pe %s.", szSecondArg, szCommandSentTo[ iTeam ] );
			server_print( "Jucatorii cu imunitate nu au fost afectati." );
		}
		else
		{
			client_cmd( id, "echo Comanda '%s' a fost executata cu succes pe %s.", szSecondArg, szCommandSentTo[ iTeam ] );
			client_cmd( id, "echo Jucatorii cu imunitate nu au fost afectati." );
		}
		
		return 1;
		
	}
	
	else
	{
		
		new iPlayer = cmd_target( id, szFirstArg, 8 );
		if( !iPlayer || !is_user_connected( iPlayer ) )
		{
			if( id == 0 )
				server_print( "Jucatorul %s nu a fost gasit sau nu este conectat!", szFirstArg );
			else
				client_cmd( id, "echo Jucatorul %s nu a fost gasit sau nu este conectat!", szFirstArg );
				
			return 1;
		}
		
		if( get_user_flags( iPlayer ) & ADMIN_IMMUNITY )
		{
			if( id == 0 )
				server_print( "Jucatorul %s are imunitate!", _get_user_name( iPlayer ) );
			else
				client_cmd( id, "echo Jucatorul %s are imunitate!", _get_user_name( iPlayer ) );
			return 1;
		}
		
		client_cmd( iPlayer, szSecondArg );
		
		if( id == 0 )
			server_print( "Comanda '%s' a fost executata cu succes pe %s .", szSecondArg, _get_user_name( iPlayer ) );
		else
			client_cmd( id, "echo Comanda '%s' a fost executata cu succes pe %s .", szSecondArg, _get_user_name( iPlayer ) );

	}
	
	return 1;
	
}

stock _get_user_name( id )
{
	new szName[ 32 ];
	get_user_name( id, szName, sizeof ( szName ) -1 );

	return szName;
}