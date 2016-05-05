#include <amxmodx>

#pragma semicolon 1


#define PLUGIN "New Plugin"
#define VERSION "1.0"

#define		MapsToSave	5

new g_szLastMapsFile[ 64 ];
new g_szLastMapsNames[ MapsToSave ][ 32 ];
new g_iLastMapsTime[ MapsToSave ];

new g_iLastMapsNum = 0;

public plugin_init( )
{
	register_plugin( PLUGIN, VERSION, "Askhanar" );
	
	register_clcmd( "say /harti", "ClCmdSayHarti" );
	
	get_localinfo( "amxx_configsdir", g_szLastMapsFile, sizeof ( g_szLastMapsFile ) -1 );
	add( g_szLastMapsFile, sizeof ( g_szLastMapsFile ) -1, "/LastPlayedMaps.txt" );
	
	
	new iFile = fopen( g_szLastMapsFile, "rt" );
	
	if( iFile )
	{
		
		new szBuffer[ 64 ], szMinutes[ 5 ];
		while( !feof( iFile ) && g_iLastMapsNum < MapsToSave )
		{
			fgets( iFile, szBuffer, sizeof ( szBuffer ) -1 );
			trim( szBuffer );
			
			if( szBuffer[ 0 ] )
			{
				parse( szBuffer,\
				g_szLastMapsNames[ g_iLastMapsNum ], sizeof ( g_szLastMapsNames[] ) -1,\
				szMinutes, sizeof ( szMinutes ) -1 );
				
				g_iLastMapsTime[ g_iLastMapsNum ] = str_to_num( szMinutes );
				g_iLastMapsNum++;
			}
		}
		
		fclose( iFile );
	}
}

public ClCmdSayHarti( id )
{	
	static szBuffer[ 2368 ], szMapName[ 128 ], iLen, i;
	
	iLen = formatex( szBuffer, 2367, "<body bgcolor=#FFFFFF><br><center><img src=^"http://img684.imageshack.us/img684/7145/headernec.png^"</center>" );
	iLen += format( szBuffer[ iLen ], 2367 - iLen, "<br><br><br><table width=58%% cellpadding=2 cellspacing=0 border=0> <tr align=center bgcolor=#52697B>" );
	iLen += format( szBuffer[ iLen ], 2367 - iLen, "<th width=8%% > # <th width=25%%> Nume harta<th width=25%%> Minute jucate");
	
	for( i = 0; i < g_iLastMapsNum; i++ )
	{		
		if( g_iLastMapsNum == 0 )
		{
			iLen += format( szBuffer[ iLen ], 2367 - iLen, "<tr align=center%s> <td> %d <td> %s <td> %s", ( ( i%2 ) == 0 ) ? "" : " bgcolor=#A4BED6", ( i + 1), " ", " " );
			//i = MaxToSave;
		}
		else
		{
			szMapName = g_szLastMapsNames[ i ];
			while( containi( szMapName , "<") != -1 )
				replace( szMapName , sizeof( szMapName  ) -1, "<", "&lt;" );
			while( containi( szMapName, ">") != -1 )
				replace( szMapName , sizeof( szMapName  ) -1, ">", "&gt;" );
				
			iLen += format( szBuffer[ iLen ], 2367 - iLen, "<tr align=center%s><td> %d <td> %s <td> %i minut ",((i%2)==0) ? "" : " bgcolor=#A4BED6",
				( i + 1 ), szMapName, g_iLastMapsTime[ i ], g_iLastMapsTime[ i ] == 1 ? "" : "e" );
		}
	}
	
	iLen += format( szBuffer[ iLen ], 2367 - iLen, "</table></body>" );
	iLen += format( szBuffer[ iLen ], 2367 - iLen, "<tr><center><b>Last Played Maps<br>Copyright � 2012, Askhanar @indungi.ro" );
	show_motd( id, szBuffer, "Ultimele harti jucate" );
	
	return 0;
}

public plugin_end(  )
{
	new iMinutes = floatround( get_gametime(  ) / 60.0, floatround_ceil );
	
	new szMapName[ 32 ];
	get_mapname( szMapName, sizeof ( szMapName ) -1 );
	
	new iFile = fopen( g_szLastMapsFile, "wt" );
	fprintf( iFile, "^"%s^" %i", szMapName, iMinutes );
	
	if( g_iLastMapsNum == MapsToSave )
		g_iLastMapsNum--;
	
	for( new i = 0; i < g_iLastMapsNum; i++ ) 
		fprintf( iFile, "^n^"%s^" %i", g_szLastMapsNames[ i ], g_iLastMapsTime[ i ] );
	
	fclose( iFile );
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ ansicpg1252\\ deff0{\\ fonttbl{\\ f0\\ froman\\ fcharset0 Times New Roman;}}\n{\\ colortbl ;\\ red0\\ green0\\ blue0;}\n\\ viewkind4\\ uc1\\ pard\\ cf1\\ lang11274\\ f0\\ fs24 \n\\ par }
*/
