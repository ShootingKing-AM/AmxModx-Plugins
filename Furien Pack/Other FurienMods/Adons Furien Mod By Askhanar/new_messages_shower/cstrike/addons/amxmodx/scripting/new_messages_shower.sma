#include < amxmodx >
#include < dhudmessage >

#pragma semicolon 1


#define PLUGIN "New Messages Shower"
#define VERSION "2.0c"

#define	MAX_MESSAGES	64

new const g_szMessagesFile[ ] = "Messages.ini";
new Float:g_fMessagesInterval = -1.0;


new g_szMessages[ MAX_MESSAGES ][ 128 ];

new g_iMessagesRedColor[ MAX_MESSAGES ];
new g_iMessagesGreenColor[ MAX_MESSAGES ];
new g_iMessagesBlueColor[ MAX_MESSAGES ];
new g_iMessagesEffect[ MAX_MESSAGES ];

new Float:g_fMessagesDuration[ MAX_MESSAGES ];

new g_iMessagesCount = 0;
new g_iLastHudMessage = 0;

public plugin_precache( )
{
	
	if( !ReadAndBuildMessages( ) )
	{
		log_amx( "Fisierul %s nu a fost gasit!", g_szMessagesFile );
		WriteAndBuildDefaultMessage( );
	}
	
}

public plugin_init( )
{
	register_plugin( PLUGIN, VERSION, "Askhanar" );
	
	if( g_fMessagesInterval > 0.0 )
		set_task( g_fMessagesInterval, "DisplayMessage", _, _, _, "b" );
		
}

public DisplayMessage( )
{
	static iRandomHud;
	iRandomHud = random( g_iMessagesCount );
	
	while( iRandomHud == g_iLastHudMessage )
		iRandomHud = random( g_iMessagesCount );
		
	set_dhudmessage( g_iMessagesRedColor[ iRandomHud ] == -1 ?  random( 256 ) : g_iMessagesRedColor[ iRandomHud ],
			g_iMessagesGreenColor[ iRandomHud ] == -1 ?  random( 256 ) : g_iMessagesGreenColor[ iRandomHud ],
			g_iMessagesBlueColor[ iRandomHud ] == -1 ?  random( 256 ) : g_iMessagesBlueColor[ iRandomHud ],
			-1.0,
			0.00,
			g_iMessagesEffect[ iRandomHud ] == -1 ? random_num( 0, 2 ) : g_iMessagesEffect[ iRandomHud ],
			1.0,
			g_fMessagesDuration[ iRandomHud ],
			0.1,
			0.1  );
			
	static iPlayers[ 32 ];
	static iPlayersNum;

	get_players( iPlayers, iPlayersNum, "ch" );
	
	if( !iPlayersNum )
		return;
		
	for( new i = 0 ; i < iPlayersNum ; i++ )
	{
		if( !is_user_connected( iPlayers[ i ] ) )
			continue;

		show_dhudmessage( iPlayers[ i ], g_szMessages[ iRandomHud ] );
		client_print( iPlayers[ i ], print_console, g_szMessages[ iRandomHud ] );
	}
	
}

ReadAndBuildMessages( )
{
	
	new szFile[ 128 ];
	get_localinfo( "amxx_configsdir", szFile, sizeof ( szFile ) -1 );
	format( szFile, sizeof ( szFile ) -1, "%s/%s", szFile, g_szMessagesFile );

	new iFile = fopen( szFile, "rt" );
	
	if( !iFile )
		return 0;

	new szData[ 256 ], szKey[ 16 ], szValue[ 128 ];
	new bool:bNewMessage = false;
	
	while( !feof( iFile ) )
	{
		
		fgets( iFile, szData, sizeof ( szData ) -1 );
		trim( szData );
		
		if( !szData[ 0 ] || szData[ 0 ] == ';' || ( szData[ 0 ] == '/' && szData[ 1 ] == '/') )
		{
			continue;
		}

		if( szData[ 0 ] == '{' )
		{
			bNewMessage = true;
			continue;
		}
	
	
		else if( szData[ 0 ] == '}' )
		{
			
			if( bNewMessage )
				g_iMessagesCount++;
			
			bNewMessage = false;
			
			if( g_iMessagesCount >= MAX_MESSAGES )
			{
				log_amx( "Numarul maxim de mesaje( %i ) a fost atins!", MAX_MESSAGES );
				break;
			}
			
			continue;
		}
		
		else
		{
			parse( szData, szKey, sizeof ( szKey ) -1, szValue, sizeof ( szValue ) -1 );

			switch( szKey[ 0 ] )
			{
				
				case '#':
				{
					
					switch( szKey[ 2 ] )
					{
						
						case 'O':
						{
							
							if( equal( szKey, "#COLOR" )  && bNewMessage )
							{
								static szRed[ 5 ], szGreen[ 5 ], szBlue[ 5 ];
								
								parse( szValue, szRed, sizeof ( szRed ) -1,\
									szGreen, sizeof ( szGreen ) -1,\
									szBlue, sizeof ( szBlue ) -1 );
									
								g_iMessagesRedColor[ g_iMessagesCount ] = clamp( str_to_num( szRed ), -1, 255 );
								g_iMessagesGreenColor[ g_iMessagesCount ]  = clamp( str_to_num( szGreen ), -1, 255 );
								g_iMessagesBlueColor[ g_iMessagesCount ]  = clamp( str_to_num( szBlue ), -1, 255 );
								
							}
						}
						
						case 'E':
						{
							
							if( equal( szKey, "#MESSAGE" )  && bNewMessage )
							{
								
								replace_all( szValue, sizeof ( szValue ) -1, "/n", "^n" );
								copy( g_szMessages[ g_iMessagesCount ], sizeof ( g_szMessages[ ] ) -1, szValue );
								
							}
						}
						
						case 'F':
						{
							if( equal( szKey, "#EFFECT" )  && bNewMessage )
							{
								
								g_iMessagesEffect[ g_iMessagesCount ] = clamp( str_to_num( szValue ), -1, 2 );
								
							}
						}
						
						case 'U':
						{
							
							if( equal( szKey, "#DURATION" )  && bNewMessage )
							{
								
								g_fMessagesDuration[ g_iMessagesCount ] = floatclamp( str_to_float( szValue ), 5.0, 20.0 );
								
							}
						}
						
						case 'N':
						{
							
							if( equal( szKey , "#INTERVAL" )  && !bNewMessage )
							{
								
								g_fMessagesInterval = floatclamp( str_to_float( szValue ), 30.0, 600.0 );
								
							}
						}
	
					}
				}
				
			}
		}
								
	}
	
	fclose( iFile );
	
	if( g_iMessagesCount < MAX_MESSAGES )
		log_amx( "Am incarcat cu succes %i mesaje din %s", g_iMessagesCount, g_szMessagesFile );
	
	return 1;
}

WriteAndBuildDefaultMessage( )
{
	new szFile[ 128 ];
	get_localinfo( "amxx_configsdir", szFile, sizeof ( szFile ) -1 );
	format( szFile, sizeof ( szFile ) -1, "%s/%s", szFile, g_szMessagesFile );

	write_file( szFile, "// Intervalul dintre mesaje, adica din cate in cate secunde apare unul din mesajele de mai jos.", -1 );
	write_file( szFile, "", -1 );
	write_file( szFile, "#INTERVAL ^"100.0^"", -1 );
	write_file( szFile, "", -1 );
	write_file( szFile, "", -1 );
	write_file( szFile, "", -1 );
	write_file( szFile, "// Aici treceti mesajele unul sub altul dupa cum urmeaza.", -1 );
	write_file( szFile, "", -1 );
	write_file( szFile, "", -1 );
	write_file( szFile, "// Incepen sa construim un nou mesaj.", -1 );
	write_file( szFile, "", -1 );
	write_file( szFile, "{", -1 );
	write_file( szFile, "", -1 );
	write_file( szFile, "// Ii setam culoarea in RRR GGG BBB (ex: culoarea alb, 255 255 255 ).Valoarea -1 inseamca ca acea culoare va fi random ( la intamplare ).", -1 );
	write_file( szFile, "", -1 );
	write_file( szFile, "#COLOR ^"255 255 255^"", -1 );
	write_file( szFile, "", -1 );
	write_file( szFile, "// Punem un mesaj ( maxim 128 caractere ). /n inseamna rand nou ( adica mesajul va fi afisat sub textul aflat inainte ", -1 );
	write_file( szFile, "", -1 );
	write_file( szFile, "#MESSAGE ^"Mesaj generat de NewMessagesShower.amxx/nSetati-va mesajele in Messages.ini/nAflat in directorul configs.^"", -1 );
	write_file( szFile, "", -1 );
	write_file( szFile, "// Setam efectul mesajului. -1 este random ( la intamplare ), 0 apare deodata, 1 sclipeste, 2 apare cate o litera.", -1 );
	write_file( szFile, "", -1 );
	write_file( szFile, "#EFFECT ^"-1^"", -1 );
	write_file( szFile, "", -1 );
	write_file( szFile, "// Durata mesajului. ( cat va ramane afisat ).", -1 );
	write_file( szFile, "", -1 );
	write_file( szFile, "#DURATION ^"5.0^"", -1 );
	write_file( szFile, "", -1 );
	write_file( szFile, "// Am terminat de contruit mesajul.", -1 );
	write_file( szFile, "", -1 );
	write_file( szFile, "}", -1 );
	write_file( szFile, "", -1 );
	write_file( szFile, "", -1 );
	write_file( szFile, "// Acum am sa va dau un exemplu:", -1 );
	write_file( szFile, "", -1 );
	write_file( szFile, "", -1 );
	write_file( szFile, "{", -1 );
	write_file( szFile, "", -1 );
	write_file( szFile, "#COLOR ^"255 255 0^"", -1 );
	write_file( szFile, "#MESSAGE ^"Pentru a reclama un presupus codat/nFolositi comanda say_team(U)/nUrmata de simbolul @ si de mesaj.^"", -1 );
	write_file( szFile, "#EFFECT ^"0^"", -1 );
	write_file( szFile, "#DURATION ^"7.0^"", -1 );
	write_file( szFile, "", -1 );
	write_file( szFile, "}", -1 );
	write_file( szFile, "", -1 );
	write_file( szFile, "{", -1 );
	write_file( szFile, "", -1 );
	write_file( szFile, "#COLOR ^"0 255 255^"", -1 );
	write_file( szFile, "#MESSAGE ^"Echipa noastra va ureaza,/nSarbatori fericite alaturi de cei dragi.^"", -1 );
	write_file( szFile, "#EFFECT ^"1^"", -1 );
	write_file( szFile, "#DURATION ^"6.0^"", -1 );
	write_file( szFile, "", -1 );
	write_file( szFile, "}", -1 );
	write_file( szFile, "", -1 );
	write_file( szFile, "{", -1 );
	write_file( szFile, "", -1 );
	write_file( szFile, "#COLOR ^"18 152 236^"", -1 );
	write_file( szFile, "#MESSAGE ^"Va rugam pastrati un limbaj decent pe server!^"", -1 );
	write_file( szFile, "#EFFECT ^"2^"", -1 );
	write_file( szFile, "#DURATION ^"10.0^"", -1 );
	write_file( szFile, "", -1 );
	write_file( szFile, "}", -1 );
	
	log_amx( "Am creat cu succes fisierul %s", g_szMessagesFile );
	
	ReadAndBuildMessages( );
	
}