#include <amxmodx>
#include <cstrike>

new gTeamChange[33];

public plugin_init()
{
	register_plugin( "Furien : Win Events", "1.0", "Shooting King" );
	register_message( get_user_msgid( "SendAudio" ),"message_sendaudio" ); 	
	register_message( get_user_msgid( "TextMsg" ), "message_textmsg" ); 
	
	register_event( "DeathMsg", "event_DeathMsg", "a", "1>0" );
	register_logevent("event_RoundEnd", 2, "1=Round_End")  
}

public event_RoundEnd()
{
	new players[32], cnum, tnum;
	get_players( players, cnum, "e", "CT" );
	get_players( players, tnum, "e", "TERRORIST" );

	for( new i = 0; i < 33; i++ )
	{
		if( gTeamChange[i] )
		{	
			if( (get_user_team(i) == _:CS_TEAM_CT) && ((cnum>1)||(cnum==tnum)) )
			{
				cs_set_user_team( i, CS_TEAM_T, CS_DONTCHANGE );
				// tnum++; cnum--;
			}
			else if( (get_user_team(i) == _:CS_TEAM_T) && ((tnum>1)||(cnum==tnum)))
			{
				cs_set_user_team( i, CS_TEAM_CT, CS_DONTCHANGE );
				// cnum++; tnum--;
			}
			gTeamChange[i] = false;
		}
	}
}

public client_putinserver(id)
{
	gTeamChange[id] = false;
}

public event_DeathMsg()
{
	new iKiller = read_data(1);
	new iVictim = read_data(2);

	if( get_user_team(iVictim) == _:CS_TEAM_T )
	{
		gTeamChange[iKiller] = true;
		gTeamChange[iVictim] = true;
	}
}

public message_textmsg( msgid, msgdest, msg_entity )
{
	static message[18];
	get_msg_arg_string( 2, message, sizeof message - 1 );

	if( equali( message, "#CTs_Win" ) )
	{	
		client_print( 0, print_center, "Anti-Furiens have won the Round." );
		return PLUGIN_HANDLED;
	}
	else if( equali( message, "#Terrorists_Win" ) )
	{	
		client_print( 0, print_center, "Furiens have won the Round." );
		return PLUGIN_HANDLED;
	}
	
	return PLUGIN_CONTINUE;
}

public message_sendaudio( msgid, msgdest, msg_entity )
{
	static message[10];
	get_msg_arg_string( 2, message, sizeof message - 1 );

	switch( message[7] )
	{
		case 'c', 't' : return PLUGIN_HANDLED;
	}

	return PLUGIN_CONTINUE;
}