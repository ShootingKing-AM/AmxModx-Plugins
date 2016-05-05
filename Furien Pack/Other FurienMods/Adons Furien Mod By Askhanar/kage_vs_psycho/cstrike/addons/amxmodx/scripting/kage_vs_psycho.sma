/*
Cvar-uri:

fmp_psycho_hp	400     -  viata care o primeste psycho
fmp_psycho_ap	400     -  armura care o primeste psycho
fmp_psycho_speed	500     -  viteza care o primeste psycho


fmp_kage_hp	300     -  viata care o primeste kage
fmp_kage_ap	200     -  armura care o primeste kage
fmp_kage_speed	1000     -  viteza care o primeste kage

*/


#include < amxmodx >
#include < fun >
#include < hamsandwich >
#include < fakemeta >
#include < ColorChat >

#pragma semicolon 1

#define PLUGIN "Furien Mod Powers"
#define VERSION "0.3.5"


new const KageSound[    ]  =  "bleahhK.wav";
new const PsychoSound[    ]  =  "bleacP.wav";

new Ham:Ham_Player_ResetMaxSpeed = Ham_Item_PreFrame;

new bool:UserIsKage[ 33 ];
new bool:UserIsPsycho[ 33 ];

new cvar_hp;
new cvar_ap;
new cvar_speed;

new cvar_hp2;
new cvar_ap2;
new cvar_speed2;

new SyncHudMessage;


public plugin_cfg(    )
{
	
	if(  get_pcvar_num(  cvar_speed  )  >  get_pcvar_num(  cvar_speed2  )  )
	{
		set_cvar_float("sv_maxspeed", float(  get_pcvar_num(  cvar_speed  )  )  );
	}
	else if(  get_pcvar_num(  cvar_speed2  )  >  get_pcvar_num(  cvar_speed  )  )
	{
		set_cvar_float("sv_maxspeed", float(  get_pcvar_num(  cvar_speed2  )  )  );
	}
	
	else
	{
		set_cvar_float("sv_maxspeed", float(  get_pcvar_num(  cvar_speed  )  )  );
	}
	
}

public plugin_precache(    )
{
	
	precache_sound(  KageSound  );
	precache_sound(  PsychoSound  );
	
}

public plugin_init( )
{
	register_plugin( PLUGIN, VERSION, "Askhanar" );
	
	cvar_hp = register_cvar( "fmp_psycho_hp", "400" );
	cvar_ap = register_cvar( "fmp_psycho_ap", "400" );
	cvar_speed = register_cvar( "fmp_psycho_speed", "450" );
	
	cvar_hp2 = register_cvar( "fmp_kage_hp", "400" );
	cvar_ap2 = register_cvar( "fmp_kage_ap", "400" );
	cvar_speed2 = register_cvar( "fmp_kage_speed", "450" );
	
	
	RegisterHam(  Ham_Spawn,  "player",  "Ham_PlayerSpawnPost",  1  );
	register_event( "DeathMsg", "evDeathMsg", "a" );
	
	RegisterHam(  Ham_Player_ResetMaxSpeed,  "player",  "Ham_ResetMaxSpeedPost",  1  );
	
	SyncHudMessage = CreateHudSyncObj( );
	
}


public client_connect(  id  )
{
	if(  is_user_bot(  id  )  ||  is_user_hltv(  id  )  ) return 1;
	
	UserIsKage[  id  ]  =  false;
	UserIsPsycho[  id  ]  =  false;
	
	client_cmd(  id  , "cl_sidespeed 1000"  );
	client_cmd(  id  , "cl_forwardspeed 1000"  );
	client_cmd(  id  , "cl_backspeed 1000"  );
	
	return 0;
}

public client_disconnect(  id  )
{
	if(  is_user_bot(  id  )  ||  is_user_hltv(  id  )  ) return 1;
	
	UserIsKage[  id  ]  =  false;
	UserIsPsycho[  id  ]  =  false;
	
	client_cmd(  id  , "cl_sidespeed 400"  );
	client_cmd(  id  , "cl_forwardpeed 400"  );
	client_cmd(  id  , "cl_backspeed 400"  );
	
	return 0;
}

public Ham_PlayerSpawnPost(  id  )
{
	
	if(  !is_user_alive(  id  )  ||  !is_user_connected(  id  )  )  return HAM_IGNORED;
	
	set_task( 0.1, "RemovePowers", id + 123 );
	
	return HAM_IGNORED;
	
}

public RemovePowers( id )
{
	id -= 123;
	if( !is_user_connected(  id  )  )  return 1;
	
		
	if( UserIsPsycho[ id ] )
	{
		
		if( get_user_flags( id ) & ADMIN_KICK )
		{
			set_user_armor( id, 150 );
		}
		
		else
		{
			set_user_armor( id, 0 );
		}
		
		set_user_rendering( id, kRenderFxGlowShell, 0, 0, 0, kRenderNormal, 25 );
	}
	
	if( UserIsKage[ id ] )
	{
		
		if( get_user_flags( id ) & ADMIN_KICK )
		{
			set_user_armor( id, 150 );
		}
		
		else
		{
			set_user_armor( id, 0 );
		}
		
		
			
	}
	
	UserIsPsycho[ id ] = false;
	UserIsKage[ id ] = false;
	
	client_cmd(  id, "lastinv" );
	client_cmd(  id, "lastinv" );
	
	return 0;
}


public SearchForPsycho(  )
{
	new iTerro  =  CountPlayers(  1  );
	new iCounter  =  CountPlayers(  2  );
	
	if(  iCounter == 1 && iTerro > 0 )
	{
		
		new id = GetRemainingPlayerId(  2  );
		if(  UserIsPsycho[  id  ]  )  return 1;
		
		UserIsPsycho[ id ] = true;
		
		ColorChat( 0, RED,"^x04[AntiFurien]^x03 %s^x01 a devenit^x03 Psycho^x01 ! ", get_name( id ) );
		ColorChat( 0, RED,"^x04[AntiFurien]^x01 Are^x03 %d^x01 HP,^x03 %d^x01 AP,^x03 %d^x01 Speed, aveti grija !", get_pcvar_num( cvar_hp ), get_pcvar_num( cvar_ap ), get_pcvar_num( cvar_speed ) );
		
		set_hudmessage( 0, 255, 0, -1.0, -1.0, 0, 0.0, 5.0, 0.0, 1.0, 3);
		ShowSyncHudMsg(  0,  SyncHudMessage,  "%s a devenit Psycho !^n Cea din urma salvare a omenirii !",  get_name(  id  )  );
		
		
		set_user_maxspeed( id, float( get_pcvar_num( cvar_speed ) ) );
		set_user_health( id, get_pcvar_num( cvar_hp ) );
		set_user_armor( id, get_pcvar_num( cvar_ap ) );
		
		set_user_rendering( id, kRenderFxGlowShell, 0, 255, 255, kRenderNormal, 25 );
		
		new szCommand[ 128 ];
		formatex( szCommand, sizeof (  szCommand  )  -1,"cl_forwardspeed %.1f;cl_sidespeed %.1f;cl_backspeed %.1f",
				float( get_pcvar_num( cvar_speed ) ), float( get_pcvar_num( cvar_speed ) ),
						float( get_pcvar_num( cvar_speed ) ) );
		client_cmd(  id,  szCommand );
		client_cmd( 0, "spk sound/%s", PsychoSound  );
		

	}

	return 0;
	
}

public SearchForKage(    )
{
	new iTerro  =  CountPlayers(  1  );
	new iCounter  =  CountPlayers(  2  );
	
	if(  iTerro  == 1  && iCounter > 0 )
	{
		new id = GetRemainingPlayerId(  1  );
		if(  UserIsKage[  id  ]  )  return 1;
		
		UserIsKage[ id ] = true;
		
		ColorChat( 0, RED,"^x04[Furien]^x03 %s^x01 s-a transformat in^x03 Kage^x01 ! ", get_name( id ));
		ColorChat( 0, RED,"^x04[Furien]^x01 Are^x03 %d^x01 HP,^x03 %d^x01 AP,^x03 %d^x01 Speed, aveti grija !", get_pcvar_num( cvar_hp2 ), get_pcvar_num( cvar_ap2 ), get_pcvar_num( cvar_speed2 )  );
		set_hudmessage( 0, 255, 0, -1.0, -1.0, 0, 0.0, 5.0, 0.0, 1.0, 3);
		ShowSyncHudMsg(  0,  SyncHudMessage,  "%s s-a transformat in Kage !^nSansele pamantenilor au scazut !",  get_name(  id  )  );
		
		
		set_user_maxspeed( id, float( get_pcvar_num( cvar_speed2 ) ) );
		set_user_health( id, get_pcvar_num( cvar_hp2 ) );
		set_user_armor( id, get_pcvar_num( cvar_ap2 ) );
		
		new szCommand[ 128 ];
		formatex( szCommand, sizeof (  szCommand  )  -1,"cl_forwardspeed %.1f;cl_sidespeed %.1f;cl_backspeed %.1f",
				float( get_pcvar_num( cvar_speed2 ) ), float( get_pcvar_num( cvar_speed2 ) ),
						float( get_pcvar_num( cvar_speed2 ) ) );
		client_cmd(  id,  szCommand );
		
		client_cmd( 0, "spk sound/%s", KageSound  );
		
	}
	
	return 0;
}

public evDeathMsg( )
{
	
	SearchForPsycho(    );
	SearchForKage(    );
	
	new iKiller = read_data( 1 );
	new iVictim = read_data( 2 ); 
     
	if( !is_user_connected( iKiller ) || !is_user_connected( iVictim ) || iKiller == iVictim ) return 1;
	
	if( UserIsKage[ iVictim ] )
	{
		ColorChat( 0, RED, "^x04[AntiFurien]^x01 Kage^x03 %s^x01 a fost omorat de^x03 %s^x01 !",get_name( iVictim ), get_name( iKiller ) );
	}
	else if( UserIsPsycho[ iVictim ] )
	{
		ColorChat( 0, RED, "^x04[AntiFurien]^x01 Psycho^x03 %s^x01 a fost omorat de^x03 %s^x01 !",get_name( iVictim ), get_name( iKiller ) );
	}
	
	return 0;
	
}


public Ham_ResetMaxSpeedPost(  id  )
{
	if(  is_user_alive(  id  )  &&  is_user_connected( id )  && get_user_maxspeed(id) != 1.0  )
	{
		
		new Float:flMaxSpeed;
		if( UserIsPsycho[ id ] )
		{
			flMaxSpeed  =  float( get_pcvar_num( cvar_speed ) );
		}
		if( UserIsKage[ id ] )
		{
			flMaxSpeed  =  float( get_pcvar_num( cvar_speed2 ) );
		}
		
		if( flMaxSpeed  >  0.0  )
		{
			set_pev(  id,  pev_maxspeed,  flMaxSpeed  );

			// slow hack ? o_O
			//client_cmd(  id,  "cl_forwardspeed %.1f;cl_sidespeed %.1f;cl_backspeed %.1f", flMaxSpeed, flMaxSpeed, flMaxSpeed );
		}
	}
}

stock CountPlayers(  const  Team  )
{
	new iPlayers[ 32 ];
	new iPlayersNum;
	
	new iPlayersCount;
	
	get_players( iPlayers, iPlayersNum, "ch" );		
	for( new i = 0 ; i < iPlayersNum ; i++ )
	{
		if( is_user_connected(  iPlayers[  i  ]  ) &&  is_user_alive(  iPlayers[  i  ]  )  )
		{
			
			if( Team  == 1  )
			{
				if( get_user_team(  iPlayers[  i  ]  )  == 1 )
				{
					iPlayersCount++;
				}
			}
			else if(  Team == 2  )
			{
				if( get_user_team(  iPlayers[  i  ]  )  == 2  )
				{
					iPlayersCount++;
				}
			}
		}
		
	}
	
	return iPlayersCount;
	
}

stock GetRemainingPlayerId(  const  Team  )
{
	new iPlayers[ 32 ];
	new iPlayersNum;
	
	new iPlayerId;
	
	get_players( iPlayers, iPlayersNum, "ch" );		
	for( new i = 0 ; i < iPlayersNum ; i++ )
	{
		if( is_user_connected(  iPlayers[  i  ]  )  &&  is_user_alive(  iPlayers[  i  ]  )  )
		{
			
			if( Team  == 1  )
			{
				
				if( get_user_team(  iPlayers[  i  ]  )  == 1  )
				{
					iPlayerId  =  iPlayers[  i  ];
				}
			}
			else if(  Team == 2  )
			{
				
				if( get_user_team(  iPlayers[  i  ]  )  == 2  )
				{
					iPlayerId  =  iPlayers[  i  ];
				}
			}
		}
		
	}
	
	return iPlayerId;
	
}
		
stock get_name( id )
{
	new name[ 32 ];
	get_user_name( id, name, sizeof ( name ) -1 );

	return name;
}