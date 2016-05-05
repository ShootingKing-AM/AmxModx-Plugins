/****************************************************************************************************

			Fake Death
				- Shooting King

		1. Cvars:
				1. amx_sk_fdeath_cost - Cost of Fake Death. Default: 2000 
				2. amx_sk_fdeath_corpsestay - Corpse Stay Time ( If you keep long 
				   time it may cause lag ). Default: 15
				3. amx_sk_fdeath_invistime - Invisibility time. Default: 10
				4. amx_sk_fdeath_auto - Automatically use Fake Death, when he has 
				   bought it, and when attacked by an enemy. Default: 1
		
		2. Cmds:
				1. say /buyfdeath - Buy Fake Death.
				2. say_team /buyfdeath - Buy Fake Death.
				3. say /fdeath - Execute fake death.
				4. say_team /fdeath - Execute fake death.

***************************************************************************************************/


#include <amxmodx>
#include <cstrike>
#include <engine>
#include <hamsandwich>

#define PLUGIN		"Fake Death"
#define VERSION		"1.0"
#define AUTHOR		"Shooting King"

#define TASK_HUD	91283

new g_isInFake[33];
new g_TimeRemaining[33];
new g_FakeDeath[33];

new pcvar_cost;
new pcvar_cstay;
new pcvar_invistime;
new pcvar_autofd;

new SyncHudObj;

public plugin_init()
{
	register_plugin( PLUGIN, VERSION, AUTHOR );	
	register_clcmd( "say /fdeath", "cmd_FDeath" );	
	register_clcmd( "say /buyfdeath", "cmd_BuyFDeath" );
	register_clcmd( "say_team /fdeath", "cmd_FDeath" );	
	register_clcmd( "say_team /buyfdeath", "cmd_BuyFDeath" );	
		
	pcvar_cost = register_cvar( "amx_sk_fdeath_cost", "2000" );
	pcvar_cstay = register_cvar( "amx_sk_fdeath_corpsestay", "15" );
	pcvar_invistime = register_cvar( "amx_sk_fdeath_invistime", "10" );
	pcvar_autofd = register_cvar( "amx_sk_fdeath_auto", "1" );
	
	register_event( "HLTV", "Event_RoundStart", "a", "1=0", "2=0" );
	RegisterHam( Ham_TakeDamage, "player", "Event_TakeDamage", false);

	SyncHudObj = CreateHudSyncObj();
}

public Event_RoundStart()
{
	Remove_Entities();

	for( new i = 1; i < 33; i++ )
	{
		if( g_isInFake[i] )
		{
			Remove_Invisibility(i);
		}
		
		if(task_exists(TASK_HUD+i))
		{
			remove_task(TASK_HUD+i);
			g_TimeRemaining[i] = 0;
		}
	}

}

public Event_TakeDamage( id, iInflictor, iAttacker, Float:flDamage, bitsDamageType )
{	
	new szWeapon[32];
	if((get_user_team(iAttacker) != get_user_team(id)) 
	    && is_player(iAttacker) 
	    && (flDamage >= get_user_health(id)) 
	    && get_pcvar_num(pcvar_autofd)
	    && (g_FakeDeath[id] > 0)
	    && !g_isInFake[id])
	{
		Fake_Death(id);

		get_weaponname( get_user_weapon(iAttacker), szWeapon, charsmax(szWeapon));
		replace( szWeapon, 32, "weapon_", "" ); 
		DeathMsg( iAttacker, id, szWeapon);		
		
		return HAM_SUPERCEDE;
	}	
	return HAM_IGNORED;
}

public client_putinserver(id)
{
	g_isInFake[id] = 0;
	g_TimeRemaining[id] = 0;
	g_FakeDeath[id] = 0;
	if(task_exists(TASK_HUD+id))
	{
		remove_task(TASK_HUD+id);
	}
}

public cmd_BuyFDeath(id)
{
	new iMoney, iCost;
	iMoney = cs_get_user_money(id);
	iCost = get_pcvar_num( pcvar_cost );

	if( iMoney >= iCost )
	{
		g_FakeDeath[id]++;
		cs_set_user_money( id, iMoney-iCost, 1 ); 
		client_print( id, print_chat, "You have bought Fake Death." );
	}
	else
	{
		client_print( id, print_chat, "You dont have %d$.", iCost );
	}
}

public cmd_FDeath(id)
{
	Fake_Death(id);
}

public Fake_Death(id)
{
	if( g_isInFake[id] )
	{
		client_print( id, print_chat, "You have to wait %d Seconds.", g_TimeRemaining[id] );
		return PLUGIN_CONTINUE;
	}
	
	if( g_FakeDeath[id] < 1 )
	{
		client_print( id, print_chat, "You dont have Fake Death." );
		return PLUGIN_CONTINUE;	
	}
	
	new szModel[64], szTempModel[32];
	new Ent, Float:Origin[3], Float:Angle[3];
	new iRand = random_num( 101, 110 );
	
	new Float:Maxs[3] = {16.0,16.0,36.0};
	new Float:Mins[3] = {-16.0,-16.0,-36.0};	
	
	szModel[0] = '^0';
	cs_get_user_model( id, szTempModel, 31 );
	formatex( szModel, 63, "models/player/%s/%s.mdl", szTempModel, szTempModel);
	entity_get_vector( id, EV_VEC_origin, Origin);	
	entity_get_vector( id, EV_VEC_v_angle, Angle);
	
	Ent = create_entity( "info_target" );	
	entity_set_string( Ent, EV_SZ_classname,"Ent_FDeath");

	entity_set_model( Ent, szModel);
	entity_set_string( Ent, EV_SZ_model, szModel); 
		
	entity_set_int( Ent, EV_INT_movetype, MOVETYPE_PUSH);	
	entity_set_int( Ent, EV_INT_solid, SOLID_BSP);
	entity_set_float( Ent, EV_FL_animtime, 2.0);
	entity_set_float( Ent, EV_FL_framerate, 1.0);
	entity_set_int( Ent, EV_INT_sequence, iRand);
	entity_set_size( Ent, Mins, Maxs);
	entity_set_vector( Ent, EV_VEC_v_angle, Angle);
	entity_set_edict( Ent, EV_ENT_owner, id);
	
	entity_set_origin( Ent, Origin);
	drop_to_floor( Ent );
		
	set_rendering( id, kRenderFxNone, 0,0,0, kRenderTransAdd, 1);
		
	set_task( get_pcvar_float(pcvar_invistime), "Remove_Invisibility", id);
	set_task( get_pcvar_float(pcvar_cstay), "Remove_Ent", Ent);
	
	g_isInFake[id] = 1;
	g_TimeRemaining[id] = get_pcvar_num( pcvar_invistime );
	g_FakeDeath[id]--;
	client_print( id, print_chat, "You have %d Fake Death remaining...", g_FakeDeath[id]); 
	
	ShowHUDTime(id+TASK_HUD);	
	return PLUGIN_HANDLED;
}

public ShowHUDTime(id)
{
	id -= TASK_HUD;
	if( g_TimeRemaining[id] > 0 )
	{
		set_hudmessage( 0, 250, 0 , 0.95, 0.65, 0, 6.0, 2.0, 0.2, 0.3, 4 );
		ShowSyncHudMsg( id, SyncHudObj, "%d Seconds Remaining...", g_TimeRemaining[id]);
		g_TimeRemaining[id]--;
		set_task( 1.0, "ShowHUDTime", TASK_HUD+id);
	}
	else
	{
		set_hudmessage( 250, 0, 0 , 0.95, 0.65, 1, 6.0, 3.0, 0.2, 0.3, 4 );
		ShowSyncHudMsg( id, SyncHudObj, "You are visible Now." );
	}
}

public Remove_Invisibility(id)
{
	set_rendering( id, kRenderFxNone, 0,0,0, kRenderNormal, 0);
	FixAttrib(id);
	g_isInFake[id] = 0;		
}
	
public Remove_Ent(Ent)
{
	remove_entity(Ent);
}

stock Remove_Entities()
{
	new temp_ent = find_ent_by_class(temp_ent, "Ent_FDeath");

	while( temp_ent > 0) 
	{
		remove_entity(temp_ent);
		temp_ent = find_ent_by_class(temp_ent, "Ent_FDeath");
	}
}

stock is_player(id)
{
	if( 1 <= id <= get_maxplayers())
	{
		return 1;
	}
	return 0;
}

stock DeathMsg(iKiller, iVictim, const szWeapon[])
{
	message_begin(MSG_BROADCAST, get_user_msgid("DeathMsg")); 
	write_byte(iKiller);
	write_byte(iVictim);
	write_byte(0);
	write_string(szWeapon);
	message_end();
}

stock FixAttrib(id)
{
	message_begin(MSG_BROADCAST, get_user_msgid("ScoreAttrib"));
	write_byte(id);
	write_byte(0); 
	message_end();
}