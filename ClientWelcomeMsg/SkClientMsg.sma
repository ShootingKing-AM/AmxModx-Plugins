#include <amxmodx>
// #include <dhudmessage>

#define PLUGIN		"Clinet Connect Msg"
#define VERSION		"1.2"
#define AUTHOR		"Shooting King"

#define TASKID		97231

new szMessageChat[] = "!nWelcome !t%s!n To SK Pro's KingDomz®";
new szMessagedHUD[] = "Welcome To SK Pro's KingDomz %s^nKeep Fragging ! ^nLife Is 1 Counter Strike is 1.6 !!";

public plugin_init() 
{
	register_plugin( PLUGIN, VERSION, AUTHOR);
}

public client_putinserver(id)
{
	set_task( 5.0, "ShowMsg", (TASKID+id));
}

public ShowMsg(id)
{
	id -= TASKID;
	
	new szName[32];
	get_user_name( id, szName, 31 );
		
	client_printc( id, szMessageChat, szName);
	set_dhudmessage( 0, 250, 0 , -1.0, -0.6, _, 2.0, _, _, _ );
	show_dhudmessage( id, szMessagedHUD, szName );
}

public client_disconnect(id)
{
	remove_task(id+TASKID);
}

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
