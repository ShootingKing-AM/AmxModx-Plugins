#include <amxmodx>
#include <fakemeta>

#define PLUGIN		"Sk Wall Shot"
#define VERSION		"1.0"
#define AUTHOR		"Shooting King"

new m_spriteTexture

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR);
	
	register_event( "DeathMsg", "event_DeathMsg", "a", "1>0" );
}

public plugin_precache()
{
	m_spriteTexture = precache_model("sprites/dot.spr");
}

public event_DeathMsg()
{
	new iKiller, iVictim, Float:vKiller[3], Float:vVictim[3];
	static szKiller[32];
	szKiller[0] = '^0';
	
	iKiller = read_data(1);
	iVictim = read_data(2);
	
	pev( iKiller, pev_origin, vKiller );
	pev( iVictim, pev_origin, vVictim );
	// get_user_origin( iKiller, vKiller, 1 );
	// get_user_origin( iVictim, vVictim, 1 );
	
	client_print( 0, print_chat, "%d" , is_wall_between_points(vKiller, vVictim, 0));
	if(is_wall_between_points(vKiller, vVictim, 0))
	{
		get_user_name( iKiller, szKiller, 31 );
		client_print( 0, print_center, "%s has just had a wall shot !! :O", szKiller );
	}
	make_tracer(vKiller, vVictim);	
}

stock is_wall_between_points(Float:start[3], Float:end[3], ignore_ent) 
{ 
	new ptr = create_tr2();
	//new Float:fstart[3], Float:fend[3];
	
	/*for( new i = 0; i < 3; i ++ )
	{
		fstart[i] = float(start[i]);		
		fend[i] = float(end[i]);
	}*/
	
	engfunc(EngFunc_TraceLine, start, end, IGNORE_GLASS, ignore_ent, ptr) 
    
	new Float:fraction;
	get_tr2(ptr, TR_flFraction, fraction); 
    
	free_tr2(ptr);
	return (fraction != 1.0);
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
	write_byte(5) // framerate
	write_byte(50) // life
	write_byte(10) // width
	write_byte(0) // noise
	write_byte( 255 )     // r, g, b
	write_byte( 0 )       // r, g, b
	write_byte( 0 )       // r, g, b
	write_byte(200) // brightness
	write_byte(150) // speed
	message_end()	
}
