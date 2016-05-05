/* AMX Mod X
*   Auto Join on Connect
*
* (c) Copyright 2007 by VEN
*
* This file is provided as is (no warranties)
*
*     DESCRIPTION
*       Plugin allow to players automatically join team/team&class on connect.
*
*     CVARS
*       ajc_team (0: OFF, N: team index, 5: auto team, default: 5) - controls team join
*       ajc_class (0: OFF, N: class index, 5: auto class, default: 5) - controls class join
*       ajc_imm (0: OFF, 1: ON, default: 1) - don't affect on immuned players (ON/OFF)
*
*     CREDITS
*       Major__ - inquiry
*/

#include <amxmodx>

#define PLUGIN_NAME "Furien : Auto Join"
#define PLUGIN_VERSION "0.1"
#define PLUGIN_AUTHOR "VEN"

#define IMMUNITY_ACCESS_LEVEL ADMIN_IMMUNITY

#define AUTO_TEAM_JOIN_DELAY 0.1

#define TEAM_SELECT_VGUI_MENU_ID 2

new g_pcvar_team
new g_pcvar_class
new g_pcvar_imm

public plugin_init() {
	register_plugin(PLUGIN_NAME, PLUGIN_VERSION, PLUGIN_AUTHOR)

	register_message(get_user_msgid("ShowMenu"), "message_show_menu")
	register_message(get_user_msgid("VGUIMenu"), "message_vgui_menu")

	g_pcvar_team = register_cvar("ajc_team", "5")
	g_pcvar_class = register_cvar("ajc_class", "5")
	g_pcvar_imm = register_cvar("ajc_imm", "1")
}

public message_show_menu(msgid, dest, id) {
	if (!should_autojoin(id))
		return PLUGIN_CONTINUE

	static team_select[] = "#Team_Select"
	static menu_text_code[sizeof team_select]
	get_msg_arg_string(4, menu_text_code, sizeof menu_text_code - 1)
	if (!equal(menu_text_code, team_select))
		return PLUGIN_CONTINUE

	set_force_team_join_task(id, msgid)

	return PLUGIN_HANDLED
}

public message_vgui_menu(msgid, dest, id) {
	if (get_msg_arg_int(1) != TEAM_SELECT_VGUI_MENU_ID || !should_autojoin(id))
		return PLUGIN_CONTINUE

	set_force_team_join_task(id, msgid)

	return PLUGIN_HANDLED
}

bool:should_autojoin(id) {
	return (get_pcvar_num(g_pcvar_team) && !get_user_team(id) && !task_exists(id) && (!get_pcvar_num(g_pcvar_imm) || !(get_user_flags(id) & IMMUNITY_ACCESS_LEVEL)))
}

set_force_team_join_task(id, menu_msgid) {
	static param_menu_msgid[2]
	param_menu_msgid[0] = menu_msgid
	set_task(AUTO_TEAM_JOIN_DELAY, "task_force_team_join", id, param_menu_msgid, sizeof param_menu_msgid)
}

public task_force_team_join(menu_msgid[], id) {
	if (get_user_team(id))
		return

	static team[2], class[2]
	get_pcvar_string(g_pcvar_team, team, sizeof team - 1)
	get_pcvar_string(g_pcvar_class, class, sizeof class - 1)
	force_team_join(id, menu_msgid[0], team, class)
}

stock force_team_join(id, menu_msgid, /* const */ team[] = "5", /* const */ class[] = "0") {
	static jointeam[] = "jointeam"
	if (class[0] == '0') {
		engclient_cmd(id, jointeam, team)
		return
	}

	static msg_block, joinclass[] = "joinclass"
	msg_block = get_msg_block(menu_msgid)
	set_msg_block(menu_msgid, BLOCK_SET)
	engclient_cmd(id, jointeam, team)
	engclient_cmd(id, joinclass, class)
	set_msg_block(menu_msgid, msg_block)
}
