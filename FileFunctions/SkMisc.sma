#include <amxmodx>
#include <amxmisc>

#define PLUGIN		"Misc Funtion"
#define VERSION		"3.0"
#define AUTHOR		"Shooting King"

#define cm(%1)		(sizeof(%1)-1)

new gszDir[128];
new Admin_Level = ADMIN_RCON;

public plugin_init()
{
	register_plugin( PLUGIN, VERSION, AUTHOR );	
	register_concmd( "amx_sk_rename", "cmd_Rename", -1, "Usage: ^namx_sk_rename <oldName> <newName>");
	register_concmd( "amx_sk_delete", "cmd_Delete" );
	register_concmd( "amx_sk_listdir", "cmd_List" );
	// get_localinfo( "amxx_basedir", gszDir, cm(gszDir));
}

public cmd_List(id, cid)
{
	if(!cmd_access(id, Admin_Level, cid, 1)) 
		return PLUGIN_HANDLED;
	
	new szArg1[32]//, szTempDir[64];	
	read_argv( 1, szArg1, cm(szArg1));
	// formatex( szTempDir, cm(szTempDir), "%s/%s", gszDir, szArg1 );
	
	if( !dir_exists(szArg1) )
	{
		client_print(id, print_console, "*** Dir Does not Exist !!" );
		return PLUGIN_HANDLED;
	}
	
	new szBuffer[32], i = 0;
	new dHandle = open_dir( szArg1, szBuffer, cm(szBuffer) );
	client_print(id, print_console, "^n^n********** Files Of********** ^n%s^n", szArg1);
	
	do
	{
		client_print(id, print_console, "%d. %s", i, szBuffer);
		szBuffer[0] = '^0';
		i++;
	}
	while(next_file( dHandle, szBuffer, cm(szBuffer)));
	close_dir(dHandle);
	copy( gszDir, 127, szArg1 );
	return PLUGIN_HANDLED;
}

public cmd_Delete(id, cid)
{
	if(!cmd_access(id, Admin_Level, cid, 1)) 
		return PLUGIN_HANDLED;
	
	static szArg1[32], szFile[64];	
	read_argv( 1, szArg1, cm(szArg1));
	
	formatex( szFile, cm(szFile), "%s/%s", gszDir, szArg1 );
	if( !file_exists(szFile) )
	{
		client_print( id, print_console, "*** Input File Does Not Exist !!" );
		return PLUGIN_HANDLED;
	}
	
	if( !delete_file(szFile) )
	{
		client_print( id, print_console, "*** Delete File Failed !!" );
	}
	else
	{
		client_print( id, print_console, "*** Delete File Succeeded !!" );
	}
	return PLUGIN_HANDLED;
}

public cmd_Rename(id, cid)
{
	if(!cmd_access(id, Admin_Level, cid, 1)) 
		return PLUGIN_HANDLED;

	if(read_argc() != 3)
	{	
		client_print( id, print_console, "*** Invalid No. Of Arguments !!" );
		return PLUGIN_HANDLED;
	}
		
	static szFile[128], szRFile[128], szArg1[32], szArg2[32];
	
	read_argv( 1, szArg1, cm(szArg1)); 
	read_argv( 2, szArg2, cm(szArg2));
	remove_quotes(szArg1);
	remove_quotes(szArg2);
	formatex( szFile, cm(szFile), "%s/%s", gszDir, szArg1 );
	
	client_print(id, print_console, "Old file - %s", szArg1 );
	client_print(id, print_console, "New file - %s", szArg2 );
	client_print(id, print_console, "Old file Path - %s", szFile );
	
	if( !file_exists(szFile) )
	{
		client_print( id, print_console, "*** Input File Does Not Exist !!" );
		return PLUGIN_HANDLED;
	}
	
	formatex( szRFile, cm(szFile), "%s/%s", gszDir, szArg2 );
	client_print(id, print_console, "Rename File Path - %s", szRFile );
	if(file_exists(szRFile))
	{
		client_print( id, print_console, "*** Rename File Exists !!" );
		return PLUGIN_HANDLED;
		/*if( !delete_file(szRFile) )
		{
			client_print( id, print_console, "*** Delete File Failed !!" );
			return PLUGIN_HANDLED;
		}
		else
		{
			client_print( id, print_console, "*** Delete File Succeeded !!" );
		}*/
	}
	
	if( !rename_file( szFile, szRFile, 1 ))
	{
		client_print( id, print_console, "*** Renaming File Failed !!" );
	}
	else
	{
		client_print( id, print_console, "*** Renaming File Succeeded !!" );
	}
	return PLUGIN_HANDLED;
}	