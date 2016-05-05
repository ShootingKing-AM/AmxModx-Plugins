#include <amxmodx>
#include <engine>
#include <fakemeta>

#define PLUGIN "Furien : Semiclip"
#define VERSION "0.4.1"
#define AUTHOR "[SK] ConnorMcLeod"

#define MAX_PLAYERS 32

#define Is_Player(%1)	( 1 <= %1 <= g_iMaxPlayers )

#define SetIdBits(%1,%2)		%1 |=  ( 1<<(%2%32) )
#define ClearIdBits(%1,%2)	%1 &= ~( 1<<(%2%32) )
#define GetIdBits(%1,%2)		%1 &   ( 1<<(%2%32) )

new g_bAlive
new g_bSolid
new g_bRestore

new g_iMaxPlayers

new gmsgStatusValue, gmsgStatusText
new g_iTarget[MAX_PLAYERS+1]
new g_iResetStatusText[MAX_PLAYERS+1]

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR)

	register_event("ResetHUD", "Event_ResetHUD", "b")
	register_event("Health", "Event_Health", "b")
	
	register_forward(FM_AddToFullPack, "AddToFullPack", 1)

	g_iMaxPlayers = get_maxplayers()

	gmsgStatusValue = get_user_msgid("StatusValue")
	gmsgStatusText = get_user_msgid("StatusText")
}

public client_putinserver( id )
{
	ClearIdBits(g_bAlive, id)
	ClearIdBits(g_bSolid, id)
	ClearIdBits(g_bRestore, id)

	g_iTarget[id] = 0
	g_iResetStatusText[id] = 0
}

public client_disconnect( id )
{
	ClearIdBits(g_bAlive, id)
	ClearIdBits(g_bSolid, id)
	ClearIdBits(g_bRestore, id)
}

public Event_Health(id)
{
	if( is_user_alive(id) )
	{
		SetIdBits(g_bAlive, id)
	}
	else
	{
		ClearIdBits(g_bAlive, id)
	}
}

public Event_ResetHUD(id)
{
	if( is_user_alive(id) )
	{
		SetIdBits(g_bAlive, id)
	}
	else
	{
		ClearIdBits(g_bAlive, id)
	}
}

public AddToFullPack(es, e, iEnt, id, hostflags, player, pSet)
{
	if(player && id != iEnt && GetIdBits(g_bAlive, id) && GetIdBits(g_bAlive, iEnt) )
	{
		if( GetIdBits(g_bAlive, id) )
		{
			if( id != iEnt )
			{
				if( GetIdBits(g_bAlive, iEnt) )
				{
					static Float:flDistance
					flDistance = entity_range(id, iEnt)
					if( flDistance < 765.0 )
					{
						set_es(es, ES_Solid, SOLID_NOT)
					}
				}
			}
		}
	}
}

FirstThink()
{
	for(new plr = 1; plr <= g_iMaxPlayers; plr++)
	{
		if( GetIdBits(g_bAlive, plr) && entity_get_int(plr, EV_INT_solid) == SOLID_SLIDEBOX )
		{
			SetIdBits(g_bSolid, plr)
		}
		else
		{
			ClearIdBits(g_bSolid, plr)
		}
	}
}

public client_PreThink(id)
{
	static i, LastThink
	
	if(LastThink > id)
	{
		FirstThink()
	}
	LastThink = id

	static iPlayer, crap
	get_user_aiming(id, iPlayer, crap)
	if( Is_Player( iPlayer ) )
	{
		static iOldPlayer
		iOldPlayer = g_iTarget[id]

		if( !iOldPlayer )
		{
			message_begin(MSG_ONE_UNRELIABLE, gmsgStatusValue, _, id)
			write_byte(1)
			write_short(2)
			message_end()
		}

		if( iOldPlayer != iPlayer )
		{
			g_iTarget[id] = iPlayer
			message_begin(MSG_ONE_UNRELIABLE, gmsgStatusValue, _, id)
			write_byte(2)
			write_short(iPlayer)
			message_end()
		}

		if( !iOldPlayer )
		{
			static const szStatusText[] = "1 %p2"
			message_begin(MSG_ONE_UNRELIABLE, gmsgStatusText, _, id)
			write_byte(0)
			write_string(szStatusText)
			message_end()
		}
	}
	else
	{
		if( g_iTarget[id] )
		{
			g_iResetStatusText[id] = 100
			g_iTarget[id] = 0
			
		}
		else if( --g_iResetStatusText[id] == 0 )
		{
			message_begin(MSG_ONE_UNRELIABLE, gmsgStatusValue, _, id)
			write_byte(1)
			write_short(0)
			message_end()
		}
	}
	
	if(!(GetIdBits(g_bSolid, id)))
	{
		return
	}

	for(i = 1; i <= g_iMaxPlayers; i++)
	{
		if(!(GetIdBits(g_bSolid, i)) || id == i)
		{
			continue
		}

		entity_set_int(i, EV_INT_solid, SOLID_NOT)
		SetIdBits(g_bRestore, i)
	}
}

public client_PostThink(id)
{
	static i

	for(i = 1; i <= g_iMaxPlayers; i++)
	{
		if(GetIdBits(g_bRestore, i))
		{
			entity_set_int(i, EV_INT_solid, SOLID_SLIDEBOX)
			ClearIdBits(g_bRestore, i)
		}
	}
}