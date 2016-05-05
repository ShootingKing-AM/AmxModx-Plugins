#include <amxmodx>
#include <hamsandwich>

#define PLUGIN		"Sk Me"
#define VERSION		"1.0"
#define AUTHOR		"Shooting King"

new Float:gPlayerDamages[33];
new bool:bFirstRound;

public plugin_init()
{
	register_plugin( PLUGIN, VERSION, AUTHOR );	
	
	register_event( "HLTV", "event_NewRound", "a" , "1=0", "2=0" );
	register_clcmd( "say /me", "cmdMe" );	
	register_clcmd( "say_team /me", "cmdMe" );	
	register_clcmd( "say !me", "cmdMe" );	
	register_clcmd( "say_team /me", "cmdMe" );	
		
	register_event( "TextMsg", "event_GameCommence", "a", "2&#Game_C" );
	register_logevent( "event_RoundEnd", 2, "1=Round_End" );
	
	RegisterHam(Ham_TakeDamage, "player", "event_TakeDamage", false);
}

public event_GameCommence()
{
	bFirstRound = true;
}

public event_TakeDamage( id, iInflictor, iAttacker, Float:flDamage, bitsDamageType )
{
	if((get_user_team(iAttacker) != get_user_team(id)) && 
		is_player(iAttacker) && is_user_connected(iAttacker))
	{
		gPlayerDamages[iAttacker] += flDamage;
	}
}

public event_NewRound()
{
	for( new i = 1; i < 33; i++ )
	{
		gPlayerDamages[i] = 0.0;
	}
}

public event_RoundEnd()
{
	if( bFirstRound )
	{
		bFirstRound = false;
		return;
	}
	
	new Float:iDmgMax = gPlayerDamages[1];
	new id = 1;
	for( new i = 2; i < 33; i++ )
	{
		if( iDmgMax < gPlayerDamages[i] )
		{
			iDmgMax = gPlayerDamages[i];
			id = i;
		}
	}
	
	new szName[33];
	get_user_name( id, szName, 32 );
	
	set_hudmessage( 0, 250, 0, 0.07, 0.28, _, _, _, _, _, -1 );
	show_hudmessage( 0, "Most Damage is Done By %s (%.2f)", szName, iDmgMax );
}

public cmdMe(id)
{
	client_printc( id, "^x04**^x01 This Round, You had done ^x03%.2f^x01 Damage", gPlayerDamages[id]);
}

stock client_printc(const id, const input[], any:...)
{
	new count = 1, players[32]
	static msg[191]
	vformat(msg, 190, input, 3)
	
	if (id) players[0] = id; else get_players(players, count, "ch")
	{
		for (new i = 0; i < count; i++)
		{
			if (is_user_connected(players[i]))
			{
				message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("SayText"), _, players[i])
				write_byte(players[i])
				write_string(msg)
				message_end()
			}
		}
	}
}
	
stock is_player( id )
{
	if( 1 <= id <= 32 )
		return 1;
		
	return 0;
}
