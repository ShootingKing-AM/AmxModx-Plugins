#include <amxmodx>
#include <fakemeta>

#define VERSION "1.0"

#define SetUserModeled(%1)		g_bModeled |= 1<<(%1 & 31)
#define SetUserNotModeled(%1)		g_bModeled &= ~( 1<<(%1 & 31) )
#define IsUserModeled(%1)		( g_bModeled &  1<<(%1 & 31) )

#define SetUserConnected(%1)		g_bConnected |= 1<<(%1 & 31)
#define SetUserNotConnected(%1)		g_bConnected &= ~( 1<<(%1 & 31) )
#define IsUserConnected(%1)		( g_bConnected &  1<<(%1 & 31) )

#define MAX_MODEL_LENGTH	16
#define MAX_AUTHID_LENGTH 25

#define MAX_PLAYERS	32

#define ClCorpse_ModelName 1
#define ClCorpse_PlayerID 12

#define m_iTeam 114
#define g_ulModelIndexPlayer 491
#define fm_cs_get_user_team_index(%1)	get_pdata_int(%1, m_iTeam)

new const MODEL[] = "model";
new g_bModeled, g_bConnected;
new g_szCurrentModel[MAX_PLAYERS+1][MAX_MODEL_LENGTH];

new gModelFiles[][] = {
	"models/player/Furien/Furien.mdl",
	"models/player/AntiFurien/AntiFurien.mdl"
}

new gModels[][] = {	"Furien", "AntiFurien" }

public plugin_init()
{
	register_plugin("Furien : Players Models", VERSION, "Shooting King & ConnorMcLeod");

	register_forward(FM_SetClientKeyValue, "SetClientKeyValue");
	register_message(get_user_msgid("ClCorpse"), "Message_ClCorpse");
}

public plugin_precache()
{
	precache_model(gModelFiles[0]);
	precache_model(gModelFiles[1]);
}

public client_putinserver(id)
{
	if( !is_user_hltv(id) )
	{
		SetUserConnected(id);
	}
}

public client_disconnect(id)
{
	SetUserNotModeled(id);
	SetUserNotConnected(id);
}

public SetClientKeyValue(id, const szInfoBuffer[], const szKey[], const szValue[])
{
	if( equal(szKey, MODEL) && IsUserConnected(id) )
	{
		new iTeam = fm_cs_get_user_team_index(id);iTeam--;
		if( 0 <= iTeam <= 1 )
		{
			if(	!IsUserModeled(id)
			||	!equal(g_szCurrentModel[id], gModels[iTeam])
			||	!equal(szValue, gModels[iTeam])	)
			{
				copy(g_szCurrentModel[id], MAX_MODEL_LENGTH-1, gModels[iTeam]);
				SetUserModeled(id);
				set_user_info(id, MODEL, gModels[iTeam]);
				return FMRES_SUPERCEDE;
			}

			if( IsUserModeled(id) )
			{
				SetUserNotModeled(id);
				g_szCurrentModel[id][0] = 0;
			}
		}
	}
	return FMRES_IGNORED;
}

public Message_ClCorpse()
{
	new id = get_msg_arg_int(ClCorpse_PlayerID);
	if( IsUserModeled(id) )
	{
		set_msg_arg_string(ClCorpse_ModelName, g_szCurrentModel[id]);
	}
}