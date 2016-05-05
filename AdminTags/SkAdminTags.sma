#include <amxmodx>
#include <amxmisc>

#define PLUGIN		"Sk Admin Tags"
#define VERSION		"2.1"
#define AUTHOR		"Shooting King"

#define cm(%0)		(sizeof(%0)-1)

// Owners
// Co-Owners
// Managers
// Heads
// VIPS
// Clan Members

enum
{
	OWNER = 0,
	COOWNER,
	MANAGER,
	HEAD,
	VIPS,
	CMEMBERS
}

enum
{
	STEAMID = 0,
	NICK
}

new const gszFiles[][] = {
	
	"owners.ini",
	"coowners.ini",
	"managers.ini",
	"heads.ini",
	"vips.ini",
	"clan-members.ini"
}

new const gszAdminTags[][] = {

	"Owner",
	"Co-Owner",
	"Manager",
	"Head",
	"VIP",
	"Clan",
	"Admin"
}

new gszDir[64];
new gszAdminFiles[6][64];
new gArraySize[6][2];
new Array:gAdminArrays[6][2];
new g_Admin[33];
new gSayText, gTeamInfo;

new gszTeams[][] = {

	"",
	"TERRORIST",
	"CT",
	"SPECTATOR"
}

public plugin_init()
{
	register_plugin( PLUGIN, VERSION, AUTHOR );
	
	register_clcmd( "say", "cmdSay" );
	register_clcmd( "say_team", "cmdTSay" );
	register_concmd( "amx_sk_reloadadmins", "reload_admins" );
	
	get_configsdir( gszDir, cm(gszDir));
	add( gszDir , cm(gszDir) , "/SkTags" );
	
	for( new i = OWNER; i <= CMEMBERS; i++ )
	{
		formatex( gszAdminFiles[i], 63, "%s/%s", gszDir, gszFiles[i] );
	}
	
	if (!dir_exists( gszDir ))
	{
		mkdir(gszDir);
		create_Files();
	}
	else
	{
		read_Files();
	}
		
	gSayText = get_user_msgid("SayText");
	gTeamInfo = get_user_msgid("TeamInfo");
}

public create_Files()
{
	for( new i = OWNER; i <= CMEMBERS; i++ )
	{
		fclose(fopen( gszAdminFiles[i], "wt" ));
	}
}	

public reload_admins()
{
	server_cmd( "amx_reloadadmins" );
	set_task( 0.1, "read_Files" );
	set_task( 0.2, "reloadStuff" );
}

public reloadStuff()
{
	new szPlayers[32], iNum;
	get_players( szPlayers, iNum );
	
	while( --iNum >= 0 )
	{
		client_putinserver(szPlayers[iNum]);
	}
	log_amx( "Admin Configuration Successfully Reloaded." );
}

public read_Files()
{
	new tempfile, szBuffer[64], szData[32], szNum[3];
	new i; //, j;
	// log_amx( "Read Files CAlled." );	
		
	for( i = OWNER; i <= CMEMBERS; i++ )
	{
		tempfile = fopen( gszAdminFiles[i], "r" );
		ArrayClear( Array:gAdminArrays[i][STEAMID] );
		ArrayClear( Array:gAdminArrays[i][NICK] );
		
		while(!feof(tempfile))
		{
			szNum[0] = '^0';
			szData[0] = '^0';
			szBuffer[0] = '^0';
		
			fgets( tempfile, szBuffer, cm(szBuffer));
			if( szBuffer[0] != ';' && szBuffer[0] != '/' && szBuffer[0] != ' ' )
			{			
				trim(szBuffer);
				for( new i = 0; i < strlen(szBuffer); i++ )
				{
					if( szBuffer[i] == ';' || szBuffer[i] == '/' )
					{
						szBuffer[i] = '^0';
					}
				}
				parse( szBuffer, szNum, cm(szNum), szData, cm(szData));
				trim(szNum);
				trim(szData);
				remove_quotes(szData);
				switch (str_to_num(szNum))
				{
					case 1: ArrayPushString( Array:gAdminArrays[i][STEAMID], szData );
					case 2: ArrayPushString( Array:gAdminArrays[i][NICK], szData );
				}
			}
		}
		gArraySize[i][STEAMID] = ArraySize(Array:gAdminArrays[i][STEAMID]);
		gArraySize[i][NICK] = ArraySize(Array:gAdminArrays[i][NICK]);		
		fclose(tempfile);
	}
	
	/*for( i = OWNER; i <= CMEMBERS; i++ )
	{
		log_amx( "%s STEAMID", gszFiles[i] );
		for( j = 0; j < ArraySize(Array:gAdminArrays[i][STEAMID]); j++ )
		{
			ArrayGetString( Array:gAdminArrays[i][STEAMID], j, szBuffer, cm(szBuffer));
			log_amx( "%s", szBuffer );
		}
		
		log_amx( "%s NICK", gszFiles[i] );
		log_amx( "%d", ArraySize(Array:gAdminArrays[i][NICK]) );
		for( j = 0; j < ArraySize(Array:gAdminArrays[i][NICK]); j++ )
		{
			ArrayGetString( Array:gAdminArrays[i][NICK], j, szBuffer, cm(szBuffer));
			log_amx( "%s", szBuffer );
		}
	}*/
}

public plugin_precache()
{
	for( new i = OWNER; i <= CMEMBERS; i++ )
	{
		gAdminArrays[i][STEAMID] = ArrayCreate(32);
		gAdminArrays[i][NICK] = ArrayCreate(32);
	}
}

public client_putinserver(id)
{
	g_Admin[id] = -1;
	if(!is_user_admin(id))
	{
		return PLUGIN_CONTINUE;
	}
	
	static i, j, szAuth[32], szBuffer[32], szName[32];
	
	szAuth[0] = '^0';
	szBuffer[0] = '^0';
	szName[0] = '^0';
	
	get_user_authid(id, szAuth, cm(szAuth));	
	for( i = OWNER; i <= CMEMBERS; i++ )
	{
		for( j = 0; j < gArraySize[i][STEAMID]; j++ )
		{
			ArrayGetString( Array:gAdminArrays[i][STEAMID], j, szBuffer, cm(szBuffer));
		
			if(equal(szBuffer, szAuth))
			{
				g_Admin[id] = i;
				return PLUGIN_CONTINUE;
			}
		}
	}
	
	get_user_name(id, szName, cm(szName));
	for( i = OWNER; i <= CMEMBERS; i++ )
	{
		for( j = 0; j < gArraySize[i][NICK]; j++ )
		{
			ArrayGetString( Array:gAdminArrays[i][NICK], j, szBuffer, cm(szBuffer));
		
			if(equal(szBuffer, szName))
			{
				g_Admin[id] = i;
				return PLUGIN_CONTINUE;
			}
		}
	}
	g_Admin[id] = 6;
	return PLUGIN_CONTINUE;
}

public cmdSay(id)
{
	if( g_Admin[id] == -1 )
	{
		return PLUGIN_CONTINUE;
	}
	
	static szMsg[192];
	read_args(szMsg, cm(szMsg));
	
	if(strlen(szMsg) > 2 && szMsg[1] != '@')
	{
		PostSay(id, 0, szMsg);
		return PLUGIN_HANDLED;
	}
	return PLUGIN_CONTINUE;
}

public cmdTSay(id)
{
	if( g_Admin[id] == -1 )
	{
		return PLUGIN_CONTINUE;
	}
	
	static szMsg[192];
	read_args(szMsg, cm(szMsg));

	if(strlen(szMsg) > 2 && szMsg[1] != '@')
	{
		PostSay(id, 1, szMsg);
		return PLUGIN_HANDLED;
	}
	return PLUGIN_CONTINUE;
}

public PostSay(id, isTeamMsg, szMsg[])
{
	static szTeam[32], szName[32], szStatus[8];
	new iTeam = get_user_team(id);
	
	if(!iTeam) iTeam = 3;
	
	szTeam[0] = '^0';
	szStatus[0] = '^0';
	
	if( isTeamMsg )
	{
		add( szTeam, charsmax(szTeam), "(" );
		if(iTeam == 2)
		{
			add( szTeam, charsmax(szTeam), "Counter-Terrorist" );
		}
		else
		{
			add( szTeam, charsmax(szTeam), gszTeams[iTeam]);
			strtolower(szTeam);
			szTeam[1] -= 32;			
		}
		add( szTeam, charsmax(szTeam), ") " );
	}
	
	if(!is_user_alive(id) && iTeam != 3)
	{
		szStatus = "*DEAD* ";
	}
	else if(!is_user_alive(id) && iTeam == 3)
	{
		szStatus = "*SPEC* ";
	}
	
	get_user_name( id, szName, cm(szName));
	remove_quotes(szMsg);
	replace_all( szMsg, 191, "%", "" );
	
	ClientColourSay( iTeam, isTeamMsg, "^x01%s%s^x03^x04[^^%s^^] ^x03%s ^x01: %s%s", szTeam, szStatus, gszAdminTags[g_Admin[id]], szName, ((g_Admin[id]<4)?"^x04":""), szMsg);
}

stock ClientColourSay( iTeam, isTeamMsg, const input[], any:...)
{
	static szPlayers[32], iCount, i, gizLTeam; 
	static szMsg[192];
	vformat(szMsg, cm(szMsg), input, 4);
	
	if(isTeamMsg)
	{
		get_players(szPlayers, iCount, "ceh", gszTeams[iTeam]);
	}
	else
	{
		get_players(szPlayers, iCount, "ch");
	}

	for( i = 0; i < iCount; i++ )
	{
		if(is_user_connected(szPlayers[i]))
		{
			if( iTeam && iTeam != get_user_team(szPlayers[i]) )
			{
				gizLTeam = get_user_team(szPlayers[i]);
				ChangeTeamInfo(szPlayers[i], iTeam);
			}
	
			message_begin(MSG_ONE_UNRELIABLE, gSayText, _, szPlayers[i]);
			write_byte(szPlayers[i]);
			write_string(szMsg);
			message_end();

			if( gizLTeam )
			{
				ChangeTeamInfo(szPlayers[i], gizLTeam);
				gizLTeam = 0;
			}			
		}
	}
}

stock ChangeTeamInfo(iPlayer, iTeam)
{
	message_begin(MSG_ONE_UNRELIABLE, gTeamInfo, _, iPlayer);	
	write_byte(iPlayer);				
	write_string(gszTeams[iTeam]);				
	message_end();	
}