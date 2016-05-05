#include <amxmodx>
#include <fun>

#define PLUGIN		"[DR] Invisibility"
#define VERSION		"1.0"
#define AUTHOR		"Shooting King"

new pcvar_amt;

public plugin_init()
{
	register_plugin( PLUGIN, VERSION, AUTHOR );

	register_clcmd( "say /invis", "GiveInvisibility" );
	register_clcmd( "say /vis", "RemoveInvisibility" );
	register_clcmd( "say_team /invis", "GiveInvisibility" );
	register_clcmd( "say_team /vis", "RemoveInvisibility" );

	// register_clcmd( "say /test125", "test" );
	pcvar_amt = register_cvar( "sk_amt", "5" );
}

public GiveInvisibility( id )
{
	if( get_user_team( id ) != 2 )
	{
		client_printc( id, "!tSorry Invisibility is only for CT's :P" );
	}
	else
	{
		new szName[32];
		get_user_name( id, szName, 32 ); 
		set_user_rendering( id, kRenderFxNone, 0,0,0, kRenderTransAdd, 5);
		client_printc( 0, "!g%s !tis invisible now.", szName );
	}
}

public RemoveInvisibility( id )
{
	new szName[32];
	get_user_name( id, szName, 32 ); 
	set_user_rendering( id, kRenderFxNone, 0,0,0, kRenderNormal, 0);
	client_printc( id, "!g%s, !tyou are visible now.", szName );
}

/* public test()
{
	for( new i; i < 33; i++ )
	{
		if(is_user_alive(i) && (get_user_team(i) == 1))
		{
			set_user_rendering( i, kRenderFxNone, 0,0,0, kRenderTransAdd, get_pcvar_num(pcvar_amt));
		}
	}
}
 */
stock client_printc(const id, const input[], any:...)
{
	new count = 1, players[32]
	static msg[191]
	vformat(msg, 190, input, 3)
	
	replace_all(msg, 190, "!g", "^x04") // Green Color
	replace_all(msg, 190, "!n", "^x01") // Default Color
	replace_all(msg, 190, "!t", "^x03") // Team Color
	
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