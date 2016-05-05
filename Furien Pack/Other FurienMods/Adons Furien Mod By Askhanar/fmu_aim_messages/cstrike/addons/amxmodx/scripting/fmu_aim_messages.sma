#include <  amxmodx  >
#include <  cstrike  >
#include <  fakemeta  >

#pragma semicolon 1


#define PLUGIN "Furien Aiming Messages"
#define VERSION "1.0"

#define IsPlayer(%1) ( 1 <= %1 <= g_MaxPlayers ) 

new g_MaxPlayers;

public plugin_init(    )
{
	register_plugin(  PLUGIN,  VERSION,  "Askhanar"  );
	
	register_forward(  FM_PlayerPreThink,  "fwdPlayerPreThink"  );
	
	g_MaxPlayers  =  global_get(  glb_maxClients  );
}

public fwdPlayerPreThink(  id  )
{
	
	if(  is_user_alive(  id  )  )
	{
		
		new target, body; 
		get_user_aiming(  id,  target,  body,  9999  );
		
		new CsTeams:team  =  cs_get_user_team(  id  );
		
		if(   is_user_alive(  target  )  )
		{
			if(  IsPlayer(  target  )  )
			{
			
				new CsTeams:targetTeam  =  cs_get_user_team(  target  );
				
				new sName[  32  ];
				get_user_name(  target,   sName,  sizeof  (  sName  )  -1  );
							
				new sMessage[  64  ];
				if(  targetTeam  ==  team  )
				{
					formatex(  sMessage, sizeof  (  sMessage  )  -1, "%s: %s Health: %i", IsUserVip(  target  ) ?  "VIP" : "Friend",  sName,  get_user_health(  target  )  );
				}
				else if(  targetTeam  !=  team  &&  team  !=  CS_TEAM_CT  )
				{
					formatex(  sMessage, sizeof  (  sMessage  )  -1, "%s: %s Health: %i", IsUserVip(  target  ) ?  "VIP" : "Enemy",  sName,  get_user_health(  target  )  );
				}
					
				if(  targetTeam  ==  CS_TEAM_CT  )
				{
					set_hudmessage( 0, 63, 127, -1.0, -1.0, 0, 0.0, 0.1, 0.0, 0.0, -1 );
				}
				else if( targetTeam == CS_TEAM_T )
				{
					set_hudmessage( 127, 0, 0, -1.0, -1.0, 0, 0.0, 0.1, 0.0, 0.0, -1 );
				}	
				
				
				show_hudmessage(  id,  "%s",  sMessage  );
			}
		}
	}
	
	return FMRES_IGNORED;
}

stock bool:IsUserVip(  id  )
{
	
	if( get_user_flags(  id  )  &  read_flags(  "vxy"  )  )
		return true;
	
	return false;
	
}