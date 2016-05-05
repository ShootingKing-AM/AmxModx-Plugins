/*                          


                               _
			      | |
			 _.__ | | __ _ _   _  ___  _ __
			| `_ \| |/ _` | | | |/ _ \| '__|
			| |_) | | (_| | \ / |  __/| |
			| ,__/|_|\__,_|\__, |\___||_|
			| |             __/ |
			|_|            |___/  	 
				
				
								 _        _                       _
								| |      | |                     | | 
								| |_  ___| | ___ _.__   ___  _ __| |_
								| __|/ _ \ |/ _ \ `_ \ / _ \| '__| __|
								| |_|  __/ |  __/ |_) | (_) | |  | |_
								 \__|\___|_|\___| ,__/ \___/|_|   \__|
										| |
										|_|


Plugin: Player Teleport
Version: 2.0
Author: sPuf ? 


*/

#include <amxmodx>
#include <amxmisc>
#include <fun>
#include <ColorChat>

static const PT_TAG[]	= "[D/C]"
static const PLUGIN_NAME[] 	= "Player Teleport"
static const PLUGIN_AUTHOR[] 	= "sPuf ?"
static const PLUGIN_VERSION[]	= "2.0"

new g_msgscreenfade;
new gSpriteId;
new gSpriteModel[] = "sprites/blueflare2.spr"

new Float: Block[33];

public plugin_init() {
	register_plugin(PLUGIN_NAME, PLUGIN_VERSION, PLUGIN_AUTHOR)
	
	register_clcmd( "say", "say_goto" )
	register_clcmd( "say_team", "say_goto" )
	
	register_concmd( "goto", "player_teleport" )
	
	g_msgscreenfade = get_user_msgid( "ScreenFade" )
}
public plugin_precache() {
	
	gSpriteId = precache_model( gSpriteModel )
}
public say_goto( id )
{
	static args[ 192 ], command[ 192 ]
	read_args( args, charsmax( args ) )
	
	if( !args[ 0 ] )
		return PLUGIN_CONTINUE
		
	remove_quotes( args[ 0 ] )
	
	if( equal( args, "/goto", strlen( "/goto" ) ) )
	{
		replace( args, charsmax( args ), "/", "" )
		formatex( command, charsmax( command ), "%s", args )
		client_cmd( id, command )
		return PLUGIN_HANDLED;
	}
	
	return PLUGIN_CONTINUE
}
public player_teleport(id) {
	
	if((get_gametime() - Block[id] < 5.0) ) {
		ColorChat(id,RED,"^x04%s^x03 Comanda Blocata^x04 5^x03 Secunde !",PT_TAG)
		return PLUGIN_HANDLED;
	}
	
	new target[32],user_origin[3],target_origin[3],target_name[32];
	
    	read_argv(1, target, 31)
	
	new player = cmd_target(id, target, 8)
	
	get_user_name(player,target_name,31)
	
	if(!player) {
		ColorChat(id,RED,"^x04%s^x03 Jucatorul^x04 %s^x03 nu a fost gasit !",PT_TAG,target)
		return PLUGIN_HANDLED;
	}
	if(!is_user_alive(player)) {
		ColorChat(id,RED,"^x04%s^x03 Nu poti folosi aceasta comanda pe un jucator mort !",PT_TAG)
		return PLUGIN_HANDLED;
	}
	if(!is_user_alive(id)) {
		ColorChat(id,RED,"^x04%s^x03 Nu poti folosi aceasta comanda cand esti mort !")
		return PLUGIN_HANDLED;
	}
	get_user_origin( player, target_origin, 0 )
	get_user_origin( id, user_origin, 0 )
	if(player == id) {
		ColorChat(id,RED,"^x04%s^x03 Nu te poti teleporta la tine !",PT_TAG)
		return PLUGIN_HANDLED;
	}
        //Astea sunt niste efecte !! de fade..
	message_begin(MSG_ONE, g_msgscreenfade, {0,0,0}, id)
	write_short(1<<10)
	write_short(1<<10)
	write_short(0x0000)
	write_byte(192)
	write_byte(192)
	write_byte(192)
	write_byte(75)
	message_end()
					
	message_begin(MSG_ONE, g_msgscreenfade, {0,0,0}, player)
	write_short(1<<10)
	write_short(1<<10)
	write_short(0x0000)
	write_byte(192)
	write_byte(192)
	write_byte(192)
	write_byte(75)
	message_end()

	//Astea sunt niste efecte !! bule ca la war3ft..
	message_begin( MSG_BROADCAST,SVC_TEMPENTITY)
	write_byte( TE_SPRITETRAIL )
	write_coord( target_origin[0] )				// start position (X)
	write_coord( target_origin[1] )				// start position (Y)
	write_coord( target_origin[2] )				// start position (Z)
	write_coord( target_origin[0] )				// end position (X)
	write_coord( target_origin[1] )				// end position (Y)
	write_coord( target_origin[2] + 40)				// end position (Z)
	write_short( gSpriteId )				// sprite index
	write_byte( 70 )					// numarul de bule
	write_byte( 15)					// life in 0.1's
	write_byte( 1)					// scale in 0.1's
	write_byte( 50 )				// velocity along vector in 10's
	write_byte( 10 )				// randomness of velocity in 10's
	message_end()

	message_begin( MSG_BROADCAST,SVC_TEMPENTITY)
	write_byte( TE_SPRITETRAIL )
	write_coord( user_origin[0] )				// start position (X)
	write_coord( user_origin[1] )				// start position (Y)
	write_coord( user_origin[2] )				// start position (Z)
	write_coord( user_origin[0] )				// end position (X)
	write_coord( user_origin[1] )				// end position (Y)
	write_coord( user_origin[2] + 40)				// end position (Z)
	write_short( gSpriteId )				// sprite index
	write_byte( 70 )					// numarul de bule
	write_byte( 15)					// life in 0.1's
	write_byte( 1)					// scale in 0.1's
	write_byte( 50 )				// velocity along vector in 10's
	write_byte( 10 )				// randomness of velocity in 10's
	message_end()
	
	target_origin[2] = target_origin[2]+40
	
	set_user_origin( id,target_origin)
	Block[id] = get_gametime();
	
	return PLUGIN_HANDLED;	
}