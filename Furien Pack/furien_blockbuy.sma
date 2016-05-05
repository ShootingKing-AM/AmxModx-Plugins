#include <amxmodx> 
#include <fakemeta> 

public plugin_cfg()  
{  
	register_plugin( "Furien : Block Buy", "1.0", "Shooting King" );
	register_message(get_user_msgid("StatusIcon"), "Message_StatusIcon"); 
} 

public Message_StatusIcon(iMsgId, iMsgDest, id)  
{  
	static szIcon[8];  
	get_msg_arg_string(2, szIcon, charsmax(szIcon));  
	if( equal(szIcon, "buyzone") ) 
	{  
		if( get_msg_arg_int(1) )  
		{  
			set_pdata_int(id, 235, get_pdata_int(id, 235) & ~(1<<0)); 
			return PLUGIN_HANDLED;  
        }  
	}      
	return PLUGIN_CONTINUE;  
}  