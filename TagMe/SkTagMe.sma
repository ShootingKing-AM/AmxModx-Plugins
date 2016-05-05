#include <amxmodx>

#define PLUGIN		"Sk TagMe"
#define VERSION		"1.2"
#define AUTHOR		"Shooting King"

#define cm(%1)		(sizeof(%1)-1)

new pCvar_Tag;

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR);
	
	pCvar_Tag = register_cvar("amx_sk_tag", "-=]SINNERS[=- ");
	
	register_clcmd("say_team /tagme", "cmdTagMe");
	register_clcmd("say /tagme", "cmdTagMe");
}

public cmdTagMe(id)
{
	static szName[33], szTag[16];
	
	get_user_name(id, szName, cm(szName));
	get_pcvar_string(pCvar_Tag, szTag, cm(szTag));
	
	if(containi(szName, szTag) != -1)
	{
		client_print(id, print_chat, "[TagMe] You already Have the Tag !");
		return PLUGIN_CONTINUE;
	}
	
	format(szName, cm(szName), "%s%s", szTag, szName);
	set_user_info(id, "name", szName);
	
	return PLUGIN_CONTINUE;
}