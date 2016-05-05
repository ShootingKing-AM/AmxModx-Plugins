#include <amxmodx>
#include <csx>

#define PLUGIN "Furien : Grenade Trail"
#define VERSION "2.5"
#define AUTHOR "Shooting King & Jim"

new g_trail

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
}

public plugin_precache()
{
	g_trail = precache_model("sprites/smoke.spr")
}

public grenade_throw(id, gid, wid)
{
	new r, g, b;

	switch(wid)
	{
		case CSW_HEGRENADE:		r = 255;
		case CSW_FLASHBANG:		b = 255;
		case CSW_SMOKEGRENADE:	g = 255;
	}

	message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
	write_byte(TE_BEAMFOLLOW);
	write_short(gid);
	write_short(g_trail);
	write_byte(10);
	write_byte(5);
	write_byte(r);
	write_byte(g);
	write_byte(b);
	write_byte(192);
	message_end();
}