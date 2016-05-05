/***************************************************************

		Special Catch Mod
				- Shooting King

	Credits:
		1. ConnorMcLeod
		2. Exolent
		3. ArkShine


***************************************************************/

#include <amxmodx>
#include <cstrike>
#include <fun>
#include <hamsandwich>

#define PLUGIN		"Special Catch Mod"
#define VERSION		"1.0"
#define AUTHOR		"Shooting King"

new gizCTModels[] = { 1,5,6,7,11 };

new gizTModels[] = { 2,3,4,8,10 };

new gszJoinClass[][] = { "1","2","3","4" };

// Old Style Menus				-----EXolents Team JOIN
stock const FIRST_JOIN_MSG[] =		"#Team_Select";
stock const FIRST_JOIN_MSG_SPEC[] =	"#Team_Select_Spect";
const iMaxLen = sizeof(FIRST_JOIN_MSG_SPEC);

// New VGUI Menus				-----EXolents Team JOIN
stock const VGUI_JOIN_TEAM_NUM 	=	2;

stock const WEP_KNIFE_ID 	= 	29;
stock const TEAM_T		=	1;
stock const TEAM_CT		=	2;

new const g_sBuyCommands[][] =
{
	"usp", "glock", "deagle", "p228", "elites",
	"fn57", "m3", "xm1014", "mp5", "tmp", "p90",
	"mac10", "ump45", "ak47", "galil", "famas",
	"sg552", "m4a1", "aug", "scout", "awp", "g3sg1",
	"sg550", "m249", "vest", "vesthelm", "flash",
	"hegren", "sgren", "defuser", "nvgs", "shield",
	"primammo", "secammo", "km45", "9x19mm", "nighthawk",
	"228compact", "fiveseven", "12gauge", "autoshotgun",
	"mp", "c90", "cv47", "defender", "clarion", "krieg552",
	"bullpup", "magnum", "d3au1", "krieg550"
};

new const MAX_BUY_COMMANDS = sizeof(g_sBuyCommands);

new SyncHudObj, g_iTimes, g_iSet;

new pcvar_times;
new pcvar_ctfrags;
new pcvar_tfrags;
new pcvar_ctspd;
new pcvar_tspd;

public plugin_init()
{
	register_plugin( PLUGIN, VERSION, AUTHOR );
	
	register_message(get_user_msgid("ShowMenu"), "message_ShowMenu");
	register_message(get_user_msgid("VGUIMenu"), "message_VGUIMenu");
	register_logevent("Event_RoundStart", 2, "0=World triggered", "1=Round_Start");	
	register_event( "TextMsg", "Event_RoundEnd", "a", "2&#Game_will_restart_in", "2&#Game_Commencing", "2&#CTs_Win", "2&#Terrorists_Win", "2&#Round_Draw" );	
	register_event( "SendAudio", "Event_TWin", "a", "2&%!MRAD_terwin");
	register_event( "SendAudio", "Event_CTWin", "a", "2&%!MRAD_ctwin");
	register_event( "CurWeapon", "Event_Weapon", "be", "1=1" );
	
	pcvar_times = register_cvar( "amx_sk_times", "5" );	
	pcvar_ctfrags = register_cvar( "amx_sk_ct_winfrags", "2" );	
	pcvar_tfrags = register_cvar( "amx_sk_t_cfrags", "2" );
	pcvar_tspd = register_cvar( "amx_sk_t_speed", "240" );
	pcvar_ctspd = register_cvar( "amx_sk_ct_speed", "250" );	

	register_clcmd( "buy", "HandleBuy" );
	register_clcmd( "buyammo1", "HandleBuy" );
	register_clcmd( "buyammo2", "HandleBuy" );
	register_clcmd( "buyequip", "HandleBuy" );
		
	set_cvar_num( "sv_gravity" , 200 ); 
	set_cvar_num( "sv_airaccelerate", 100 ); 
	set_cvar_num( "sv_airmove" , 10 ); 
	set_cvar_num( "sv_maxspeed", 99999 );
	set_cvar_float( "mp_roundtime",  4.5 );	
	
	SyncHudObj = CreateHudSyncObj();

	RegisterHam(Ham_TakeDamage, "player", "Event_TakeDamage", false);
}

/******* Client Commands *******/
public client_command(id)
{
	new szArg[13];
	read_argv(0, szArg, 12);
	
	if( equali(szArg, "chooseteam") )
	{
		return PLUGIN_HANDLED;
	}
	
	for( new i = 0; i < MAX_BUY_COMMANDS; i++ )
	{
		if( equali(g_sBuyCommands[i], szArg, 0) )
		{
			HandleBuy(id);
			return PLUGIN_HANDLED;
		}
	}
	return PLUGIN_CONTINUE;
}

/******* Message Hooks *******/ 
public message_ShowMenu(iMsgid, iDest, id)
{
	static sMenuCode[iMaxLen];
	get_msg_arg_string(4, sMenuCode, sizeof(sMenuCode) - 1);

	if(equal(sMenuCode, FIRST_JOIN_MSG) || equal(sMenuCode, FIRST_JOIN_MSG_SPEC))
	{
		set_autojoin_task(id, iMsgid);
		return PLUGIN_HANDLED;
	}
	return PLUGIN_CONTINUE;
}

public message_VGUIMenu(iMsgid, iDest, id)
{
	if(get_msg_arg_int(1) != VGUI_JOIN_TEAM_NUM)
	{
		return PLUGIN_CONTINUE;
	}	
	set_autojoin_task(id, iMsgid);
	return PLUGIN_HANDLED;
}

/******* Event Hooks *******/ 
public Event_RoundStart()
{
	g_iTimes = 0;
	g_iSet = 0;
	new szPlayers[32], iNum, iPlayer, i;
	get_players( szPlayers, iNum );

	for( i = 0; i < iNum; i++)
	{
		iPlayer = szPlayers[i];
		ChangeToKnife(iPlayer);
		CheckSpeed(iPlayer);
	}	
}

public Event_RoundEnd()
{
	new szPlayers[32];
	new iNum, iRand, iTRand, i, Player;

	get_players( szPlayers, iNum );		
	
	for( i = 0; i < iNum; i++ )
	{
		Player = szPlayers[i];
		iTRand = random_num( 0, 4 );
		cs_set_user_team( Player, CS_TEAM_CT, gizCTModels[iTRand]);
	}
	
	iRand = random_num( 0, iNum-1 );
	iTRand = random_num( 0, 4 );
	cs_set_user_team( szPlayers[iRand], CS_TEAM_T , gizTModels[iTRand]);
}

public Event_TakeDamage( id, iInflictor, iAttacker, Float:flDamage, bitsDamageType )
{
	new iNum, iRand;
	new szPlayers[32];
	
	get_players( szPlayers, iNum, "ae", "CT" );

	if((get_user_team(iAttacker) == TEAM_T) && is_player(iAttacker) && is_user_connected(iAttacker))
	{
		if( iNum == 1 )
		{
			if( !g_iSet )
			{
				g_iTimes = get_pcvar_num( pcvar_times );
				g_iSet = 1;
			}
			LastCT(id);
		}
		else if( iNum != 0 )
		{ 
			iRand = random_num( 0, 4 );
			cs_set_user_deaths( id, get_user_deaths(id)+1 ); 
			set_user_frags( iAttacker, get_user_frags(iAttacker) + get_pcvar_num(pcvar_tfrags)); 
			
			DeathMsg( iAttacker, id, "knife" );
			cs_set_user_team( id, CS_TEAM_T, gizTModels[iRand] );
			FixAttrib(id);
			CheckSpeed(id);					
		}
		return HAM_SUPERCEDE;
	}	
	return HAM_IGNORED;
}

public Event_Weapon(id)
{
	CheckSpeed(id);	
	if(read_data(2) != WEP_KNIFE_ID)
	{
		ChangeToKnife(id);
		//if(!is_user_bot(id))
		FixAmmoHud(id);
		return PLUGIN_HANDLED;
	}
	return PLUGIN_CONTINUE;
}

public Event_CTWin()
{
	new iParams[2], i, szPlayers[32], iNum, iPlayer;
	iParams[0] = 1;
	get_players( szPlayers, iNum, "ae", "CT" );

	for( i = 0; i < iNum; i++ )
	{
		iPlayer = szPlayers[i];
		set_user_frags( iPlayer, get_user_frags(iPlayer) + get_pcvar_num(pcvar_ctfrags));
	}

	set_task( 0.5, "task_WinMsg", 0, iParams, sizeof(iParams));
}

public Event_TWin()
{
	new iParams[2];
	iParams[0] = 0;
	set_task( 0.5, "task_WinMsg", 0, iParams, sizeof(iParams));
}

/******* Tasks *******/ 
public task_WinMsg(iParams[])
{
	if( iParams[0] )
	{
		set_hudmessage( 0, 250, 0 , -1.0, 0.3, 1, 6.0, 12.0, 0.2, 0.3, 4 );
		ShowSyncHudMsg( 0, SyncHudObj, "Hiders Won The Round.");
	}
	else
	{
		set_hudmessage( 250, 0, 0 , -1.0, 0.3, 1, 6.0, 12.0, 0.2, 0.3, 4 );
		ShowSyncHudMsg( 0, SyncHudObj, "Catchers Won The Round.");
	}
}

public task_Autojoin(iParam[], id)
{
	new szPlayers[32], iNum, iRClass;
	new iMsgid = iParam[0];
	new iMsgBlock = get_msg_block(iMsgid);
	set_msg_block(iMsgid, BLOCK_SET);

	get_players( szPlayers, iNum, "e", "CT" ); 
	if( iNum > 1 )
	{
		engclient_cmd(id, "jointeam", "2");
	}
	else
	{
		engclient_cmd(id, "jointeam", "1");
	}
	
	iRClass = random_num(0, 3);
	engclient_cmd(id, "joinclass", gszJoinClass[iRClass]);
	set_msg_block(iMsgid, iMsgBlock);
}

public LastCT(id)
{
	g_iTimes--;
	if( !g_iTimes )
	{
		user_kill( id );		
		g_iSet = 0;
	}
	else
	{
		set_hudmessage( 250,0, 0 , -0.95, 0.65, 1, 6.0, 12.0, 0.2, 0.3, 4 );
		ShowSyncHudMsg( 0, SyncHudObj, "%d times remaining...", g_iTimes);
	}
}

public HandleBuy(id)
{
	client_print( id, print_center, "Buy Option is Disabled." );
	return PLUGIN_HANDLED;
}

/********* Stock *********/
stock set_autojoin_task(id, iMsgid)
{
	new iParam[2];
	iParam[0] = iMsgid;
	set_task(0.1, "task_Autojoin", id, iParam, sizeof(iParam));
}
stock is_player(id)
{
	if( 1 <= id <= 32 )
	{
		return 1;
	}
	return 0;
}

stock ChangeToKnife(id)
{
	engclient_cmd(id, "weapon_knife");
	//strip_user_weapons(id);
	//give_item( id, "weapon_knife" );	
}

stock CheckSpeed(id)
{
	if( get_user_team(id) == TEAM_T )
	{
		set_user_maxspeed( id, get_pcvar_float(pcvar_tspd));
	}
	else if(get_user_team(id) == TEAM_CT)
	{
		set_user_maxspeed( id, get_pcvar_float(pcvar_ctspd));
	}
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

stock FixAmmoHud(id)
{
	message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("CurWeapon"), { 0, 0, 0 }, id); 
	write_byte(1);
	write_byte(29);
	write_byte(-1);
	message_end();
}