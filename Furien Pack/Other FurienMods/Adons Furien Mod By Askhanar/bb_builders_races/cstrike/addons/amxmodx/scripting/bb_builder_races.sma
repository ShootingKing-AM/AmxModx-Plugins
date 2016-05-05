#include <  amxmodx  >
#include <  cstrike  >
#include <  hamsandwich  >
#include <  fakemeta  >
#include <  fun >
#include <  ColorChat  >


#pragma semicolon 1


#define PLUGIN "BB Humans Races"
#define VERSION "1.0"


#define		DEFAULT_HP		100			// Cat hp ii este setat default.
#define		DEFAULT_ARMOUR		100			// Cata armura ii este setata default.

// weapons offsets
#define OFFSET_CLIPAMMO        51
#define OFFSET_LINUX_WEAPONS    4
#define fm_cs_set_weapon_ammo(%1,%2)    set_pdata_int(%1, OFFSET_CLIPAMMO, %2, OFFSET_LINUX_WEAPONS)

// players offsets
#define m_pActiveItem 373

const NOCLIP_WPN_BS    = ((1<<CSW_HEGRENADE)|(1<<CSW_SMOKEGRENADE)|(1<<CSW_FLASHBANG)|(1<<CSW_KNIFE)|(1<<CSW_C4));

new const g_MaxClipAmmo[] = 
{
	0,
	13, //CSW_P228
	0,
	10, //CSW_SCOUT
	0,  //CSW_HEGRENADE
	7,  //CSW_XM1014
	0,  //CSW_C4
	30,//CSW_MAC10
	30, //CSW_AUG
	0,  //CSW_SMOKEGRENADE
	15,//CSW_ELITE
	20,//CSW_FIVESEVEN
	25,//CSW_UMP45
	30, //CSW_SG550
	35, //CSW_GALIL
	25, //CSW_FAMAS
	12,//CSW_USP
	20,//CSW_GLOCK18
	10, //CSW_AWP
	30,//CSW_MP5NAVY
	100,//CSW_M249
	8,  //CSW_M3
	30, //CSW_M4A1
	30,//CSW_TMP
	20, //CSW_G3SG1
	0,  //CSW_FLASHBANG
	7,  //CSW_DEAGLE
	30, //CSW_SG552
	30, //CSW_AK47
	0,  //CSW_KNIFE
	50//CSW_P90
};


enum _:Classes
{
	CLASS_NONE = 0,
	CLASS_HUMAN = 1,
	CLASS_SURVIVOR = 2,
	CLASS_DESTROYER = 3,
	CLASS_INVISIBLE = 4,
	CLASS_SPEEDER = 5,
	CLASS_VIP = 6
};

new const gModels[  7  ][    ] =
{
	"",
	"NumeModelHuman",			//fara .mdl !!!
	"NumeModelSurvivor",			//fara .mdl !!!
	"NumeModelDestroyer",			//fara .mdl !!!
	"NumeModelInvisible",			//fara .mdl !!!
	"NumeModelSpeeder",			//fara .mdl !!!
	"NumeModelVip"				//fara .mdl !!!
};


new  gUserRace[  33  ];

// Numele meniului
new  const  MenuName[    ]  =  "\r      Alege o rasa^n";

// Site-ul ce apare sub cele 6 clase ( este in loc de tasta 0  );
new  const  NumeSite[    ]  =  "\yVa asteptam si pe forum:^n^n\rwww.numesite.ro";

// Tagul mesajelor din chat.
new  const  BBTag[    ]  =  "[BB Races]";

new gCvarHumanHP;
new gCvarHumanAP;
new gCvarSpeederSpeed;

new Ham:Ham_Player_ResetMaxSpeed = Ham_Item_PreFrame;

public plugin_precache(     )
{
	
	new modelpath[ 64 ];
	for( new i = CLASS_HUMAN; i < CLASS_VIP +1; i++ )
	{
		formatex( modelpath, sizeof ( modelpath ) -1, "models/player/%s/%s.mdl", gModels[ i ], gModels[ i ] );
		precache_model( modelpath );
	}
}

/*================================================================================================*/
/*======================================= - ¦ Askhanar ¦ - =======================================*/

public plugin_init(    ) 
{
	
	register_plugin(  PLUGIN,  VERSION, "Askhanar"  );
	
	gCvarHumanHP = register_cvar( "bb_race_humanhp", "200" );
	gCvarHumanAP = register_cvar( "bb_race_humanap", "200" );
	gCvarSpeederSpeed = register_cvar( "bb_race_speeder_speed", "430" );
	
	RegisterHam(  Ham_Spawn,  "player",  "Ham_PlayerSpawnPost",  true  );
	RegisterHam(  Ham_Player_ResetMaxSpeed,  "player",  "Ham_ResetMaxSpeedPost",  true  );
	RegisterHam(  Ham_TakeDamage,  "player",  "Ham_PlayerTakeDamage",  false  );
	
	register_event( "CurWeapon" , "Event_CurWeapon" , "be" , "1=1" );
	
	
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public client_putinserver(  id  )
{
	
	if(  is_user_bot(  id  )  ||  is_user_hltv(  id  )  )  return 1;
	
	gUserRace[  id  ]  =  CLASS_NONE;
	
	client_cmd( id, "cl_forwardspeed 1000" );
	client_cmd( id, "cl_backspeed 1000" );
	client_cmd( id, "cl_sidespeed 1000" );
	
	return 0;
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public client_disconnect(  id  )
{
	
	if(  is_user_bot(  id  )  ||  is_user_hltv(  id  )  )  return 1;
	
	gUserRace[  id  ]  =  CLASS_NONE;
	
	return 0;
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public Ham_PlayerSpawnPost(  id  ) 
{
	
	if(  !is_user_alive(  id  )  ||  is_user_bot(  id  )  ||  is_user_hltv(  id  )  )  return HAM_IGNORED;
	
	if(  cs_get_user_team(  id  )  ==  CS_TEAM_CT  )
	{
		
		ResetUserSettings( id );
		set_task( 0.5, "MainMenu", id );
	}
	
	return HAM_IGNORED;
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public Ham_ResetMaxSpeedPost(  id  )
{

	if(  is_user_alive(  id  )  &&  get_user_maxspeed(  id  )  !=  1.0  )
	{
		
		if( gUserRace[  id  ]  == CLASS_SPEEDER  )
		{
	
			new Float:flMaxSpeed;
				
			flMaxSpeed  =  float(  get_pcvar_num(  gCvarSpeederSpeed  )  );
			set_pev(  id,  pev_maxspeed,  flMaxSpeed  );
				
		}
	}
		
/*
	client_cmd(  id,  "cl_forwardspeed %0.1f;cl_sidespeed %0.1f;cl_backspeed %0.1f", flMaxSpeed, flMaxSpeed, flMaxSpeed );
*/

}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public Ham_PlayerTakeDamage(  id,  iInflictor,  iAttacker,  Float:flDamage,  bitsDamageType  )
{
	
	if( !iAttacker || id == iAttacker  ) return HAM_IGNORED;
	
	if(  is_user_alive(  id  )  )
	{
		if(  gUserRace[  id  ]  ==  CLASS_DESTROYER   ||  gUserRace[  id  ]  ==  CLASS_VIP  )
		{
			SetHamParamFloat( 4, flDamage  *  2.0  );
					
		}
	}
	
	return HAM_IGNORED;
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public Event_CurWeapon( id )
{
	if(  gUserRace[  id  ]  ==  CLASS_SURVIVOR  )
	{
		new iWeapon = read_data( 2 );
		if(  !(  NOCLIP_WPN_BS  &  (1<<iWeapon)  )  )
		{
			fm_cs_set_weapon_ammo(  get_pdata_cbase( id, m_pActiveItem ) , g_MaxClipAmmo[ iWeapon ] );
		}
	}
	
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public MainMenu(  id  )
{
	if( !is_user_connected(  id  )  ) return 1;
	
	new  menu  =  menu_create(  MenuName,  "MainMenuHandler"  );
	new Human[ 128 ], Survivor[ 128 ], Destroyer[ 128 ], Invisible[ 128 ], Speeder[ 128 ], VIP[ 128 ];
	
	formatex( Human, sizeof (  Human  ) -1, "%sHuman     \r[\y %dHP + %dAP\r ]", gUserRace[  id  ]  ==  CLASS_HUMAN ?  "\y" : "\w", get_pcvar_num(  gCvarHumanHP ), get_pcvar_num(  gCvarHumanAP ) );
	formatex( Survivor, sizeof (  Survivor  ) -1, "%sSurvivor         \r[\y Unlimited Ammo\r ]", gUserRace[  id  ]  ==  CLASS_SURVIVOR ?  "\y" : "\w" );
	formatex( Destroyer, sizeof (  Destroyer  ) -1, "%sDestroyer    \r[\y Double X2\r ]", gUserRace[  id  ]  ==  CLASS_DESTROYER ?  "\y" : "\w" );
	formatex( Invisible, sizeof (  Invisible  ) -1, "%sInvisible    \r[\y 85%% Visible\r ]", gUserRace[  id  ]  ==  CLASS_INVISIBLE ?  "\y" : "\w" );
	formatex( Speeder, sizeof (  Speeder  ) -1, "%sSpeeder    \r[\y %.1f Speed\r ]^n", gUserRace[  id  ]  ==  CLASS_SPEEDER ?  "\y" : "\w", float( get_pcvar_num( gCvarSpeederSpeed)  ) );
	formatex( VIP, sizeof (  VIP  ) -1, "%sV.I.P     \r[\y %dHP + %dAP and Damage X2\r ]", gUserRace[  id  ]  ==  CLASS_VIP ?  "\y" : "\w", get_pcvar_num(  gCvarHumanHP ), get_pcvar_num(  gCvarHumanAP ) );
	
	
	menu_additem(  menu,  Human,  "1",  0  );
	menu_additem(  menu,  Survivor,  "2",  0  );
	menu_additem(  menu,  Destroyer,  "3",  0  );
	menu_additem(  menu,  Invisible,  "4",  0  );
	menu_additem(  menu,  Speeder,  "5",  0  );
	menu_additem(  menu,  VIP,  "6",  0  );
	
	menu_setprop(  menu,  MPROP_EXITNAME,  NumeSite  );
	
	menu_display(  id,  menu,  0  );
	
	return 0;

}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public MainMenuHandler(  id,  menu,  item  )
{
	
	if(  item  ==  MENU_EXIT  )
	{
		set_task(  0.1,  "MainMenu",  id  );
		return 1;
	}
	
	if( cs_get_user_team( id ) != CS_TEAM_CT ) 
	{
		client_print( id, print_center, "You can not use this bug anymore!" );
		return 1;
	}
	
	new  data[  6  ],  iName[  64  ];
	new  iaccess,  callback;
	
	menu_item_getinfo(  menu,  item,  iaccess,  data,  5,  iName,  sizeof  (  iName  )  -1,  callback  );
	
	new  key  =  str_to_num(  data  );
	
	switch(  key  )
	{
		case CLASS_HUMAN:
		{
			
			if(  gUserRace[  id  ]  ==  CLASS_HUMAN  )
			{

				ColorChat(  id,  RED,  "^x04%s^x01 Esti deja rasa^x03 Human^x01 !",  BBTag  );
				MainMenu(  id  );
				return 1;
			}
			
			ResetUserSettings(  id  );
			
			set_user_health(  id,  get_pcvar_num( gCvarHumanHP )  );
			set_user_armor(  id,  get_pcvar_num( gCvarHumanAP )  );
			
			gUserRace[  id  ]  =  CLASS_HUMAN;
			
			cs_set_user_model(  id,  gModels[  key  ]  );
			

			ColorChat(  id,  RED,  "^x04%s^x01 Ai ales rasa^x03 Human^x01 !",  BBTag  );
			ColorChat(  id,  RED,  "^x04%s^x01 Aceasta rasa are^x03%d^x01HP +^x03 %d^x01AP !",  BBTag, get_pcvar_num( gCvarHumanHP ), get_pcvar_num( gCvarHumanAP )  );
			
			return 1;
		}
		case CLASS_SURVIVOR:
		{
			
			if(  gUserRace[  id  ]  ==  CLASS_SURVIVOR  )
			{

				ColorChat(  id,  RED,  "^x04%s^x01 Esti deja rasa^x03 Survivor^x01 !",  BBTag  );
				
				MainMenu(  id  );
				return 1;
			}
			
			ResetUserSettings(  id  );
			
			gUserRace[  id  ]  =  CLASS_SURVIVOR;
			
			cs_set_user_model(  id,  gModels[  key  ]  );
			

			ColorChat(  id,  RED,  "^x04%s^x01 Ai ales rasa^x03 Survivor^x01 !",  BBTag  );
			ColorChat(  id,  RED,  "^x04%s^x01 Aceasta rasa are^x03 Gloante Nelimitate^x01 !",  BBTag  );
			
			return 1;
		}
		case CLASS_DESTROYER:
		{
			
			if(  gUserRace[  id  ]  ==  CLASS_DESTROYER  )
			{

				ColorChat(  id,  RED,  "^x04%s^x01 Esti deja rasa^x03 Destroyer^x01 !",  BBTag  );
				
				MainMenu(  id  );
				return 1;
			}
			
			ResetUserSettings(  id  );

			gUserRace[  id  ]  =  CLASS_DESTROYER;
			
			cs_set_user_model(  id,  gModels[  key  ]  );
			

			ColorChat(  id,  RED,  "^x04%s^x01 Ai ales rasa^x03 Destroyer^x01 !",  BBTag  );
			ColorChat(  id,  RED,  "^x04%s^x01 Aceasta rasa face^x03 Damage Dublu^x01 !",  BBTag  );
			
			return 1;
		}
		
		case CLASS_INVISIBLE:
		{
			
			if(  gUserRace[  id  ]  ==  CLASS_INVISIBLE  )
			{

				ColorChat(  id,  RED,  "^x04%s^x01 Esti deja rasa^x03 Invisible^x01 !",  BBTag  );
				
				MainMenu(  id  );
				return 1;
			}
			
			
			ResetUserSettings(  id  );
			
			gUserRace[  id  ]  =  CLASS_INVISIBLE;
			
			cs_set_user_model(  id,  gModels[  key  ]  );
			set_user_rendering(  id,  kRenderFxNone,  0,  0,  0,  kRenderTransAlpha, 180 );
			
			ColorChat(  id,  RED,  "^x04%s^x01 Ai ales rasa^x03 Invisible^x01 !",  BBTag  );
			ColorChat(  id,  RED,  "^x04%s^x01 Aceasta rasa este^x03 85%% Vizibila^x01 !",  BBTag  );
			
			return 1;
		}
		case CLASS_SPEEDER:
		{
			
			if(  gUserRace[  id  ]  ==  CLASS_SPEEDER  )
			{

				ColorChat(  id,  RED,  "^x04%s^x01 Esti deja rasa^x03 Speeder^x01 !",  BBTag  );
				
				MainMenu(  id  );
				return 1;
			}
			
			
			ResetUserSettings(  id  );
			
			gUserRace[  id  ]  =  CLASS_SPEEDER;
			
			cs_set_user_model(  id,  gModels[  key  ]  );
			
			
			ColorChat(  id,  RED,  "^x04%s^x01 Ai ales rasa^x03 Speeder^x01 !",  BBTag  );
			ColorChat(  id,  RED,  "^x04%s^x01 Aceasta rasa are^x03 %.1f Speed^x01 !",  BBTag, float( get_pcvar_num( gCvarSpeederSpeed ) ) );
			
			return 1;
		}
		case CLASS_VIP:
		{
			if( !UserIsVip( id ) )
			{
				ColorChat(  id,  RED,  "^x04%s^x01 Doar jucatorii cu^x03 VIP^x01 pot alege aceasta rasa!",  BBTag  );
				MainMenu(  id  );
				return 1;
			}
			if(  gUserRace[  id  ]  ==  CLASS_VIP  )
			{

				ColorChat(  id,  RED,  "^x04%s^x01 Esti deja rasa^x03 VIP^x01 !",  BBTag  );
				
				MainMenu(  id  );
				return 1;
			}
			
			
			ResetUserSettings(  id  );
			
			set_user_health(  id,  get_pcvar_num( gCvarHumanHP )  );
			set_user_armor(  id,  get_pcvar_num( gCvarHumanAP )  );
			
			gUserRace[  id  ]  =  CLASS_VIP;
			
			cs_set_user_model(  id,  gModels[  key  ]  );
			

			ColorChat(  id,  RED,  "^x04%s^x01 Ai ales rasa^x03 Vip^x01 !",  BBTag  );
			ColorChat(  id,  RED,  "^x04%s^x01 Aceasta rasa are^x03 %d^x01 HP +^x03 %d^x01 AP !",  BBTag, get_pcvar_num( gCvarHumanHP ), get_pcvar_num( gCvarHumanAP )   );
			ColorChat(  id,  RED,  "^x04%s^x01 De asemenea beneficiaza si de^x03 Damage Dublu^x01!",  BBTag  );
			
			return 1;
		}
	}
	
	return 0;
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public ResetUserSettings(  id  )
{
	gUserRace[  id  ]  = CLASS_NONE;
	set_user_rendering(  id,  kRenderFxNone,  0,  0,  0,  kRenderNormal,  0  );
	cs_reset_user_model(  id  );
	
	set_user_health(  id,  DEFAULT_HP  );
	set_user_armor(  id,  DEFAULT_ARMOUR  );
	
	set_user_gravity(  id,  1.0  );
	set_user_maxspeed( id, 250.0 );
	
}

stock bool:UserIsVip( id )
{
	if( get_user_flags( id ) & ADMIN_IMMUNITY )
		return true;
		
	return false;
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/
/*================================================================================================*/