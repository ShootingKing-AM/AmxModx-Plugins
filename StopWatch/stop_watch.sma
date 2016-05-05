#include <amxmodx>
#include <engine>

#define PLUGIN		"Stop Watch"
#define VERSION		"1.0"
#define AUTHOR		"Shooting King"

enum
{
	HRS,
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
new g_PlayerWatchStatus[33];
new g_StopWatchTime[33][4];

new const g_ClassName[] = "sk_StopWatch";

public plugin_init()
{
	register_plugin( PLUGIN, VERSION, AUTHOR );
	
	register_clcmd( "say /sw", "Show_SWMenu" );
	register_clcmd( "say_team /sw", "Show_SWMenu" );
	g_MenuCallback = menu_makecallback( "MenuCallback" );
	
	new iEnt = create_entity("info_target");
	entity_set_string(iEnt, EV_SZ_classname, g_ClassName);
	entity_set_float(iEnt, EV_FL_nextthink, get_gametime() + 0.01);
	register_think(g_ClassName, "ForwardThink");
	
	g_SyncHud = CreateHudSyncObj();
}


public Show_SWMenu(id)
{
	new hMenu = menu_create( "**** Stop Watch ****", "handler_SWMenu" );
	
	menu_additem( hMenu, "Start", "", 0, g_MenuCallback );
	menu_additem( hMenu, "Reset", "", 0, g_MenuCallback );
	
	menu_setprop( hMenu, MPROP_EXIT, MEXIT_ALL );
	menu_display( id, hMenu, 0 );
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
			g_PlayerWatchStatus[id] = 0;
			g_StopWatchTime[id][HRS] = 0;
			g_StopWatchTime[id][MINS] = 0;
			g_StopWatchTime[id][SECS] = 0;
			g_StopWatchTime[id][MSECS] = 0;
			menu_display( id, hMenu, 0 );
		}
		default:
		{
			g_PlayerWatchStatus[id] = 0;
			g_StopWatchTime[id][HRS] = 0;
			g_StopWatchTime[id][MINS] = 0;
			g_StopWatchTime[id][SECS] = 0;
			g_StopWatchTime[id][MSECS] = 0;
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
			ShowSyncHudMsg(tempid, g_SyncHud, "%02d:%02d:%02d:%02d", g_StopWatchTime[tempid][HRS], g_StopWatchTime[tempid][MINS], g_StopWatchTime[tempid][SECS], g_StopWatchTime[tempid][MSECS]);	
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
				if( g_StopWatchTime[tempid][MINS] > 59 )
				{
					g_StopWatchTime[tempid][MINS] = 0;
					g_StopWatchTime[tempid][HRS]++;
				}
			}
		}		
	}
	entity_set_float(iEnt, EV_FL_nextthink, get_gametime() + 0.01);
}