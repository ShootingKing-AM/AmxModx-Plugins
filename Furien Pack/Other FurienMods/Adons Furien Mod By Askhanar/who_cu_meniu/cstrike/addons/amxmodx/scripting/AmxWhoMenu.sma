#include <amxmodx>

#pragma semicolon 1


#define MAX_GROUPS 7

new const g_groupNames[ MAX_GROUPS ][ ] = {
   
	"Manager",
	"Owner",
	"God",
	"Administrator",
	"Moderator",
	"Helper",
	"Nume Rezervat"
};

new const g_groupFlags[ MAX_GROUPS ][ ] = {
	
	"abcdefghijklmnopqrstu",
	"abcdefghijklmnopqrs",
	"cdefghijmnopqr",  
	"cdefijmnopqr",
	"cdefijmnp",
	"cdefijm",
	"w"
};

new const g_groupFlagsB[ MAX_GROUPS ][ ] = {
	
	"abcdefghijklmnopqrstu",
	"abcdefghijklmnopqrs",
	"bcdefghijmnopqr",  
	"bcdefijmnopqr",
	"bcdefijmnp",
	"bcdefijm",
	"bw"
};

new const g_groupFlagsVIP[ MAX_GROUPS ][ ] = {
	
	"abcdefghijklmnopqrstuvxy",
	"abcdefghijklmnopqrsvxy",
	"cdefghijmnopqrvxy",  
	"cdefijmnopqrvxy",
	"cdefijmnpvxy",
	"cdefijmvxy",
	"vwxy"
};

new const g_groupFlagsBVIP[ MAX_GROUPS ][ ] = {
	
	"abcdefghijklmnopqrstuvxy",
	"abcdefghijklmnopqrsvxy",
	"bcdefghijmnopqrvxy",  
	"bcdefijmnopqrvxy",
	"bcdefijmnpvxy",
	"bcdefijmvxy",
	"bvwxy"
};


#define PLUGIN	"Ultimate Who"
#define VERSION	"2.0"

static const MENU_NAME[ ] = "\r| \wNume Admin      \r|  \wGrad  \r|  \wSlot  \r|\w  VIP  \r|";
static const NO_ADMINS_MENU_NAME[ ] = "\y Nu sunt admini online";
static const MENU_EXIT_NAME[ ] = "\yIesire";

public plugin_init( )
{
	
	register_plugin( PLUGIN, VERSION, "Askhanar" );
	
	register_clcmd( "say /who", "cmdWho", -1, "" );
	register_clcmd( "say /admins", "cmdWho", -1, "" );
	register_concmd( "say /admin", "cmdWho", -1, "" );
	register_clcmd( "say_team /who", "cmdWho", -1, "" );
	register_clcmd( "say_team /admins", "cmdWho", -1, "" );
	register_concmd( "say_team /admin", "cmdWho", -1, "" );
	
}

public cmdWho( id )
{
	ShowMenu( id, 0 );
	return 1;
}

public ShowMenu(id, page)
{
	new MenuName[ 64 ], MenuExitKey[ 32 ];
	
	formatex( MenuName, sizeof ( MenuName ) -1, "%s",  MENU_NAME );

	formatex( MenuExitKey, sizeof ( MenuExitKey ) -1, "%s", MENU_EXIT_NAME );
	
	new menu = menu_create(MenuName, "MenuHandler");   
	
	if( AdminsOnline(  )  )
	{
		
		for( new i = 0; i < MAX_GROUPS; i++  )
		{
			AddAdminsToMenu( id, menu, i );
		}
	}
	else
	{
		menu_additem( menu, NO_ADMINS_MENU_NAME, "1", 0 );
	}
	
	menu_setprop(menu, MPROP_EXITNAME, MenuExitKey );
	
	menu_display(id, menu, page);
}

public MenuHandler(id, menu, item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy( menu );
		return 1;
	}
	
	new data[6], iName[64];
	new iaccess, callback;
	
	menu_item_getinfo(menu, item, iaccess, data,5, iName, 63, callback);
	
	new key = str_to_num(data);
	
	switch(key)
	{
		case 1,2,3,4,5,6,7:
		{
			menu_destroy( menu );
			return 1;
		}
	}
	
	return 0;
}

public AddAdminsToMenu( const id, const iMenu,  const iGroup  )
{
	
	new szMenuMessage[ 64 ], szMenuKey[ 32 ], iMenuKey = 1;
	
	new iPlayers[ 32 ];
	new iPlayersNum, iPlayer;
	
	get_players( iPlayers, iPlayersNum, "c" );		
	for( new i = 0 ; i < iPlayersNum ; i++ )
	{
		iPlayer = iPlayers[ i ];
		if( UserHasGroupAcces( iPlayer, iGroup ) )
		{

			formatex( szMenuMessage, sizeof (szMenuMessage ) -1, "\w%s \y-| \w%s \y| %s \y| %s\y | %s",
				get_name( iPlayer ), g_groupNames[ iGroup ],
				UserHasSlot( iPlayer )? "\rx" : "\dx", IsUserVip( iPlayer )? "\rx" : "\dx",
				iPlayers[ i ] == id ? "\r *" : "" );
				
			formatex( szMenuKey, sizeof ( szMenuKey ) -1, "%i", iMenuKey );
			
			menu_additem( iMenu, szMenuMessage, szMenuKey, 0 );
			iMenuKey++;
		}
	}
	
}
	
stock bool:AdminsOnline(    )
{
	new bool:AdminsFound = false;
	
	new iPlayers[ 32 ];
	new iPlayersNum;

	get_players( iPlayers, iPlayersNum, "c" );		
	for( new i = 0 ; i < iPlayersNum ; i++ )
	{

		if( UserHasAnyAcces( iPlayers[ i ] ) >= 0 )
		{
			AdminsFound = true;
			break;
		}
	}
	
	return AdminsFound;
}

stock bool:IsUserVip(  id  )
{
	
	if( get_user_flags(  id  )  &  read_flags(  "vxy"  )  )
		return true;
	
	return false;
	
}

stock bool:UserHasSlot( id )
{
	if( get_user_flags( id ) & read_flags( "b" ) )
		return true;
		
	return false;
}

stock bool:UserHasGroupAcces( id, const iGroup )
{
	static iFlags;
	iFlags = get_user_flags( id );
	
	if( iFlags == read_flags( g_groupFlags[ iGroup ] )
		|| iFlags == read_flags( g_groupFlagsB[ iGroup ] )
		|| iFlags == read_flags( g_groupFlagsVIP[ iGroup ] )
		|| iFlags == read_flags( g_groupFlagsBVIP[ iGroup ] ) )
		return true;
		
	return false;
	
}
		
stock UserHasAnyAcces( id )
{
	new iFlags = get_user_flags( id );
	new iValueToReturn = -2;
	
	for( new i = 0; i < MAX_GROUPS; i++ )
	{
		if( iFlags == read_flags( g_groupFlags[ i ] )
			|| iFlags == read_flags( g_groupFlagsB[ i ] )
			|| iFlags == read_flags( g_groupFlagsVIP[ i ] )
			|| iFlags == read_flags( g_groupFlagsBVIP[ i ] ) )
		{
			iValueToReturn = i;
			break;
		}
	}
	
	return iValueToReturn;
}

stock get_name( id )
{
	
	new name[ 32 ];
	get_user_name( id, name, sizeof ( name ) -1 );

	return name;
}