#include <amxmodx>
#include <amxmisc>
#include <engine>

#define PLUGIN		"Set lights"
#define VERSION		"1.0"
#define AUTHOR		"Shooting King"

new const LEVEL = ADMIN_IMMUNITY;

public plugin_init() 
{
	register_plugin( PLUGIN, VERSION, AUTHOR );
	
	register_clcmd( "amx_sk_slights", "cmd_sLights" );
}

public cmd_sLights(id, cid)
{
	if (!cmd_access(id, LEVEL, cid, 1))
		return PLUGIN_HANDLED;
	
	new szCmd[3];
	read_args( szCmd, charsmax(szCmd));
	set_lights( szCmd );
	return PLUGIN_HANDLED;
}

