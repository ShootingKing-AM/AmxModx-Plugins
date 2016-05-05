#include <  amxmodx  >
#include <  cstrike  >
#include <  fun  >
#include <  CC_ColorChat  >


#pragma semicolon 1


#define PLUGIN "Advanced TeamSlay"
#define VERSION "1.0"

#define TAG	"[D/C]"

public plugin_init(    )
{
	register_plugin(  PLUGIN,  VERSION,  "Askhanar"  );
	
	register_clcmd(  "amx_slayteam",  "ClCmdSlayTeam"  );
	register_clcmd(  "amx_slapteam",  "ClCmdSlapTeam"  );
	
}

public ClCmdSlayTeam(  id  )
{
	
	if( !( get_user_flags(  id  )  &  ADMIN_SLAY  )  )
	{
		client_cmd(  id,  "echo Nu ai acces la aceasta comanda"  );
		return 1;
	}
	
	new szFirstArg[  32  ],  iTeam;
	
	read_argv(  1, szFirstArg ,  sizeof  (  szFirstArg  )  -1  );
	
	if(  equal(  szFirstArg,  ""  )  )
	{
		client_cmd( id, "echo amx_slayteam @ALL / @T / @CT " );
		return 1;
	}
		
	if(  szFirstArg[  0  ]  ==  '@'  )
	{
		
		new iPlayers[  32  ];
		new iPlayersNum;
	
		switch(  szFirstArg[  1  ]  )
		{
			case 'A':
			{
				if(  equali(  szFirstArg,  "@ALL"  )  )
				{
					iTeam  =  0;
					get_players(  iPlayers,  iPlayersNum,  "ach"  );
				}
			}
			case 'T':
			{
				if(  equali(  szFirstArg,  "@T"  )  )
				{
					iTeam  =  1;
					get_players(  iPlayers,  iPlayersNum,  "aceh",  "TERRORIST"  );
				}
			}
			case 'C':
			{
				if(  equali(  szFirstArg,  "@CT"  )  )
				{
					iTeam  =  2;
					get_players(  iPlayers,  iPlayersNum,  "aceh",  "CT"  );
				}
			}
			
		}
		
		for(  new i = 0 ; i < iPlayersNum ; i++  )
		{
			
			if(  is_user_connected(  iPlayers[  i  ]  )  )
			{
				new iFrags = 0, iDeaths = 0;
				iFrags  =   get_user_frags(  iPlayers[  i  ]  );
				iDeaths  =  get_user_deaths(  iPlayers[  i  ]  );
				
				user_kill(  iPlayers[  i  ],  1  );
				
				cs_set_user_deaths(  iPlayers[  i  ],  iDeaths  );
				set_user_frags(  iPlayers[  i  ],  iFrags  );
				cs_set_user_deaths(  iPlayers[  i  ],  iDeaths  );
				set_user_frags(  iPlayers[  i  ],  iFrags  );
			}
		}
		
		new  szName[  32  ];
		get_user_name(  id,  szName,  sizeof  (  szName  )  -1  );
		
		switch(  iTeam  )
		{
			case 0:
			{
				ColorChat(  0,  RED,"^x04%s^x03 %s^x01 le-a dat slay l-a^x03 toti jucatorii^x01 !", TAG,  szName  );
			}
			case 1:
			{
				ColorChat(  0,  RED,"^x04%s^x03 %s^x01 le-a dat slay l-a jucatorii din echipa^x03 Terrorist^x01 !", TAG,  szName  );
			}
			case 2:
			{
				ColorChat(  0,  RED,"^x04%s^x03 %s^x01 le-a dat slay l-a jucatorii din echipa^x03 Counter-Terorrist^x01 !", TAG,  szName  );
			}
		}
	}
	
	return 1;
	
}

public ClCmdSlapTeam(  id  )
{
	
	if( !( get_user_flags(  id  )  &  ADMIN_SLAY  )  )
	{
		client_cmd(  id,  "echo Nu ai acces la aceasta comanda"  );
		return 1;
	}
	
	new szFirstArg[  32  ],  szSecondArg[  32  ],  iTeam, iPower;
	
	read_argv(  1, szFirstArg ,  sizeof  (  szFirstArg  )  -1  );
	read_argv(  2, szSecondArg ,  sizeof  (  szSecondArg  )  -1  );
	
	if(  equal(  szFirstArg,  ""  )  ||  equal(  szSecondArg,  ""  )  )
	{
		client_cmd( id, "echo amx_slapteam < @ALL / @T / @CT > < power >" );
		return 1;
	}
	
	if(  szFirstArg[  0  ]  ==  '@'  )
	{
		
		new iPlayers[  32  ];
		new iPlayersNum;
	
		switch(  szFirstArg[  1  ]  )
		{
			case 'A':
			{
				if(  equali(  szFirstArg,  "@ALL"  )  )
				{
					iTeam  =  0;
					get_players(  iPlayers,  iPlayersNum,  "ach"  );
				}
			}
			case 'T':
			{
				if(  equali(  szFirstArg,  "@T"  )  )
				{
					iTeam  =  1;
					get_players(  iPlayers,  iPlayersNum,  "aceh",  "TERRORIST"  );
				}
			}
			case 'C':
			{
				if(  equali(  szFirstArg,  "@CT"  )  )
				{
					iTeam  =  2;
					get_players(  iPlayers,  iPlayersNum,  "aceh",  "CT"  );
				}
			}
			
		}
			
		
		iPower  =  str_to_num(  szSecondArg  );
		
		if(  iPower  <  0  )  iPower  =  0;
		
		for(  new i = 0 ; i < iPlayersNum ; i++  )
		{
			
			if(  is_user_connected(  iPlayers[  i  ]  )  )
			{
				
				user_slap(  iPlayers[  i  ],  iPower  );
				
			}
		}
		
		new  szName[  32  ];
		get_user_name(  id,  szName,  sizeof  (  szName  )  -1  );
		
		switch(  iTeam  )
		{
			case 0:
			{
				ColorChat(  0,  RED,"^x04%s^x03 %s^x01 le-a dat slap la^x03 toti jucatorii^x01 cu^x03 %d^x01 dmg !", TAG,  szName,  iPower  );
			}
			case 1:
			{
				ColorChat(  0,  RED,"^x04%s^x03 %s^x01 le-a dat slap la jucatorii din echipa^x03 Terrorist^x01 cu^x03 %d^x01 dmg !", TAG,  szName,  iPower  );
			}
			case 2:
			{
				ColorChat(  0,  RED,"^x04%s^x03 %s^x01 le-a dat slap la jucatorii din echipa^x03 Counter-Terorrist^x01 cu^x03 %d^x01 dmg !", TAG,  szName,  iPower  );
			}
		}
	}
	
	return 1;
	
}
		
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ ansicpg1252\\ deff0{\\ fonttbl{\\ f0\\ fnil\\ fcharset0 Tahoma;}}\n{\\ colortbl ;\\ red0\\ green0\\ blue0;}\n\\ viewkind4\\ uc1\\ pard\\ cf1\\ lang2057\\ f0\\ fs16 \n\\ par }
*/
