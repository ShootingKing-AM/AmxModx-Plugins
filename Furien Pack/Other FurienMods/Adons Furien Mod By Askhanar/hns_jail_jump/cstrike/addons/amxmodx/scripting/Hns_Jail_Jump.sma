/* 

Plugin: H'N'S Jail Jump
Version: 1.0
Author: sPuf ? 

Description:

Le da playerilor posibilitatea de a ramane cu 1hp
      atunci cand acestia jail pe harta awp_rooftops.
      
      
      
(c)2011 www.godplay.ro 

*/
#include <amxmodx>
#include <fakemeta>
#include <hamsandwich>

#pragma semicolon 1


static const PLUGIN_NAME[] 	= "H'N'S Jail Jump";
static const PLUGIN_AUTHOR[] 	= "sPuf ?";
static const PLUGIN_VERSION[]	= "1.0";

new Float:Min[3]= {873.560485,1641.077392,768.031250};
new Float:Max[3] = {973.560485,1741.077392,840.031};

public plugin_init() {
	new mapName[33];
	get_mapname(mapName, 32);
	
	if(!equali(mapName, "awp_rooftops", 12) || equali(mapName, "awp_rooftops_remake", 19)) {
		new pluginName[33];
		format(pluginName, 32, "[Dezactivat] %s", PLUGIN_NAME);
		register_plugin(pluginName,PLUGIN_VERSION,PLUGIN_AUTHOR);
		pause("ade");
	} else {
		register_plugin(PLUGIN_NAME, PLUGIN_VERSION, PLUGIN_AUTHOR);
		RegisterHam(Ham_TakeDamage, "player", "fwd_TakeDamage", 0);
	}
}
public fwd_TakeDamage(id, idinflictor, idattacker, Float:damage, damagebits) {
	if(damagebits & DMG_FALL) {
		if(is_in_zone(id)) {
			new health = get_user_health(id);
			if(health < 100) {
				user_kill (id,1);
			} else {
				fm_set_user_health(id, 1);
			}
			return HAM_SUPERCEDE;
		}else {
			return HAM_IGNORED;
		}
	}
	return HAM_IGNORED;
}
//i took a look in ConnorMcLeon's NoKillZones plugin..
stock is_in_zone(id) {
	new Float:Origin[3];
	pev(id, pev_origin, Origin);

	if(Min[0] < Origin[0] && Min[1] < Origin[1] && Min[2] < Origin[2] && Max[0] > Origin[0] && Max[1] > Origin[1] && Max[2] > Origin[2] )
		return 1;

	return 0;
}
//from fakemeta_util
stock fm_set_user_health(index, health) {
	health > 0 ? set_pev(index, pev_health, float(health)) : dllfunc(DLLFunc_ClientKill, index);

	return 1;
}