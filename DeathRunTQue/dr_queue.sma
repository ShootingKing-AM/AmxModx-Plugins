#include <amxmodx>
#include <cstrike>

#define PLUGIN		"[DR] Queue"
#define VERSION		"2.0"
#define AUTHOR		"Shooting King"

new const RANKENCRIPTION = 10;

new gizTModels[] = { 2,3,4,8,10 };
new gizCTModels[] = { 1,5,6,7,11 };

new gszQRanks[33];
new gszEnrolled[33];
new gizEnrolled;
new gMenu, gTMenu;
new gizLastT;

public plugin_init()
{
	register_plugin( PLUGIN, VERSION, AUTHOR );
	
	register_clcmd( "say /addme", "cmd_AddMe" );
	register_clcmd( "say /showme", "cmd_ShowMe" );
	register_clcmd( "say /showq", "cmd_ShowMenu" );
	register_clcmd( "say /remvme", "cmd_RemoveMe" );

	register_logevent( "Event_RoundStart", 2, "1=Round_Start" );
	register_event( "TextMsg", "Event_RoundEnd", "a", "2&#CTs_Win", "2&#Terrorists_Win", "2&#Round_Draw" );
	register_event( "TextMsg", "ResetValues", "a", "2&#Game_will_restart_in", "2&#Game_Commencing" );
}

public client_disconnect(id)
{
	RemoveNUpdateQ(id);
	if( cs_get_user_team(id)  == CS_TEAM_T )
	{
		SetRandomT();
	}	
}

public cmd_AddMe(id)
{
	new iPlace = GetLastPlace()-RANKENCRIPTION;
	if( !gszEnrolled[id] )
	{
		if( iPlace > -1 )
		{
			gszQRanks[iPlace] = id;
		}
		gszEnrolled[id] = 1;
		gizEnrolled++;
		client_print( id, print_chat, "You have been enrolled and your rank is %d", GetPlace(id)-RANKENCRIPTION );
	}
	else
	{
		client_print( id, print_chat, "You have already been enrolled and your rank is %d", GetPlace(id)-RANKENCRIPTION );
	}	
	return PLUGIN_HANDLED;	
}

public cmd_RemoveMe(id)
{
	RemoveNUpdateQ(id);
	client_print( id, print_chat, "You have been removed from the Queue." );
	return PLUGIN_HANDLED;
}

public cmd_ShowMe(id)
{
	if( gszEnrolled[id] )
	{
		client_print( id, print_chat, "Your place in the Queue is %d.", GetPlace(id)-RANKENCRIPTION);
	}
	else
	{
		client_print( id, print_chat, "You have not been enrolled in the Queue.");
	}
	return PLUGIN_HANDLED;
}

public cmd_ShowMenu(id)
{
	if( gizEnrolled < 1 )
	{
		client_print( id, print_chat, "No body has been enrolled in the Queue." );
	}
	else
	{
		ShowMenu(id);
	}
	return PLUGIN_HANDLED;
}

public Event_RoundStart()
{
	if(gizLastT)
	{
		ChangePlayerTeam( gizLastT, CS_TEAM_T );
		handle_menu();
		SetRandomT();		
		gizLastT = 0;
	}
}

public Event_RoundEnd()
{
	new szPlayers[32], szName[32], iNum, iPlayer, i;
	get_players( szPlayers, iNum, "e", "TERRORIST" );

	if( gizEnrolled > 0 )
	{
		for( i = 0; i < iNum; i++ )
		{
			iPlayer = szPlayers[i];
			ChangePlayerTeam( iPlayer, CS_TEAM_CT );
		}

		get_user_name( gszQRanks[0], szName, 32);
		ChangePlayerTeam( gszQRanks[0], CS_TEAM_T );
		RemoveNUpdateQ(gszQRanks[0]);
		client_print( 0, print_chat, "%s has been trasferred to Terrorist", szName );
	}
	else
	{
		gizLastT = szPlayers[0];
		ShowTMenu(gizLastT);
	}	
}

public ShowMenu(id)
{
	new szMenuItem[64], szName[32];
	gMenu = 0;
	gMenu = menu_create("[DR] Queue", "handle_menu", 0);

	for( new i; i < gizEnrolled; i++ )
	{
		szMenuItem[0] = '^0';
		szName[0] = '^0';
		get_user_name( gszQRanks[i], szName, 32);
		formatex( szMenuItem, sizeof(szMenuItem), "%s", szName );

		menu_additem( gMenu, szMenuItem );
	}
	menu_setprop( gMenu, MPROP_EXIT, MEXIT_ALL );
	menu_display( id, gMenu, 0 );
	return PLUGIN_HANDLED;
}

public handle_menu()
{
	menu_destroy( gMenu );
	return PLUGIN_HANDLED;
}

public ShowTMenu(id)
{
	gTMenu = 0;
	gTMenu = menu_create("Want To be in T ??", "handle_Tmenu", 0);
	menu_additem( gTMenu, "Yes !!" );
	menu_additem( gTMenu, "No" );
	
	menu_setprop( gTMenu, MPROP_EXIT, MEXIT_ALL );
	menu_display( id, gTMenu, 0 );
	return PLUGIN_HANDLED;
}
	
public handle_Tmenu( id, menu, item )
{
	if( item == MENU_EXIT )
    	{
		gizLastT = 0;
		menu_destroy( gTMenu );
		return PLUGIN_HANDLED;
    	}
	
	new szName[32];
	get_user_name( gizLastT, szName, 32 );	
	switch (item)
	{
		case 0: 
		{
			client_print( 0, print_chat, "%s choosed to be in TERRORIST Team", szName );
			menu_destroy( gTMenu );
			gizLastT = 0;
			return PLUGIN_HANDLED;
		}
		case 1: 
		{	
			SetRandomT();
			ChangePlayerTeam( gizLastT, CS_TEAM_CT );
			menu_destroy( gTMenu );
			gizLastT = 0;
			return PLUGIN_HANDLED;
		}
	}
	gizLastT = 0;
	menu_destroy( gTMenu );
	return PLUGIN_HANDLED;
}

public ResetValues()
{
	for( new i = 0; i < 33; i++ )
	{
		gszQRanks[i] = 0;
		gszEnrolled[i] = 0;
	}
	gizEnrolled = 0;
}

SetRandomT()
{
	new szPlayers[32], iNum, iRand;
	get_players( szPlayers, iNum );
	iRand = random_num( 0 , iNum-1 );
	ChangePlayerTeam( szPlayers[iRand], CS_TEAM_T );
}

ChangePlayerTeam( id, {CsTeams,_}:iTeam)
{
	new iRand = random_num( 0, 4 );

	if( iTeam == CS_TEAM_T )
	{
		cs_set_user_team( id, CS_TEAM_T, gizTModels[iRand] );
	}
	else
	{
		cs_set_user_team( id, CS_TEAM_CT, gizCTModels[iRand] );
	}
}

RemoveNUpdateQ(id)
{
	new iPos, i;

	gszEnrolled[id] = 0;
	gizEnrolled--;
	iPos = GetPlace(id)-RANKENCRIPTION;
	
	for( i = iPos; i < gizEnrolled; i++ )
	{
		gszQRanks[i] = gszQRanks[i+1];
	}
}

GetLastPlace()
{
	new i;
	for( i = 0; i < sizeof(gszQRanks); i++ )
	{
		if( gszQRanks[i] == 0 )
		{
			return (i+RANKENCRIPTION);
		}
	}
	return -1;
}

GetPlace(id)
{
	new i;
	for( i = 0; i < sizeof(gszQRanks); i++ )
	{
		if( gszQRanks[i] == id )
		{
			return (i+1+RANKENCRIPTION);
		}
	}
	return -1;
}