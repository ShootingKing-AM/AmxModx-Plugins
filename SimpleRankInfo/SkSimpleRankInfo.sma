#include <amxmodx>
#include <csx>
#include <nvault>

#define PLUGIN		"Simple Rank Info"
#define VERSION		"1.2"
#define AUTHOR		"Shooting King"

#define PRUNEDAYS	30
#define MAXLENGTH	190

enum
{
	STATS_KILLS,
	STATS_DEATHS,
	STATS_HS
}

new gKeysMainMenu = MENU_KEY_0 | MENU_KEY_1 | MENU_KEY_2 | MENU_KEY_3 | MENU_KEY_4 | MENU_KEY_5 | MENU_KEY_6 | MENU_KEY_7 | MENU_KEY_8 | MENU_KEY_9; 
new gszMenu[256];
new g_Vault;
new gszLOnline[33][32];
new g_RndKills[33];

public plugin_init()
{
	register_plugin( PLUGIN, VERSION, AUTHOR );
	
	register_clcmd( "say /rank", "cmd_Rank" );
	register_clcmd( "say_team /rank", "cmd_Rank" );
	register_clcmd( "say /top", "cmd_TopThree" );
	register_clcmd( "say_team /top", "cmd_TopThree" );
	register_clcmd( "say /next", "cmd_NextRank" );
	register_clcmd( "say_team /next", "cmd_NextRank" );
	
	g_Vault = nvault_open("SK_LastOnline");
	register_event( "DeathMsg", "event_DeathMsg", "a", "1>0" );
	register_event( "HLTV", "event_NewRound", "a", "1=0", "2=0" );
	register_menucmd(register_menuid("skMainMenu"), gKeysMainMenu, "handleMainMenu");
	
	CreateMenu();
}

CreateMenu()
{
	new iSize = sizeof(gszMenu);
	gszMenu[0] = '^0';
	
	add( gszMenu , iSize , "\r***** \yRanking\r*****^n^n" );
	add( gszMenu , iSize , "\r1. \wRank: %d/%d Score: %d^n" );
	add( gszMenu , iSize , "\r2. \wKills: %d Deaths: %d KPD: %.2f^n" );
	add( gszMenu , iSize , "\r3. \wHeadshots: %d^n" );
	add( gszMenu , iSize , "\r4. \wLast Online: %s^n" );
}

public client_putinserver(id)
{
	gszLOnline[id][0] = '^0';
	new szKey[32], szData[32], iDataExists, iTimestamp;
	get_user_name( id, szKey, charsmax(szKey));
	
	iDataExists = nvault_lookup( g_Vault, szKey, gszLOnline[id], charsmax(szData), iTimestamp);
	if( !iDataExists )
	{
		copy( gszLOnline[id], charsmax(szData), "Today" );
	}		
	szData[0] = '^0';
	format_time( szData, charsmax(szData), "%d/%m - %H:%M:%S", -1 );
	nvault_set( g_Vault, szKey, szData );
}

public cmd_Rank(id)
{
	new izStats[8], izBody[8], szName[32], inStats[3];
	new iRankPos, iRankMax;
	new szShowMenu[256];
	
	inStats[0] = get_user_frags(id);
	inStats[1] = get_user_deaths(id);
	
	iRankPos = get_user_stats(id, izStats, izBody);
	iRankMax = get_statsnum();
	get_user_name( id, szName, charsmax(szName));
	
	ColorPrint(0, "^x03%s's ^x01rank is ^x04%d^x01/^x04%d^x01 -- KPD ^x03%.2f", szName, iRankPos, iRankMax, inStats[1] == 0? 0.0:float((inStats[0]/inStats[1])));
	
	formatex( szShowMenu, sizeof(szShowMenu), gszMenu, iRankPos, iRankMax, izStats[STATS_KILLS], inStats[0], inStats[1], inStats[1] == 0? 0.0:float((inStats[0]/inStats[1])), izStats[STATS_HS], gszLOnline[id]); 
	
	show_menu( id , gKeysMainMenu, szShowMenu, -1 , "skMainMenu");
	return PLUGIN_CONTINUE
}

public cmd_NextRank(id)
{
	new szName[32], iRank;
	new izStats[8], iznStats[8], izBody[8];
	iRank = get_user_stats(id, izStats, izBody);
	
	iRank -= 2;
	do
	{
		if( iRank < 0 )
		{
			ColorPrint( id, "^x04You are the Top Dog around here." );
			return PLUGIN_CONTINUE;
		}
		szName[0] = '^0';
		get_stats( iRank, iznStats, izBody, szName, 31);
		iRank--;
	}
	while(iznStats[STATS_KILLS] <= (izStats[STATS_KILLS] + g_RndKills[id]));
	
	ColorPrint( id, "^x01You have to get ^x04%d^x01 kills in order to beat ^x04%s^x01", (iznStats[STATS_KILLS]-(izStats[STATS_KILLS]+ g_RndKills[id])), szName);
	return PLUGIN_CONTINUE;
}

public cmd_TopThree(id)
{
	new szTop[MAXLENGTH+1], szName[32];
	new izStats[8], izBody[8];
	new iMax = get_statsnum();
	iMax = iMax > 3 ? 3: iMax;
	add( szTop, MAXLENGTH, "^x04Top 3 Players are^x03 " );
	
	for (new i = 0; i < iMax ; i++)
	{
		szName[0] = '^0';
		get_stats(i, izStats, izBody, szName, 31)
		replace_all(szName, 31, "<", "[")
		replace_all(szName, 31, ">", "]")
		add( szName, 31, ", " );
		add( szTop, MAXLENGTH, szName );
	}
	trim(szTop);
	szTop[strlen(szTop)-1] = '.';
	ColorPrint( id, szTop );
}

public event_DeathMsg()
{
	new iVic = read_data(2);
	new iAtt = read_data(1);
	
	if( iVic != iAtt )
	{
		g_RndKills[iAtt]++;
	}
}

public event_NewRound()
{
	for( new id = 1; id < 33; id++ )
	{
		g_RndKills[id] = 0;
	}
}

public handleMainMenu(id, num)
{
	return PLUGIN_HANDLED;
}

public plugin_end()
{
	nvault_prune( g_Vault , 0 , get_systime() - ( PRUNEDAYS * 86400 ) );
	nvault_close( g_Vault );
}
	
stock ColorPrint(const id, const input[], any:...)
{
	new count = 1, players[32]
	static msg[191]
	vformat(msg, 190, input, 3)
	
	//"^x04") Green Color
	//"^x01") Default Color
	//"^x03") Team Color
	
	if (id) players[0] = id; else get_players(players, count, "ch")
	{
		for (new i = 0; i < count; i++)
		{
			if (is_user_connected(players[i]))
			{
				message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("SayText"), _, players[i])
				write_byte(players[i])
				write_string(msg)
				message_end()
			}
		}
	}
}