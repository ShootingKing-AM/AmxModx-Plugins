#include <amxmodx>
#include <fakemeta>

#define PLUGIN		"Anti FlashLight"
#define VERSION		"1.0"
#define AUTHOR		"Shooting King"

new bool:g_FlashLight[33];

public plugin_init()
{
	register_plugin( PLUGIN, VERSION, AUTHOR );
	register_clcmd( "say /flashlights", "cmd_ToggleFlashLight" );
	
	register_forward( FM_AddToFullPack, "forward_AddToFullPack_Post", true);
}

public client_putinserver(id)
{
	g_FlashLight[id] = true;
}

public cmd_ToggleFlashLight(id)
{
	g_FlashLight[id] = !g_FlashLight[id];
	
	client_print( id, print_chat, "Anti-FlashLight is now %s.", (g_FlashLight[id])?"ON":"OFF" );
}

public forward_AddToFullPack_Post( e_Handle, iEnt, e_Ent, e_Host, hflags, iPlayer, pSet)
{
	static bitEffects;
	if( iPlayer && g_FlashLight[e_Host] && e_Host != e_Ent && get_orig_retval() &&
		(bitEffects = get_es(e_Handle, ES_Effects)) & EF_DIMLIGHT)
    {
        set_es(e_Handle, ES_Effects, bitEffects & ~EF_DIMLIGHT);
    }	
	
	return FMRES_IGNORED;
}