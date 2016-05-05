#include <amxmodx>
#include <hamsandwich>
#include <hlsdk_const>  

public plugin_init()
{
    register_plugin("Furien : Block C4 Damage", "1.0.0", "schmurgel1983")
    RegisterHam(Ham_TakeDamage, "player", "fwd_TakeDamage")
}

public fwd_TakeDamage(victim, inflictor, attacker, Float:damage, damage_type)
{
    if (damage_type & DMG_BLAST)
        return HAM_SUPERCEDE;
    
    return HAM_IGNORED;
}