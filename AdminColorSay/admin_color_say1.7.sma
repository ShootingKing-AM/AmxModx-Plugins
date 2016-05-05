/************************************************************************************

			Admin Color Say
					- Shooitng King
					- ConnorMcLeod ( Stock )
	Cvars:
		Color Nums :
				1 - Normal
				2 - Green
				3 - Red
				4 - Blue
				5 - White
				6 - Team Color		

		1. acs_ncolor <num> Default: 3
		2. acs_mcolor <num> Default: 2

	NOTE:
		- Color 3, 4, 5 can be used for either of the cvars not for BOTH.
		- If you keep both the cvars to 3, 4, 5 then the Message will be uniformly
		  coloured according to acs_ncolor cvar.
				
************************************************************************************/	 

#include <amxmodx>

#define PLUGIN		"Admin Color Say"
#define VERSION		"1.7"
#define AUTHOR		"Shooting King"

new pcvar_NameColor, pcvar_MsgColor;
new gizLTeam;
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
	pcvar_NameColor = register_cvar( "acs_ncolor", "3" );
	pcvar_MsgColor = register_cvar( "acs_mcolor", "2" );
	
	gSayText = get_user_msgid("SayText");
	gTeamInfo = get_user_msgid("TeamInfo");
}

public cmdSay(id)
{
	static szMsg[192]
	read_args(szMsg, 191);

	if((get_user_flags(id) & ADMIN_CHAT) && (strlen(szMsg) > 0))
	{
		PostSay(id, 0, szMsg);
		return PLUGIN_HANDLED_MAIN;
	}
	return PLUGIN_CONTINUE;
}

public cmdTSay(id)
{
	static szMsg[192]
	read_args(szMsg, 191);

	if((get_user_flags(id) & ADMIN_CHAT) && (strlen(szMsg) > 0))
	{
		PostSay(id, 1, szMsg);
		return PLUGIN_HANDLED_MAIN;
	}
	return PLUGIN_CONTINUE;
}

public PostSay(id, isTeamMsg, szMessage[])
{
	static szPostMessage[192], szName[32], szTeam[32], szStatus[8], iTeam, g_NColor, g_MColor;//, iPos, szPostName[128];
	static szNColor[8], szMColor[8];	
	g_NColor = get_pcvar_num(pcvar_NameColor);
	g_MColor = get_pcvar_num(pcvar_MsgColor);

	get_user_name( id, szName, 31);
	remove_quotes(szMessage);
	iTeam = get_user_team(id);
	
	if( !iTeam )
	{
		iTeam = 3;
	}	
	szTeam[0] = '^0';
	szStatus[0] = '^0';
	
	switch (g_NColor)
	{
		case 1: szNColor = "^x01";
		case 2:	szNColor = "^x04";
		default:szNColor = "^x03";
	}
	switch (g_MColor)
	{	
		case 1: szMColor = "^x01";
		case 2:	szMColor = "^x04";
		default:szMColor = "^x03";		
	}

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
		szStatus = "*DEAD*";
	}
	else if(!is_user_alive(id) && iTeam == 3)
	{
		szStatus = "*SPEC*";
	}

	formatex( szPostMessage, charsmax(szPostMessage), "^x01%s%s%s%s : %s%s", szStatus, szTeam, szNColor, szName, szMColor, szMessage );
	
	if( !isTeamMsg )
	{
		iTeam = 0;
	}
	
	if( 3 <= g_NColor <= 5 )
	{
		Client_Print_All((g_NColor-2), iTeam, "%s", szPostMessage);
	}
	else if( 3 <= g_MColor <= 5 )
	{
		Client_Print_All((g_MColor-2), iTeam, "%s", szPostMessage);
	}
	else
	{
		Client_Print_All( 0, iTeam, "%s", szPostMessage);
	}
	return PLUGIN_HANDLED;
}

stock Client_Print_All( const Color, const isTeamMsg, const input[], any:...)
{
	static szPlayers[32], iCount, i, temp; 
	static szMsg[192];
	vformat(szMsg, 191, input, 4);
	
	if(isTeamMsg)
	{
		get_players(szPlayers, iCount, "ceh", gszTeams[isTeamMsg]);
	}
	else
	{
		get_players(szPlayers, iCount, "ch");
	}

	for( i=0; i < iCount; i++ )
	{
		temp = szPlayers[i];
		if(is_user_connected(temp))
		{
			if( Color && Color != get_user_team(temp) )
			{
				gizLTeam = get_user_team(temp);
				ChangeTeamInfo(temp, Color);
			}
	
			message_begin(MSG_ONE_UNRELIABLE, gSayText, _, temp);
			write_byte(temp);
			write_string(szMsg);
			message_end();

			if( gizLTeam )
			{
				ChangeTeamInfo(temp, gizLTeam);
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