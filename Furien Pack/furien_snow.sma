#include <amxmodx>
#include <engine>

public plugin_init()
{
	register_plugin( "Furien : Snow", "1.2", "Shooting King" );
}

public plugin_precache()
{
	create_entity("env_snow");
}