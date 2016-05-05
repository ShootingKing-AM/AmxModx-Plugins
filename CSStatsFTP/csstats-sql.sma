/*
	Copyright (C) 2014 Shooting King

	This program is free software; you can redistribute it and/or
	modify it under the terms of the GNU General Public License
	as published by the Free Software Foundation; either version 2
	of the License, or (at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program; if not, write to the Free Software
	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

#include <amxmodx>
#include <amxmisc>
#include <ftp>

#define TASKSEND		989898
#define TASKSTART		723213
#define ADMIN_LEVEL		ADMIN_IMMUNITY

new g_iStartTime;

new gszServer[] = "server.ip.here";
new giPort =  21;
new gszUser[] = "ftpusername";
new gszPass[] = "ftppassword";
new gszLocalFile[] = "addons/amxmodx/data/csstats.dat";
new gszRemoteFile[] = "/remotedir/csstats.dat";

public plugin_init() 
{
	register_plugin( "CSX Sql Support" , "2.0" , "Shooting King( Harsha Raghu )" );
	register_cvar( "csx_sql_version", "2.0", FCVAR_SERVER);

	register_concmd( "amx_sk_forceupdate" , "cmdSend" );
	register_event( "TextMsg", "event_GameCommence", "a", "2&#Game_C" );
}

public cmdSend(id, cid)
{
	if( !cmd_access( id, ADMIN_LEVEL, cid, 1 ))
		return PLUGIN_HANDLED;
	
	Send();
	client_print( id, print_chat, "Send Called." );
	return PLUGIN_HANDLED;
}

public event_GameCommence()
{
	remove_task(TASKSEND);
	set_task(2.0, "Send", TASKSEND);
}

public Send()
{
	FTP_Open( gszServer , giPort , gszUser , gszPass , "FwdFuncOpen" );
	log_to_file( "csstats.log", "FTP READY : %s", (FTP_Ready())?"True":"False" );
}

public StartTransfer()
{
	if ( FTP_Ready() )
	{
		FTP_SendFile( gszLocalFile , gszRemoteFile , "FwdFuncTransfer" );    
		g_iStartTime = get_systime();
	}
}

public FwdFuncOpen( bool:bLoggedIn )
{
	log_to_file( "csstats.log",   "Login was %ssuccessful!" , bLoggedIn ? "" : "un" );
	if( bLoggedIn )
	{
		remove_task( TASKSTART );
		set_task( 1.0, "StartTransfer", TASKSTART );
	}
}

public FwdFuncTransfer( szFile[] , iBytesComplete , iTotalBytes )
{
    log_to_file( "csstats.log", "[%.1f%%] [%s] [ %d of %d bytes ][ %dkB/s ]" , ( floatdiv( float( iBytesComplete ) , float( iTotalBytes ) ) * 100.0 ) , 
                                    szFile , 
                                    iBytesComplete ,
                                    iTotalBytes , 
                                    ( ( iBytesComplete ) / 1000 ) / ( get_systime() - g_iStartTime ) );
                                    
    
    if ( iBytesComplete == iTotalBytes )
	{
		log_to_file( "csstats.log", "File transfer completed in %d seconds!" , get_systime() - g_iStartTime );
		set_task( 10.0, "Close" );
	}
}

public Close() FTP_Close();
