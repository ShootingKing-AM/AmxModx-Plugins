#include <amxmodx>
#include <cstrike>
#include <engine>
#include <hamsandwich>
#include <fun>

#pragma semicolon 1

#define PLUGIN "FMU Weapons Menu"
#define VERSION "1.0"

// Null ( do not modify )
#define 	NULL			0

// Max number of secondary weapons ( Pistols.. ).Do not modify.
#define		MAX_SECONDARY		7

// These determine if these secondary weapons ( Pistols.. ) should be enabled or disabled.
// 1 = enabled
// 0 = disabled

#define		ENABLE_USP		1
#define		ENABLE_GLOCK		1
#define		ENABLE_DEAGLE		1
#define		ENABLE_P228		1
#define		ENABLE_ELITE		1
#define		ENABLE_FIVESEVEN	1

// Max number of primary weapons ( Guns.. ).Do not modify.
#define 	MAX_PRIMARY		19


// These determine if these primary weapons ( Guns.. ) should be enabled or disabled.
// 1 = enabled
// 0 = disabled

#define		ENABLE_M4A1		1
#define		ENABLE_AK47		1
#define		ENABLE_AUG		1
#define		ENABLE_SG552		1
#define		ENABLE_GALIL		1
#define		ENABLE_FAMAS		1
#define		ENABLE_SCOUT		1
#define		ENABLE_AWP		1
#define		ENABLE_SG550		1
#define		ENABLE_M249		1
#define		ENABLE_G3SG1		1
#define		ENABLE_UMP45		1
#define		ENABLE_MP5NAVY		1
#define		ENABLE_M3		1
#define		ENABLE_XM1014		1
#define		ENABLE_TMP		1
#define		ENABLE_MAC10		1
#define		ENABLE_P90		1



// Max number of Grenades .Do not modify.
#define 	MAX_NADES		5


// These determine if these grenades should be enabled or disabled.
// 1 = enabled
// 0 = disabled

#define		ENABLE_FURIEN_NADES		1


#define		ENABLE_FURIEN_HE		1
#define		ENABLE_FURIEN_FLASHBANG1	0
#define		ENABLE_FURIEN_FLASHBANG2	1
#define		ENABLE_FURIEN_SMOKEGRENADE	1



#define		ENABLE_ANTIFURIEN_NADES		1


#define		ENABLE_ANTIFURIEN_HE     	0
#define		ENABLE_ANTIFURIEN_FLASHBANG1	0
#define		ENABLE_ANTIFURIEN_FLASHBANG2	1
#define		ENABLE_ANTIFURIEN_SMOKEGRENADE	1


/*======================================= - | Askhanar | - =======================================*/

new const gSecondaryWeaponsEnabled[  MAX_SECONDARY  ]  =
{
	
	NULL,
	ENABLE_USP,
	ENABLE_GLOCK,
	ENABLE_DEAGLE,
	ENABLE_P228,
	ENABLE_ELITE,
	ENABLE_FIVESEVEN
	
};

/*======================================= - | Askhanar | - =======================================*/

new const gSecondaryWeaponsName[  MAX_SECONDARY  ][    ]  =
{
	
"",
	"MK23 \w[\r30 \yBullets\w]",
	"Glock \w[\r30 \yBullets\w]",
	"Deagle \w[\r20 \yBullets\w]",
	"P228 \w[\r40 \yBullets\w]",
	"Duals \w[\r60 \yBullets\w]",
	"Kimbear \w[\r60 \yBullets\w]"
	
};

/*======================================= - | Askhanar | - =======================================*/

new const gSecondaryWeaponsItemName[  MAX_SECONDARY  ][    ]  =
{
	
	"",
	"weapon_usp",
	"weapon_glock18",
	"weapon_deagle",
	"weapon_p228",
	"weapon_elite",
	"weapon_fiveseven"
	
};

/*======================================= - | Askhanar | - =======================================*/

new const gSecondaryWeaponsItemNum[  MAX_SECONDARY  ]  =
{
	
	NULL,
	CSW_USP,
	CSW_GLOCK18,
	CSW_DEAGLE,
	CSW_P228,
	CSW_ELITE,
	CSW_FIVESEVEN
	
};

/*======================================= - | Askhanar | - =======================================*/

new const gSecondaryWeaponsMaxClip[  MAX_SECONDARY  ]  =
{
	NULL,
	30,
	30,
	20,
	40,
	60,
	60
	
};

/*======================================= - | Askhanar | - =======================================*/

new const gSecondaryWeaponsMaxAmmo[  MAX_SECONDARY  ]  =
{
	NULL,
	80,
	80,
	80,
	80,
	80,
	80
	
};

/*======================================= - | Askhanar | - =======================================*/

new const gPrimaryWeaponsEnabled[  MAX_PRIMARY  ]  =
{
	
	NULL,
	ENABLE_M4A1,
	ENABLE_AK47,
	ENABLE_AUG,
	ENABLE_SG552,
	ENABLE_GALIL,
	ENABLE_FAMAS,
	ENABLE_SCOUT,
	ENABLE_AWP,
	ENABLE_SG550,
	ENABLE_M249,
	ENABLE_G3SG1,
	ENABLE_UMP45,
	ENABLE_MP5NAVY,
	ENABLE_M3,
	ENABLE_XM1014,
	ENABLE_TMP,
	ENABLE_MAC10,
	ENABLE_P90
	
};

/*======================================= - | Askhanar | - =======================================*/

new const gPrimaryWeaponsName[  MAX_PRIMARY  ][    ]  =
{
	
	"",
	"M4A1 \w[\r45 \yBullets\w]",
	"AK47 -Gold-Edition \w[\r45 \yBullets\w]",
	"AUG -PrO \w[\r70 \yBullets\w]",
	"XM8 -PrO \w[\r75 \yBullets\w]",
	"Galil -Gold-Edition \w[\r75 \yBullets\w]",
	"Famas BR2-PrO \w[\r35 \yBullets\w]",
	"Scout -Gold-Edition \w[\r30 \yBullets\w]",
	"AWP -Gold-Edition \w[\r30 \yBullets\w]",
	"M16A4 Sniper-PrO \w[\r70 \yBullets\w]",
	"M249 -PrO \w[\180 \yBullets\w]",
	"G3SG1 -Gold-Edition \w[\r70 \yBullets\w]",
	"UMP 45 -PrO\w[\r50 \yBullets\w]",
	"MP5 Navy -Dula-PrO \w[\r100 \yBullets\w]",
	"M3 -Gold-Edition \w[\r25 \yBullets\w]",
	"XM1014 -Pro \w[\r25 \yBullets\w]",
	"TMP -Pro \w[\r60 \yBullets\w]",
	"Mac 10 -Gold-Edition \w[\r50 \yBullets\w]",
	"P90 -DuaL -Pro\w[\r100 \yBullets\w]"
	
};

/*======================================= - | Askhanar | - =======================================*/

new const gPrimaryWeaponsItemName[  MAX_PRIMARY  ][    ]  =
{
	
	"",
	"weapon_m4a1",
	"weapon_ak47",
	"weapon_aug",
	"weapon_sg552",
	"weapon_galil",
	"weapon_famas",
	"weapon_scout",
	"weapon_awp",
	"weapon_sg550",
	"weapon_m249",
	"weapon_g3sg1",
	"weapon_ump45",
	"weapon_mp5navy",
	"weapon_m3",
	"weapon_xm1014",
	"weapon_tmp",
	"weapon_mac10",
	"weapon_p90"
	
};

/*======================================= - | Askhanar | - =======================================*/

new const gPrimaryWeaponsItemNum[  MAX_PRIMARY  ]  =
{
	
	NULL,
	CSW_M4A1,
	CSW_AK47,
	CSW_AUG,
	CSW_SG552,
	CSW_GALIL,
	CSW_FAMAS,
	CSW_SCOUT,
	CSW_AWP,
	CSW_SG550,
	CSW_M249,
	CSW_G3SG1,
	CSW_UMP45,
	CSW_MP5NAVY,
	CSW_M3,
	CSW_XM1014,
	CSW_TMP,
	CSW_MAC10,
	CSW_P90
	
};

/*======================================= - | Askhanar | - =======================================*/
new const gPrimaryWeaponsMaxClip[  MAX_PRIMARY  ]  =
{
	
	NULL,
	45,
	45,
	70,
	75,
	75,
	35,
	30,
	30,
	70,
	180,
	70,
	100,
	25,
	25,
	25,
	60,
	50,
	100
	
};

/*======================================= - | Askhanar | - =======================================*/

new const gPrimaryWeaponsMaxAmmo[  MAX_PRIMARY  ]  =
{
	
	NULL,
	200,
	200,
	200,
	200,
	200,
	200,
	200,
	200,
	200,
	200,
	200,
	200,
	200,
	200,
	200,
	200,
	200,
	200,
	
};

/*======================================= - | Askhanar | - =======================================*/

new const gGrenadesEnabled[  CsTeams  ]  =
{
	
	NULL,
	ENABLE_FURIEN_NADES,
	ENABLE_ANTIFURIEN_NADES,
	NULL
	
};

new const gFurienNadeEnabled[  MAX_NADES  ]  =
{
	
	NULL,
	ENABLE_FURIEN_HE,
	ENABLE_FURIEN_FLASHBANG1,
	ENABLE_FURIEN_FLASHBANG2,
	ENABLE_FURIEN_SMOKEGRENADE
	
};

new const gAntiFurienNadeEnabled[  MAX_NADES  ]  =
{
	
	NULL,
	ENABLE_ANTIFURIEN_HE,
	ENABLE_ANTIFURIEN_FLASHBANG1,
	ENABLE_ANTIFURIEN_FLASHBANG2,
	ENABLE_ANTIFURIEN_SMOKEGRENADE
	
};

/*======================================= - | Askhanar | - =======================================*/

new const gGrenadesItemName[  MAX_NADES  ][    ]  =
{
	
	"",
	"weapon_hegrenade",
	"weapon_flashbang",
	"weapon_flashbang",
	"weapon_smokegrenade"
	
};

/*======================================= - | Askhanar | - =======================================*/

new gUserLastSecondaryWeapons[  33  ];
new gUserLastPrimaryWeapons[  33  ];

/*======================================= - | Askhanar | - =======================================*/

public plugin_init(    )
{
	register_plugin(  PLUGIN,  VERSION,  "[SK] Askhanar"  );	
	register_clcmd(  "say /weapons", "ClCmdSayWeapons"  );	
	RegisterHam(  Ham_Spawn,  "player",  "Ham_PlayerSpawnPost",  true  );
	
}

/*======================================= - | Askhanar | - =======================================*/

public client_putinserver(  id  )
{
	
	if(  is_user_bot(  id  )  ||  is_user_hltv(  id  )  )  return 0;
	
	gUserLastSecondaryWeapons[  id  ]  =  0;
	gUserLastPrimaryWeapons[  id  ]  =  0;
		
	return 0;
}

/*======================================= - | Askhanar | - =======================================*/

public client_disconnect(  id  )
{
		
	if(  is_user_bot(  id  )  ||  is_user_hltv(  id  )  )  return 0;
	
	gUserLastSecondaryWeapons[  id  ]  =  0;
	gUserLastPrimaryWeapons[  id  ]  =  0;
		
	return 0;
}

/*======================================= - | Askhanar | - =======================================*/

public ClCmdSayWeapons(  id  )
{
	if(  !IsUserAntiFurien(  id  )  ||  !is_user_alive(  id  )  )  return 1;
	
	if(  UserHasNoWeapon(  id  )  )
	{
		ShowWeaponsMenu(  id  );
		return 0;
	}
	else
	{
		client_print(id, print_chat, "You've already chosen your weapons !"  );
		return 1;
	}
	
	return 0;
}
	
/*======================================= - | Askhanar | - =======================================*/

public Ham_PlayerSpawnPost(  id  )
{
	if( is_user_alive(  id  )  && !is_user_bot(  id  )  &&  !is_user_hltv(  id  )  )
	{
		
		new CsTeams:Team  =  cs_get_user_team(  id  );
		if( Team  ==  CS_TEAM_T  ||  Team  ==  CS_TEAM_CT  )
		{
			
			if(  Team  == CS_TEAM_CT  )	ShowWeaponsMenu(  id  );
			
			if(  gGrenadesEnabled[  Team  ]  )
			{
				switch(  Team  )
				{
					case CS_TEAM_T:
					{
						for(  new  i  = 1;  i  <  MAX_NADES;  i++  )
						{
							if(  gFurienNadeEnabled[  i  ]  )
							{
								give_item(  id,  gGrenadesItemName[  i  ]  );
							}
						}
					}
					case CS_TEAM_CT:
					{
						for(  new  i  = 1;  i  <  MAX_NADES;  i++  )
						{
							if(  gAntiFurienNadeEnabled[  i  ]  )
							{
								give_item(  id,  gGrenadesItemName[  i  ]  );
							}
						}
					}
				}
			}
		}
	}
	
	return HAM_IGNORED;
}

/*======================================= - | Askhanar | - =======================================*/

public ShowWeaponsMenu(  id  )
{
	new menu = menu_create(  "\rAntiFurien:\y Weapons \w[MENU]", "WeaponsMenuHandler" );	
	
	menu_additem(  menu,  "New Weapons",  "1", 0  );
	menu_additem(  menu,  "Previous Setup",  "2", 0  );
	
	menu_setprop( menu, MPROP_EXIT , MEXIT_NEVER );
	menu_display(  id,  menu,  0 );

}

/*======================================= - | Askhanar | - =======================================*/

public WeaponsMenuHandler(  id,  menu,  item  )
{
	
	new data[ 6 ], iName[ 64 ];
	new iaccess, callback;
	
	menu_item_getinfo(  menu,  item,  iaccess,  data,  5,  iName,  63,  callback );
	menu_destroy(  menu  );
	
	new key = str_to_num(  data  );
	
	switch(  key  )
	{
		case 1:
		{
			if(  IsUserAntiFurien(  id  )  )
			{
				ShowSecondaryWeaponsMenu(  id,  0  );
			}
			return 1;
		}
		case 2:
		{
			if(  IsUserAntiFurien(  id  )  )
			{
			
			
				if(  gUserLastPrimaryWeapons[  id  ]  <=  0  ||  gUserLastSecondaryWeapons[  id  ]  <=  0  )
				{
					ShowWeaponsMenu(  id  );
					client_print(id, print_chat, "[Furien Ultimate]Prima data trebuie sa alegi armele!"  );
					return 1;
				}
				
				GiveWeaponAndSetClipAndAmmo(  id,  gSecondaryWeaponsItemName[  gUserLastSecondaryWeapons[  id  ]  ],  gSecondaryWeaponsItemNum[  gUserLastSecondaryWeapons[  id  ]  ],
						gSecondaryWeaponsMaxClip[  gUserLastSecondaryWeapons[  id  ]  ],  gSecondaryWeaponsMaxAmmo[  gUserLastSecondaryWeapons[  id  ]  ]  );
						
				GiveWeaponAndSetClipAndAmmo(  id,  gPrimaryWeaponsItemName[  gUserLastPrimaryWeapons[  id  ]  ],  gPrimaryWeaponsItemNum[  gUserLastPrimaryWeapons[  id  ]  ],
						gPrimaryWeaponsMaxClip[  gUserLastPrimaryWeapons[  id  ]  ],  gPrimaryWeaponsMaxAmmo[  gUserLastPrimaryWeapons[  id  ]  ]  );
				
				return 1;
			}
		}
	}
	
	return 1;
}

/*======================================= - | Askhanar | - =======================================*/

public ShowSecondaryWeaponsMenu(  id,  page  )
{
	new menu = menu_create(  "\rAntiFurien:\y Secondary Weapons", "SecondaryWeaponsMenuHandler" );	
	new callback = menu_makecallback(  "CallbackSecondaryWeapons"  );
	
	for(  new i = 1; i  <  MAX_SECONDARY;  i++  )
	{
		new  szMenuKey[  32  ];
		num_to_str(  i,  szMenuKey,  sizeof  (  szMenuKey  )  );
		
		menu_additem(  menu,  gSecondaryWeaponsName[  i  ],  szMenuKey,  _,  callback  );
	}
	
	menu_setprop( menu, MPROP_EXIT , MEXIT_NEVER );
	menu_display(  id,  menu,  page );

}

/*======================================= - | Askhanar | - =======================================*/

public SecondaryWeaponsMenuHandler(  id,  menu,  item  )
{
	
	new data[ 6 ], iName[ 64 ];
	new iaccess, callback;
	
	menu_item_getinfo(  menu,  item,  iaccess,  data,  5,  iName,  63,  callback );
	menu_destroy(  menu  );
	
	new key = str_to_num(  data  );
	
	if(  IsUserAntiFurien(  id  )  )
	{
			
		GiveWeaponAndSetClipAndAmmo(  id,  gSecondaryWeaponsItemName[  key  ],  gSecondaryWeaponsItemNum[  key  ],
						gSecondaryWeaponsMaxClip[  key  ],  gSecondaryWeaponsMaxAmmo[  key  ]  );
		
		gUserLastSecondaryWeapons[  id  ]  =  key;
		ShowPrimaryWeaponsMenu(  id,  0  );
	}
	
	return 1;
}

/*======================================= - | Askhanar | - =======================================*/

public CallbackSecondaryWeapons(  id,  menu,  item  )
{
	static  _access,  info[  4  ],  callback;
	menu_item_getinfo(  menu,  item,  _access,  info,  sizeof (  info  )  - 1,  _,  _,  callback  );
	
	if(  !gSecondaryWeaponsEnabled[  str_to_num(  info  )  ]  )  return ITEM_DISABLED;
	
	return ITEM_ENABLED;
}

/*======================================= - | Askhanar | - =======================================*/

public ShowPrimaryWeaponsMenu(  id,  page  )
{
	new menu = menu_create(  "\rAntiFurien:\y Primary Weapons", "PrimaryWeaponsMenuHandler" );	
	new callback = menu_makecallback(  "CallbackPrimaryWeapons"  );
	
	for(  new i = 1; i  <  MAX_PRIMARY;  i++  )
	{
		new  szMenuKey[  32  ];
		num_to_str(  i,  szMenuKey,  sizeof  (  szMenuKey  )  );
		
		menu_additem(  menu,  gPrimaryWeaponsName[  i  ],  szMenuKey,  _,  callback  );
	}
	
	menu_setprop( menu, MPROP_EXIT , MEXIT_NEVER );
	menu_display(  id,  menu,  page );

}

/*======================================= - | Askhanar | - =======================================*/

public PrimaryWeaponsMenuHandler(  id,  menu,  item  )
{
	
	new data[ 6 ], iName[ 64 ];
	new iaccess, callback;
	
	menu_item_getinfo(  menu,  item,  iaccess,  data,  5,  iName,  63,  callback  );
	menu_destroy(  menu  );
	
	new key = str_to_num( data );
	
	if(  IsUserAntiFurien(  id  )  )
	{
		GiveWeaponAndSetClipAndAmmo(  id,  gPrimaryWeaponsItemName[  key  ],  gPrimaryWeaponsItemNum[  key  ],
						gPrimaryWeaponsMaxClip[  key  ],  gPrimaryWeaponsMaxAmmo[  key  ]  );
		
		gUserLastPrimaryWeapons[  id  ]  =  key;
	
	}
	
	return 1;
}

/*======================================= - | Askhanar | - =======================================*/

public CallbackPrimaryWeapons(  id,  menu,  item  )
{
	static _access, info[4], callback;
	menu_item_getinfo(menu, item, _access, info, sizeof(info) - 1, _, _, callback);
	
	if(  !gPrimaryWeaponsEnabled[  str_to_num(  info  )  ]  )  return ITEM_DISABLED;
	
	return ITEM_ENABLED;
}

/*======================================= - | Askhanar | - =======================================*/

public GiveWeaponAndSetClipAndAmmo(  id,  const WeaponName[    ],  const WeaponId,  const WeaponMaxClip,  const WeaponMaxAmmo  )
{
	
	if( !is_user_alive(  id  )  ) return 1;
	
	give_item(  id,  WeaponName  );
	give_item(  id,  "weapon_knife" );
	new WeapId  =  find_ent_by_owner(  -1,  WeaponName,  id  );
	
	if(  WeapId  )
	{
		cs_set_weapon_ammo(  WeapId, WeaponMaxClip  );
	} 
	
	if(  WeaponId  !=  0  )
		cs_set_user_bpammo(  id,  WeaponId,  WeaponMaxAmmo  );
	
	return 0;
	
}

/*======================================= - | Askhanar | - =======================================*/

stock bool:IsUserAntiFurien(  id  )
{
	if(  get_user_team(  id  )  ==  2  )
	{
		give_item(  id,  "weapon_knife" );
		return true;
	}
	return false;
}			

/*======================================= - | Askhanar | - =======================================*/

stock bool:UserHasNoWeapon(  id  )
{
	
	new bool:WeaponFound  =  false;
	
	for(  new i  =  1;  i <  MAX_PRIMARY ; i++  )
	{
		if( user_has_weapon(  id,  gPrimaryWeaponsItemNum[  i  ]  )  )
		{
			WeaponFound  =  true;
			break;
		}
	}
	
	for(  new i  =  1;  i <  MAX_SECONDARY ; i++  )
	{
		if( user_has_weapon(  id,  gSecondaryWeaponsItemNum[  i  ]  )  )
		{
			WeaponFound  =  true;
			break;
		}
	}
	
	return WeaponFound  ?  false  :  true;
	
}		

/*======================================= - | Askhanar | - =======================================*/