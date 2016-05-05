#include <amxmodx>
#include <engine>
#include <cstrike>

#define ADMINACCESS ADMIN_CHAT

new jumpnum[33] = 0
new bool:dojump[33] = false

public plugin_init()
{
	register_plugin("Furien : MultiJump", "1.1", "[SK] twistedeuphoria")
}

public client_putinserver(id)
{
	jumpnum[id] = 0
	dojump[id] = false
}

public client_disconnect(id)
{
	jumpnum[id] = 0
	dojump[id] = false
}

public client_PreThink(id)
{
	if(!is_user_alive(id)) return PLUGIN_CONTINUE
	if(get_user_team(id) != _:CS_TEAM_CT) return PLUGIN_CONTINUE

	new nbut = get_user_button(id)
	new obut = get_user_oldbutton(id)
	if((nbut & IN_JUMP) && !(get_entity_flags(id) & FL_ONGROUND)  && !(obut & IN_JUMP))
	{
		if(jumpnum[id] < 1)
		{
			dojump[id] = true
			jumpnum[id]++
			return PLUGIN_CONTINUE
		}
	}
	if((nbut & IN_JUMP) && (get_entity_flags(id) & FL_ONGROUND))
	{
		jumpnum[id] = 0
		return PLUGIN_CONTINUE
	}
	return PLUGIN_CONTINUE
}

public client_PostThink(id)
{
	if(!is_user_alive(id)) return PLUGIN_CONTINUE

	if(dojump[id] == true)
	{
		new Float:velocity[3]	
		entity_get_vector(id,EV_VEC_velocity,velocity)
		velocity[2] = random_float(265.0,285.0)
		entity_set_vector(id,EV_VEC_velocity,velocity)
		dojump[id] = false
		return PLUGIN_CONTINUE
	}
	return PLUGIN_CONTINUE
}	