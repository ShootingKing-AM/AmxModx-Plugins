#include <amxmodx>
#include <cstrike>
#include <csstats>
#include <fun>

#define PLUGIN		"Regain Score"
#define VERSION		"1.0"
#define AUTHOR		"Shooting King"

enum
{
	STATS_KILLS,
	STATS_DEATHS,
}

public plugin_init()
{
	register_plugin( PLUGIN, VERSION, AUTHOR );
	register_event( "TextMsg", "Event_NewRound", "a", "2&#Game_will_restart_in", "2&#Game_Commencing" );	
}

public client_putinserver(id)
{
	if( is_user_connected(id) && !is_user_bot(id))
	{
		SetScores(id);
	}
}

public Event_NewRound()
{
	/*for( new i = 1; i < get_maxplayers(); i++ )
	{
		if( is_user_connected(i) && !is_user_bot(i))
		{
			SetScores(i);
		}
	}*/
	
	new szPlayers[32], iNum, iPlayer;
	get_players( szPlayers, iNum );
	iNum--;
	
	while( iNum > 0 )
	{
		iPlayer = szPlayers[iNum];
		SetScores(iPlayer);
		iNum--;
	}
}

public SetScores(id)
{
	static izStats[8], izBody[8];
	get_user_stats(id, izStats, izBody);
	
	cs_set_user_deaths( id, izStats[STATS_DEATHS]);
	cs_set_user_deaths( id, izStats[STATS_DEATHS]);
	set_user_frags( id, izStats[STATS_KILLS]);
	set_user_frags( id, izStats[STATS_KILLS]);
}