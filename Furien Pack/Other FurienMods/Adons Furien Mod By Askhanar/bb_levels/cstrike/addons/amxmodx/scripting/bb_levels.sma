#include < amxmodx >
#include < amxmisc >
#include < cstrike >
#include < fun >
#include < fakemeta >
#include < hamsandwich >
#include < CC_ColorChat >

#pragma semicolon 1


#define PLUGIN "BB Levels"
#define VERSION "1.0"

// Nu modifica..
#define HookTask	24896172


// Din cate in cate secunde poate folosi teleport!.

#define TeleportUnlock		5.0



// Viteza de deplasare in hook.

#define HookSpeed		700.0


//Tag Mesaje
new const g_szTag[ ] = "[BB.Lunetistii.RO]";


//Sunete Abilitati..
new const g_szBBLevelUp[ ] = "bb_LevelUp.wav";
new const g_szBBAbility[ ] = "bb_Ability.wav";


//Sunete Hook si Teleport.
new const g_szTeleport[ ] = "bb_Teleport.wav";
new const g_szHook[ ] = "weapons/xbow_fire1.wav";


//Cate fraguri ai nevoie pentru fiecare level.
new g_iLevelsFrags[ 5 ] =
{
	4,
	8,
	12,
	16,
	25,
	
};

//Gravitate Tero si CT.
new Float:g_fTGravity = 0.3;	//Tero
new Float:g_fCTGravity = 0.5;	//CT


//Cata viata primeste.
new g_iUserHealth[ CsTeams ] =
{
	
	0,
	1000,	//Viata la tero
	500,	//Viata la CT
	0
	
};


new g_iUserFrags[ 33 ];
new g_iUserLevels[ 33 ];

new bool:g_bUserHasHook[ 33 ];
new bool:g_bUserHasTeleport[ 33 ];

new g_iFirstPlayer;
new g_iMaxPlayers;


//Teleport.
new iBlueFlare;
new iShockWave;

new Float:g_fBlockTeleport[ 33 ];


//Hook
new bool:bUserIsHooked[ 33 ];
new iHookOrigin[ 33 ][ 3 ];
new iBeamSprite;

public plugin_precache( )
{
	iBlueFlare  =	precache_model( "sprites/blueflare2.spr" );
	iShockWave  =	precache_model( "sprites/shockwave.spr" );
	iBeamSprite =	precache_model( "sprites/plasma.spr" );
	
	precache_sound( g_szBBLevelUp );
	precache_sound( g_szBBAbility );
	
	precache_sound(  g_szTeleport );
	precache_sound( g_szHook );
}

public plugin_init( )
{
	register_plugin( PLUGIN, VERSION, "Askhanar" );
	
	
	register_clcmd( "+hook", "ClCmdUseHook" );
	register_clcmd( "+teleport", "ClCmdUseTeleport" );
	
	register_clcmd( "-hook", "ClCmdStopUsingHook" );
	register_clcmd( "-teleport", "ClCmdNone" );
	
	register_clcmd( "bb_hidden_addfrag", "ClCmdAddFrag" );
	register_clcmd( "check_for_level", "ClCmdCheckLevel" );
	register_clcmd( "say", "ClCmdSay" );
	register_clcmd( "say_team", "ClCmdSay" );
	
	register_clcmd( "bb_frags", "ClCmdBBFrags" );
	register_clcmd( "bb_level", "ClCmdBBLevel" );
	
	register_event(  "DeathMsg",  "EventDeathMsg",  "a"  );
	
	register_event(  "SendAudio",  "EventSendAudioTerroWin",  "a",  "2=%!MRAD_terwin"  );
	register_event(  "SendAudio",  "EventSendAudioCounterWin",  "a",  "2=%!MRAD_ctwin"  );
		
	RegisterHam(  Ham_Spawn,  "player",  "Ham_PlayerSpawnPost",  true  );
	RegisterHam(  Ham_Killed,  "player",  "Ham_PlayerKilledPost", true  );

	g_iFirstPlayer = 1;
	g_iMaxPlayers = get_maxplayers( );
}

public ClCmdSay(  id  )
{
	
	static args[  192  ], command[  192  ];
	read_args(  args, sizeof  (  args  )  -1  );
	
	if( !args[  0  ] )	return 0;
	
	remove_quotes(  args[  0  ]  );
	
	if(  equal(  args,  "/frags",  strlen(  "/frags"  )  )
		||  equal(  args,  "/level",  strlen(  "/level"  )  ) )
	{
		replace(  args, sizeof  (  args  )  -1,  "/",  ""  );
		formatex(  command, sizeof  (  command  )  -1,  "bb_%s",  args );
		client_cmd(  id,  command  );
		return 1;
	}
	
	return 0;
}

public ClCmdBBFrags(  id  )
{
	new FirstArg[  32  ];
	
    	read_argv(  1,  FirstArg,  sizeof  (  FirstArg  )  -1  );
	
	if(  equal(  FirstArg,  ""  )  )
	{
		ColorChat( id, RED, "^x04%s^x01 Fragurile tale sunt^03 %i^x01 .", g_szTag, g_iUserFrags[ id ] );
		return 1;
	}
	
	new iPlayer = cmd_target(  id,  FirstArg,  8 );
	
	if(  !iPlayer  )
	{
		ColorChat(  id,  RED, "^x04%s^x01 Acel jucator nu a fost gasit.",  g_szTag );
		return 1;
	}
	
	new szName[ 32 ];
	get_user_name( iPlayer, szName, sizeof ( szName ) -1 );
	ColorChat( id, RED, "^x04%s^x01 Fragurile lui^x03 %s^x01 sunt^03 %i^x01 .", g_szTag, szName, g_iUserFrags[ iPlayer ] );
	
	return 1;
}

public ClCmdBBLevel(  id  )
{
	new FirstArg[  32  ];
	
    	read_argv(  1,  FirstArg,  sizeof  (  FirstArg  )  -1  );
	
	if(  equal(  FirstArg,  ""  )  )
	{
		ColorChat( id, RED, "^x04%s^x01 Levelul tau este^03 %i^x01 .", g_szTag, g_iUserLevels[ id ] );
		return 1;
	}
	
	new iPlayer = cmd_target(  id,  FirstArg,  8 );
	
	if(  !iPlayer  )
	{
		ColorChat(  id,  RED, "^x04%s^x01 Acel jucator nu a fost gasit.",  g_szTag );
		return 1;
	}
	
	new szName[ 32 ];
	get_user_name( iPlayer, szName, sizeof ( szName ) -1 );
	ColorChat( id, RED, "^x04%s^x01 Levelul lui^x03 %s^x01 este^03 %i^x01 .", g_szTag, szName, g_iUserLevels[ iPlayer ] );
	
	return 1;
}

	
public ClCmdUseHook( id )
{
	if( !g_bUserHasHook[ id ] )
		return 1;
		
	
	emit_sound( id,CHAN_VOICE, g_szHook, 1.0, ATTN_NORM, 0, PITCH_NORM );
	set_pev( id, pev_gravity, 0.0 );
	
	set_task( 0.1,"TaskHookPrethink", id + HookTask , "", 0, "b" );
	
	bUserIsHooked[ id ] = true;
	iHookOrigin[ id ][ 0 ] = 999999;
	
	TaskHookPrethink( id + HookTask );
	return 1;
	
}

public ClCmdStopUsingHook( id )
{
	set_pev( id, pev_gravity, 1.0 );
	bUserIsHooked[ id ] = false;
	
	return 1;
}

public ClCmdUseTeleport( id )
{
	if( !g_bUserHasTeleport[ id ] )
		return 1;
		
	if( get_gametime( ) - g_fBlockTeleport[ id ] < TeleportUnlock )
	{
		ColorChat( id, RED, "^x04%s^x03 NU^x01 te mai poti teleporta^x03 %.1f^x01 secunde !", g_szTag , TeleportUnlock - ( get_gametime( ) - g_fBlockTeleport[ id ] ) );
		return 1;
	}
	
	UserUseTeleport( id );	
	g_fBlockTeleport[ id ] = get_gametime( );
	
	
	return 1;
	
}

public ClCmdNone( id )
	return 1;
	

public ClCmdAddFrag( id )
{
	
	g_iUserFrags[ id ]++;
	
	if( g_iUserLevels[ id ] >= 5 )
		return 1;
		
	while( g_iUserFrags[ id ] >= g_iLevelsFrags[ g_iUserLevels[ id ] ] )
	{
		g_iUserLevels[ id ]++;
		SetUserAbilities( id, true, false );
	}
	
	return 0;
}

public ClCmdCheckLevel( id )
{
	
	if( g_iUserLevels[ id ] >= 5 )
		return 1;
		
	while( g_iUserFrags[ id ] >= g_iLevelsFrags[ g_iUserLevels[ id ] ] )
	{
		g_iUserLevels[ id ]++;
		SetUserAbilities( id, true, false );
	}
	
	return 0;
}
	
public EventDeathMsg(  )
{	
	
	new iKiller  = read_data( 1 );
	new iVictim  = read_data( 2 );
	
	if( ( g_iFirstPlayer <= iKiller <= g_iMaxPlayers ) && iVictim != iKiller )
	{
		
		new szName[ 32 ];
		get_user_name( iVictim, szName, sizeof ( szName ) -1 );
		ColorChat( iKiller, RED, "^x04%s^x01 L-ai omorat pe^x03 %s^x01 ai primit^x03 1^x01 frag.", g_szTag, szName );
		
		client_cmd( iKiller, "bb_hidden_addfrag" );
		
	}
	
	return 0;
}

public EventSendAudioTerroWin( )
{
	GiveWinnersFrags( 1 );
	
	return 0;
}


public EventSendAudioCounterWin( )
{
	GiveWinnersFrags( 2 );

	return 0;
}

public GiveWinnersFrags( const iTeam )
{
	new iPlayers[ 32 ];
	new iPlayersNum, iPlayer;

	if( iTeam == 1 )
	{
		ColorChat( 0, RED, "^x04%s^x03 Zombii^x01 au castigat!Au primit cate^x03 2^x01 fraguri!", g_szTag );
		get_players( iPlayers, iPlayersNum, "ceh", "TERRORIST" );		
	}
	else if( iTeam == 2 )
	{
		ColorChat( 0, RED, "^x04%s^x03 Oamenii^x01 au castigat!Au primit cate^x03 2^x01 fraguri!", g_szTag );
		get_players( iPlayers, iPlayersNum, "ceh", "CT" );
	}
	
	for( new i = 0 ; i < iPlayersNum ; i++ )
	{
		iPlayer = iPlayers[ i ];
		g_iUserFrags[ iPlayer ] += 2;
		client_cmd( iPlayer, "check_for_level" );
	}
	
	
}
public Ham_PlayerSpawnPost(  id  )
{
	
	if( !is_user_alive( id ) )
		return HAM_IGNORED;
	
	g_fBlockTeleport[ id ] = 0.0;
	g_bUserHasHook[ id ] = false;
	g_bUserHasTeleport[ id ] = false;
	
	SetUserAbilities( id, false, true );
	
	return HAM_IGNORED;
			
}

public Ham_PlayerKilledPost(  id  )
{
	
	g_iUserFrags[ id ] = 0;
	g_iUserLevels[ id ] = 0; 
	g_fBlockTeleport[ id ] = 0.0;
	g_bUserHasHook[ id ] = false;
	g_bUserHasTeleport[ id ] = false;
	
	ColorChat( id, RED, "^x04%s^x01 Ai murit! Ai pierdut tot!", g_szTag );
	
	return HAM_IGNORED;
	
}

SetUserAbilities( id, const bool:bPlayLevelUpSound, const bool:bPlayAbbilitySound )
{
	
	if( g_iUserLevels[ id ] <= 0 )
		return 1;
		
	switch( g_iUserLevels[ id ] )
	{
		
		case 1:
		{
			set_task( 0.5, "TaskGiveHealth", id );
			goto gotoPlaySounds;
			
		}
		
		case 2:
		{
			set_task( 0.5, "TaskGiveGravity", id );
			goto gotoPlaySounds;
		}
		
		case 3:
		{
			
			g_bUserHasHook[ id ] = true;
			
			ColorChat( id, RED, "^x04%s^x01 Ai primit^x03 Hook^x01 - Omoara mai multi pentru a castiga alte puteri!", g_szTag );
			ColorChat( id, RED, "^x04%s^x01 Bindul pentru hook este:^x03 bind ^"tasta^" ^"+hook^"^x01 !", g_szTag );
			goto gotoPlaySounds;
		}
		
		case 4:
		{
			if( g_bUserHasHook[ id ] ) g_bUserHasHook[ id ] = false;
			
			g_bUserHasTeleport[ id ] = true;
			
			ColorChat( id, RED, "^x04%s^x01 Ai primit^x03 Teleportare^x01 - Omoara mai multi pentru a castiga alte puteri!", g_szTag );
			ColorChat( id, RED, "^x04%s^x01 Bindul pentru a te teleporta este:^x03 bind ^"tasta^" ^"+teleport^"^x01 !", g_szTag );
			goto gotoPlaySounds;
		
		}
		
		case 5:
		{
			set_task( 0.5, "TaskGiveHealth", id );
			set_task( 0.5, "TaskGiveGravity", id );
			
			g_bUserHasHook[ id ] = true;
			g_bUserHasTeleport[ id ] = true;
			
			ColorChat( id, RED, "^x04%s^x01 Ai primit^x03 Toate Puterile^x01! Rezista pentru a nu-ti pierde abilitatile!", g_szTag );
			goto gotoPlaySounds;
		
		}
			
	}
	
	gotoPlaySounds:
	
	if( bPlayLevelUpSound )
		emit_sound(  id, CHAN_AUTO, g_szBBLevelUp, 1.0, ATTN_NORM, 0, PITCH_NORM  );
		
	if( bPlayAbbilitySound )
		emit_sound(  id, CHAN_AUTO, g_szBBAbility, 1.0, ATTN_NORM, 0, PITCH_NORM  );
		
	return 0;
	
}

public TaskGiveHealth( id )
{
	if( !is_user_connected( id ) || !is_user_alive( id ) )
		return 1;
		
	new CsTeams:iTeam = cs_get_user_team( id );
	
	if( iTeam == CS_TEAM_CT || iTeam == CS_TEAM_T )
	{
			
		new iHealth = get_user_health( id );
		set_user_health( id, iHealth + g_iUserHealth[ iTeam ] );
					
		ColorChat( id, RED, "^x04%s^x01 Ai primit^x03 +%iHP^x01 - Omoara mai multi pentru a castiga alte puteri!", g_szTag, g_iUserHealth[ iTeam ] );
	}
	
	return 0;
}

public TaskGiveGravity( id )
{
	if( !is_user_connected( id ) || !is_user_alive( id ) )
		return 1;
	
	new CsTeams:iTeam = cs_get_user_team( id );
	
	if( iTeam == CS_TEAM_CT || iTeam == CS_TEAM_T )
	{
		
		set_user_gravity( id, iTeam == CS_TEAM_CT ? g_fCTGravity : g_fTGravity );
		ColorChat( id, RED, "^x04%s^x01 Ai primit^x03 Gravitatie^x01 - Omoara mai multi pentru a castiga alte puteri!", g_szTag );
		
	}
	
	return 0;
}
				
// --| Hook.
// --| Functie Extras din Kz Arg Mod by ReymonARG!

public TaskHookPrethink( id )
{
	id -= HookTask;
	
	if( !is_user_alive( id ) )
	{
		bUserIsHooked[ id ] = false;
	}
	
	if( !bUserIsHooked[ id ] )
	{
		remove_task( id + HookTask );
		return 1;
	}


	static iOrigin1[ 3 ];
	new Float:fOrigin[3];
	get_user_origin( id, iOrigin1 );
	pev( id, pev_origin, fOrigin);

	if( iHookOrigin[ id ][ 0 ] == 999999 )
	{
		static iOrigin2[ 3 ];
		get_user_origin( id, iOrigin2, 3 );
		iHookOrigin[ id ][ 0 ] = iOrigin2[ 0 ];
		iHookOrigin[ id ][ 1 ] = iOrigin2[ 1 ];
		iHookOrigin[ id ][ 2 ] = iOrigin2[ 2 ];
	}

	//Create blue beam
	message_begin( MSG_BROADCAST, SVC_TEMPENTITY );
	write_byte( 1 );
	write_short( id );
	write_coord( iHookOrigin[ id ][ 0 ] );
	write_coord( iHookOrigin[ id ][ 1 ]);
	write_coord( iHookOrigin[ id ][ 2 ] );
	write_short( iBeamSprite );
	write_byte( 1 );
	write_byte( 1 );
	write_byte( 5 );
	write_byte( 18 );
	write_byte( 0 );
	write_byte( random( 256 ) );
	write_byte( random( 256 ) );
	write_byte( random( 256 ) );
	write_byte( 200 );
	write_byte( 0 );
	message_end( );

	//Calculate Velocity
	static Float:fVelocity[ 3 ];
	fVelocity[ 0 ] = ( float( iHookOrigin[ id ][ 0 ] ) - float( iOrigin1[ 0 ] ) ) * 3.0;
	fVelocity[ 1 ] = ( float( iHookOrigin[ id ][ 1 ] ) - float( iOrigin1[ 1 ] ) ) * 3.0;
	fVelocity[ 2 ] = ( float( iHookOrigin[ id ][ 2 ] ) - float( iOrigin1[ 2 ] ) ) * 3.0;

	static Float:fY;
	fY = fVelocity[ 0 ] * fVelocity[ 0 ] + fVelocity[ 1 ] * fVelocity[ 1 ] + fVelocity[ 2 ] * fVelocity[ 2 ];

	static Float:fX;
	fX = ( HookSpeed ) / floatsqroot( fY );

	fVelocity[ 0 ] *= fX;
	fVelocity[ 1 ] *= fX;
	fVelocity[ 2 ] *= fX;

	set_velo( id, fVelocity );

	return 0;
}

public set_velo( id, Float:fVelocity[ 3 ] )
{
	return set_pev( id, pev_velocity, fVelocity );
}

// --| Teleport.
// --| Functie Extrasa din modul warcraft3.
public UserUseTeleport(  id  )
{
	
	if( !is_user_alive( id ) )  return 1;
	
	
	new vOldLocation[3], vNewLocation[3];
	
	// Get the player's current location
	get_user_origin( id, vOldLocation );
	
	// Get where the player is looking (where the player will teleport)
	get_user_origin( id, vNewLocation, 3 );
	
	// Play the blink sound!
	emit_sound( id, CHAN_STATIC, g_szTeleport, 1.0, ATTN_NORM, 0, PITCH_NORM );
	
	// If we teleport them back, make sure they don't get teleported into the ground
	vOldLocation[2] += 15;

	// Change coordinates to make sure player won't get stuck in the ground/wall
	vNewLocation[0] += ( ( vNewLocation[0] - vOldLocation[0] > 0 ) ? -50 : 50 );
	vNewLocation[1] += ( ( vNewLocation[1] - vOldLocation[1] > 0 ) ? -50 : 50 );
	vNewLocation[2] += 40;			

	
	// Set up some origins for some special effects!!!
	new vCenterOrigin[3], vAxisOrigin[3];
	vCenterOrigin[0]	= vOldLocation[0];
	vCenterOrigin[1]	= vOldLocation[1];
	vCenterOrigin[2]	= vOldLocation[2] + 10;
	vAxisOrigin[0]		= vOldLocation[0];
	vAxisOrigin[1]		= vOldLocation[1];
	vAxisOrigin[2]		= vOldLocation[2] + 10 + 50;

	// Lets create some beam cylinders!
	Create_TE_BEAMCYLINDER( vOldLocation, vCenterOrigin, vAxisOrigin, iShockWave, 0, 0, 3, 60, 0, 255, 255, 255, 255, 0 );
	
	// Modify our effects a bit for another cylinder
	vCenterOrigin[2]	+= 80;
	vAxisOrigin[2]		+= 80;
	
	// And draw another cylinder!!!
	Create_TE_BEAMCYLINDER( vOldLocation, vCenterOrigin, vAxisOrigin, iShockWave, 0, 0, 3, 60, 0, 255, 255, 255, 255, 0 );

	// Planting the bomb then teleporting = bad, lets stop this...
	client_cmd( id, "-use" );
	// Teleport the player!!!
	set_user_origin( id, vNewLocation );

	// Check if Blink landed you in a wall, if so, abort
	new parm[5];
	parm[0] = id;
	parm[1] = vOldLocation[0];
	parm[2] = vOldLocation[1];
	parm[3] = vOldLocation[2];
	parm[4] = vNewLocation[2];
	
	set_task( 0.1, "_HU_ULT_BlinkStuck", 112233 + id, parm, 5 );

	emit_sound( id, CHAN_STATIC, g_szTeleport, 1.0, ATTN_NORM, 0, PITCH_NORM );
	
	return 1;
}

public _HU_ULT_BlinkStuck( parm[] )
{

	new id = parm[0]	;

	if ( !is_user_connected(  id  ) )
	{
		return;
	}

	new vOldLocation[3], vOrigin[3];

	vOldLocation[0] = parm[1];
	vOldLocation[1] = parm[2];
	vOldLocation[2] = parm[3];

	get_user_origin( id, vOrigin );
	
	// Then the user is stuck :/
	if ( parm[4] == vOrigin[2] )
	{

		//set_hudmessage( 255, 255, 10, -1.0, -0.4, 1, 0.5, BLINK_COOLDOWN, 0.2, 0.2, 5 );
		set_hudmessage(255, 0, 0, -1.0, 0.28, 0, 6.0, 1.0);
		show_hudmessage(id, "Teleport failed");
		
		// This will try to move the user back - if this fails then they will be teleported back to their spawn instead of left stuck!
		SHARED_Teleport( id, vOldLocation );
		g_fBlockTeleport[ id ] = 0.0;

	}

	// Otherwise they teleported correctly!
	else
	{

		// Sprays white bubbles everywhere
		new vStartOrigin[3];
		vStartOrigin[0] = vOrigin[0];
		vStartOrigin[1] = vOrigin[1];
		vStartOrigin[2] = vOrigin[2] + 40;
		
		Create_TE_SPRITETRAIL( vStartOrigin, vOrigin, iBlueFlare, 50, 10, 1, 50, 10 );

		Create_ScreenFade( id, (1<<15), (1<<10), (1<<12), 0, 0, 255, 180 );
	}	
	
	return;
}
// This will teleport a user to a location and test to make sure they were actually moved there
SHARED_Teleport( id, vOrigin[3] )
{
	// Increase so user doesn't get stuck in ground
	vOrigin[2] += 15;

	// Attempt to move the user
	set_user_origin( id, vOrigin );

	new iParm[4];
	iParm[0] = vOrigin[0];
	iParm[1] = vOrigin[1];
	iParm[2] = vOrigin[2];
	iParm[3] = id;

	// Set up the parameters
	set_task( 0.1, "_SHARED_Teleport", 112233 + id, iParm, 4 );
}

public _SHARED_Teleport( parm[] )
{
	new id = parm[3];
	new vOrigin[3];
	
	get_user_origin( id, vOrigin );


	// User is stuck, lets teleport them back to their spawn
	if ( vOrigin[2] == parm[2] )
	{
		
		client_print( id, print_chat, "Sorry, I know you're stuck, but I can't move you right now :/" );
		user_kill( id, 1 );
	}
}
stock Create_TE_BEAMCYLINDER(origin[3], center[3], axis[3], iSprite, startFrame, frameRate, life, width, amplitude, red, green, blue, brightness, speed){

	message_begin( MSG_PAS, SVC_TEMPENTITY, origin );
	write_byte( TE_BEAMCYLINDER );
	write_coord( center[0] );			// center position (X)
	write_coord( center[1] );			// center position (Y)
	write_coord( center[2] );			// center position (Z)
	write_coord( axis[0] );			// axis and radius (X)
	write_coord( axis[1] );				// axis and radius (Y)
	write_coord( axis[2] );				// axis and radius (Z)
	write_short( iSprite );				// sprite index
	write_byte( startFrame );			// starting frame
	write_byte( frameRate );				// frame rate in 0.1's
	write_byte( life );					// life in 0.1's
	write_byte( width );					// line width in 0.1's
	write_byte( amplitude );				// noise amplitude in 0.01's
	write_byte( red );					// color (red)
	write_byte( green );					// color (green)
	write_byte( blue );					// color (blue)
	write_byte( brightness );			// brightness
	write_byte( speed );					// scroll speed in 0.1's
	message_end();
}

stock Create_ScreenFade(id, duration, holdtime, fadetype, red, green, blue, alpha){

	message_begin( MSG_ONE,get_user_msgid( "ScreenFade" ),{0,0,0},id );			
	write_short( duration );			// fade lasts this long duration
	write_short( holdtime );			// fade lasts this long hold time
	write_short( fadetype );			// fade type (in / out)
	write_byte( red );				// fade red
	write_byte( green );				// fade green
	write_byte( blue );				// fade blue
	write_byte( alpha );				// fade alpha
	message_end();
}

stock Create_TE_SPRITETRAIL(start[3], end[3], iSprite, count, life, scale, velocity, random ){

	message_begin( MSG_BROADCAST,SVC_TEMPENTITY);
	write_byte( TE_SPRITETRAIL );
	write_coord( start[0] );			// start position (X)
	write_coord( start[1] );			// start position (Y)
	write_coord( start[2] );				// start position (Z)
	write_coord( end[0] );				// end position (X)
	write_coord( end[1] );				// end position (Y)
	write_coord( end[2] );				// end position (Z)
	write_short( iSprite );				// sprite index
	write_byte( count );					// count
	write_byte( life);					// life in 0.1's
	write_byte( scale);					// scale in 0.1's
	write_byte( velocity );				// velocity along vector in 10's
	write_byte( random );				// randomness of velocity in 10's
	message_end();
}

// --| Teleport.
// --| Functie Extrasa din modul war3ft.