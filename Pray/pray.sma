#include <amxmodx>
#include <engine>

#define PLUGIN		"Pray Plugin"
#define VERSION		"1.0"
#define AUTHOR		"Shooting King"

#define TASK_PRAY	78238

new bool:HasPrayed[33][2];
new pCvar_Hp;

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR);
	register_clcmd("say /pray", "cmd_GiveHp");
	register_clcmd("say_team /pray", "cmd_GiveHp");

	pCvar_Hp = register_cvar("amx_sk_pray_hp", "20");
	
	register_event("HLTV", "event_NewRound", "a", "1=0", "2=0");
}

public event_NewRound()
{
	for(new i=1; i < 33; i++)
	{
		HasPrayed[i][1] = false;
		HasPrayed[i][0] = false;
	}
}

public client_putinserver(id)
{
	HasPrayed[id][1] = false;
	HasPrayed[id][0] = false;
}

public cmd_GiveHp(id)
{
	static iSpecMode, iSpecPlayer, szName[32], szSpecName[32], izParam[1];
	
	iSpecMode = entity_get_int(id, EV_INT_iuser1);
	if(iSpecMode == 0 || iSpecMode == 3)
	{
		client_print( id, print_chat, "You are not Spectating a player." );
		return PLUGIN_CONTINUE;
    }
	
	if(HasPrayed[id][0])
	{
		client_print( id, print_chat, "You have to wait for 2.5 seconds." );
		return PLUGIN_CONTINUE;
	}
	
	if(HasPrayed[id][1])
	{
		client_print( id, print_chat, "You have already prayed this round." );
		return PLUGIN_CONTINUE;
	}
	
	iSpecPlayer = entity_get_int(id, EV_INT_iuser2);
	if(entity_get_float(iSpecPlayer, EV_FL_health) == 100.0)
	{	
		client_print( id, print_chat, "The Player you are spectating already has 100 Hp." );
		return PLUGIN_CONTINUE;
	}
	
	get_user_name( id, szName, charsmax(szName));
	get_user_name( iSpecPlayer, szSpecName, charsmax(szSpecName));
	
	client_print( 0, print_chat, "%s has just prayed for %s.", szName, szSpecName);
	izParam[0] = iSpecPlayer;
	HasPrayed[id][0] = true;
	set_task( 2.5, "Pray", (TASK_PRAY+id), izParam, 1);
	return PLUGIN_CONTINUE;
}

public Pray( param[1], id )
{
	id -= TASK_PRAY;
	static Float:flCvarHealth, Float:flHealth, Float:flRemPlayerHealth;	
	
	flRemPlayerHealth = 100.0-entity_get_float(param[0], EV_FL_health);
	
	if( is_user_alive(param[0]) && (flRemPlayerHealth > 0.0))
	{	
		flCvarHealth = get_pcvar_float(pCvar_Hp);
		flHealth = ( flRemPlayerHealth >= flCvarHealth )? flCvarHealth:flRemPlayerHealth;
		
		entity_set_float(param[0], EV_FL_health, entity_get_float(param[0], EV_FL_health)+flHealth);
		HasPrayed[id][1] = true;
	}
	HasPrayed[id][0] = false;
}