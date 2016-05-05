#include <amxmodx>
#include <fun>

#define PLUGIN		"Two HS Kills"
#define VERSION		"1.0"
#define AUTHOR		"Shooting King"

public plugin_precache()
{
	register_plugin( PLUGIN, VERSION, AUTHOR );
	
	register_event( "DeathMsg", "event_HSDeath", "a", "1>0", "3=1" );
}

public event_HSDeath()
{
	static iKiller;
	iKiller = read_data(1);
	
	set_user_frags( iKiller, (get_user_frags(iKiller)+1));
	client_print( iKiller, print_chat, "** You have gained an Extra frag for Head Shot !!" );
}