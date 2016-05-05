#include <amxmodx>
#include <amxmisc>
#include <sklevels>

#define PLUGIN		"Client Levels Chat"
#define VERSION		"1.3"
#define AUTHOR		"Shooting King"

#define SIZE		190

new gizLTeam[33];
new bool:bAlive[33];
new gSayText, gTeamInfo;
new g_maxplayers;

new gszTeams[][] = {

	"",
	"TERRORIST",
	"CT",
	"SPECTATOR"
}

public plugin_init()
{
	register_plugin( PLUGIN, VERSION, AUTHOR );
	// CheckServerIp( "128.199.249.214:27015" );
	register_clcmd( "say", "cmd_Say" );
	
	gSayText = get_user_msgid("SayText");
	gTeamInfo = get_user_msgid("TeamInfo");
	g_maxplayers = get_maxplayers();
}

public cmd_Say(id)
{	
	static szMessage[SIZE+1], szPostMessage[SIZE+1], szName[32], szStatus[16];
	
	szMessage[0] = '^0';
	szPostMessage[0] = '^0';
	szName[0] = '^0';
	szStatus[0] = '^0';
	
	read_args( szMessage, SIZE );
	remove_quotes( szMessage );
	trim( szMessage );
	
	if( strlen(szMessage) < 1 )
	{
		return PLUGIN_CONTINUE;
	}
	
	get_user_name( id, szName, charsmax(szName));
		
	if( !is_user_alive(id) )
	{
		if( get_user_team(id) == 4 )
		{
			szStatus = "*SPEC* ";
		}
		else
		{
			szStatus = "*DEAD* ";
		}
		bAlive[id] = false;
	}
	else
	{
		bAlive[id] = true;
	}
	
	formatex( szPostMessage, SIZE, "^x01%s^x03[Level %d] ^x03%s^x01 : %s", szStatus, sk_get_user_level(id), szName, szMessage );
	gizLTeam[id] = get_user_team(id);
	
	Client_Print_All( gizLTeam[id], bAlive[id], szPostMessage );
	return PLUGIN_HANDLED;
}

stock Client_Print_All( Color, Alive, const input[], any:...)
{
	static i; 
	static szMsg[192];
	vformat(szMsg, 191, input, 4);
	
	for( i=0; i < g_maxplayers; i++ )
	{
		if( is_user_connected(i) )
		{
			if((is_user_alive(i) == Alive)|| Alive || is_user_admin(i))
			{
				if( Color && Color != get_user_team(i) )
				{
					gizLTeam[i] = get_user_team(i);
					ChangeTeamInfo(i, Color);
				}
	
				message_begin(MSG_ONE_UNRELIABLE, gSayText, _, i);
				write_byte(i);
				write_string(szMsg);
				message_end();

				if( gizLTeam[i] )
				{
					ChangeTeamInfo(i, gizLTeam[i]);
					gizLTeam[i] = 0;
				}
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
	