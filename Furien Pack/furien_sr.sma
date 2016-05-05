#include < amxmodx >
#include < dhudmessage >
	
#pragma semicolon 1
new const
	PLUGIN_NAME[ ] 		= "Furien : Score & Round",
	PLUGIN_VERSION[ ] 	= "0.2.1";
	
	
#define	iNameRed	0
#define	iNameGreen	255
#define	iNameBlue	255
	
#define	iScoreRed	255
#define	iScoreGreen	0
#define	iScoreBlue	0
	
new const
	g_szTeamsMessage[ ] 	= "    |-  Furien           AntiFurien  -|    ",
	g_szScoreMessage[ ]	= "%02i                                                %02i",
	g_szRoundMessage[ ]	= "                  Round                     ",
	g_szRound[ ]		= "                    %02i                       ";
		
		
enum _:iTeamWons
{
	FURIEN,
	ANTIFURIEN
}
	
new g_iTeamWons[ iTeamWons ];
new g_iRounds;
	
new SyncHudTeamNames, SyncHudTeamScore;

public plugin_init()
{
	register_plugin( PLUGIN_NAME, PLUGIN_VERSION, "[SK] Askhanar" );	
	
	register_event( "HLTV", "ev_NewRound", "a", "1=0", "2=0" );
	register_event( "TextMsg", "ev_RoundRestart", "a", "2&#Game_C", "2&#Game_w" );	
	register_event( "SendAudio", "ev_TerroristWin", "a", "2&%!MRAD_terwin" );
	register_event( "SendAudio", "ev_CtWin", "a", "2&%!MRAD_ctwin" );
	
	g_iRounds = 0;
	g_iTeamWons[ FURIEN ] = 0;
	g_iTeamWons[ ANTIFURIEN ] = 0;
	
	SyncHudTeamNames = CreateHudSyncObj( );
	SyncHudTeamScore = CreateHudSyncObj( );	
	
	set_task( 1.0, "task_DisplayHudScore", _, _, _, "b", 0 );
}


public ev_NewRound( )		g_iRounds++;
public ev_RoundRestart( )	{	g_iRounds = 0;	g_iTeamWons[ FURIEN ] = 0;	g_iTeamWons[ ANTIFURIEN ] = 0;	}
public ev_TerroristWin( )	g_iTeamWons[ FURIEN ]++;
public ev_CtWin( )	g_iTeamWons[ ANTIFURIEN ]++;


public task_DisplayHudScore()
{
	static iPlayers[ 32 ];
	static iPlayersNum;
		
	get_players( iPlayers, iPlayersNum, "ch" );
	if( !iPlayersNum )
		return;
		
	static id, i;
	for( i = 0; i < iPlayersNum; i++ )
	{
		id = iPlayers[ i ];
		
		if( 1 <= get_user_team( id ) <= 3 )
		{
			set_hudmessage( iNameRed, iNameGreen, iNameBlue, -1.0, is_user_alive( id ) ? 0.01 : 0.16 , 0, _, 1.0, _, _, -1 );
			ShowSyncHudMsg( id, SyncHudTeamNames, g_szTeamsMessage );
			
			set_hudmessage( iScoreRed, iScoreGreen, iScoreBlue, -1.0, is_user_alive( id ) ? 0.01 : 0.16 , 0, _, 1.0, _, _, -1 );
			ShowSyncHudMsg( id, SyncHudTeamScore, g_szScoreMessage,  g_iTeamWons[ FURIEN ], g_iTeamWons[ ANTIFURIEN ]  );
						
			set_dhudmessage( iNameRed, iNameGreen, iNameBlue, -1.0, is_user_alive( id ) ? 0.03 : 0.18 , 0, _, 1.0, _, _ );
			show_dhudmessage( id, g_szRoundMessage );
			
			set_dhudmessage( iScoreRed, iScoreGreen, iScoreBlue, -1.0, is_user_alive( id ) ? 0.06 : 0.21 , 0, _, 1.0, _, _ );
			show_dhudmessage( id, g_szRound, g_iRounds );
		}	
	}
}