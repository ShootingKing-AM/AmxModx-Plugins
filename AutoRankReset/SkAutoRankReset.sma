#include <amxmodx>
#include <amxmisc>
#include <csstats>

#define PLUGIN		"Auto Rank Reset"
#define VERSION		"1.0"
#define AUTHOR		"Shooting King"

enum
{
	KILLS,
	DEATHS,
	HS,
	TK,
	SHOTS,
	HITS,
	DMG
}

public plugin_init()
{
	register_plugin( PLUGIN, VERSION, AUTHOR );
	// register_clcmd( "say /test", "plugin_end" );
}

public plugin_end()
{
	new day, szBuffer[3];
	date( _, _, day );
	new file = fopen( "resetdata", "rt" );
	fgets( file, szBuffer, 3 );
	if( day == 1 )
	{
		if( str_to_num(szBuffer) == 0 )
		{
			cmd_SaveTop15();
			server_cmd( "csstats_reset 1" );
			fclose(file);
			file = fopen( "resetdata", "wt" );
			fputs( file, "1" );	
		}
	}
	else
	{
		if( str_to_num(szBuffer) != 0 )
		{
			fclose(file);
			file = fopen( "resetdata", "wt" );
			fputs( file, "0" );
		}
	}
	fclose(file);	
}

public cmd_SaveTop15()
{
	new szName[32], izStats[8], izBodyHits[8], szFileName[64];
	new iMax;
	
	get_configsdir( szFileName , 64 );
	add( szFileName , 64 , "/SkTopRanks" );
	
	if (!dir_exists( szFileName ))
	{
		mkdir( szFileName );
	}
	szFileName[0] = '^0';
	format_time( szFileName, 64, "addons/amxmodx/configs/SkTopRanks/top15_%m-%d-%Y.txt" );
	new file = fopen( szFileName, "wt" );
	
	iMax = get_statsnum();
	iMax = ( iMax > 15 )? 15 : iMax;
	
	fprintf( file, "<html>" );
	fprintf( file, "<body bgcolor=black><font color=white size=3><pre><b>^n");
	fprintf( file, "%4s %-33.33s %7s %7s %7s %7s %7s %7s %7s ^n", "Rank", "Name", "Level", "Kills", "Deaths", "HS", "Shots", "Hits", "Damage" );
	
	for( new i=0; i < iMax; i++ )
	{
		get_stats( i , izStats, izBodyHits, szName, charsmax(szName), "", 0);
		if( i < 2 )
			fprintf( file, "<font color=^"green^">%4d %-33.33s</font> %-7d %-7d %-7d %-7d %-7d %-7d %-7d^n", (i+1), szName, CalcLevel(izStats), izStats[KILLS], izStats[DEATHS], izStats[HS], izStats[SHOTS], izStats[HITS], izStats[DMG]);
		else if( i == 2 )
			fprintf( file, "<font color=^"red^">%4d %-33.33s</font> %-7d %-7d %-7d %-7d %-7d %-7d %-7d^n", (i+1), szName, CalcLevel(izStats), izStats[KILLS], izStats[DEATHS], izStats[HS], izStats[SHOTS], izStats[HITS], izStats[DMG]);
		else
			fprintf( file, "%4d %-33.33s %-7d %-7d %-7d %-7d %-7d %-7d %-7d^n", (i+1), szName, CalcLevel(izStats), izStats[KILLS], izStats[DEATHS], izStats[HS], izStats[SHOTS], izStats[HITS], izStats[DMG]);
	}
	fprintf( file, "</html>" );
	fclose(file);
}

stock CalcLevel(izStats[])
{
	return floatround(float(izStats[KILLS])/5, floatround_floor);
}