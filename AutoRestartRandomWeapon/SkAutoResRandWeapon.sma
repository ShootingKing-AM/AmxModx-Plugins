#include <amxmodx>
#include <cstrike>
#include <fun>
#include <engine>
#include <hamsandwich>
#include <fakemeta>

#define PLUGIN		"AutoRestart & RandomWeapon"
#define VERSION		"1.2"
#define AUTHOR		"Shooting King"

#define TASKMSG		91238
#define TASKRES		72318
#define	ammo_9mm 120

new SyncHudObj;
new bool:bKnifeOnly = false;
new bool:bFirstRound = false;
new bool:bShowLiveMsg = false;

new const szWeaponCmdNames[][] = {
	"weapon_p228",
	"weapon_shield",
	"weapon_scout",
	"weapon_hegrenade",
	"weapon_xm1014",
	"weapon_c4",
	"weapon_mac10",
	"weapon_aug",
	"weapon_smokegrenade",
	"weapon_elite",
	"weapon_fiveseven",
	"weapon_ump45",
	"weapon_sg550",
	"weapon_galil",
	"weapon_famas",
	"weapon_usp",
	"weapon_glock18",
	"weapon_awp",
	"weapon_mp5navy",
	"weapon_m249",
	"weapon_m3",
	"weapon_m4a1",
	"weapon_tmp",
	"weapon_g3sg1",
	"weapon_flashbang",
	"weapon_deagle",
	"weapon_sg552",
	"weapon_ak47",
	"weapon_knife",
	"weapon_p90"
};

new const g_iMaxBpAmmo[] = {
	0,
	30,
	90,
	200,
	90,
	32,
	100,
	100,
	35,
	52,
	120,
	2,
	1,
	1,
	1
}

new const szWeaponNames[][] = {

	"P228",
	"SHIELD",
	"SCOUT",
	"HEGRENADE",
	"XM1014",
	"C4",
	"MAC10",
	"AUG",
	"SMOKEGRENADE",
	"ELITE",
	"FIVESEVEN",
	"UMP45",
	"SG550",
	"GALIL",
	"FAMAS",
	"USP",
	"GLOCK18",
	"AWP",
	"MP5NAVY",
	"M249",
	"M3",
	"M4A1",
	"TMP",
	"G3SG1",
	"FLASHBANG",
	"DEAGLE",
	"SG552",
	"AK47",
	"KNIFE",
	"P90"
};

new const szRestrictedWeapons[] = {

	0, //"weapon_p228",
	1, // "weapon_shield",
	0, //eapon_scout",
	1, //eapon_hegrenade",
	0, //eapon_xm0004",
	1, //eapon_c4",
	0, //eapon_mac10",
	0, //eapon_aug",
	1, //eapon_smokegrenade",
	0, //eapon_elite",
	0, //eapon_fiveseven",
	0, //eapon_ump45",
	1, //eapon_sg550",
	0, //eapon_galil",
	0, //eapon_famas",
	0, //eapon_usp",
	0, //eapon_glock08",
	0, //eapon_awp",
	0, //eapon_mp5navy",
	0, //eapon_m249",
	0, //eapon_m3",
	0, //eapon_m4a0",
	0, //eapon_tmp",
	1, //eapon_g3sg0",
	1, //eapon_flashbang",
	0, //eapon_deagle",
	0, //eapon_sg552",
	0, //eapon_ak47",
	0, //eapon_knife",
	0, //eapon_p90"
};

new const iMaxBpammo[] = { 52, -1, 90, 1, 32, 1, 100, 90, 1, 120, 100, 100, 90, 90, 90, 100, 120,
			30, 120, 200, 32, 90, 120, 90, 2, 35, 90, 90, -1, 100 };

new const iMaxClip[] = { 13, -1, 10, -1, 7, -1, 30, 30, -1, 30, 20, 25, 30, 35, 25, 12, 20,
			10, 30, 100, 8, 30, 30, 20, -1, 7, 30, 30, -1, 50 };

new iRandWeapon;

new const g_WeaponSecondary[] = {
	0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 
	1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 
	0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
	0
};

new const m_rgpPlayerItems_CBasePlayer[6] = {367,368,...};

public plugin_init()
{
	register_plugin( PLUGIN, VERSION, AUTHOR );
	
	register_logevent( "event_RoundStart", 2, "1=Round_Start" );
	register_event( "TextMsg", "task_Restart", "a", "2&#Game_C" );
	register_event( "CurWeapon", "event_Weapon", "be", "1=1" );
	register_event( "HLTV", "event_NewRound", "a", "1=0", "2=0" );

	register_message(get_user_msgid("AmmoX"), "message_ammox");
	register_message(get_user_msgid("StatusIcon"), "message_StatusIcon"); 

	register_clcmd( "drop", "cmd_Drop" );

	SyncHudObj = CreateHudSyncObj();
}

public message_StatusIcon(iMsgId, iMsgDest, id)  
{
	if( !bKnifeOnly )
		return PLUGIN_CONTINUE;

	static szIcon[8];  
	get_msg_arg_string(2, szIcon, charsmax(szIcon));  
	if( equal(szIcon, "buyzone") ) 
	{  
		if( get_msg_arg_int(1) )  
		{  
			set_pdata_int(id, 235, get_pdata_int(id, 235) & ~(1<<0)); 
			return PLUGIN_HANDLED;  
		}  
	}      
	return PLUGIN_CONTINUE;  
}  

public message_ammox(iMsgId, iMsgDest, id)
{
	if( !bKnifeOnly )
		return;

	new iAmmoID = get_msg_arg_int(1);
	
	if( iAmmoID >= sizeof(g_iMaxBpAmmo) )
		return;
	
	if( is_user_alive(id) && iAmmoID )
	{
		new ilMaxBpAmmo = g_iMaxBpAmmo[iAmmoID];
		if( get_msg_arg_int(2) == 0 )
		{
			if( iAmmoID <= ammo_9mm && (iRandWeapon+1 != CSW_KNIFE))
			{
				set_msg_arg_int(2, ARG_BYTE, ilMaxBpAmmo);
				cs_set_user_bpammo( id, iRandWeapon+1, ilMaxBpAmmo );
			}
		}
	}
}

public cmd_Drop(id)
{
	if( bKnifeOnly )
	{
		client_print( id, print_center, "You cannot drop anything in this round." );
		return PLUGIN_HANDLED;
	}
	return PLUGIN_CONTINUE;
}

public ShowMsg()
{
	static szNum[32], szSound[48], iNum = 40;
	if((!(iNum%5)) || (iNum < 5) )
	{
		set_hudmessage( 0, 250, 0, _, 0.30, 1, _, _, _, _, -1);
		ShowSyncHudMsg( 0, SyncHudObj, "Game Restarts in ^n%d Seconds.", iNum );
		
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

public task_Restart()
{
	remove_task(TASKMSG);
	remove_task(TASKRES);	

	set_task( 1.0, "ShowMsg", TASKMSG, _, _, "a", 40 );
	set_task( 40.0, "RestartGame", TASKRES );
}

public event_NewRound()
{
	bKnifeOnly = false;
	if( bFirstRound )
	{
		iRandWeapon = random_num(0,29);
		while( szRestrictedWeapons[iRandWeapon] )
			iRandWeapon = random_num(0,29);
		bKnifeOnly = true;
	}
}
		
public event_RoundStart()
{
	if( bShowLiveMsg )
	{
		set_hudmessage( 0, 250, 0, _, _, 1, _, _, _, _, -1);
		ShowSyncHudMsg( 0, SyncHudObj, "L!v3 L!v3 L!v3 L!v3 L!v3 !!^n GL & HF" );
		bShowLiveMsg = false;
	}
	
	if( bFirstRound )
	{		
		new temp, iNum, i;
		new szPlayers[32];
		get_players( szPlayers, iNum );
		while( --iNum >= 0 )
		{
			i = szPlayers[iNum];			

			if( user_has_weapon(i, iRandWeapon+1) )
			{
				temp = find_ent_by_owner(-1, szWeaponCmdNames[iRandWeapon], i);
			}
			else
			{
				if( g_WeaponSecondary[iRandWeapon+1] && HasUserWeaponSlot(i,2) )
				{
					strip_user_weapons(i);
					give_item(i, "weapon_knife");
				}
				temp = give_item(i, szWeaponCmdNames[iRandWeapon]);
			}
			if( iMaxBpammo[iRandWeapon] > 0 ) cs_set_user_bpammo( i, iRandWeapon+1, iMaxBpammo[iRandWeapon] );
			if( iMaxClip[iRandWeapon] > 0 && temp > 0 ) cs_set_weapon_ammo( temp, iMaxClip[iRandWeapon] );
			cs_set_user_armor( i, 100, CS_ARMOR_VESTHELM);
			engclient_cmd( i, szWeaponCmdNames[iRandWeapon] );
		}
		set_hudmessage( 0, 250, 0, _, _, 1, _, _, _, _, -1)
		ShowSyncHudMsg( 0, SyncHudObj, "L!v3 L!v3 L!v3 !! First Round !!^n%s Only !!", szWeaponNames[iRandWeapon] );
		PlaySound( "radio/com_go" );
		bFirstRound = false;
		bShowLiveMsg = true;
	}
}

public Seconds()
	PlaySound( "vox/seconds" );

public Remaining()
	PlaySound( "vox/remaining" );

public event_Weapon(id)
{
	if( bKnifeOnly && (read_data(2) != (iRandWeapon+1)))
	{
		if( user_has_weapon(id, iRandWeapon+1) )
		{
			engclient_cmd( id, szWeaponCmdNames[iRandWeapon] );
			if((iRandWeapon+1) == CSW_KNIFE) FixAmmoHud(id);
		}
		else
		{
			if( g_WeaponSecondary[iRandWeapon+1] && HasUserWeaponSlot(id,2) )
			{
				strip_user_weapons(id);
				give_item(id, "weapon_knife");
			}
			new temp = give_item( id, szWeaponCmdNames[iRandWeapon] );
			if( iMaxBpammo[iRandWeapon] > 0 ) cs_set_user_bpammo( id, iRandWeapon+1, iMaxBpammo[iRandWeapon] );
			if( iMaxClip[iRandWeapon] > 0 && temp > 0 ) cs_set_weapon_ammo( temp, iMaxClip[iRandWeapon] );
			engclient_cmd( id, szWeaponCmdNames[iRandWeapon] );
		}
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

stock HasUserWeaponSlot(id, slot) 
{ 
    return get_pdata_cbase(id, m_rgpPlayerItems_CBasePlayer[slot]) > 0; 
}  