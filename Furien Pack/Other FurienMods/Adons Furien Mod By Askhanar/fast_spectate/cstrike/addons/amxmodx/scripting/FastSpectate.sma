/*
Descriere:
	Cu Acest Plugin pe Serverul Tau Jucatorii Se Pot Pune Spectator Prin Simpla Comanda /spec.
	Si Pot Reveni La Joc Prin Simpla Comanda /back(va fin in fosta echipa)

(c) www.forum.godplay.ro

Plugin: Fast Spectate
Author: sPuf ?
Vers: 1.0

Cvaruri:
	fs_score 1/0 daca este setat 1 cand jucatorul va da /back ii va pune scorul care il avea cand a scris /spec
	fs_messages 1/0 daca este setat 1 cand scrie /spec sau /back ii apar niste mesaje..
	fs_spawn 1/0 daca este setat 1 cand scrie /back va primi spawn
Changelog:
v1.0 prima lansare a pluginului
v2.0 adaugarea cvarurilor fs_spawn fs_score

*/
#include <amxmodx>
#include <cstrike>

#include <ColorChat>
#include <fun>

#pragma semicolon 1

static const PLUGIN_NAME[] 	= "Fast Spectate";
static const PLUGIN_AUTHOR[] 	= "sPuf ?";
static const PLUGIN_VERSION[]	= "2.0";

new gReturn[33],gDeaths[33],gFrags[33];

new cvar_score,cvar_msg,cvar_spawn;

static const TAG[] 	= "*";

public plugin_init() {
	register_plugin(PLUGIN_NAME, PLUGIN_VERSION, PLUGIN_AUTHOR);
	
	cvar_score = register_cvar("fs_score","1");
	cvar_msg = register_cvar("fs_message","1");
	cvar_spawn = register_cvar("fs_spawn","1");
	
	register_clcmd("say /spec","saySpec");
	register_clcmd("say_team /spec","saySpec");
	
	register_clcmd("say /back","sayBack");
	register_clcmd("say_team /back","sayBack");	
}
public saySpec(id) {
	new team = get_user_team(id);
	switch(team) {
		case 1: {
			gReturn[id] = 1;
		}
		case 2: {
			gReturn[id] = 2;
		}
		case 3: {
			if(get_pcvar_num(cvar_msg)) {	
				ColorChat(id,RED,"^x04%s ^x03 Esti Deja Spectator ^x04!",TAG);
			}
			return PLUGIN_HANDLED;
		}
	}
	if(get_pcvar_num(cvar_score) == 1) {	
		gFrags[id] = get_user_frags(id);
		gDeaths[id] = get_user_deaths(id);
	}
	if(is_user_alive(id)) {
		user_silentkill(id);
		cs_set_user_team(id,3);
		if(get_pcvar_num(cvar_msg)) {	
			ColorChat(id,RED,"^x04%s^x03 Ai Fost Transferat Spectator ^x04!",TAG);
			ColorChat(id,RED,"^x04%s^x03 Foloseste Comanda ^x04^"/back^" ^x03Pentru A Reveni In Fosta Echipa ^x04!",TAG);
		}
		return PLUGIN_HANDLED;
	} else {
		cs_set_user_team(id,3);
		if(get_pcvar_num(cvar_msg)) {	
			ColorChat(id,RED,"^x04%s^x03 Ai Fost Transferat Spectator ^x04!",TAG);
			ColorChat(id,RED,"^x04%s^x03 Foloseste Comanda ^x04^"/back^" ^x03Pentru A Reveni In Fosta Echipa ^x04!",TAG);
		}
		return PLUGIN_HANDLED;
	}
	return PLUGIN_CONTINUE;
}
public sayBack(id) {
	if(!(get_user_team(id) == 3) || is_user_alive(id)) {
		if(get_pcvar_num(cvar_msg)) {	
			ColorChat(id,RED,"^x04%s^x03 Poti Folosi Aceasta Comanda Doar Cand Esti Spectator ^x04!",TAG);
			ColorChat(id,RED,"^x04%s^x03 Foloseste Comanda ^x04^"/spec^"^x03 Ca Sa Fii Transferat Spectator ^x04!",TAG);
			return PLUGIN_HANDLED;
		}
	} else {
		switch(gReturn[id]) {
			case 1: {
				cs_set_user_team(id,1);
				if(get_pcvar_num(cvar_msg)) {
					ColorChat(id,RED,"^x04%s^x03 Ai Fost Transferat La Echipa Terrorist ^x04!",TAG);
					ColorChat(id,RED,"^x04%s^x03 Foloseste Comanda ^x04^"/spec^"^x03 Ca Sa Fii Transferat Spectator ^x04!",TAG);
				}
				if(get_pcvar_num(cvar_score)) {	
					cs_set_user_deaths(id, gDeaths[id]);
					set_user_frags(id, gFrags[id]);
					cs_set_user_deaths(id, gDeaths[id]);
					set_user_frags(id, gFrags[id]);
					ColorChat(id,RED,"^x04%s^x03 Scorul Tau Este ^x04%d^x03-^x04%d !",TAG,gFrags[id],gDeaths[id]);
				}
				if(get_pcvar_num(cvar_spawn)) {
					spawn(id);
				}
				return PLUGIN_HANDLED;
			}
			case 2: {
				cs_set_user_team(id,2);
				if(get_pcvar_num(cvar_msg)) {
					ColorChat(id,RED,"^x04%s^x03 Ai Fost Transferat La Echipa Counter-Terrorist ^x04!",TAG);
					ColorChat(id,RED,"^x04%s^x03 Foloseste Comanda ^x04^"/spec^"^x03 Ca Sa Fii Transferat Spectator ^x04!",TAG);
				}
				if(get_pcvar_num(cvar_score)) {	
					cs_set_user_deaths(id, gDeaths[id]);
					set_user_frags(id, gFrags[id]);
					cs_set_user_deaths(id, gDeaths[id]);
					set_user_frags(id, gFrags[id]);
					ColorChat(id,RED,"^x04%s^x03 Scorul Tau Este ^x04%d^x03-^x04%d !",TAG,gFrags[id],gDeaths[id]);
				}
				if(get_pcvar_num(cvar_spawn)) {
					spawn(id);
				}
				return PLUGIN_HANDLED;
			}
		}
	}
	return PLUGIN_CONTINUE;
}
public client_putinserver(id) {
	gDeaths[id] = 0;
	gFrags[id] = 0;
	gReturn[id] = 0;
}
public client_disconnect(id) {
	gDeaths[id] = 0;
	gFrags[id] = 0;
	gReturn[id] = 0;
}
				
	