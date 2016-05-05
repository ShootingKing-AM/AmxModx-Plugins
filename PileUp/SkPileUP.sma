#include <amxmodx>
#include <amxmisc>
#include <engine>
#include <fakemeta>
#include <fakemeta_util>

#define TASKMAKE		58231
#define SEQ_DUCK		2

#define PLUGIN		"Sk Pile UP"
#define VERSION		"1.0"
#define AUTHOR		"Shooting King"

new const gszClassName[] = "SkPileUpClass";
new const gszModels[][] = {

	"models/player/arctic/arctic.mdl",
	"models/player/gign/gign.mdl",
	"models/player/gsg9/gsg9.mdl",
	"models/player/leet/leet.mdl",
	// "models/player/militia/militia.mdl",
	"models/player/sas/sas.mdl",
	// "models/player/spetsnaz/spetsnaz.mdl",
	"models/player/terror/terror.mdl",
	"models/player/urban/urban.mdl"
}

new Float:gOrigins[33][3];
// new m_spriteTexture;
new const szKnifeModel[] = "models/p_knife.mdl";

public plugin_init()
{
	register_plugin( PLUGIN, VERSION, AUTHOR );
	
	register_clcmd( "amx_sk_pup", "cmdPileUp" );
	register_clcmd( "amx_sk_clearup", "cmdClearUp" );
	// register_clcmd( "say /show" , "cmd" );
	
	register_touch( gszClassName, "player", "PlayerTouch");
}

public PlayerTouch( ent, id )
{
	dllfunc( DLLFunc_Blocked, ent, id );
	client_print( 0, print_chat,  "%d Touched %d", id, ent );
}

public plugin_precache()
{
	for( new i = 0; i < sizeof(gszModels); i++ ) precache_model( gszModels[i] );
	
	precache_model( szKnifeModel );
	// m_spriteTexture = precache_model("sprites/dot.spr");
}

public cmdPileUp( id, cid )
{
	if(!cmd_access( id, ADMIN_IMMUNITY, cid, 2 ))
		return PLUGIN_HANDLED;
	
	new params[1];
	new szNum[3];
	pev( id, pev_origin, gOrigins[id] );
	
	read_argv ( id, szNum, 3 ); 
	params[0] = str_to_num(szNum);
	remove_task( id+TASKMAKE );
	
	set_task( 2.0, "MakeUP", (id+TASKMAKE), params, 1 );
	return PLUGIN_HANDLED;
}

public cmdClearUp( id, cid )
{
	if(!cmd_access( id, ADMIN_IMMUNITY, cid, 1 ))
		return PLUGIN_HANDLED;
	
	new tempent = fm_find_ent_by_owner( -1, gszClassName, id, 0 );
	new entowner;
	
	while( tempent )
	{
		if((entowner = fm_find_ent_by_owner(-1, "weaponbox", tempent)) != 0 )
		{
			fm_remove_entity( entowner );
		}
		fm_remove_entity( tempent );
		tempent = fm_find_ent_by_owner( -1, gszClassName, id, 0 );
	}
	
	return PLUGIN_HANDLED;
}

public MakeUP( Params[], id )
{
	id -= TASKMAKE;
	new Ent, iRand;
	new Float:Angle[3], Float:PlrOrigin[3];
		
	new Float:maxs[3] = {16.0,16.0,36.0};
	new Float:mins[3] = {-16.0,-16.0,-36.0};
	new Float:TempOrigin[3];
	
	TempOrigin[0] = gOrigins[id][0];
	TempOrigin[1] = gOrigins[id][1];
	TempOrigin[2] = gOrigins[id][2]-15;
	
	for( new i = 0; i < Params[0]; i++ )
	{
		pev( id, pev_v_angle, Angle );
		iRand = random_num(0, sizeof(gszModels)-1);
				
		Ent = create_entity( "info_target" );	
		entity_set_string( Ent, EV_SZ_classname, gszClassName);
		
		entity_set_size( Ent, mins, maxs);
		entity_set_int( Ent, EV_INT_solid, SOLID_BBOX);
		entity_set_int( Ent, EV_INT_movetype, MOVETYPE_BOUNCE);
		entity_set_model( Ent, gszModels[iRand]);
		// entity_set_string( Ent, EV_SZ_model, gszModels[iRand]); 		
		// entity_set_string( Ent, EV_SZ_viewmodel, szKnifeModel );		
		// entity_set_string( Ent, EV_SZ_weaponmodel, szKnifeModel );
			
		entity_set_int( Ent, EV_INT_sequence, SEQ_DUCK);
		entity_set_float( Ent, EV_FL_framerate, 1.0);
		entity_set_float( Ent, EV_FL_animtime, 2.0);
		
		entity_set_vector( Ent, EV_VEC_v_angle, Angle);
		entity_set_edict( Ent, EV_ENT_owner, id);
		
		entity_set_origin( Ent, TempOrigin);
		pev( id, pev_origin, PlrOrigin );
		GiveEntKnife( Ent );
		// drop_to_floor( Ent );
		// make_tracer( TempOrigin, PlrOrigin );
		TempOrigin[2] += 38;
	}
}

GiveEntKnife( ent )
{
	new iEntWeapon = create_entity( "info_target" );
	
	entity_set_string( iEntWeapon, EV_SZ_classname, "weaponbox" );
	entity_set_int( iEntWeapon, EV_INT_movetype, MOVETYPE_FOLLOW );
	entity_set_int( iEntWeapon, EV_INT_solid, SOLID_NOT );
	entity_set_edict( iEntWeapon, EV_ENT_aiment, ent );
	entity_set_model( iEntWeapon, szKnifeModel );
}
/*
public cmd( id )
{
	new Float:plrOrigin[3], Float:EntOrigin[3];
	new Float:SolidMode, Float:Movetype;
	new ent = fm_find_ent_by_owner( -1, gszClassName, id );
	pev( id, pev_origin, plrOrigin );
	pev( ent, pev_origin, EntOrigin );
	pev( id, pev_solid, SolidMode );
	pev( id, pev_movetype, Movetype );
	
	make_tracer( plrOrigin, EntOrigin );
	client_print( id , print_chat, "%f - Solid, %f - Move Type", SolidMode, Movetype );
	pev( ent, pev_solid, SolidMode );
	pev( ent, pev_movetype, Movetype );
	client_print( id , print_chat, "%f - Solid, %f - Move Type", SolidMode, Movetype );
}

public make_tracer(Float:fvec1[], Float:fvec2[])
{
	new vec1[3], vec2[3];
	
	for( new i = 0; i < 3; i ++ )
	{
		vec1[i] = floatround(fvec1[i]);		
		vec2[i] = floatround(fvec2[i]);
	}
	//BEAMENTPOINTS
	message_begin( MSG_BROADCAST,SVC_TEMPENTITY)
	write_byte (0)     //TE_BEAMENTPOINTS 0
	write_coord(vec1[0])
	write_coord(vec1[1])
	write_coord(vec1[2])
	write_coord(vec2[0])
	write_coord(vec2[1])
	write_coord(vec2[2])
	write_short( m_spriteTexture )
	write_byte(1) // framestart
	write_byte(1) // framerate
	write_byte(0) // life
	write_byte(5) // width
	write_byte(0) // noise
	write_byte( 255 )     // r, g, b
	write_byte( 255 )       // r, g, b
	write_byte( 255 )       // r, g, b
	write_byte(200) // brightness
	write_byte(150) // speed
	message_end()	
}*/