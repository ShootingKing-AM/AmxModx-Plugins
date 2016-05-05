#include <amxmodx>
#include <hamsandwich>

#define PLUGIN		"Knife & AutoRestart"
#define VERSION		"1.0"
#define AUTHOR		"Shooting King"

#define TASKMSG		91238
#define TASKRES		72318

new SyncHudObj;
new bool:bKnifeOnly = false;
new bool:bFirstRound = false;

public plugin_init()
{
	register_plugin( PLUGIN, VERSION, AUTHOR );
	
	register_logevent( "event_RoundStart", 2, "1=Round_Start" );
	register_event( "TextMsg", "event_GameCommencing", "a", "2&#Game_C" );
	register_event( "CurWeapon", "event_Weapon", "be", "1=1" );

	RegisterHam( Ham_Spawn, "player", "event_PlayerSpawn", 1 );

	SyncHudObj = CreateHudSyncObj();
}

public event_PlayerSpawn(id)
{
	if( bKnifeOnly )
		engclient_cmd( id, "weapon_knife" );
}

public ShowMsg()
{
	static szNum[32], szSound[48], iNum = 60;
	if((!(iNum%5)) || (iNum < 5) )
	{
		set_hudmessage( 0, 250, 0, _, 0.30, 1, _, _, _, _, -1);
		ShowSyncHudMsg( 0, SyncHudObj, "Game Restarts in %d Seconds.^n -=[D_G]=- Knife Round -=[D_G]=-", iNum );
		
		num_to_word( iNum, szNum, 31);
		formatex( szSound, 47, "vox/%s", szNum );
		PlaySound( szSound );
		if(iNum > 5)
		{
			set_task( 1.30, "Seconds" );
			set_task( 1.93, "Remaining" );
		}
	}
	iNum--;
	if( iNum < 1 )
	{
		bFirstRound = true;
		remove_task(TASKMSG);
	}
}

public RestartGame()
{
	server_cmd( "sv_restart 1");
	remove_task(TASKRES);
}

public event_GameCommencing()
{
	remove_task(TASKMSG);
	remove_task(TASKRES);
	bKnifeOnly = true;

	set_task( 1.0, "ShowMsg", TASKMSG, _, _, "a", 60 );
	set_task( 60.0, "RestartGame", TASKRES );
}

public event_RoundStart()
{
	if( bFirstRound )
	{
		set_hudmessage( 0, 250, 0, _, _, 1, _, _, _, _, -1)
		ShowSyncHudMsg( 0, SyncHudObj, "L!v3 L!v3 L!v3 L!v3 L!v3 !!^n GL & HF");
		PlaySound( "radio/com_go" );
		bKnifeOnly = false;	
		bFirstRound = false;
	}
}

public Seconds()
	PlaySound( "vox/seconds" );

public Remaining()
	PlaySound( "vox/remaining" );

public event_Weapon(id)
{
	if( bKnifeOnly && (read_data(2) != CSW_KNIFE))
	{
		engclient_cmd( id, "weapon_knife" );
		FixAmmoHud(id);
		return PLUGIN_HANDLED;
	}
	return PLUGIN_CONTINUE;
}

public PlaySound( szSound[] )
{
	client_cmd( 0, "stopsound" );
	client_cmd( 0, "speak ^"%s^"", szSound);
}

stock FixAmmoHud(id)
{
	message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("CurWeapon"), { 0, 0, 0 }, id); 
	write_byte(1);
	write_byte(29);
	write_byte(-1);
	message_end();
}