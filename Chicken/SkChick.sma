#include <amxmodx>
#include <amxmisc>
#include <fakemeta>

#define PLUGIN		"Sk Chicken"
#define VERSION		"1.0"
#define AUTHOR		"Shooting King"

#define LEVEL 		ADMIN_RCON
#define cm(%1)		(sizeof(%1)-1)

new szModel[] = "models/chick.mdl";
new szClass[] = "sk_chicken";
new bool:Chicken[33];
new gEnt[33];

public plugin_init()
{
	register_plugin( PLUGIN, VERSION, AUTHOR );	
	register_clcmd( "amx_sk_chick", "cmd_Chick" );
	register_clcmd( "amx_sk_unchick", "cmd_UnChick" );
}

public plugin_precache()
{
	precache_model(szModel);
}

public client_PreThink(id)
{
	if( Chicken[id] )
	{
		static Float:Vec[3];		
		pev( id, pev_origin, Vec );
		Vec[2] += 20.0;
		set_pev( gEnt[id], pev_origin, Vec );
		pev( id, pev_angles, Vec);
		set_pev( gEnt[id], pev_angles, Vec );
	}
}

public cmd_UnChick(id, cid)
{
	if (!cmd_access( id, LEVEL, cid, 1)) 
		return PLUGIN_HANDLED;
		
	if( read_argc() != 2 )
	{
		client_print( id, print_console, "Invalid Arguments !!" );
		return PLUGIN_HANDLED;
	}
	
	new szPlayer[32], pid;
	read_argv( 1, szPlayer, cm(szPlayer));	
	pid = find_player( "bl", szPlayer );
	
	szPlayer[0] = '^0';
	get_user_name( pid, szPlayer, 31 );
	client_print( 0, print_chat, "*** Admin Has removed Chicken for %s :(", szPlayer );
	
	Chicken[pid] = false;
	engfunc(EngFunc_RemoveEntity, gEnt[pid]);
	gEnt[pid] = 0;
	
	return PLUGIN_HANDLED;
}

public cmd_Chick(id, cid)
{
	if (!cmd_access( id, LEVEL, cid, 1)) 
		return PLUGIN_HANDLED;
		
	if( read_argc() != 2 )
	{
		client_print( id, print_console, "Invalid Arguments !!" );
		return PLUGIN_HANDLED;
	}
	
	new szPlayer[32], pid;
	read_argv( 1, szPlayer, cm(szPlayer));	
	pid = find_player( "bl", szPlayer );
	
	szPlayer[0] = '^0';
	get_user_name( pid, szPlayer, 31 );
	client_print( 0, print_chat, "*** %s Has a Chicken Now :D", szPlayer );
	
	SetChicken(pid);
	
	return PLUGIN_HANDLED;
}

stock SetChicken(id)
{
	gEnt[id] = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"));
	set_pev( gEnt[id], pev_classname, szClass);
	set_pev( gEnt[id], pev_movetype, MOVETYPE_FLY);
	set_pev( gEnt[id], pev_owner, id);
	set_pev( gEnt[id], pev_sequence, 1 );	
	set_pev( gEnt[id], pev_animtime, 2.0 );
	set_pev( gEnt[id], pev_framerate, 1.0 );
	
	engfunc( EngFunc_SetModel, gEnt[id], szModel);	
	Chicken[id] = true;
}