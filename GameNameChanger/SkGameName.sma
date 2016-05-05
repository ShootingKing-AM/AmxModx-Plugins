#include <amxmodx>
#include <fakemeta>

new const gamename[] = "-=[SK]=- ZM 24/7";

public plugin_init() 
{ 
	register_plugin( "Game Name", "1.1", "Shooting King" ); 
	register_forward( FM_GetGameDescription, "GameDesc" ); 
}
 
public GameDesc() 
{
	forward_return( FMV_STRING, gamename ); 
	return FMRES_SUPERCEDE; 
}  