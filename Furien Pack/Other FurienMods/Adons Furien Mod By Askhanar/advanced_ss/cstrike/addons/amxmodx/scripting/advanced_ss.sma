#include < amxmodx >
#include < amxmisc >
#include < cstrike >
#include < fun >
#include < CC_ColorChat >


#pragma semicolon 1


#define PLUGIN "New Plugin"
#define VERSION "1.0"

#define SS_ACCESS	ADMIN_SLAY
#define SignTask	112233
#define UnSignTask	332211

enum
{
	
	INFO_NAME,
	INFO_IP,
	INFO_AUTHID
	
};

new const szTag[    ]  =  "*";
new const szSite[    ]  =  "www.indungi.ro/forum";

new g_iUserHP[ 33 ];
new g_iUserAP[ 33 ];

new gCvarMoveSpec;

new SyncHudMessage;
new SyncHudMessage2;
new SyncHudMessage3;

public plugin_init( )
{
	// Idee plugin si primul care l-a publicat: ThE_ChOSeN_OnE
	// Acest cod este scris de mine in totalitate..
	register_plugin( PLUGIN, VERSION, "Askhanar" );
	
	gCvarMoveSpec  =  register_cvar(  "ss_move_spec",  "0"  );
	register_clcmd(  "amx_ss", "ClCmdSS"  );

	SyncHudMessage  =  CreateHudSyncObj(    );
	SyncHudMessage2  =  CreateHudSyncObj(    );
	SyncHudMessage3  =  CreateHudSyncObj(    );
	
}

public client_putinserver(  id  )
{
	g_iUserHP[  id  ]  =  0;
	g_iUserAP[  id  ]  =  0;
}

public client_disconnect(  id   )
{
	g_iUserHP[  id  ]  =  0;
	g_iUserAP[  id  ]  =  0;
	
	if( task_exists(  id + UnSignTask  )  )
	{
		ColorChat(  0, RED, "^x04%s^x03 %s^x01 s-a deconectat in timp ce i s-a facut SS!", szTag, GetInfo(  id,  INFO_NAME  )  );
		remove_task(  id  + UnSignTask  );
	}
}

public ClCmdSS(  id  )
{
	if(  !(  get_user_flags(  id  )  &  SS_ACCESS  )  )
	{
		client_cmd(  id, "echo %s Nu ai acces la aceasta comanda!", szTag  );
		return 1;
	}
	
	new szFirstArg[ 32 ];
	read_argv(  1,  szFirstArg, sizeof ( szFirstArg ) -1  );
	
	if(  equal(  szFirstArg, ""  )  )
	{
		client_cmd(  id, "echo amx_ss < nume > faci o poza semnata!"  );
		return 1;
	}
	
	new iPlayer  =  cmd_target(  id,  szFirstArg,  8  );
	
	if( !iPlayer  )
	{
		client_cmd(  id, "echo %s Jucatorul specificat nu a fost gasit!", szTag  );
		return 1;
	}
	
	if( !is_user_alive(  iPlayer  ) )
	{
		client_cmd(  id, "echo %s Jucatorul %s nu este in viata !", szTag, GetInfo(  iPlayer, INFO_NAME  )  );
		return 1;
	}
	
	if(  task_exists(  iPlayer  +  SignTask)  ||  task_exists(  iPlayer  + UnSignTask  )  )
	{
		client_cmd(  id, "echo %s Jucatorul %s este in curs de 'pozare' !", szTag, GetInfo(  iPlayer, INFO_NAME  )  );
		return 1;
	}
	
	if(  cs_get_user_team(  id  )  !=  CS_TEAM_SPECTATOR  )
	{
		client_cmd(  id, "echo %s Trebuie sa fii Spectator ca sa poti face o poza!", szTag  );
		return 1;
	}
	
	ColorChat(  0,  RED,  "^x04%s^x03 %s^x01 i-a facut o poza semnata lui^x04 %s^x01 !",  szTag,  GetInfo(  id,  INFO_NAME  ),  GetInfo(  iPlayer,  INFO_NAME  )  );
	
	g_iUserHP[ iPlayer ]  =  get_user_health(  iPlayer  );
	g_iUserAP[ iPlayer ]  =  get_user_armor(  iPlayer  );
	
	set_user_godmode(  iPlayer,  1  );
	set_user_health(  iPlayer,  255  );
	set_user_armor(  iPlayer,  255  );
	
	ColorChat(  iPlayer, RED, "^x04%s^x01 Nume:^x03 %s^x04 |^x01 Nume Admin:^x03 %s", szTag, GetInfo(  iPlayer,  INFO_NAME  ), GetInfo(  id, INFO_NAME  )  );
	ColorChat(  iPlayer, RED, "^x04%s^x01 IP:^x03 %s^x04 |^x01 IP Admin:^x03 %s", szTag, GetInfo(  iPlayer, INFO_IP  ),  GetInfo(  id,  INFO_IP  )  );
	ColorChat(  iPlayer, RED, "^x04%s^x01 SteamId:^x03 %s^x04 |^x01 SteamId Admin:^x03 %s", szTag, GetInfo(  iPlayer,  INFO_AUTHID  ),  GetInfo(  id,  INFO_AUTHID  )  );
	ColorChat(  iPlayer, RED, "^x04%s^x01 Data/Ora:^x03 %s^x04 |^x01 Site ^x03%s", szTag, _get_time(    ),  szSite  );
	client_print(  iPlayer,  print_center,  "Screenshot facut.."  );
	
	
	client_print(  iPlayer,  print_console,  " %s Nume: %s | Nume Admin: %s", szTag, GetInfo(  iPlayer,  INFO_NAME  ), GetInfo(  id, INFO_NAME  )  );
	client_print(  iPlayer,  print_console,  " %s IP: %s | IP Admin: %s", szTag, GetInfo(  iPlayer, INFO_IP  ),  GetInfo(  id,  INFO_IP  )  );
	client_print(  iPlayer,  print_console,  " %s SteamId: %s | SteamId Admin: %s", szTag, GetInfo(  iPlayer,  INFO_AUTHID  ),  GetInfo(  id,  INFO_AUTHID  )  );
	client_print(  iPlayer,  print_console,  " %s Data/Ora: %s | Site %s", szTag, _get_time(    ),  szSite  );
	
	for( new i = 1; i <= 3; i++ )
		DisplayMessages(  iPlayer,  i  );
	
	set_task(  0.1, "SignScreen", iPlayer  + SignTask  );
	
	return 1;
}

public SignScreen(  iPlayer  )
{
	
	iPlayer  -=  SignTask;
	if(  !is_user_connected( iPlayer )  )	return 1;
	
	client_cmd(  iPlayer,  "toggleconsole;snapshot;toggleconsole"  );
	
	if( get_pcvar_num(  gCvarMoveSpec  )  )
	{
		user_kill(  iPlayer,  1  );
		cs_set_user_team(  iPlayer,  CS_TEAM_SPECTATOR  );
	}
	
	set_task(  0.7, "UnSignPlayer",  iPlayer + UnSignTask );
	
	return 0;
	
}
	
public UnSignPlayer(  iPlayer  )
{
	iPlayer -= UnSignTask;
	if(  !is_user_connected( iPlayer ) )	return 0;
	
	ColorChat(  iPlayer, RED, "^x04%s^x03 Screenshot semnat..", szTag  );
	client_cmd(  iPlayer,  "echo %s^x03 Screenshot semnat..", szTag  );
	client_print(  iPlayer, print_center,  "Screenshot semnat.."  );
	
	if( is_user_alive(  iPlayer  )  )
	{
		set_user_godmode(  iPlayer,  0  );
		set_user_health(  iPlayer,  g_iUserHP[ iPlayer ]  );
		set_user_armor(  iPlayer,  g_iUserAP[ iPlayer ] );
	}
	
	g_iUserHP[ iPlayer ]  =  0;
	g_iUserAP[ iPlayer ]  =  0;
	
	return 0;
}

public DisplayMessages(  iPlayer,  const iMessage  )
{
	
	new szHostName[ 64 ];
	get_cvar_string( "hostname", szHostName, sizeof ( szHostName ) -1  );
	
	switch(  iMessage  )
	{
		case 1:
		{
			
			set_hudmessage(  255,  0,  0,  0.10, 0.25,  0,  0.0 , 0.2,  0.0,  0.1,  1  );
			ShowSyncHudMsg(  iPlayer,  SyncHudMessage,  "%s",  szHostName  );
		}
		case 2:
		{
			set_hudmessage(  235,  255,  45,  -1.0, -1.0,  0,  0.0 , 0.2,  0.0,  0.1,  2  );
			ShowSyncHudMsg(  iPlayer,  SyncHudMessage2,  "%s",  szHostName  );
		}
		case 3:
		{
			set_hudmessage(  0,  0,  255,  0.75, 0.75,  0,  0.0 , 0.2,  0.0,  0.1,  3  );
			ShowSyncHudMsg(  iPlayer,  SyncHudMessage3,  "%s",  szHostName  );
		}
	}
	
}




stock GetInfo( id, const iInfo )
{
	
	new szInfoToReturn[  64  ];
	
	switch(  iInfo  )
	{
		case INFO_NAME:
		{
			new szName[ 32 ];
			get_user_name(  id,  szName,  sizeof ( szName ) -1  );
			
			copy(  szInfoToReturn,  sizeof ( szInfoToReturn ) -1,  szName  );
		}
		case INFO_IP:
		{
			new szIp[ 32 ];
			get_user_ip(  id,  szIp,  sizeof ( szIp ) -1,  1  );
			
			copy(  szInfoToReturn,  sizeof ( szInfoToReturn ) -1,  szIp  );
		}
		case INFO_AUTHID:
		{
			new szAuthId[ 35 ];
			get_user_authid(  id,  szAuthId,  sizeof ( szAuthId ) -1  );
			
			copy(  szInfoToReturn,  sizeof ( szInfoToReturn ) -1,  szAuthId  );
		}
	}

	return szInfoToReturn;
}

stock _get_time( )
{
	new logtime[ 32 ];
	get_time("%d.%m.%Y - %H:%M:%S", logtime ,sizeof ( logtime ) -1 );
	
	return logtime;
}