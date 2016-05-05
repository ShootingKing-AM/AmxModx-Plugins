#include <amxmodx>
#include <nvault>
#include <zombieplague>
// #include <iplock>

#define TASKLOAD	72381
#define TASKHUD		81234

#define is_valid_player(%1) (1 <= %1 <= 32) 

enum
{
	CS_TEAM_T = 1,
	CS_TEAM_CT
};

stock const FIRST_JOIN_MSG[] =		"#Team_Select";
stock const FIRST_JOIN_MSG_SPEC[] =	"#Team_Select_Spect";
const iMaxLen = sizeof(FIRST_JOIN_MSG_SPEC);

new g_Vault;
new g_LoginVault;
new gSelectedPlayer[33];

new bool:g_LoggedIn[33];
new g_RegisterSelection[33];
new g_szTempName[33][64];
new g_szTempPassWord[33][64];
new g_szPassword[33][64];

public plugin_init()
{
	register_plugin( "[ZP] SK Ammo Bank", "1.3", "Shooting King" );
	// CheckServerIp("183.87.110.11:27015")

	register_clcmd( "say /donate", "cmdDonate" );
	register_clcmd( "say_team /donate", "cmdDonate" );
	register_clcmd( "say /login", "menuRegister" );
	register_clcmd( "say_team /login", "menuRegister" );

	register_message(get_user_msgid("ShowMenu"), "message_ShowMenu");
	register_message(get_user_msgid("VGUIMenu"), "message_VGUIMenu");

	register_clcmd( "jointeam", "cmdBlock")
	register_clcmd( "joinclass", "cmdBlock")

	register_clcmd( "donation_amount", "cmdDonation" );
	register_clcmd( "Username", "cmdUsername" );
	register_clcmd( "szPassword", "cmdPw" );

	g_Vault = nvault_open( "SkAmmoBank" );
	g_LoginVault = nvault_open( "SkAmmoBankLogin" );

	nvault_prune( g_Vault , 0 , get_systime()-(86400*30) );
	nvault_prune( g_LoginVault , 0 , get_systime()-(86400*30) );
	set_task( 120.0, "Advertise", .flags="b" );
}

public client_command(id)
{
	static cmd[11], arg[4];
	read_argv(0, arg, 3);
	remove_quotes(arg);
	// log_amx( "%s - %s", arg, cmd );

	if( !equal(arg, "say", 3) )
		return PLUGIN_CONTINUE;

	read_args( cmd, 10 );
	remove_quotes(cmd);

	if( equali(cmd, "/bank", 5) || equali(cmd, "/withdraw", 9) || equali(cmd, "/deposit", 8) 
		|| equali(cmd, "^"/bank", 6) || equali(cmd, "^"/withdraw", 10) || equali(cmd, "^"/deposit", 9) )
	{
		client_printc( id, "!t[ !gSK BANK!t ]!n Our bank automatically loads and saves ammopacks on your account." );
		client_printc( id, "!t[ !gSK BANK!t ]!n /bank, /withdraw, /deposit commans are useless." );
	}
	return PLUGIN_CONTINUE;
}

public Advertise()
{
	client_printc( 0, "!t[ !gSK BANK!t ]!n This server is using !tSk Ammo Bank!n, by !gShooting King::d( ^^ _ ^^ )b!n." );
	client_printc( 0, "!t[ !gSK BANK!t ]!n To donate ammo to other players say '!t/donate!n'." );
}

public cmdBlock(id)
{
	if( !g_LoggedIn[id] && !is_user_bot(id))
		return PLUGIN_HANDLED;
	return PLUGIN_CONTINUE;
}

public message_ShowMenu(iMsgid, iDest, id)
{
	if( g_LoggedIn[id] || is_user_bot(id))
		return PLUGIN_CONTINUE;

	static sMenuCode[iMaxLen];
	get_msg_arg_string(4, sMenuCode, sizeof(sMenuCode) - 1);
	if(equal(sMenuCode, FIRST_JOIN_MSG) || equal(sMenuCode, FIRST_JOIN_MSG_SPEC))
	{
		return PLUGIN_HANDLED;
	}
	return PLUGIN_CONTINUE;
}

public message_VGUIMenu(iMsgid, iDest, id)
{
	if( g_LoggedIn[id] || is_user_bot(id))
		return PLUGIN_CONTINUE;

	static temp; temp = get_msg_arg_int(1);

	if(temp == 2 || temp == 27 || temp == 26)
	{
		return PLUGIN_HANDLED;
	}
	return PLUGIN_CONTINUE;
}

public plugin_end()
{
    nvault_close( g_Vault );
    nvault_close( g_LoginVault );
}

public client_connect(id)
{
	g_LoggedIn[id] = false;
}

public client_putinserver(id)
{
	if( !is_user_bot(id) )
	{
		set_task( 2.0, "taskMenuRegister", id+TASKLOAD );
		set_task( 1.0, "ShowInstrunctions", id+TASKHUD, .flags="b" );
	}
}

public ShowInstrunctions(id)
{
	id -= TASKHUD;
	set_hudmessage( 0, 255, 0, .y=0.25, .effects=0, .fxtime=0.5, .holdtime=1.2, .channel=-1 );
	show_hudmessage( id, "If you are new to Server choose ^"New Account^" and enter username and pass.\
		To enter your registered username and password choose ^"Login^".^n\
		To exit from the process type ^"exit^" as username or password.^n\
		To re-choose options please type ^"/login^" after exiting." );
}

public taskMenuRegister(id) menuRegister( id-TASKLOAD );

public client_disconnect(id)
{
	SaveAmmoPacks(id);
}

public cmdDonate(id)
{
	new menu = menu_create( "\rSk Bank \yDonate Menu", "hDonateMenu" );

	new izPlayers[32], szBuffer[3], szName[32], iNum, temp;
	get_players( izPlayers, iNum );

	while( --iNum >= 0 )
	{
		temp = izPlayers[iNum];
		if( temp == id ) continue;
		get_user_name( temp, szName, 31 );
		num_to_str( temp, szBuffer, 2 );
		menu_additem( menu, szName, szBuffer, 0 );
	}

	menu_display( id, menu, 0 );
}

public hDonateMenu(id, menu, item)
{
	if( item == MENU_EXIT )
	{
		menu_destroy( menu );
		return PLUGIN_HANDLED;
	}

	new szData[6];
	new item_access, item_callback;
	menu_item_getinfo( menu, item, item_access, szData, charsmax(szData), _, _, item_callback );

	gSelectedPlayer[id] = str_to_num(szData);
	client_cmd( id, "messagemode donation_amount" );

	return PLUGIN_HANDLED;
}

public cmdDonation(id)
{
	new szData[32], szName[32];
	new money, iData;

	read_args(szData, 12)
	remove_quotes(szData);
	trim(szData);
	
	if( equal(szData, "") || equal(szData, " ") )
		return PLUGIN_HANDLED;

	if( !is_str_num(szData) )
	{
		client_printc( id, "!t[ !gSK BANK!t ]!n Not a Valid Number." );
		return PLUGIN_HANDLED;
	}

	money = str_to_num( szData );
	iData = zp_get_user_ammo_packs( id );

	if( iData < money )
	{
		client_printc( id, "!t[ !gSK BANK!t ]!n You dont have enough ammopacks to donate." );
		return PLUGIN_HANDLED;
	}
	
	zp_set_user_ammo_packs( id, iData-money );
	iData = gSelectedPlayer[id];
	zp_set_user_ammo_packs( iData, zp_get_user_ammo_packs(iData)+money );

	get_user_name( id, szName, 31 );
	get_user_name( iData, szData, 31 );
	client_printc( 0, "!t[ !gSK BANK!t ]!n %s dontated %d ammo packs to %s.", szName, money, szData );

	return PLUGIN_HANDLED;
}

public menuRegister(id)
{
	static menuLoginCreate;
	if( g_LoggedIn[id] )
	{
		client_printc( id, "!t[ !gSK BANK!t ]!n You are already Loged-In. Please reconnect to login again." );
	}		
	else if(is_valid_player(id))
	{
		menuLoginCreate = menu_create("\rSk Bank \yLogin Menu", "menuLoginCreateHandler");
		
		menu_additem(menuLoginCreate, "\wNew Account", "", 0);
		menu_additem(menuLoginCreate, "\rLogin^n", "", 0);
		
		menu_display(id, menuLoginCreate, 0);
		return PLUGIN_HANDLED;
	}	
	return PLUGIN_HANDLED;
}

public menuLoginCreateHandler(id, menuLoginCreate, item)
{
	if( item == MENU_EXIT )
	{
		// server_cmd( "kick #%d ^"You should login properly to play.^"", id );
		return PLUGIN_HANDLED;
	}

	switch(item)
	{
		case 0:
		{
			g_RegisterSelection[id] = 1;
			client_cmd(id, "messagemode Username");
		}
		case 1:
		{
			g_RegisterSelection[id] = 2;
			client_cmd(id, "messagemode Username");
		}
	}
	return PLUGIN_HANDLED;
}

public cmdUsername(id)
{
	if(g_LoggedIn[id])
	{
		return PLUGIN_HANDLED;
	}
	
	read_args(g_szTempName[id], 63);
	remove_quotes(g_szTempName[id]);
	
	if(contain(g_szTempName[id], " ") != -1 || strlen(g_szTempName[id]) < 3)
	{
		client_printc( id, "!t[ !gSK BANK!t ]!n Invalid Username. Try another one now.");
		client_cmd(id, "messagemode Username");
		
		return PLUGIN_HANDLED;
	}

	if(equali(g_szTempName[id], "exit"))
	{
		// server_cmd( "kick #%d ^"You should login properly to play.^"", id );
		return PLUGIN_HANDLED;
	}

	if(g_RegisterSelection[id])
	{
		new timestamp;
		new ret = nvault_lookup( g_LoginVault, g_szTempName[id], g_szPassword[id], 63, timestamp );
		
		switch(g_RegisterSelection[id])
		{
			case 1:
			{
				if(!ret)
				{
					client_cmd(id, "messagemode szPassword")
				}
				else
				{
					client_printc( id, "!t[ !gSK BANK!t ]!n This username is already given to someone else. Try another one now.")
					client_cmd(id, "messagemode Username")
				}
			}
			case 2:
			{
				if(!ret)
				{
					client_printc( id, "!t[ !gSK BANK!t ]!n This username is not registered on this server. Please try it again now!")
					client_cmd(id, "messagemode Username")
				}
				else
				{
					client_cmd(id, "messagemode szPassword")
				}
			}
		} 	
	}	
	return PLUGIN_CONTINUE
}

public cmdPw(id)
{
	if(g_LoggedIn[id] == true)
	{
		return PLUGIN_HANDLED
	}
	
	read_args(g_szTempPassWord[id], 63)
	remove_quotes(g_szTempPassWord[id])

	static szClass[2], szTeam[2]; 
	formatex( szClass, 1, "%d", random_num(1,4));
	formatex( szTeam, 1, "%d", random_num(CS_TEAM_T,CS_TEAM_CT));

	if(contain(g_szTempPassWord[id], " ") != -1 || strlen(g_szTempPassWord[id]) < 3 || strlen(g_szTempName[id]) < 3)
	{
		client_printc( id, "!t[ !gSK BANK!t ]!n Invalid Password. Try another one now.")
		client_cmd(id, "messagemode szPassword")
		
		return PLUGIN_HANDLED
	}
	
	if(equali(g_szTempPassWord[id], "exit"))
	{
		// server_cmd( "kick #%d ^"You should login properly to play.^"", id );
		return PLUGIN_HANDLED;
	}

	switch(g_RegisterSelection[id])
	{
		case 1:
		{
			nvault_set( g_LoginVault, g_szTempName[id], g_szTempPassWord[id] );
			
			engclient_cmd(id, "jointeam", szTeam)
			engclient_cmd(id, "joinclass", szClass )
			remove_task(id+TASKHUD);
			g_LoggedIn[id] = true
			
			client_printc( id, "!t[ !gSK BANK!t ]!n You successfully created a new Account")
			client_printc( id, "!t[ !gSK BANK!t ]!n Username = '%s'", g_szTempName[id])
			client_printc( id, "!t[ !gSK BANK!t ]!n Password = '%s'", g_szTempPassWord[id])
		}
		case 2:
		{			
			if(equal(g_szTempPassWord[id], g_szPassword[id]))
			{
				engclient_cmd(id, "jointeam", szTeam)
				engclient_cmd(id, "joinclass", szClass )
				remove_task(id+TASKHUD);
				g_LoggedIn[id] = true
				LoadAmmoPacks(id);
			
				client_printc( id, "!t[ !gSK BANK!t ]!n Welcome %s.", g_szTempName[id])
			}
			else
			{
				client_printc( id, "!t[ !gSK BANK!t ]!n Wrong Password! Try it again please.")
				client_cmd(id, "messagemode szPassword")
			}
		}
	}	
	return PLUGIN_CONTINUE
}

public SaveAmmoPacks(id)
{
	new szValue[12];

	if( g_LoggedIn[id] )
	{
		formatex( szValue, 12, "%d", zp_get_user_ammo_packs(id) );
		nvault_set( g_Vault , g_szTempName[id], szValue );
	}
}

public LoadAmmoPacks(id)
{
	if( g_LoggedIn[id] )
	{
		new iPacks = nvault_get( g_Vault , g_szTempName[id] );
		if( iPacks )
		{
			zp_set_user_ammo_packs( id, iPacks );
			client_printc( id, "!t[ !gSK BANK!t ]!n %d AmmoPacks are withdrawn from your account.", iPacks)
		}
	}
}

stock client_printc(const id, const input[], any:...)
{
	new count = 1, players[32]
	static msg[191]
	vformat(msg, 190, input, 3)
	
	replace_all(msg, 190, "!g", "^x04") // Green Color
	replace_all(msg, 190, "!n", "^x01") // Default Color
	replace_all(msg, 190, "!t", "^x03") // Team Color
	
	if (id) players[0] = id; else get_players(players, count, "ch")
	{
		for (new i = 0; i < count; i++)
		{
			if (is_user_connected(players[i]))
			{
				message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("SayText"), _, players[i])
				write_byte(players[i])
				write_string(msg)
				message_end()
			}
		}
	}
}