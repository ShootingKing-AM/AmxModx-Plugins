#include < amxmodx >
#include < cstrike >
#include < fun >
#include < ColorChat >

#pragma semicolon 1


#define PLUGIN "Magic Word"
#define VERSION "1.0"

#define		MagicWordTask		112233
#define		MagicWordSecondTask	332211

enum
{
	PRIZE_MONEY,
	PRIZE_HP,
	PRIZE_NADES,
	PRIZE_DEAGLE
}

new const g_szSmallLetters[    ] =
{
	'a','b','c','d',
	'e','f','g','h',
	'i','j','k','l',
	'm','n','o','p',
	'q','r','s','t',
	'u','v','w','x',
	'y','z'
};


new const g_szLargeLetters[    ] =
{
	'A','B','C','D',
	'E','F','G','H',
	'I','J','K','L',
	'M','N','O','P',
	'Q','R','S','T',
	'U','V','W','X',
	'Y','Z'
};


new const g_szNumbers[    ]  =  
{
	'0','1',
	'2','3',
	'4','5',
	'6','7',
	'8','9'
};

new const g_szSymbols[    ]  =  
{
	'!','@','#','$',
	'%','&','*','(',
	')','_','-','+',
	'=','\','|','[',
	'{',']','}',':',
	',','<','.','>',
	'/','?'
};

new gCvarMagicWordIterval;
new gCvarMagicWordAnswerTime;
new gCvarMagicWordMoney;
new gCvarMagicWordHP;

new g_iAnswerTime = 0;
new g_szMagicWord[ 32 ];

new bool:g_bPlayersCanAnswer  =  false;

new SyncHudMessage;

public plugin_init( )
{
	register_plugin( PLUGIN, VERSION, "Askhanar" );
	
	gCvarMagicWordIterval =  register_cvar( "fmu_mw_interval",  "180"  );
	gCvarMagicWordAnswerTime = register_cvar( "fmu_mw_answertime",  "15"  );
	gCvarMagicWordMoney = register_cvar( "fmu_mw_money",  "8000"  );
	gCvarMagicWordHP = register_cvar( "fmu_mw_hp",  "500"  );
	
	register_clcmd( "amx_magicword", "ClCmdMagicWord" );
	
	register_clcmd( "say", "CheckForMagicWord" );
	register_clcmd( "say_team", "CheckForMagicWord" );	
	
	SyncHudMessage  =  CreateHudSyncObj(    );
	set_task(  15.0,  "ChooseRandomWord",  MagicWordTask  );
	
}

public ClCmdMagicWord( id )
{
	if( !UserHasAcces( id ) )
	{
		client_cmd( id, "echo Nu ai acces la aceasta comanda !" );
		return PLUGIN_HANDLED;
	}
	
	read_argv( 1, g_szMagicWord, 14 );
	if( equal( g_szMagicWord, "" ) )
	{
	
		remove_task( MagicWordTask );
		remove_task( MagicWordSecondTask );
		g_bPlayersCanAnswer = false;
	
		ChooseRandomWord( );
	}
	else
	{
		remove_task( MagicWordTask );
		remove_task( MagicWordSecondTask );
		g_bPlayersCanAnswer = false;
	
		DisplayMagicWord( );
	}
	
	
	return 1;
}
	
public CheckForMagicWord(  id  )
{
	
	static szSaid[ 192 ];
	read_args( szSaid, sizeof ( szSaid ) -1 );
	
	remove_quotes( szSaid );
	if( equali( szSaid, "" )  || !g_bPlayersCanAnswer )
		return PLUGIN_CONTINUE;
	
	
	if( equal( szSaid, g_szMagicWord ) )
	{
		g_bPlayersCanAnswer  =  false;
		client_cmd( 0, "spk woop" );
		GiveUserPrize( id );
	}
	
	return PLUGIN_CONTINUE;
}


public ChooseRandomWord( )
{
	if( !get_playersnum( ) )
	{
		set_task( float( get_pcvar_num( gCvarMagicWordIterval ) ), "ChooseRandomWord", MagicWordTask );
		return;
	}
	
	new iLen = random_num( 10, 15 );
	formatex( g_szMagicWord, sizeof ( g_szMagicWord ) -1, "" );
	
	for( new i = 0; i < iLen; i++ )
		g_szMagicWord[ i ] = GetRandomCharacter( );
	
	StartMagicWord( );
	client_cmd( 0, "spk doop" );
	
	set_task( float( get_pcvar_num( gCvarMagicWordIterval ) ), "ChooseRandomWord", MagicWordTask );
}

public DisplayMagicWord( )
{
	if( !get_playersnum( ) )
	{
		set_task( float( get_pcvar_num( gCvarMagicWordIterval ) ), "ChooseRandomWord", MagicWordTask );
		return;
	}
	
	StartMagicWord( );
	client_cmd( 0, "spk doop" );
	
	set_task( float( get_pcvar_num( gCvarMagicWordIterval ) ), "ChooseRandomWord", MagicWordTask );
}

GetRandomCharacter( )
{
	new Float:fRandom = random_float( 1.0, 100.0 );
	
	if( fRandom <= 25.0 )
	{
		return g_szSmallLetters[ random( sizeof ( g_szSmallLetters ) ) ];
	}
	
	else if( fRandom > 25.0 && fRandom <= 50.0 )
	{
		return g_szLargeLetters[ random( sizeof ( g_szLargeLetters ) ) ];
	}
	
	else if( fRandom > 50.0 && fRandom < 75.0 )
	{
		return g_szNumbers[ random( sizeof ( g_szNumbers ) ) ];
	}
	else if( fRandom > 75.0 )
	{
		return g_szSymbols[ random( sizeof ( g_szSymbols ) ) ];
	}
	
	return EOS;
}

public StartMagicWord( )
{
	g_bPlayersCanAnswer = true;
	
	g_iAnswerTime = get_pcvar_num( gCvarMagicWordAnswerTime );
	CountAnswerTime( );
	
}
	
public CountAnswerTime( )
{
	
	if( g_bPlayersCanAnswer )
	{
		
		if( g_iAnswerTime <= 0 )
		{
			g_bPlayersCanAnswer  =  false;
			ColorChat( 0, RED, "^x04[Magic Word]^x01 Nu a scris nimeni cuvantul magic, poate data viitoare.." );
			return PLUGIN_HANDLED;
		}
		
		set_hudmessage( 0, 255, 255, 0.01, 0.20, 0, 0.0, 1.0, 0.0, 0.1, 2 );
		ShowSyncHudMsg( 0, SyncHudMessage, "Castiga un premiu primul care scrie  -|   %s   |-^n               %i secund%s ramas%s !!",
			g_szMagicWord, g_iAnswerTime, g_iAnswerTime  ==  1 ? "a" : "e", g_iAnswerTime  ==  1 ? "a" : "e" );
		
		g_iAnswerTime--;
		
		set_task( 1.0, "CountAnswerTime", MagicWordSecondTask );
	}
	
	return PLUGIN_CONTINUE;
}

public GiveUserPrize( id )
{
	
	new szName[ 32 ];
	get_user_name( id, szName, sizeof ( szName ) -1 );
	
	new iRandomPrize = random_num( PRIZE_MONEY, PRIZE_DEAGLE );
	
	switch( iRandomPrize )
	{
		case PRIZE_MONEY:
		{
			cs_set_user_money( id, clamp( cs_get_user_money( id ) + get_pcvar_num( gCvarMagicWordMoney ), 0, 16000 ) );
			ColorChat( 0, RED, "^x04[Magic Word]^x03 %s^x01 a scris primul^x03 %s^x01 si a primit^x03 %i $^x01 !", szName, g_szMagicWord, get_pcvar_num( gCvarMagicWordMoney ) );
		}
		case PRIZE_HP:
		{
			set_user_health( id, get_user_health( id ) + get_pcvar_num( gCvarMagicWordHP ) );
			ColorChat( 0, RED, "^x04[Magic Word]^x03 %s^x01 a scris primul^x03 %s^x01 si a primit^x03 %i HP^x01 !", szName, g_szMagicWord, get_pcvar_num( gCvarMagicWordHP ) );
		}
		case PRIZE_NADES:
		{
			give_item( id, "weapon_hegrenade" );
			give_item( id, "weapon_smokegrenade" );
			
			cs_set_user_bpammo( id, CSW_HEGRENADE, 3 );
			cs_set_user_bpammo( id, CSW_SMOKEGRENADE, 3 );
			
			ColorChat( 0, RED, "^x04[Magic Word]^x03 %s^x01 a scris primul^x03 %s^x01 si a primit^x03 grenade ^x01 !", szName, g_szMagicWord );
		}
		case PRIZE_DEAGLE:
		{
			cs_set_weapon_ammo( give_item( id, "weapon_deagle" ), 7 );
			ColorChat( 0, RED, "^x04[Magic Word]^x03 %s^x01 a scris primul^x03 %s^x01 si a primit^x03 deagle ^x01 !", szName, g_szMagicWord );
		}
	}
	
	formatex( g_szMagicWord, sizeof ( g_szMagicWord ) -1, "" );
	return 0;
}

stock bool:UserHasAcces( id )
{
	
	if( get_user_flags( id ) & ADMIN_RCON )
		return true;
	
	return false;
	
}