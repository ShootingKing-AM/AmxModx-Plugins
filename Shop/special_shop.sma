#include <amxmodx>
#include <cstrike>
#include <fun>

#define PLUGIN		"Special Shop"
#define VERSION		"1.0"
#define AUTHOR		"Shooting King"

new gKeysMainMenu = MENU_KEY_0 | MENU_KEY_1 | MENU_KEY_2 | MENU_KEY_3 | MENU_KEY_4 | MENU_KEY_5 | MENU_KEY_6 | MENU_KEY_7 | MENU_KEY_8 | MENU_KEY_9; 

new pcvar_grenc, pcvar_mechgc, pcvar_armorc, pcvar_fragsc, pcvar_hpc, pcvar_gvityc, pcvar_speedc, pcvar_invisc;
new bool:g_speed[33];

public plugin_init()
{
	register_plugin( PLUGIN, VERSION, AUTHOR );

	register_clcmd("say /sshop", "showMainMenu" );
	register_clcmd("say_team /sshop", "showMainMenu" );

	register_menucmd(register_menuid("skMainMenu"), gKeysMainMenu, "handleMainMenu");
	register_logevent("event_roundstart", 2, "0=World triggered", "1=Round_Start");
	register_event( "CurWeapon", "event_weapon", "be", "1=1" );
	
	pcvar_grenc = register_cvar( "ss_grenscost", "1100" );
	pcvar_mechgc = register_cvar( "ss_mechgcost", "5600" );
	pcvar_armorc = register_cvar( "ss_armorcost", "1500" );
	pcvar_fragsc = register_cvar( "ss_fragscost", "14000" );
	pcvar_hpc = register_cvar( "ss_hpcost", "9000" );
	pcvar_gvityc = register_cvar( "ss_gravitycost", "1100" );
	pcvar_speedc = register_cvar( "ss_speedcost", "5500" );
	pcvar_invisc = register_cvar( "ss_inviscost", "6000" );
}
public event_roundstart()
{
	set_task( 0.5, "DisplayMsg" );	
	
	for( new i = 1; i < 33; i++ )
	{
		if( is_user_connected(i) )
		{
			set_user_rendering( i, kRenderFxNone, 0,0,0, kRenderNormal, 0);
			set_user_gravity( i, 1.0);
			if( get_user_health(i) > 100 )
			{
				set_user_health( i, 100 );
			}
			set_user_maxspeed( i, 0.0 );
			g_speed[i] = false;
		}	
	}
}

public showMainMenu( id )
{	
	new szMenu[256];
	new szMainMenu[256];
	new size = sizeof( szMainMenu );
	new igrenc, imechgc, iarmorc, ifragsc, ihpc, igvityc, ispeedc, iinvisc;

	igrenc = get_pcvar_num( pcvar_grenc );
	imechgc = get_pcvar_num( pcvar_mechgc );
	iarmorc = get_pcvar_num( pcvar_armorc );
	ifragsc = get_pcvar_num( pcvar_fragsc);
	ihpc = get_pcvar_num( pcvar_hpc );
	igvityc = get_pcvar_num( pcvar_gvityc );
	ispeedc = get_pcvar_num( pcvar_speedc );
	iinvisc = get_pcvar_num( pcvar_invisc );

	szMainMenu[0] = '^0';
	
	add( szMainMenu , size , "\r***** \ySpecial Shop \r*****^n^n" );
	add( szMainMenu , size , "\r1. \wHE+2Flash+Smoke Grenades (%d$)^n" );
	add( szMainMenu , size , "\r2. \wMashineGun M429 (%d$)^n" );
	add( szMainMenu , size , "\r3. \wArmor (%d$)^n" );
	add( szMainMenu , size , "\r4. \w+10 Frags (%d$)^n" );
	add( szMainMenu , size , "\r5. \w+50 HP (%d$)^n" );
	add( szMainMenu , size , "\r6. \wHalf Gravity (%d$)^n" );
	add( szMainMenu , size , "\r7. \w350 Speed (%d$)^n" );
	add( szMainMenu , size , "\r8. \w90% Invisibility (%d$)^n^n" );
	add( szMainMenu , size , "\r0. \yExit^n" );

	format( szMenu , 256 , szMainMenu, igrenc, imechgc, iarmorc, ifragsc, ihpc, igvityc, ispeedc, iinvisc );
	show_menu( id , gKeysMainMenu , szMenu , -1 , "skMainMenu");
	
	return PLUGIN_HANDLED;
}

public handleMainMenu(id, num)
{
	switch (num)
	{
		case 0: 
		{ 
			if( CheckMoney( id , get_pcvar_num(pcvar_grenc)) )
			{
				new iAmmo = cs_get_user_bpammo( id, 4 ) ; 
				
				if( iAmmo )
				{
					cs_set_user_bpammo( id, 4, iAmmo+1 )
				} 
				else
				{
					give_item( id, "weapon_hegrenade" );
				}

				iAmmo = cs_get_user_bpammo( id, 9 )
				
				if( iAmmo )
				{
					cs_set_user_bpammo( id, 9, iAmmo+1 ) 
				}
				else
				{
					give_item( id, "weapon_smokegrenade");
				}

				iAmmo = cs_get_user_bpammo( id, 25 )
				
				if( iAmmo > 0)
				{
					cs_set_user_bpammo( id, 25, iAmmo+2 ) 
				}
				else
				{
					give_item( id, "weapon_flashbang" );
					give_item( id, "weapon_flashbang" ); 
				}

				client_print( id, print_chat, "You have been given a pack Grenades." );		
			}
			else
			{
				print_client( id, get_pcvar_num(pcvar_grenc) );
			}
		}
		case 1:
		{ 
			if( CheckMoney( id , get_pcvar_num(pcvar_mechgc)) )
			{
				if( cs_get_user_hasprim(id) )
				{
					client_cmd( id, "slot1" );
					client_cmd( id, "drop" );
				}
				give_item( id, "weapon_m249" );
				client_print( id, print_chat, "You have been give a Machine Gun." );
			}
			else
			{
				print_client( id, get_pcvar_num(pcvar_mechgc) );
			}
		} 
		case 2: 
		{ 
			if( CheckMoney( id , get_pcvar_num(pcvar_armorc)) )
			{
				set_user_armor( id, get_user_armor(id) + 100 );
				client_print( id, print_chat, "You have been give +100 Armor." );
			}
			else
			{
				print_client( id, get_pcvar_num(pcvar_armorc) );
			}
		}
		case 3:
		{
			if( CheckMoney( id , get_pcvar_num(pcvar_fragsc)) )
			{
				set_user_frags( id, get_user_frags(id) + 10 ); 
				client_print( id, print_chat, "You have been given +10 frags." );
			}
			else
			{
				print_client( id, get_pcvar_num(pcvar_fragsc) );
			}
		}
		case 4:
		{
			if( CheckMoney( id , get_pcvar_num(pcvar_hpc)) )
			{
				set_user_health( id, get_user_health(id) + 50 );
				client_print( id, print_chat, "You have been given +50 HP." );
			}
			else
			{
				print_client( id, get_pcvar_num(pcvar_hpc) );
			} 
		}	
		case 5:
		{
			if( CheckMoney( id , get_pcvar_num(pcvar_gvityc)) )
			{
				set_user_gravity( id, get_user_gravity(id)*0.5 );
				client_print( id, print_chat, "Your gravity has been Halfed" );
			}
			else
			{
				print_client( id, get_pcvar_num(pcvar_gvityc) );
			}
		}	
		case 6:
		{
			if( CheckMoney( id , get_pcvar_num(pcvar_speedc)) )
			{
				g_speed[id] = true;
				event_weapon(id);
				client_print( id, print_chat, "Your speed has been incresed" );
			}
			else
			{
				print_client( id, get_pcvar_num(pcvar_speedc) );
			}
		}	
		case 7:
		{
			if( CheckMoney( id , get_pcvar_num(pcvar_invisc)) )
			{ 
				set_user_rendering( id, kRenderFxNone, 0,0,0, kRenderTransAdd, 50);
				client_print( id, print_chat, "You are 90% Invisiable" );
			}
			else
			{
				print_client( id, get_pcvar_num(pcvar_invisc) );
			}
		}	
		default: 
		{ 
			return; 
		}
	}
}


public DisplayMsg()
{
	client_print( 0, print_chat, "Type /sshop for special shop menu." );
}

CheckMoney( id , iCost )
{
	new iMoney = cs_get_user_money(id);
	if( iMoney >= iCost )
	{
		cs_set_user_money(id, iMoney - iCost, 1);
		return 1;
	}
	return 0;
}

print_client( id, iCost )
{
	client_print( id, print_chat, "You dont have %d$", iCost );
}

public event_weapon(id)				
{
	if(g_speed[id])
	{
		set_user_maxspeed( id, 350.0);
	}
}