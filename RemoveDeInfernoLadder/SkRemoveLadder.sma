#include <amxmodx>
#include <amxmisc>
#include <engine>

#define PLUGIN		"Remove Ladder"
#define VERSION		"1.0"
#define AUTHOR		"Shooting King"

public plugin_init()
{
	register_plugin( PLUGIN, VERSION, AUTHOR );
	new szMap[32];
	get_mapname( szMap,31 );
	
	if(!equali(szMap, "de_inferno"))
	{
		set_fail_state( "Plugin Disabled because the Map is'nt de_inferno" );
	}
	
	RemoveLadder();
}

public RemoveLadder()
{	
	remove_entity(find_ent_by_model(-1, "func_wall", "*15"));   
	remove_entity(find_ent_by_model(-1, "func_ladder", "*142"));
}
	

