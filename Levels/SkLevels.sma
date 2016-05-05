#include <amxmodx>
#include <csstats>
#include <engine>
#include <iplock>

#define PLUGIN		"Levels"
#define VERSION		"3.7"
#define AUTHOR		"Shooting King"

#define TASK_TUT	91234

enum
{
	KILLS,
	DEATHS,
	HS,
	MAX_BUFFER = 2047
}

enum
{
	COLOR_GREEN = 0,
	COLOR_RED,
	COLOR_BLUE,	
	COLOR_YELLOW
}

new const g_ClassName[] = "sk_levels";
new g_Level[33];
new g_RemKills[33];
new g_Ranks[33];
// new g_maxRanks;
new g_SyncScoreInfo;//, g_iMaxPlayers;
new pCvar_kills;

public plugin_init()
{
	register_plugin( PLUGIN, VERSION, AUTHOR );
	CheckServerIp( "128.199.249.214:27015" );

	register_think(g_ClassName,"ForwardThink");
	register_event( "DeathMsg", "event_DeathMsg", "a", "1>0" );
	// register_event( "HLTV", "event_NewRound", "a", "1=0", "2=0" );
	register_logevent( "event_NewRound", 2, "0=World triggered", "1=Round_Start");

	register_clcmd( "say /top10", "cmd_Top15" );
	register_clcmd( "say /top15", "cmd_Top15" );
	register_clcmd( "say_team /top10", "cmd_Top15" );
	register_clcmd( "say_team /top15", "cmd_Top15" );
	
	pCvar_kills = register_cvar( "sk_lvl_kills", "5" );
	
	new iEnt = create_entity("info_target");
	entity_set_string(iEnt, EV_SZ_classname, g_ClassName);
	entity_set_float(iEnt, EV_FL_nextthink, get_gametime() + 1.0);
	
	g_SyncScoreInfo = CreateHudSyncObj();
	// g_iMaxPlayers = get_maxplayers();
}

public plugin_natives()
{
	register_native("sk_get_user_level", "_get_Level");
}

public _get_Level(plugin, params)
{
	return g_Level[get_param(1)];
}

public client_putinserver(id)
{
	remove_task(id);
	set_task( 2.0, "SetLevel", id );
}

public client_disconnect(id)
{
	g_Level[id] = 0;
	g_RemKills[id] = 0;
	g_Ranks[id] = 0;
}

public ForwardThink(iEnt)
{
	static id, iMaxRanks, szPlayers[32], iNum;

	iMaxRanks = get_statsnum();
	get_players( szPlayers, iNum, "ach" );

	set_hudmessage( 0, 250, 0, -1.25, 0.30, _, _, 0.2, _, _, -1)
	while( --iNum >= 0 )
	{
		id = szPlayers[iNum];
		if(is_user_alive(id))
		{
			ShowSyncHudMsg(id, g_SyncScoreInfo, "Level : %d^nRemaining Kills : %d^nRank : %d/%d", g_Level[id], g_RemKills[id], g_Ranks[id], iMaxRanks );
		}
	}
	entity_set_float(iEnt, EV_FL_nextthink, get_gametime() + 0.1);
}

public SetLevel(id)
{
	static izStats[8], izBody[8];
	
	g_Ranks[id] = get_user_stats(id, izStats, izBody);
	g_Level[id] = CalcLevel(izStats);
	g_RemKills[id] = get_pcvar_num(pCvar_kills) - (izStats[KILLS]%get_pcvar_num(pCvar_kills));
}

public event_DeathMsg()
{
	static iAttacker, iVic;
	
	iAttacker = read_data(1);
	iVic = read_data(2);
		
	if(iAttacker != iVic)
	{
		g_RemKills[iAttacker]--;
		if( g_RemKills[iAttacker] == 0 )
		{
			g_Level[iAttacker]++;
			g_RemKills[iAttacker] = get_pcvar_num(pCvar_kills);
		}		
	}
}

public event_NewRound()
{
	set_task( 1.0, "RestartStats" );
}

public RestartStats()
{
	new szPlayers[32], iNum, izStats[8], izBody[8], tempid;
	get_players( szPlayers, iNum, "ch" );

	while( --iNum >= 0 )
	{
		tempid = szPlayers[iNum];
		g_Ranks[tempid] = get_user_stats( tempid, izStats, izBody );
	}
}

stock CalcLevel(izStats[])
{
	return floatround(float(izStats[KILLS])/get_pcvar_float(pCvar_kills), floatround_floor);
}

public cmd_Top15(id)
{
	static szBuffer[MAX_BUFFER+1], szName[32], izStats[8], izBodyHits[8];
	static iMax, iLen;
	
	iMax = get_statsnum();
	iMax = ( iMax > 15 )? 15 : iMax;
	
	iLen = formatex(szBuffer, MAX_BUFFER, "<body bgcolor=black><font color=white size=3><pre><b>");
	iLen += formatex(szBuffer[iLen], MAX_BUFFER, "%4s %-30.30s %6s %6s %6s %6s ^n", "Rank", "Name", "Level", "Kills", "Deaths", "HS" );
	
	for( new i=0; i < iMax; i++ )
	{
		get_stats( i , izStats, izBodyHits, szName, charsmax(szName), "", 0);
		if( i < 2 )
			iLen += formatex(szBuffer[iLen], MAX_BUFFER, "<font color=^"red^">%4d %-30.30s</font> %5d %5d %5d %5d ^n", (i+1), szName, CalcLevel(izStats), izStats[KILLS], izStats[DEATHS], izStats[HS]);
		else if( i == 2 )
			iLen += formatex(szBuffer[iLen], MAX_BUFFER, "<font color=^"green^">%4d %-30.30s</font> %5d %5d %5d %5d ^n", (i+1), szName, CalcLevel(izStats), izStats[KILLS], izStats[DEATHS], izStats[HS]);
		else
			iLen += formatex(szBuffer[iLen], MAX_BUFFER, "%4d %-30.30s %5d %5d %5d %5d ^n", (i+1), szName, CalcLevel(izStats), izStats[KILLS], izStats[DEATHS], izStats[HS]);
	}
	
	show_motd( id, szBuffer, "Top 10 Players" );
}