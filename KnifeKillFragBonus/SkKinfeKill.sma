#include <amxmodx>
#include <fun>

#define PLUGIN		"Sk Knife Kills"
#define VERSION		"1.0"
#define AUTHOR		"Shooting King"

public plugin_init()
{
	register_plugin( PLUGIN, VERSION, AUTHOR );
	register_event( "DeathMsg", "event_KnifeKill", "a", "1>0", "4&knife" );
}

public event_KnifeKill()
{
	new iVictim, iAttacker;
	iAttacker = read_data(1);
	iVictim = read_data(2);
	
	if(get_user_team(iAttacker) != get_user_team(iVictim))
	{
		set_user_frags( iAttacker, get_user_frags(iAttacker)+2 );
	}
}
	