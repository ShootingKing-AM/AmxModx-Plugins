#include <amxmodx>
#include <cstrike>

#define ACCESS		ADMIN_BAN


#define PLUGINNAME    "Change Teams"
#define VERSION        "1.0"
#define AUTHOR        "sPuf ?"

public plugin_init()
{
	register_plugin(PLUGINNAME, VERSION, AUTHOR)
	register_clcmd( "say /changeteams", "sayChangeTeams" );
	
}
public SwitchTeams(id) 
{
	if(!has_access(id) )
	{
		client_print(id,print_chat,"You have no access to that command !");
		return PLUGIN_HANDLED;
	}
	
	new iPlayers[32], iNum;
	get_players(iPlayers, iNum, "h");
	
	if( iNum )
	{
		new id;
		for(--iNum; iNum >= 0; iNum--)
		{
			id = iPlayers[iNum];
			if(is_t_user(id) ) cs_set_user_team(id, CS_TEAM_CT)
			else if(is_ct_user(id) ) cs_set_user_team(id, CS_TEAM_T)
		}
	}
	return PLUGIN_CONTINUE;
}
stock is_ct_user(id) 
{
	
	if(is_user_connected(id) && !is_user_bot(id) && cs_get_user_team(id) == CS_TEAM_CT )
		return 1;
		
	return 0;
}
stock is_t_user(id)
{
	
	if(is_user_connected(id) && !is_user_bot(id) && cs_get_user_team(id) == CS_TEAM_T )
		return 1;
		
	return 0;
}
stock has_access(id)
{
	
	if( get_user_flags(id) & ACCESS )
       		return 1;
		
	return 0;
}