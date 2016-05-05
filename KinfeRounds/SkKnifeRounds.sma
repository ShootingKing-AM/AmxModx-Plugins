#include <amxmodx>
#include <amxmisc>

#define PLUGIN		"Knife Round"
#define VERSION		"1.2"
#define AUTHOR		"Shooting King"

#define TASKMSG		91238

new SyncHudObj, g_maxPlayers;
new bool:bKnifeOnly;
new bool:bNextRoundKnife;

public plugin_init()
{
	register_plugin( PLUGIN, VERSION, AUTHOR );
	
	register_clcmd( "say !knifenow", "cmd_KnifeNow" );
	register_clcmd( "say !kniferound", "cmd_KnifeRound" );
	
	register_logevent( "event_RoundStart", 2, "1=Round_Start" );
	// register_event( "HLTV", "event_NewRound", "a", "1=0", "2=0" );
	register_event( "CurWeapon", "event_WeaponKnife", "be", "1=1", "2!29" );
	
	g_maxPlayers = get_maxplayers();
	SyncHudObj = CreateHudSyncObj();
}

public cmd_KnifeNow(id, cid)
{
	if(!cmd_access(id, ADMIN_KICK, cid, 2))
		return PLUGIN_HANDLED;
	
	set_hudmessage( 0, 250, 0, _, 0.30, 1, _, _, _, _, -1);
	ShowSyncHudMsg( 0, SyncHudObj, "Kn!fe Now !!" );
		
	bKnifeOnly = true;
	for( new i = 1; i < g_maxPlayers; i++ )
	{
		if(is_user_connected(i))
		{
			engclient_cmd( i, "weapon_knife" );
		}
	}
	return PLUGIN_CONTINUE;
}

public cmd_KnifeRound(id, cid)
{
	if(!cmd_access(id, ADMIN_KICK, cid, 2))
		return PLUGIN_HANDLED;
	
	set_hudmessage( 0, 250, 0, _, 0.30, 1, _, _, _, _, -1);
	ShowSyncHudMsg( 0, SyncHudObj, "Next Round Will be a Kn!fe Round" );
	
	bNextRoundKnife = true;
	return PLUGIN_CONTINUE;
}

public event_RoundStart()
{
	bKnifeOnly = false;
	if( bNextRoundKnife )
	{
		bKnifeOnly = true;
		
		set_hudmessage( 0, 250, 0, _, 0.30, 1, _, _, _, _, -1);
		ShowSyncHudMsg( 0, SyncHudObj, "Kn!fe Round." );
		
		for( new i = 1; i < g_maxPlayers; i++ )
		{
			if(is_user_connected(i))
			{
				engclient_cmd( i, "weapon_knife" );
			}
		}
	}
	bNextRoundKnife = false;
}

public event_WeaponKnife(id)
{
	if( bKnifeOnly )
	{
		engclient_cmd( id, "weapon_knife" );
		FixAmmoHud(id);
		return PLUGIN_HANDLED;
	}
	return PLUGIN_CONTINUE;
}

stock FixAmmoHud(id)
{
	message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("CurWeapon"), _, id); 
	write_byte(1);
	write_byte(29);
	write_byte(-1);
	message_end();
}