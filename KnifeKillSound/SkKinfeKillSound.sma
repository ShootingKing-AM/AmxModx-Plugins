#include <amxmodx>

#define PLUGIN		"Sk Knife Sound"
#define VERSION		"1.2"
#define AUTHOR		"Shooting King"

new const szSound[] = "misc/knife_kill.wav";
new SyncHudObj;

public plugin_init()
{
	register_plugin( PLUGIN, VERSION, AUTHOR );
	register_event( "DeathMsg", "event_KnifeKill", "a", "1>0", "4&knife" );
	
	SyncHudObj = CreateHudSyncObj();
}

public plugin_precache()
{
	precache_sound(szSound);
}

public event_KnifeKill()
{
	static szVicName[32], szAttName[32], iVictim, iAttacker;
	iAttacker = read_data(1);
	iVictim = read_data(2);
	
	get_user_name( iAttacker, szAttName, 31 );
	get_user_name( iVictim, szVicName, 31 );
	
	set_hudmessage( 250, 0, 0, _, _, 1, _, _, _, _, -1 );
	ShowSyncHudMsg( 0, SyncHudObj, "%s has just knifed %s.", szAttName, szVicName );
	
	client_cmd( 0, "stopsound" );
	client_cmd( 0, "spk ^"%s^"", szSound );
}
	