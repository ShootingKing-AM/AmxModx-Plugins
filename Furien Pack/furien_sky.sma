#include <amxmodx>

public plugin_init()
{
	register_plugin( "Furien : Sky", "1.0", "Shooting King" );
}

public plugin_precache()
{
	server_cmd( "sv_skyname ^"space^"" );
}