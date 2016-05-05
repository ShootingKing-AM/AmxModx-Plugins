#include <amxmodx>
#include <csx>

#define PLUGIN		"Sk Points"
#define VERSION		"1.0"
#define AUTHOR		"Shooting King"

#define TASKALL		99899
#define TASKSHOW	69323
#define RESETID		48332

enum
{
	KILLS=0,
	DEATHS,
	HEADSHOTS,
	TEAMKILLS,
}

enum
{
	TDEFUSIONS=0,
	BOMBDEF,
	BOMBPLANTS,
	BOMBEXP
}

new g_Points[33];
new g_maxPlayers, g_SyncHudObj, g_SayText;
new pCvar_killpnts, pCvar_headpnts, pCvar_defpnts, pCvar_deaths, pCvar_tdefpnts, pCvar_plntpnts, pCvar_exppnts, pCvar_clantag, pCvar_teamwin;

public plugin_init()
{
	register_plugin( PLUGIN, VERSION, AUTHOR );	
	register_clcmd( "say /points", "cmd_ShowPoints" );
	register_clcmd( "say_team /points", "cmd_ShowPoints" );
	
	pCvar_killpnts 	= register_cvar( "amx_sk_pnts_kills", "8" );
	pCvar_headpnts	= register_cvar( "amx_sk_pnts_headshots", "10" );
	pCvar_defpnts	= register_cvar( "amx_sk_pnts_defusions", "6" );
	pCvar_tdefpnts	= register_cvar( "amx_sk_pnts_tdefusions", "3" );
	pCvar_plntpnts	= register_cvar( "amx_sk_pnts_plant", "5" );
	pCvar_exppnts	= register_cvar( "amx_sk_pnts_explosions", "7" );
	pCvar_deaths	= register_cvar( "amx_sk_pnts_deaths", "3" );
	pCvar_clantag	= register_cvar( "amx_sk_pnts_tag", "SK" );
	pCvar_teamwin	= register_cvar( "amx_sk_pnts_teamwin", "4" );
		
	register_event( "DeathMsg", "event_DeathMsg", "a", "1>0" );
	register_logevent( "event_RoundStart", 2, "1=Round_Start" );
	
	register_event( "SendAudio", "event_TWin", "a", "2&%!MRAD_terwin");
	register_event( "SendAudio", "event_CTWin", "a", "2&%!MRAD_ctwin");
	
	g_SayText = get_user_msgid("SayText")
	g_SyncHudObj = CreateHudSyncObj();
	g_maxPlayers = get_maxplayers();	
}

public client_putinserver(id)
{
	remove_task(id+TASKALL);
	remove_task(id+TASKSHOW);
	
	set_task( 3.0, "SetPointsConnect", (id+TASKALL));
	set_task( 5.0, "cmd_ShowPointsAll", (id+TASKSHOW));
}

public cmd_ShowPointsAll(id)
{
	id -= TASKSHOW;
	new szName[32], szTag[32];
	get_user_name( id, szName, 31 );
	get_pcvar_string( pCvar_clantag, szTag, 31 );
	
	ColorPrint( 0, "^x04%s^x01 ^x03%s^x01 having ^x03%d^x01 points connected.", szTag, szName, g_Points[id] );
}

public event_TWin()
{
	new szPlayers[32], szTag[32], iNum, temp;	
	get_players( szPlayers, iNum, "ae", "TERRORIST" );
	get_pcvar_string( pCvar_clantag, szTag, 31 );
	
	while( --iNum > 0 )
	{
		temp = szPlayers[iNum];
		g_Points[temp] += get_pcvar_num(pCvar_teamwin);
		ColorPrint( temp, "^x04%s^x01 You have given %d points for TeamWin.", szTag, get_pcvar_num(pCvar_teamwin));
		ShowHud( temp, get_pcvar_num(pCvar_teamwin));
	}
}

public event_CTWin()
{
	new szPlayers[32], szTag[32], iNum, temp;	
	get_players( szPlayers, iNum, "ae", "CT" );
	get_pcvar_string( pCvar_clantag, szTag, 31 );
	
	while( --iNum >= 0 )
	{
		temp = szPlayers[iNum];
		g_Points[temp] += get_pcvar_num(pCvar_teamwin);
		ColorPrint( temp, "^x04%s^x01 You have given %d points for TeamWin.", szTag, get_pcvar_num(pCvar_teamwin));
		ShowHud( temp, get_pcvar_num(pCvar_teamwin));
	}
}
	

public event_DeathMsg()
{
	new iAttacker = read_data(1);
	new iVictim = read_data(2);
	
	if( iAttacker == iVictim )
	{
		return PLUGIN_CONTINUE;
	}
	
	g_Points[iVictim] -= get_pcvar_num( pCvar_deaths );
	
	if( get_user_team(iAttacker) != get_user_team(iVictim) )
	{
		if(read_data(3))
		{
			g_Points[iAttacker] += (get_pcvar_num(pCvar_headpnts) + get_pcvar_num(pCvar_killpnts));
			ShowHud( iAttacker, (get_pcvar_num(pCvar_headpnts) + get_pcvar_num(pCvar_killpnts)));
		}
		else
		{
			g_Points[iAttacker] += get_pcvar_num(pCvar_killpnts);
			ShowHud( iAttacker, get_pcvar_num(pCvar_killpnts) );
		}
	}
	return PLUGIN_CONTINUE;
}

public event_RoundStart()
{
	for( new i=1; i < g_maxPlayers; i++ )
	{
		if(is_user_connected(i))
		{
			SetPoints(i);
		}
	}
}

public bomb_planted(id)
{
	g_Points[id] += get_pcvar_num(pCvar_plntpnts);
	ShowHud( id, get_pcvar_num(pCvar_plntpnts));
}

public bomb_explode(id, idef)
{
	ShowHud( id, get_pcvar_num(pCvar_exppnts));
}

public bomb_defusing(id)
{
	g_Points[id] += get_pcvar_num(pCvar_tdefpnts);
	ShowHud( id, get_pcvar_num(pCvar_tdefpnts));
}

public bomb_defused(id)
{
	ShowHud( id, get_pcvar_num(pCvar_defpnts));
}

public SetPointsConnect(id)
{
	id -= TASKALL;
	SetPoints(id);
}

public cmd_ShowPoints(id)
{
	new szTag[32];
	get_pcvar_string( pCvar_clantag, szTag, 31 );
	ColorPrint( id, "^x04%s^x01 You have ^x03%d^x01 points.", szTag, g_Points[id] );
}

public SetPoints(id)
{
	new izStats[8], izBody[8], iz2Stats[4];
	
	g_Points[id] = 0;
	get_user_stats(id, izStats, izBody);
	get_user_stats2(id, iz2Stats);
	
	g_Points[id] += (izStats[KILLS]-izStats[TEAMKILLS])*get_pcvar_num(pCvar_killpnts);
	g_Points[id] += izStats[HEADSHOTS]*get_pcvar_num( pCvar_headpnts );
	g_Points[id] += iz2Stats[TDEFUSIONS]*get_pcvar_num( pCvar_tdefpnts );
	g_Points[id] += iz2Stats[BOMBDEF]*get_pcvar_num( pCvar_defpnts );
	g_Points[id] += iz2Stats[BOMBPLANTS]*get_pcvar_num( pCvar_plntpnts );
	g_Points[id] += iz2Stats[BOMBEXP]*get_pcvar_num( pCvar_exppnts );
	g_Points[id] -= iz2Stats[DEATHS]*get_pcvar_num( pCvar_deaths );
}

public ShowHud( id, iPoints )
{
	if( iPoints > 0 )
	{
		set_hudmessage( 0, 250, 0 , 0.55, 0.48, 0, 1.0, 1.0, 0.1, 0.4, -1 );
	}
	else
	{
		set_hudmessage( 250, 0, 0 , 0.55, 0.48, 0, 1.0, 1.0, 0.1, 0.4, -1 );
	}
	ShowSyncHudMsg( id, g_SyncHudObj, "%s%d", (iPoints > 0)? "+":"", iPoints );
}

stock ColorPrint(const id, const input[], any:...)
{
	new count = 1, players[32];
	static msg[191];
	vformat(msg, 190, input, 3);
	
	if (id) players[0] = id; else get_players(players, count, "ch")
	{
		for (new i = 0; i < count; i++)
		{
			if (is_user_connected(players[i]))
			{
				message_begin(MSG_ONE_UNRELIABLE, g_SayText, _, players[i]);
				write_byte(players[i]);
				write_string(msg);
				message_end();
			}
		}
	}
}	