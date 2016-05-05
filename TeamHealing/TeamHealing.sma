/********************************************************************************************

		Team Healing
			- Shooting King

	With this plugin one can heal his Team mate in two ways:
		
		Meathod 1: By pressing "+use"(e default) at his wounded friend.
		Meathod 2: By pressing "h" at his friend , without moving , on 
		           completion of the bar his friend will get full hp. 

Cvars:

		1. fm_sk_minhealth 	= Minimum health for a person to get healed.
		2. fm_sk_instheal	= Healing by Meathod 2, without Bar.
		3. fm_sk_stepvalue 	= Step Value for Meathod 1.
		4. fm_sk_enable 	= Enable Or Disable Plugin.
		5. fm_sk_autobind	= Autobinds letter "h" for Meathod 2. 
		6. fm_sk_stepheal 	= Enable Or Disable cvar for Meathod 1.
		7. fm_sk_fullheal	= Enable Or Disable cvar for Meathod 2.


*********************************************************************************************/

#include <amxmodx>
#include <fun>
#include <engine>

#define PLUGIN			"Team Healing"
#define AUTHOR			"Shooting King"
#define VERSION			"1.0"

#define TASK_HEALP	        30100
#define TASK_HEAL	        30500
#define TASK_POST	        98989

new cvar_MinHealth
new cvar_InstantHeal
new cvar_StepValue
new cvar_FmEnable
new cvar_AutoBind
new cvar_StepHeal
new cvar_FullHeal

new i_hp
new P_id
new Origin[3]
new P_Origin[3]
new Float:NextHealTime[33]
new Float:NextPlayTime[33]
new pluginname[32] = PLUGIN
new SayText

new const
	ENT_SOUND1[]    = "fmod/medcharge4.wav",
	ENT_SOUND2[]    = "fmod/medshot4.wav";

public plugin_init()
{

	register_plugin( PLUGIN , VERSION , AUTHOR )
	register_clcmd("+stepheal","Heal");
   	register_clcmd("-stepheal","StopHeal");
	register_logevent("RoundStart", 2, "0=World triggered", "1=Round_Start")

	cvar_MinHealth 	= register_cvar( "fm_sk_minhealth" , "20" )
	cvar_InstantHeal= register_cvar( "fm_sk_instheal" , "0" )
	cvar_StepValue	= register_cvar( "fm_sk_stepvalue" , "1" )
	cvar_FmEnable	= register_cvar( "fm_sk_enable" , "1" )
	cvar_AutoBind	= register_cvar( "fm_sk_autobind" , "1" )
	cvar_StepHeal	= register_cvar( "fm_sk_stepheal" , "1" )
	cvar_FullHeal	= register_cvar( "fm_sk_fullheal" , "1" )	
	
	SayText = get_user_msgid("SayText")
}

public plugin_precache() 
{
   	precache_sound(ENT_SOUND1);
   	precache_sound(ENT_SOUND2);
           
   	return PLUGIN_CONTINUE;
}

public RoundStart(id)
{
	set_task(1.0, "roundDelay" ,(TASK_POST + id));
}

public roundDelay(id)
{
	id -= TASK_POST
	print_col_chat( id , "^1This Plugin ^4%s^1 , is created by ^4Shooting King" , pluginname );
}

public client_connect( id )
{

	if( get_pcvar_num(cvar_AutoBind))
	{
		client_cmd( id , "bind h +stepheal" )
	}

} 
 
public client_PreThink(id)
{
	
	if( !is_user_alive(id) )
	{
		return PLUGIN_CONTINUE
	}
	
	if (get_user_button(id) & IN_USE )
	{
		if( get_pcvar_num(cvar_FmEnable) && get_pcvar_num(cvar_StepHeal))
		{
			new body
			new Team1[16] , Team2[16]
			get_user_aiming ( id , P_id , body , 70) 
			get_user_team ( id , Team1 , 15 )
			get_user_team ( P_id , Team2 , 15 ) 
			i_hp = get_user_health ( P_id )

			if( equali( Team1 , Team2 ))
			{
				if( i_hp < get_pcvar_num(cvar_MinHealth) )
				{	
					ActionHeal(id);
 							
				} else if( i_hp > get_pcvar_num(cvar_MinHealth) ) {			
					
					client_print ( id , print_center , "Minimum Health To heal Is %d" , get_pcvar_num(cvar_MinHealth));
				
				}	
			} else {
	
				client_print ( id , print_center , "The Player You Have Selected Is Not Your Friend" );
			}

		} else {
			print_col_chat ( id , "^3StepHealing Is Disabled By Admin." )
		}
			
	}
	return PLUGIN_CONTINUE
}

public Heal( id )
{
	
	new body
	new Team1[16] , Team2[16]
	get_user_aiming ( id , P_id , body , 70) 
	get_user_team ( id , Team1 , 15 )
	get_user_team ( P_id , Team2 , 15 ) 
	i_hp = get_user_health ( P_id ) 
	
	if( equali( Team1 , Team2 ))
	{ 
		if( get_pcvar_num(cvar_FmEnable) && get_pcvar_num(cvar_FullHeal))
		{
			if( i_hp > get_pcvar_num(cvar_MinHealth) )
			{	
				client_print ( id , print_center , "Minimum Health To heal Is %d" , get_pcvar_num(cvar_MinHealth));
					
			} else if( i_hp < get_pcvar_num(cvar_MinHealth) ) {

				set_task( 0.0 , "Heal_Progress" , (TASK_HEALP + id));
			}
		} else {
			print_col_chat ( id , "^3FullHealing Is Disabled By Admin." )
		}
	} else {

		client_print ( id , print_center , "You Have Not Selected A Player Who Is Your Friend" )
			
	}
	return PLUGIN_CONTINUE

}

public Heal_Progress(id)
{

	id -= TASK_HEALP

	get_user_origin(id, Origin)
	get_user_origin(P_id, P_Origin)

	if ( get_pcvar_num(cvar_InstantHeal) == 0 )				
    	{
    		message_begin( MSG_ONE, 108, {0,0,0}, id );
    		write_byte(1);
    		write_byte(0);
    		message_end();
		set_task( 1.2 , "Health", (TASK_HEAL + id))

	} else {

		set_task( 0.0 , "Health", (TASK_HEAL + id))
	}
}

public Health(id)
{
	id -= TASK_HEAL

	if( MovingCheck( id , Origin ) == 1 &&  MovingCheck( P_id , P_Origin ) == 1)
	{
		set_user_health ( P_id , 100 )
		emit_sound(id, CHAN_BODY, ENT_SOUND2, VOL_NORM, ATTN_NORM, 0, PITCH_NORM);

	} else {

		client_print( id , print_center , "You Should Not Move While Healing" )
		client_print( P_id , print_center , "You Should Not Move While Healing" )
	}
}

public StopHeal(id)
{
	remove_task((TASK_HEAL + id));
	message_begin(MSG_ONE, 108, {0,0,0}, id);
	write_byte(0);
	write_byte(0);
	message_end();
}

MovingCheck( C_id , OldOrigin[3] )
{
	
	new result
	new NewOrigin[3]
	get_user_origin( C_id , NewOrigin)
	if( OldOrigin[0] == NewOrigin[0] && OldOrigin[1] == NewOrigin[1] && OldOrigin[2] == NewOrigin[2] )
	{
		result = 1;
	} else {
		result = 0;
	}
	return result;
}

ActionHeal(id)
{

	if (halflife_time() >= NextHealTime[id])
	{
		new hp = get_user_health(P_id);
		new amount = get_pcvar_num(cvar_StepValue);
		new sum = (hp + amount);
	
		if (sum < 100)
		{
			set_user_health(P_id, sum);
			if (halflife_time() >= NextPlayTime[id])
			{			
				emit_sound(id, CHAN_BODY, ENT_SOUND1, VOL_NORM, ATTN_NORM, 0, PITCH_NORM);
			}
		}
		else
		{
			set_user_health(P_id, 100);
		}

		NextHealTime[id] = halflife_time() + 0.2;
		NextPlayTime[id] = halflife_time() + 0.5;
	}
}

stock print_col_chat(const id, const input[], any:...) 
{ 
    new count = 1, players[32]; 
    static msg[191]; 
    vformat(msg, 190, input, 3); 
    replace_all(msg, 190, "!g", "^4"); // Green Color 
    replace_all(msg, 190, "!y", "^1"); // Default Color
    replace_all(msg, 190, "!t", "^3"); // Team Color 
    if (id) players[0] = id; else get_players(players, count, "ch"); 
    { 
        for ( new i = 0; i < count; i++ ) 
        { 
            if ( is_user_connected(players[i]) ) 
            { 
                message_begin(MSG_ONE_UNRELIABLE, SayText, _, players[i]); 
                write_byte(players[i]); 
                write_string(msg); 
                message_end(); 
            } 
        } 
    } 
}
