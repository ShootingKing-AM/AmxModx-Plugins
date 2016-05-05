#include <amxmodx>
#include <hamsandwich>
#include <engine>

#define PLUGIN		"Stop Watch [W/o Hrs]"
#define VERSION		"1.2"
#define AUTHOR		"Shooting King"

enum
{
	MINS,
	SECS,
	MSECS
};

enum
{
	RUNNING,
	PAUSE,
	RESUME
};

new g_SyncHud, g_MenuCallback;
new g_hMenu[33];
new g_PlayerWatchStatus[33];
new g_StopWatchTime[33][4];

new const g_ClassName[] = "sk_StopWatch";

public plugin_init()
{
	register_plugin( PLUGIN, VERSION, AUTHOR );
	
	register_clcmd( "say /sw", "Show_SWMenu" );
	register_clcmd( "say_team /sw", "Show_SWMenu" );
	RegisterHam( Ham_Killed, "player", "Ham_Killed_Pre", false);
	g_MenuCallback = menu_makecallback( "MenuCallback" );
	
	new iEnt = create_entity("info_target");
	entity_set_string(iEnt, EV_SZ_classname, g_ClassName);
	entity_set_float(iEnt, EV_FL_nextthink, get_gametime() + 0.01);
	register_think(g_ClassName, "ForwardThink");
	
	g_SyncHud = CreateHudSyncObj();
}

public Ham_Killed_Pre(id)
{	
	ResetWatch(id);
	if( g_hMenu[id] )	
	{
		menu_destroy(g_hMenu[id]);
		show_menu(id, 0, "^n", 1); 
		g_hMenu[id] = 0;
		return PLUGIN_HANDLED;
	}
	return PLUGIN_CONTINUE;
}

public Show_SWMenu(id)
{
	if( !is_user_alive(id) )
	{
		client_print( id, print_chat, "Stop Watch is only for alive players !!" );
		return PLUGIN_HANDLED;
	}
	
	if( g_hMenu[id] )	
	{
		client_print( id, print_chat, "Stop Watch is already active !!" );
		return PLUGIN_HANDLED;
	}
	
	g_hMenu[id] = menu_create( "**** Stop Watch ****", "handler_SWMenu" );
	
	menu_additem( g_hMenu[id], "Start", "", 0, g_MenuCallback );
	menu_additem( g_hMenu[id], "Reset", "", 0, g_MenuCallback );
	
	menu_setprop( g_hMenu[id], MPROP_EXIT, MEXIT_ALL );
	menu_display( id, g_hMenu[id], 0 );
	
	return PLUGIN_CONTINUE;
}

public MenuCallback( id, hMenu, item )
{
	if( !item )
	{
		switch(g_PlayerWatchStatus[id])
		{
			case RUNNING:	menu_item_setname( hMenu, item, "Start");
			case PAUSE:		menu_item_setname( hMenu, item, "Pause");
			case RESUME:	menu_item_setname( hMenu, item, "Resume");
		}
	}
}

public handler_SWMenu( id, hMenu, item )
{
	switch(item)
	{
		case 0:
		{			
			g_PlayerWatchStatus[id]++;
			if( g_PlayerWatchStatus[id] > 2 )
			{
				g_PlayerWatchStatus[id] = 1;
			}
			menu_display( id, hMenu, 0 );
		}
		case 1:
		{
			ResetWatch(id);
			menu_display( id, hMenu, 0 );
		}
		default:
		{
			ResetWatch(id);
			g_hMenu[id] = 0;
			menu_destroy( hMenu );
			return PLUGIN_HANDLED;
		}
	}	
	return PLUGIN_HANDLED;
}

public ForwardThink(iEnt)
{
	static tempid;
	static izPlayers[32], iNum;
	get_players( izPlayers, iNum );
	set_hudmessage( 0, 250, 0, _, _, _, _, 0.1, _, _, -1)
	while( --iNum >= 0 )
	{
		tempid = izPlayers[iNum];
		
		if( is_user_connected(tempid) && g_PlayerWatchStatus[tempid] )
		{			
			ShowSyncHudMsg(tempid, g_SyncHud, "%02d:%02d:%02d", g_StopWatchTime[tempid][MINS], g_StopWatchTime[tempid][SECS], g_StopWatchTime[tempid][MSECS]);	
			if( g_PlayerWatchStatus[tempid] != 2 )
			{
				++g_StopWatchTime[tempid][MSECS];
				if( g_StopWatchTime[tempid][MSECS] > 99 )
				{
					g_StopWatchTime[tempid][MSECS] = 0;
					g_StopWatchTime[tempid][SECS]++;
				}
				if( g_StopWatchTime[tempid][SECS] > 59 )
				{
					g_StopWatchTime[tempid][SECS] = 0;
					g_StopWatchTime[tempid][MINS]++
				}
			}
		}		
	}
	entity_set_float(iEnt, EV_FL_nextthink, get_gametime() + 0.01);
}

stock ResetWatch(id)
{
	g_PlayerWatchStatus[id] = 0;
	g_StopWatchTime[id][MINS] = 0;
	g_StopWatchTime[id][SECS] = 0;
	g_StopWatchTime[id][MSECS] = 0;
}