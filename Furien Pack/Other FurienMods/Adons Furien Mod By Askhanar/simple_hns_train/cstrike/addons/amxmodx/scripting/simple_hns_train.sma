#include <amxmodx>
#include <cstrike>
#include <hamsandwich>
#include <fakemeta>
#include <fun>
#include <ColorChat>

#define PLUGIN "Hine'N'Seek Training Sistem "
#define VERSION "1.0"
#define AUTHOR "sPuf ?"

new humans_join_team;
new mp_autoteambalance;
new mp_limitteams;
new mp_roundtime;
new mp_timelimit;

new bool:TrainOn = false;
new hnst_checkpoints[33];
new hnst_gochecks[33];

new Float:hnst_lastcp[33][3];
new Float:hnst_prelastcp[33][3];

new bool:g_bGM[ 33 ];
new bool:g_bNC[ 33 ];

new bool:hook[33];
new hook_to[33][3];

/*================================================================================================*/
public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	register_clcmd("say /train","sayTrain");
	register_clcmd("say /hns","sayHns");
	
	RegisterHam(Ham_Spawn, "player", "hamSpawnPlayer_Post", 1 );
	
	register_clcmd("say /cp", "cmdCP");
	register_clcmd("cp", "cmdCP");
	register_clcmd("say /tp","cmdTele");
	register_clcmd("tp","cmdTele");
	register_clcmd("say /gm","ClCmdSayGodMode");
	register_clcmd("say /nc","ClCmdSayNoClip");
	register_concmd("+hook","hook_on");
	register_concmd("-hook","hook_off");
	
	//Cvar Pointers
	humans_join_team = get_cvar_pointer("humans_join_team");
	mp_autoteambalance = get_cvar_pointer("mp_autoteambalance");
	mp_limitteams = get_cvar_pointer("mp_limitteams");
	mp_roundtime = get_cvar_pointer("mp_roundtime");
	mp_timelimit = get_cvar_pointer("mp_timelimit");

}

//m-am inspirat din tutorialul lui Askhanar despre godmode si noclip :D : pluginuri-cs/modulul-fun-t207269.html

public ClCmdSayGodMode( id )
{
	if( !TrainOn )
	{
		ColorChat( id, RED, "^x04[DR]^x01 Modul^x03 TRAIN^x01 nu este activ!" );
		return PLUGIN_HANDLED;
	}
	
	if( g_bGM[ id ] )
	{
	
		g_bGM[ id ] = false;
		set_user_godmode( id, 0 );
		ColorChat(id ,RED, "^x04[DR]^x01 Ai dezactivat^x03 godmode^x01!" );
	}
	else
	{
		g_bGM[ id ] = true;
		set_user_godmode( id, 1 );
		ColorChat(id ,RED, "^x04[DR]^x01 Ai activat^x03 godmode^x01!" );
	
	}
	
	return PLUGIN_HANDLED;

}

public ClCmdSayNoClip ( id )
{
	if( !TrainOn )
	{
		ColorChat( id, RED, "^x04[DR]^x01 Modul^x03 TRAIN^x01 nu este activ!" );
		return PLUGIN_HANDLED;
	}
	
	if( g_bNC[ id ] )
	{
	
		g_bNC[ id ] = false;
		set_user_noclip( id, 0 );
		ColorChat(id ,RED, "^x04[DR]^x01 Ai dezactivat^x03 noclip^x01!" );
	}
	else
	{
		g_bNC[ id ] = true;
		set_user_noclip( id, 1 );
		ColorChat(id ,RED, "^x04[DR]^x01 Ai activat^x03 noclip^x01!" );
	}
	
	return PLUGIN_HANDLED;

}

public hook_on(id)
{		
	if( !TrainOn || hook[id])
	{
		return PLUGIN_HANDLED;
	}
	
	set_pev(id, pev_gravity, 0.0);
	set_task(0.1,"hook_prethink",id+10000,"",0,"b");
	
	hook[id]=true;
	hook_to[id][0]=999999;
	hook_prethink(id+10000);
	return PLUGIN_HANDLED;
}
public hook_off(id)
{
	
	set_pev(id, pev_gravity, 1.0);
	hook[id] = false;
	return PLUGIN_HANDLED;
}

public hook_prethink(id)
{
	id -= 10000;
	
	if(!is_user_alive(id))
	{
		hook[id]=false;
	}
	
	if(!hook[id])
	{
		remove_task(id+10000);
		return PLUGIN_HANDLED;
	}


	static origin1[3];
	new Float:origin[3];
	get_user_origin(id,origin1);
	pev(id, pev_origin, origin);

	if(hook_to[id][0]==999999)
	{
		static origin2[3];
		get_user_origin(id,origin2,3);
		hook_to[id][0]=origin2[0];
		hook_to[id][1]=origin2[1];
		hook_to[id][2]=origin2[2];
	}

	//Calculate Velocity
	static Float:velocity[3];
	velocity[0] = (float(hook_to[id][0]) - float(origin1[0])) * 3.0;
	velocity[1] = (float(hook_to[id][1]) - float(origin1[1])) * 3.0;
	velocity[2] = (float(hook_to[id][2]) - float(origin1[2])) * 3.0;

	static Float:y;
	y = velocity[0]*velocity[0] + velocity[1]*velocity[1] + velocity[2]*velocity[2];

	static Float:x;
	x = (900.0) / floatsqroot(y);

	velocity[0] *= x;
	velocity[1] *= x;
	velocity[2] *= x;

	set_velo(id,velocity);

	return PLUGIN_CONTINUE;
}

public set_velo(id,Float:velocity[3])
{
	return set_pev(id,pev_velocity,velocity);
}

public sayTrain( id )
{
	if( user_has_access( id ) )
	{
		new name[32];
		get_user_name(id, name,31);
		ColorChat(0,RED,"^x04[DR]^x01 Modul train a fost pornit de catre adminul ^x03%s^x01.Credite lui^x04 fuzy^x01 !",name);

		TrainOn = true;
		set_pcvar_string(humans_join_team, "ct");
		set_pcvar_num(mp_autoteambalance, 0);
		set_pcvar_num(mp_limitteams, 0);
		set_pcvar_num(mp_timelimit, 0);
		set_pcvar_num(mp_roundtime, 9);
		MovePlayers( );
	}
}
public MovePlayers( )
{
	new Players[32];
	new PlayersNum, plr;
	get_players(Players, PlayersNum, "c");	
	for(new i=0; i<PlayersNum; i++) {
		plr = Players[i];
		cs_set_user_team( plr, CS_TEAM_CT );
		ExecuteHamB(Ham_CS_RoundRespawn, plr);
	}
}
public hamSpawnPlayer_Post( id )
{
	if(is_user_alive( id ) )
	{
		if(TrainOn)
		{
			if( g_bGM[ id ] )
			{
			
				g_bGM[ id ] = false;
				set_user_godmode( id, 0 );
				
			}
			else
			{
				g_bGM[ id ] = true;
				set_user_godmode( id, 1 );
			}
			
			if( g_bNC[ id ] )
			{
			
				g_bNC[ id ] = false;
				set_user_noclip( id, 0 );
				
			}
			else
			{
				g_bNC[ id ] = true;
				set_user_noclip( id, 1 );
			
			}
		}

		else
		{
			set_user_godmode( id, 0);
		}
	}
}

public sayHns( id )
{
	if( user_has_access( id ) )
	{
		TrainOn = false;
		new name[32];
		get_user_name(id, name,31);
		ColorChat(0,RED,"^x04[DR]^x01 Modul train a fost oprit de catre adminul ^x03%s^x01 !",name);

		set_pcvar_string(humans_join_team, "any");
		set_pcvar_num(mp_autoteambalance, 1);
		set_pcvar_num(mp_limitteams, 3);
		set_pcvar_num(mp_timelimit, 30);
		set_pcvar_num(mp_roundtime, 3);
		set_task(10.0,"SecondRR");
		server_cmd("sv_restart 10");
	}
}
public SecondRR( )
{
	server_cmd("sv_restart 1");	
	set_task(1.0,"ThirdRR");
}

public ThirdRR( )
{
	server_cmd("sv_restart 1");	
}
	
stock bool:user_has_access( id )
{
	if( get_user_flags( id ) & ADMIN_CVAR )
		return true;
		
	return false;
}

public cmdCP(id)
{
	if(TrainOn)
	{
		
		if(is_user_alive(id))
		{

			if( hnst_checkpoints[id] == 0 )
			{
				pev(id, pev_origin, hnst_lastcp[id])
			}
			else
			{
				hnst_prelastcp[id] = hnst_lastcp[id]
				pev(id, pev_origin, hnst_lastcp[id])
			}
			hnst_checkpoints[id]++
			
		}
		
		ColorChat( id, RED, "^x04[DR]^x01 Checkpoint #%i creat!", hnst_checkpoints[ id ] );
		return PLUGIN_HANDLED;
	}
	return PLUGIN_CONTINUE;
}

public cmdTele(id)
{
	if(TrainOn)
	{	
		if(!is_user_alive(id))
		{
			return PLUGIN_HANDLED;
		}

		if( hnst_checkpoints[id] != 0 )
		{
			set_pev(id, pev_velocity, Float:{0.0, 0.0, 0.0})
			set_pev(id, pev_origin, hnst_lastcp[id])
			hnst_gochecks[id]++
			fm_set_entity_flags(id, FL_DUCKING, 1);
		}
		ColorChat( id, RED,  "^x04[DR]^x01 Te-am teleportat la checkpoint-ul anterior!" );
		return PLUGIN_HANDLED;
	}
	return PLUGIN_CONTINUE;
}


public cmdStuck(id)
{
	if( !TrainOn )
		return 1

	if(!is_user_alive(id))
	{
			return 1;
	}

	set_pev(id, pev_velocity, Float:{0.0, 0.0, 0.0})
	set_pev(id, pev_origin, hnst_prelastcp[id])
	
	// Add a GoCheck because player can use this for bugs GoChecks
	hnst_gochecks[id]++
	ColorChat( id, RED,  "^x04[DR]^x01 Checkpoint STERS!" );
	
	fm_set_entity_flags(id, FL_DUCKING, 1);
	
	return 1;
}

public force_duck(id)
{
	id -= 111222;
	fm_set_entity_flags(id, FL_DUCKING, 1);
}


stock fm_set_entity_flags(index, flag, onoff) 
{
	new flags = pev(index, pev_flags);
	if ((flags & flag) > 0)
		return onoff == 1 ? 2 : 1 + 0 * set_pev(index, pev_flags, flags - flag);
	else
		return onoff == 0 ? 2 : 1 + 0 * set_pev(index, pev_flags, flags + flag);

	return 0;
}

public plugin_end( )
{
	set_pcvar_string(humans_join_team, "any");
	set_pcvar_num(mp_autoteambalance, 1);
	set_pcvar_num(mp_limitteams, 3);
	set_pcvar_num(mp_timelimit, 30);
	set_pcvar_num(mp_roundtime, 3);
}