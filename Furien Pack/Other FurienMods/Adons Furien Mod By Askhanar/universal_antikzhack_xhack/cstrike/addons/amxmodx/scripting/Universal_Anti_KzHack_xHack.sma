/*

___________________________________________________________________________________________________________
===========================================================================================================
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
				    ___________________________________
				   |=                                 =|
			           |=  Universal Anti KzHack / xHack  =|
			           |=  ¯¯¯¯¯¯¯¯¯ ¯¯¯by¯¯¯¯¯¯ ¯ ¯¯¯¯¯  =|
			           |=		    ¯¯  Askhanar      =|
			           |=                   ¯¯¯¯¯¯¯¯      =|
                                    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
 __________________________________________________________________________________________________________
|==========================================================================================================|
|													   |
|					 Copyright © 2012, Askhanar					   |
|			  Acest fisier este prevazut asa cum este ( fara garantii )			   |
|													   |
|==========================================================================================================|
 ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
	- ¦ 				         « Prieteni »			      		¦ -
	** * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **
	* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	* * *										      * * *
	* *  	Rap^		Frosten			TheBeast		AZAEL!   	* *
	* *	fuzy		razvan W-strafer	RZV			SNKT   	 	* *	
	* *	ahonen		Arion			pHum			d e w   	* *
	* *	gLobe		syBlow			kvL^			krom3       	* *
	* *	Henk		DANYEL			SimpLe			XENON^		* *
	* * *								                      *	* *
	* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	** * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **
	
	- ¦ 				       « Multumiri »			      		¦ -
	** * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **
	* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	* * *										      *	* *
	* *	o    -=hunter=-   pentru ca m-am inspirat din					* *
	* *				Universal Anti KzHack v1.6 si am rescris alta		* *
	* *				versiune in propriul stil.				* *
	* *											* *
	* *	o    ReymonARG    pentru ca m-am uitat prin cod-ul               		* *
	* *				lui din Kz-Arg Mod unde am gasit cateva lucruri	  	* *
	* *				care m-au ajutat.					* *
	* *											* *
	* *	o    fuzy         pentru ca m-a ajutat cu multe comenzi         		* *
	* *				de KzHack si de xHack si sa inteleg care		* *
	* *				cum sunt folosite de client.				* *
	* *											* *
	* *	 o    Exolent      pentru ca m-am uitat prin cod-ul lui         		* *
	* *				din advanced_bans si am luat functia de 		* *
	* *				amx_printhackbans.( am vazut modul )			* *
	* * *										      *	* *
	* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	** * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **
	   _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	- ¦  Le multumesc tuturor testerilor ( KzHack-erii si xHack-erii xD ) care m-au ajutat  ¦ -
	   ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯
 __________________________________________________________________________________________________________	
|==========================================================================================================|	
* 													   *
 *	                   Daca gasiti ceva in neregula, va rog sa ma contactati.		          *
  **												        **
    *				      YM:        red_bull2oo6					       *
     *				      Steam:     red_bull2oo6				              *
      **			      e-mail:    red_bull2oo6@yahoo.com			            **
        *										           *
	 *											  *
	 |****************************************************************************************|
	  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
                           Comenzi:
			   
				   amx_removehackban < steamid / ip > 
			   -|  scoti ban-ul de pe ip-ul / steamid-ul specificat |-
			
				   amx_reloadhackbans 
			   -|  reincarci toate ban-urile din fisier |-
			
				   amx_reloadhackcommands 
			   -|  reincarci toate comenzile din fisier |-
			
				  amx_printhackbans < nr > 
			   -|  printeaza in consola 9 ban-uri incepand de la nr specificat  |-
			
			  Cvar-uri:
			
				   ua_kzhack_xhack_tag "[D/C]"
			   -|  acest cvar seteaza tag-ul mesajelor din chat |-
			   -|  tag-ul va fi verde si este situat inaintea mesajelor |-
			
			
				    ua_kzhack_xhack_site "www.site.ro"
			   -|  acest cvar seteaza site-ul din consola |-
			   -|  site-ul este folosit la printarea informatiilor despre ban |-
			
			   Ex:
			
			  *    Daca te simti neindreptatit contacteaza-ne pe:
			  *    www.site.ro
			
			
			   Jucatorii sunt scanati la primul spawn de la conectare.
			   Daca iese de pe server si intra iar, va fi scanat iar.
			   Scanarea nu impiedica gameplay-ul si nu flodeaza jucatorul. 
			
			   Plugin-ul detecteaza 113 comenzi de KzHack / xHack.
			   Acele 113 comenzi sunt adaugate de mine si sunt cele default.
			   Nu pot fi sterse decat daca umblii in .sma si le scoti tu.
			   Acelea sunt toate comenzile care le stiu / gasit ori aflat.
			   Poti adauga in HackCommands.ini pana la 1000 de comenzi.
			
			
			   Cei prinsi cu KzHack / xHack vor primi ban permanent.
			   Plugin-ul foloseste fisier propriu pentru a salva ban-urile.
			   De asemenea functioneaza pe steam / non-steam / fakesteam.
			
			   Cei ce vor cumpara plugin-ul vor primi un .amxx customizat.
			   Acel .amxx va functiona doar pe un singur ip de server.
			   In caz ca iti schimbi server-ul vei primi un alt .amxx pt acel sv.
					       
			   Plugin-ul mai are si 2 log-uri in care salveaza activitatile.
			   Unul in folderul logs in care salveaza urmatoarele:
			   Cate comenzi / ban-uri a incarcat, daca a gasit sau nu
				    fisierul HackCommands.ini ( in caz ca nu il va crea
				    cu comenzile defalut puse de mine ).
				    
			   Si unul in folderul configs care salveaza urmatoarele:
			   Cine si cand a fost prins si a primit ban.
			   Cine, cand si cui a dat unban.

*/



#include < amxmodx >
#include < amxmisc >

#include < hamsandwich >
#include < ColorChat >


/*================================================================================================*/
/*======================================= - ¦ Askhanar ¦ - =======================================*/
/*============================= - | [Defines & Variables & Const] | - ============================*/
/*================================================================================================*/

static const ServerLicensedIp[ ] = "188.212.105.61";

#define PLUGIN "Universal Anti KzHack / xHack"
#define VERSION "1.0.1"

#define HackCmdsNum 			1000		//Mai mult de 1000 de comenzi nu suporta pluginul.
#define HackBansNum			5120		//Mai mult de 5120 de ban-uri nu am testat dar e de ajuns.
#define CheckTime			5.0		//La cat timp dupa ce serverul a trimis comenzile va fi verificat.
#define All				999		//Nu modifica..
#define HACKTASK 			112233		//Nu modifica..
#define KICKTASK			332211		//Nu modifica..
#define HACK_ACCESS			ADMIN_LEVEL_B	//Accesul pentru comenzi.



/*======================================= - ¦ Askhanar ¦ - =======================================*/



//Comenzile default puse de mine ce vor fi scrise si in fisierul HackCommands.ini .
new const DefaultHackCmds[ 113 ][ ] =
{

	"123_exec", "zhy_exec", "rzv_exec", "kzh_exec", "xhz_exec",
	"kir_exec", "zkh_exec", "yho_exec", "xkz_exec", "yam_exec",
	"punct_exec", "eMy_ixic", "str_exec", "kid_cexe", "xhz_cexe",
	"the_cexe", "punct_cexe", "edd_cexe", "tom_exec", "rayuexec",
	"tom_cexe", "ddd_ixic", "ddd_exec", "ken_exec", "zhx_exec",
	"crp_exec", "plm_exec", "rayu_exec", "fps_exec", "eMy_exec",
	"kyk_exec", "the_exec", "bld_exec", "str8_cexe", "tvx_cexe",
	"nok_cexe", "bof_exec", "d3eveloper", "str_cexe", "per_exec",
	"developee", "erx_exec", "4jb_max", "fps_upp", "aliaz", "make",
	"r4te", "xrat", "str8_exec", "dh_bhop", "EdiTioN_bhop", "BiotecK_speed",
	"csrv4_speed", "Eddi_speed", "Eddwz_speed", "eMy?!_speed", "eXper_speed",
	"Jonnn_speed", "night_speed", "LastE_speed", "raiz0_speed", "ressu_speed",
	"speed_speed", "strafe_speed", "pbut_speed", "under_speed", "xawze_speed",
	"xHack_speed", "xrayu_speed", "xPr9n_speed", "XHackaspeed", "xkzh_speed",
	"xkz_speed", "roxaspeed", "pbutspeed", "xrayuspeed", "nok_exec", "tvx_exec",
	"phn_exec", "asd_exec", "spd_exec", "ray_exec", "afk_exec", "pad_exec",
	"kic_exec", "hns_exec", "edy_exec", "zhe_exec", "raf_exec", "coi_exec",
	"yah_exec", "6ei_exec", "raf+exec", "kar_exec", "coi+exec", "edi_exex",
	"edi+exec", "edy+exec", "str+exec", "kid+exec", "zhy+exec", "bld+exec",
	"afk+exec" , "ray+exec", "pad+exec", "edd_exec", "edd+exec", "spd+exec",
	"kid_exec", "str8exec", "m4c_exec", "!speed", "khack_speed"

}

//Motivul pentru ban.
new const HackReason[ ] = "KzHack / xHack";


/*======================================= - ¦ Askhanar ¦ - =======================================*/


//Pentru ban-uri..
new HackBannedIp[ HackBansNum ] [ 32 ];
new HackBannedSteamId[ HackBansNum ] [ 35 ];
new HackBannedName[ HackBansNum ] [ 32 ];
new HackBannedTime[ HackBansNum ] [ 32 ];
new HackBannedCommand[ HackBansNum ] [ 32 ];
new HackBannedReason[ HackBansNum ] [ 32 ];

//Pentru a verifica daca comanda trimisa a ajuns la client.
new HackResponse[ 32 ];
new HackResponseValue;
new HackResponseNum[ 33 ];

//Pentu a incarca comenzile.
new HackCmds[ HackCmdsNum ][ 32 ];
new HackCmdsValue;

//Pentru comenzile si ban-urile incarcate.
new HackTasks = 0;
new HackBans = 0;
new Tasks[ 33 ];

//Altele...
new bool:HackFound[ 33 ][ HackCmdsNum ];
new bool:HackRechecked[ 33 ];
new bool:FirstSpawn[ 33 ];

//Cvaruri
new cvar_tag;
new cvar_site;

//Pentru mesajul Hud.
new g_hud;

//De aici nu va mai explic..pentru ca nu e nevoie sa intelegeti voi...
//Daca modificati sunteti bun raspunzatori.

/*================================================================================================*/
/*======================================= - ¦ Askhanar ¦ - =======================================*/


public plugin_init( ) 
{
	new ServerIp[ 22 ];
	get_user_ip( 0, ServerIp, sizeof ( ServerIp ) -1, 1 );
	
	if( equal( ServerIp, ServerLicensedIp ) )
	{
		
		new PluginName[ 32 ];
		format( PluginName, sizeof ( PluginName ) -1, "[Ip Licentiat] %s", PLUGIN );
		register_plugin( PluginName, VERSION, "Askhanar" );
	
		cvar_tag = register_cvar( "ua_kzhack_xhack_tag", "[D/C]" );
		cvar_site = register_cvar( "ua_kzhack_xhack_site", "www.disconnect.ro/forum" );
		
		register_concmd( "amx_removehackban", "ConCmdRemoveHackBan", -1, "< target ip / target steamid >" );
		register_concmd( "amx_reloadhackbans", "ConCmdReloadHackBans", -1, "" );
		register_concmd( "amx_reloadhackcommands", "ConCmdReloadHackCommands", -1, "" );
		register_concmd( "amx_printhackbans", "ConCmdPrintHackBans", -1, "" );
		register_concmd( "amx_lol", "PrintConsoleTimeoutInfo", -1, "" );
		
		RegisterHam( Ham_Spawn, "player" , "hamSpawnPlayer_Post" , 1 );
		
		CreateResponsesAndValues( );
		g_hud = CreateHudSyncObj( );
		
		set_task(  215.0,"cmdRunningMsg",_,_,_,"b",0);
		
		server_print( "%s Felicitari! Detii o licenta valida, iar pluginul functioneaza perfect!", PLUGIN );
		server_print( "%s Pentru mai multe detalii y/m: red_bull2oo6 | steam: red_bull2oo6 !", PLUGIN );
		server_print( "%s Ip-ul Licentiat: %s, Ip-ul Serverului: %s", PLUGIN, ServerIp, ServerLicensedIp );
	}
	else
	{
		new PluginName[ 32 ];
		format( PluginName, sizeof ( PluginName ) -1, "[Ip Nelicentiat] %s", PLUGIN );
		register_plugin( PluginName, VERSION, "Askhanar" );
		
		server_print( "%s Nu detii o licenta valabila ! Plugin-ul nu va functiona corespunzator !", PLUGIN );
		server_print( "%s Pentru mai multe detalii y/m: red_bull2oo6 | steam: red_bull2oo6 !", PLUGIN );
		server_print( "%s Ip-ul Licentiat: %s, Ip-ul Serverului: %s", PLUGIN, ServerIp, ServerLicensedIp );
		
		pause( "ade" );
	}
}


/*================================================================================================*/
/*======================================= - ¦ Askhanar ¦ - =======================================*/
/*===================================== - | [Plugin Code] | - ====================================*/
/*================================================================================================*/

public plugin_precache( ) 
{
	new ServerIp[ 22 ];
	get_user_ip( 0, ServerIp, sizeof ( ServerIp ) -1, 1 );
	
	if( equal( ServerIp, ServerLicensedIp ) )
	{
			
		new szFile[ 128 ];
		
		get_configsdir( szFile, sizeof ( szFile ) -1 );
		formatex( szFile, sizeof ( szFile ) -1, "%s/Hackers.txt", szFile );
		
		if( !file_exists( szFile ) ) 
		{
			write_file(szFile, "Jucatorii prinsi cu KzHack sau xHack !", -1 );
			write_file(szFile, "", -1 );
			write_file(szFile, "", -1 );
		}
		
		get_configsdir( szFile, sizeof ( szFile ) -1 );
		formatex( szFile, sizeof ( szFile ) -1, "%s/HackersData.txt", szFile );
		
		if( !file_exists( szFile ) ) 
		{
			write_file(szFile, ";Ip-uri / Steamid-uri blocate datorita KzHack / xHack !", -1 );
			write_file(szFile, ";", -1 );
			write_file(szFile, ";", -1 );
		}
		
		LoadHackCommands( );
		LoadHackBans( );
	}

}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public CreateResponsesAndValues( )
{
	new HackLen = random_num( 10, 15 );
	
	for( new i = 0; i < HackLen ; i ++ )
	{
		
		HackResponse[ i ] = random_num( 'a', 'z' );
		
	}
	
	HackResponseValue = random_num( 100000 , 499999 );
	HackCmdsValue = random_num( 500000 , 999999 );
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public ConCmdRemoveHackBan( id )
{
	if( !( get_user_flags( id ) & HACK_ACCESS ) )
	{
		client_cmd( id, "echo Nu ai acces la aceasta comanda !" );
		return 1;
	}
	
	new plugin_info[ 128 ];
	if( id == 0 )
	{
		formatex( plugin_info, sizeof ( plugin_info ) -1,"******** %s v%s by %s ********", PLUGIN, VERSION, "Askhanar" );
	}
	else
	{
		formatex( plugin_info, sizeof ( plugin_info ) -1,"echo ^"******** %s v%s by %s ********^"", PLUGIN, VERSION, "Askhanar" );
	}
	
	new bool: BanFound = false;
	new authid[ 32 ];
	
	read_argv(1, authid, sizeof ( authid ) -1 );
	if( equal( authid, "" ) )
	{
		if( id == 0 )
		{
			server_print( "echo amx_removehackban < target ip / target steamid > !" );
		}
		else
		{
			
			client_cmd( id, "echo amx_removehackban < target ip / target steamid > !" );
		}
		return 1;
	}
	
	for( new i = 0; i < HackBans ; i++ )
	{
		if( equal( HackBannedIp[ i ], authid ) || equal( HackBannedSteamId[ i ], authid ) )
		{
			if( id == 0 )
			{
				server_print( "****************************************************" );
				server_print( "**************Informatii despre scoaterea banului*************" );
				server_print( "*    ");
				server_print( "*    Nume: %s", HackBannedName[ i ] );
				server_print( "*    Steamid: %s", HackBannedSteamId[ i ] );
				server_print( "*    Ip: %s", HackBannedIp[ i ]);
				server_print( "*    Motiv: %s ", HackBannedReason[ i ] );
				server_print( "*    Durata: Permanenta");
				server_print( "*    Comanda detectata: %s", HackBannedCommand[ i ] );
				server_print( "*    Data/Ora: %s^"", HackBannedTime[ i ] );
				server_print( "*    ");
				server_print( "*    Comanda executata cu succes !");
				server_print( "*    Banul de pe ip-ul / steamid-ul |%s| a fost scos.", authid );
				server_print( "*    ");
				server_print( "****************************************************" );
				server_print( "%s", plugin_info );
				server_print( "****************************************************" );
			}
			else
			{
					
				client_cmd( id, "echo ^"****************************************************^"") ;
				client_cmd( id, "echo ^"**************Informatii despre scoaterea banului*************^"" );
				client_cmd( id, "echo ^"*    ^"" );
				client_cmd( id, "echo ^"*    Nume: %s^"", HackBannedName[ i ] );
				client_cmd( id, "echo ^"*    Steamid: %s^"", HackBannedSteamId[ i ] );
				client_cmd( id, "echo ^"*    Ip: %s^"", HackBannedIp[ i ] );
				client_cmd( id, "echo ^"*    Motiv: %s ^"", HackBannedReason[ i ] );
				client_cmd( id, "echo ^"*    Durata: Permanenta^"" );
				client_cmd( id, "echo ^"*    Comanda detectata: %s^"", HackBannedCommand[ i ] );
				client_cmd( id, "echo ^"*    Data/Ora: %s^"", HackBannedTime[ i ] );
				client_cmd( id, "echo ^"*    ^"" );
				client_cmd( id, "echo ^"*    Comanda executata cu succes !^"" );
				client_cmd( id, "echo ^"*    Banul de pe ip-ul / steamid-ul |%s| a fost scos.^"", authid );
				client_cmd( id, "echo ^"*    ^"");
				client_cmd( id, "echo ^"****************************************************^"" );
				client_cmd( id, "%s", plugin_info );
				client_cmd( id, "echo ^"****************************************************^"" );
			}
			
			BanFound = true;
			
			new configsdir[64], file[ 128 ], log[ 256 ];
			
			get_configsdir( configsdir, sizeof ( configsdir ) -1 );
			formatex( file, sizeof ( file ) -1,"%s/Hackers.txt", configsdir );	
			
			new name[ 32 ], ip[ 32 ], authid[ 35 ], logtime[ 32 ];
			
			get_user_name( id, name, sizeof ( name ) -1 )
			get_user_authid( id, authid,sizeof ( authid ) -1 )
			get_user_ip( id, ip , sizeof ( ip ) -1, 1 );
			get_time("%d.%m.%Y - %H:%M:%S", logtime ,sizeof ( logtime ) -1 );
			
			formatex( log, sizeof (log ) -1,"-----------------------------------------------------------------------------------------------------------------------------------------------");
			write_file(file, log, -1 );
			
			formatex( log, sizeof (log ) -1,"|%s| - ADMIN %s [%s] (%s) - a scos ban-ul ce urmeaza !", logtime, name, authid, ip );
			write_file(file, log, -1 );
			
			formatex( log, sizeof (log ) -1,"|%s| - %s [%s] (%s) -  comanda detectata <%s> - motiv | %s |",
				HackBannedTime[ i ], HackBannedName[ i ], HackBannedSteamId[ i ], HackBannedIp[ i ], HackBannedCommand[ i ], HackBannedReason[ i ] );
			write_file(file, log, -1 );
			
			formatex( log, sizeof (log ) -1, "-----------------------------------------------------------------------------------------------------------------------------------------------");
			write_file(file, log, -1 );
			
			RemoveHackBan( i );
			break;
		}
	}

	if( !BanFound )
	{
		if( id == 0 )
		{
			server_print( "****************************************************" );
			server_print( "****************************************************" );
			server_print( "*    " );
			server_print( "*    Comanda nu poate fi executata !" );
			server_print( "*    Ip-ul / steamid-ul |%s|", authid );
			server_print( "*    Nu a fost gasit in baza de date." );
			server_print( "*    " );
			server_print( "****************************************************" );
			server_print( "%s", plugin_info );
			server_print( "****************************************************" );
		}
		else
		{
			
			client_cmd( id, "echo ^"****************************************************^"" );
			client_cmd( id, "echo ^"****************************************************^"" );
			client_cmd( id, "echo ^"*    ^"" );
			client_cmd( id, "echo ^"*    Comanda nu poate fi executata !^"" );
			client_cmd( id, "echo ^"*    Ip-ul / steamid-ul |%s|^"", authid );
			client_cmd( id, "echo ^"*    Nu a fost gasit in baza de date.^"" );
			client_cmd( id, "echo ^"*    ^"" );
			client_cmd( id, "echo ^"****************************************************^"" );
			client_cmd( id, "%s", plugin_info );
			client_cmd( id, "echo ^"****************************************************^"" );
		}
	}

	return 1;
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public ConCmdPrintHackBans( id )
{
	if( !( get_user_flags( id ) & HACK_ACCESS ) )
	{
		client_cmd( id, "echo Nu ai acces la aceasta comanda !" );
		return 1;
	}
	
	if( HackBans == 0 )
	{
		client_cmd( id, "echo Nu am gasit niciun ban in baza de date !" );
		return 1;
	}
	
	new start , end, pos_to_num;
	new position[ 5 ];
	
	read_argv( 1, position, sizeof ( position ) - 1 );
	pos_to_num = str_to_num( position );
	start = min( pos_to_num, HackBans ) - 1;

	if( start <= 0 ) start = 0;
	
	end = min( start + 9, HackBans ); // nu modifica aici mai mult de 9 ca iti va da reliable channel overflowed
	
	new plugin_info[ 128 ];
	
	if( id == 0 )
	{
		formatex( plugin_info, sizeof ( plugin_info ) -1,"******** %s v%s by %s ********", PLUGIN, VERSION, "Askhanar" );
	
		server_print( "****************************************************" );
		server_print( "*    Numar total de banuri: %d | Banuri vizualizate acum: %d - %d ****", HackBans, start + 1, end );
		server_print( "*    " );
		
		for( new i = start ; i < end ; i++ )
		{
			
			server_print( "******************* Detaliile banului #%d ******************", i + 1 );
			server_print( "*    " );
			server_print( "*    Nume: %s", HackBannedName[ i ] );
			server_print( "*    Steamid: %s", HackBannedSteamId[ i ] );
			server_print( "*    Ip: %s", HackBannedIp[ i ] );
			server_print( "*    Motiv: %s ", HackBannedReason[ i ] );
			server_print( "*    Durata: Permanenta" );
			server_print( "*    Comanda detectata: %s", HackBannedCommand[ i ] );
			server_print( "*    Data/Ora: %s", HackBannedTime[ i ] );
			server_print( "*    " );
			server_print( "*    " );
			
		}
		
		server_print( "****************************************************" );
		server_print( "%s", plugin_info );
		server_print( "****************************************************" );
	}
	
	else
	{
		formatex( plugin_info, sizeof ( plugin_info ) -1,"echo ^"******** %s v%s by %s ********^"", PLUGIN, VERSION, "Askhanar" );
	
		client_cmd( id, "echo ^"****************************************************^"");
		client_cmd( id, "echo ^"*    Numar total de banuri: %d | Banuri vizualizate acum: %d - %d ****^"", HackBans, start + 1, end );
		client_cmd( id, "echo ^"*    ^"" );
		
		for( new i = start ; i < end ; i++ )
		{
			
			client_cmd( id, "echo ^"******************* Detaliile banului #%d ******************^"", i + 1 );
			client_cmd( id, "echo ^"*    ^"" );
			client_cmd( id, "echo ^"*    Nume: %s^"", HackBannedName[ i ] );
			client_cmd( id, "echo ^"*    Steamid: %s^"", HackBannedSteamId[ i ] );
			client_cmd( id, "echo ^"*    Ip: %s^"", HackBannedIp[ i ] );
			client_cmd( id, "echo ^"*    Motiv: %s ^"", HackBannedReason[ i ] );
			client_cmd( id, "echo ^"*    Durata: Permanenta^"" );
			client_cmd( id, "echo ^"*    Comanda detectata: %s^"", HackBannedCommand[ i ] );
			client_cmd( id, "echo ^"*    Data/Ora: %s^"", HackBannedTime[ i ] );
			client_cmd( id, "echo ^"*    ^"" );
			client_cmd( id, "echo ^"*    ^"" );
			
		}
		
		client_cmd( id, "echo ^"****************************************************^"" );
		client_cmd( id, "%s", plugin_info );
		client_cmd( id, "echo ^"****************************************************^"" );
	}
	
	return 1;
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public ConCmdReloadHackBans( id )
{
	if( !( get_user_flags( id ) & HACK_ACCESS ) )
	{
		client_cmd( id, "echo Nu ai acces la aceasta comanda !");
		return 1;
	}
	
	HackBans = 0;
	
	for( new i = 0 ; i < HackBansNum ; i++ )
	{
		
		copy( HackBannedIp[ i ], sizeof ( HackBannedIp[ ] ) -1, "" );
		copy( HackBannedSteamId[ i ], sizeof ( HackBannedSteamId[ ] ) -1, "" );
		copy( HackBannedName[ i ], sizeof ( HackBannedName[ ] ) -1, "" );
		copy( HackBannedTime[ i ], sizeof ( HackBannedTime[ ] ) -1, "" );
		copy( HackBannedCommand[ i ], sizeof ( HackBannedCommand[ ] ) -1, "" );
		
	}
	
	if( id == 0 )
	{
		server_print( "Ban-urile vor fi reincarcate !" );
	}
	else
	{
		client_cmd( id, "echo Ban-urile vor fi reincarcate !" );
	}
	
	LoadHackBans( );
	
	if( id == 0 )
	{
		server_print( "Am incarcat cu succes %d ban-uri.", HackBans )
	}
	else
	{
		client_cmd( id, "echo Am incarcat cu succes %d ban-uri.", HackBans )
	}
	
	return 1;
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public ConCmdReloadHackCommands( id )
{
	if( !( get_user_flags( id ) & HACK_ACCESS ) )
	{
		client_cmd( id, "echo Nu ai acces la aceasta comanda !");
		return 1;
	}
	
	HackTasks = 0;
	
	if( id == 0 )
	{
		server_print( "Comenzile de KzHack / xHack vor fi reincarcate !" );
	}
	else
	{
		client_cmd( id, "echo Comenzile de KzHack / xHack vor fi reincarcate !" );
	}
	
	LoadHackCommands( );
	
	if( id == 0 )
	{
		server_print( "Am incarcat cu succes %d comenzi de KzHack / xHack.", HackTasks )
	}
	else
	{
		client_cmd( id, "echo Am incarcat cu succes %d comenzi de KzHack / xHack.", HackTasks )
	}

	return 1;
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public cmdRunningMsg( )
{

	client_cmd( 0, "echo Anti KzHack - Running" );
	client_cmd( 0, "echo Anti xHack - Running" );
	
	set_hudmessage( random_num( 0 , 255 ), random_num( 0 , 255 ), random_num( 0 , 255 ), -1.0, 0.35, 0, 0.0, 2.0, 0.0, 1.0, 3);
	ShowSyncHudMsg( 0, g_hud , "Anti KzHack - Running^nAnti xHack - Running" );

}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public hamSpawnPlayer_Post( id )
{

	if(is_user_alive( id ) && is_user_connected( id ) )
	{
		
		if(FirstSpawn[ id ] )
		{
			
			FirstSpawn[ id ] = false;
			set_task( random_float( 5.0 , 10.0 ), "SendHackTasks", id + HACKTASK );
			
		}
	}
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public client_authorized( id )
{

	if ( is_user_bot( id ) || is_user_hltv( id ) ) return 0;
	
	
	new ip[ 32 ], authid[ 35 ], bool:IsSteamUser = false;
	get_user_ip( id, ip , sizeof ( ip ) -1, 1 );
	get_user_authid( id, authid, sizeof ( authid ) -1 );
	
	IsSteamUser = ( authid[ 7 ] == ':' ? true : false );
	
	for( new i = 0; i < HackBans ; i++ )
	{
		if( equal( HackBannedIp[ i ], ip ) || IsSteamUser && equal( HackBannedSteamId[ i ], authid ) ) 
		{
			PrintConsoleInfo( id, HackBannedSteamId[ i ], HackBannedIp[ i ], HackBannedName[ i ], HackBannedTime[ i ], HackBannedCommand[ i ], HackBannedReason[ i ] );
			set_task( 1.0, "TaskDisconnectPlayer", id + KICKTASK );
			break;
		}
	}

	return 0;
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public client_putinserver( id )
{

	if ( is_user_bot( id ) || is_user_hltv( id ) ) return 0;
	
	HackRechecked[ id ] = false;
	Tasks[ id ] = 0;
	FirstSpawn[ id ] = true;
	
	set_task( 10.0, "cmdHackIncarcat", id );
	return 0;
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public cmdHackIncarcat( id )
{ 

	if( !is_user_connected( id ) ) return 1;
	
	new TAG[ 32 ];
	get_pcvar_string( cvar_tag, TAG , sizeof ( TAG ) -1 );
	
	ClearChat( id );
	ColorChat( id, RED,"^x04%s^x01 Anti^x03 KzHack^x01 , Anti^x03 xHack^x01 Incarcat Cu Succes !", TAG ); 
	
	return 0;

}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public SendHackTasks( id )
{
	
	id -= HACKTASK;
	
	if( !is_user_connected( id ) ) return 1;
	
	for( new i = 0; i < HackTasks ; i++ )
	{
		HackFound[ id ][ i ] = true;
	}
	
	HackResponseNum[ id ] = 0;
	Tasks[ id ] = 0;
	
	new TAG[ 32 ];
	get_pcvar_string( cvar_tag, TAG , sizeof ( TAG ) -1 );
	
	ClearChat( id );	
	ColorChat( id, RED,"^x04%s^x01 Esti scanat de^x03 KzHack^x01 ,^x03 xHack^x01, te rugam sa ai rabdare.", TAG );
	ColorChat( id, RED,"^x04%s^x01 Acest lucru dureaza^x03 %.1f ^x01 secunde.", TAG,  ( float( HackTasks ) * 0.1 ) ); 
	
	set_task( 1.0, "ExecHackCmds", id );
	
	return 0;

}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public ExecHackCmds( id )
{
	if( !is_user_connected( id ) ) return 1;
	
	new command[ 25 ];
	if( Tasks[ id ] >= HackTasks )
	{
		client_cmd( id , "clear" );
		set_task( CheckTime, "CheckForHacker", id );
		return 1;
	}
	
	formatex( command, sizeof ( command ) -1 , "%s %d" , HackCmds[ Tasks[ id ] ], HackCmdsValue );
	MakeClientExecCommand( id, command );
	
	formatex( command, sizeof ( command ) -1 , "%s %d" , HackResponse , HackResponseValue );
	MakeClientExecCommand( id, command );
	
	set_task( 0.1 , "ExecHackCmds", id );
	
	Tasks[ id ] ++;
	return 0;
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public MakeClientExecCommand( id, const command[ ] )
{
	client_cmd( id , "clear" );
	client_cmd( id, "%s", command );
	client_cmd( id , "clear" );
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public CheckForHacker( id )
{
	if( !is_user_connected( id ) ) return 1;
	
	new bool:HackerFound = false;
	new TAG[ 32 ];
	get_pcvar_string( cvar_tag, TAG , sizeof ( TAG ) -1 );
	
	for( new i = 0; i < HackCmdsNum ; i++ )
	{
		if( HackFound[ id ][ i ] )
		{
			
			if( HackResponseNum[ id ] == HackTasks )
			{
				
				HackerFound = true;
				cmdRunningMsg( );
				
				new name[ 32 ], ip[ 32 ], authid[ 35 ], logtime[ 32 ];
				
				get_user_name( id, name, sizeof ( name ) -1 )
				get_user_authid( id, authid,sizeof ( authid ) -1 )
				get_user_ip( id, ip , sizeof ( ip ) -1, 1 );
				get_time("%d.%m.%Y - %H:%M:%S", logtime ,sizeof ( logtime ) -1 );
				
				LogHacker( logtime, name, authid, ip, HackCmds[ i ], HackReason );
				SaveHackerData( ip, authid, name, logtime, HackCmds[ i ], HackReason );
				PrintConsoleInfo( id, authid, ip, name, logtime, HackCmds[ i ], HackReason );
					
				ClearChat( All );
				ColorChat( 0, RED,"^x04%s^x03 %s^x01 a primit ban pentru ca joaca cu^x03 kzHazk^x01/^x03xHack^x01, (^x03%s^x01) !", TAG , name, HackCmds[ i ] );
				
				set_task( 1.0, "TaskDisconnectPlayer", id + KICKTASK);
				break;
				
			}
			
			else
			{
				
				if ( !HackRechecked[ id ] )
				{
					
					HackerFound = true;
					cmdRunningMsg( );
					
					HackRechecked[ id ] = true;				
					set_task( 3.0, "SendHackTasks" , id + HACKTASK );
					
				}
				else
				{
					
					HackerFound = true;
					
					PrintConsoleTimeoutInfo( id );
					set_task( 1.0, "TaskDisconnectPlayer", id + HACKTASK );
					
					
				}
				break;
			}
		}
	}
	
	if( !HackerFound )
	{
		
		ClearChat( id );
		ColorChat( id, RED,"^x04%s^x01 Scanarea a luat sfarsit, nu am detectat nimic !", TAG);
		
	}
	
	return 0;
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public client_command( id )
{
	
	new command[ 25 ], value[ 10 ], value_to_num;
	
	read_argv( 0, command , sizeof ( command ) -1 );
	read_argv( 1, value , sizeof ( value ) -1 );
	
	if( equal( HackResponse , command, 0 ) )
	{
		value_to_num = str_to_num( value );
		
		if( value_to_num == HackResponseValue ) 
		{
			
			HackResponseNum[ id ]++;
			
		}
	}
	
	for( new i = 0; i < HackTasks ; i++ )
	{
		if( equal( HackCmds[ i ], command, 0 ) )
		{
			value_to_num = str_to_num( value );
			
			if( value_to_num == HackCmdsValue ) 
			{
				
				HackFound[ id ][ i ] = false;
				break;
				
			}
		}
	}
	
	return 0;
} 

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public LogHacker( const logtime[ ], const name[ ], const authid[ ], const ip[ ], const command[ ], const reason[ ] )
{
	new configsdir[ 64 ], file[ 128 ], log[ 256 ];
	
	get_configsdir( configsdir, sizeof ( configsdir ) -1 );
	formatex( file, sizeof ( file ) -1,"%s/Hackers.txt", configsdir );
	
	if(!file_exists( file ) ) {
		write_file( file ,"Jucatorii prinsi cu kzHack sau xHack !", -1 );
		write_file( file ,"",-1);
		write_file( file ,"",-1);
	}	
	
	formatex( log, sizeof (log ) -1,"|%s| - %s [%s] (%s) - a primit ban - comanda detectata <%s> - motiv | %s |", logtime, name, authid, ip, command, reason );
	write_file( file, log, -1 );

}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public SaveHackerData( const ip[ ], const authid[ ], const name[ ], const logtime[ ], const command[ ], const reason[ ] )
{
	if( HackBans >= HackBansNum )
	{
		Log( "[EROARE] - BanList FULL  ( %d ) !", HackBans );
		return 1;	
	}
	
	new configsdir[ 64 ], file[ 128 ], log[ 256 ];
	
	get_configsdir( configsdir, sizeof ( configsdir ) -1 );
	formatex( file, sizeof ( file ) -1,"%s/HackersData.txt", configsdir );
	
	if( !file_exists( file ) )
	{
		write_file( file ,";Ip-uri / Steamid-uri blocate datorita kzHack / xHack !", -1 );
		write_file( file ,";",-1);
		write_file( file ,";",-1);
	}	
	
	formatex( log, sizeof (log ) -1,"^"%s^" ^"%s^" ^"%s^" ^"%s^" ^"%s^" ^"%s^"", ip, authid, name, logtime, command, reason );
	write_file( file, log, -1 );
	
	LoadHackBans( );
	
	return 0;
	
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public LoadHackCommands( )
{
	new configsdir[ 64 ], file[ 128 ];
	
	get_configsdir( configsdir, sizeof ( configsdir ) -1 );
	formatex( file, sizeof ( file ) -1,"%s/HackCommands.ini", configsdir );
	
	if( !file_exists( file ) ) 
	{
		
		Log( "[EROARE] - Nu am gasit %s ", file);
		Log( "[EROARE] - Acest fisier este vital pentru detectarea KzHack / xHack !" );
		Log( "[EROARE] - Creez un nou fisier cu comenzile default." );
		
		write_file( file ,";Aici treceti una sub alta comenzi de KzHack / xHack !", -1 );
		write_file( file ,";",-1);
		write_file( file ,";",-1);
		
		WriteDefaultCommands( );
		
		
	}	
	
	new f = fopen( file, "rt" );
	
	if( !f ) return 0;
	
	new data[ 512 ], command[ 32 ];
	
	while( !feof( f ) && HackTasks < HackCmdsNum ) 
	{
		fgets( f, data, sizeof ( data ) -1 );
		
		if( !data[ 0 ] || data[ 0 ] == ';' || ( data[ 0 ] == '/' && data[ 1 ] == '/' ) ) 
			continue;
			
		parse( data, command, sizeof ( command ) - 1 );
			
		copy( HackCmds[ HackTasks ], sizeof ( HackCmds[ ] ) -1, command );
			
		HackTasks++;
	}
		
	fclose( f );
		
	if(HackTasks > 0 )
	{
			
		Log( "[INFO] - Am incarcat cu succes %d comenzi de KzHack / xHack ! din %s", HackTasks, file );
			
	}
	else if( HackTasks <= 0 )
	{
			
		Log( "[EROARE] - Nu am putut incarca nicio comanda din %s !", file);
		Log( "[EROARE] - Fisierul ce contine comenzi de KzHack / xHack este gol !" );
		Log( "[EROARE] - Acesta va fi sters si voi crea unul cu comenzile default !" );
		CreateNewCommandsFile( );
			
	}
		
	return 0;
	
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public LoadHackBans( )
{
	new configsdir[ 64 ], file[ 128 ];
	
	get_configsdir( configsdir, sizeof ( configsdir ) -1 );
	formatex( file, sizeof ( file ) -1,"%s/HackersData.txt", configsdir );
	
	if( !file_exists( file ) ) 
	{
		Log( "[EROARE] - Nu am gasit %s ", file );
		Log( "[EROARE] - Creez un nou fisier." );
		
		write_file( file ,";Ip-uri / Steamid-uri blocate datorita KzHack / xHack !", -1 );
		write_file( file ,";", -1 );
		write_file( file ,";", -1 );
	}
	
	new f = fopen( file, "rt" );
	
	if( !f ) return 0;
	
	new data[ 512 ], buffer[ 6 ][ 64 ] ;
	
	while( !feof( f ) && HackBans < HackBansNum ) 
	{
		fgets( f, data, sizeof ( data ) -1 );
		
		if( !data[ 0 ] || data[ 0 ] == ';' || ( data[ 0 ] == '/' && data[ 1 ] == '/' ) ) 
			continue;
		
		parse(data,\
		buffer[ 0 ], sizeof ( buffer[ ] ) - 1,\
		buffer[ 1 ], sizeof ( buffer[ ] ) - 1,\
		buffer[ 2 ], sizeof ( buffer[ ] ) - 1,\
		buffer[ 3 ], sizeof ( buffer[ ] ) - 1,\
		buffer[ 4 ], sizeof ( buffer[ ] ) - 1,\
		buffer[ 5 ], sizeof ( buffer[ ] ) - 1
		);
		
		copy( HackBannedIp[ HackBans ], sizeof ( HackBannedIp[ ] ) -1, buffer[ 0 ] );
		copy( HackBannedSteamId[ HackBans ], sizeof ( HackBannedSteamId[ ] ) -1, buffer[ 1 ] );
		copy( HackBannedName[ HackBans ], sizeof ( HackBannedName[ ] ) -1, buffer[ 2 ] );
		copy( HackBannedTime[ HackBans ], sizeof ( HackBannedTime[ ] ) -1, buffer[ 3 ] );
		copy( HackBannedCommand[ HackBans ], sizeof ( HackBannedCommand[ ] ) -1, buffer[ 4 ] );
		copy( HackBannedReason[ HackBans ], sizeof ( HackBannedReason[ ] ) -1, buffer[ 5 ] );
		
		HackBans++;
	}
	
	fclose( f );
	
	Log( "[INFO] - Am incarcat cu succes %d ban-uri din %s", HackBans, file );
	
	return 0;
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public Log( const message_fmt[ ], any:...)
{
	new message[ 256 ];
	vformat( message, sizeof ( message ) -1, message_fmt , 2 );
	
	new dir[64], file[ 128 ], log[ 256 ], logtime[ 32 ];		
	get_time("%d.%m.%Y - %H:%M:%S", logtime ,sizeof ( logtime ) -1 );
	
	if( !dir[ 0 ] )
	{
		get_basedir( dir, sizeof ( dir ) -1 );
		formatex( file, sizeof ( file ) -1,"%s/logs/Universal_Anti_KzHack_xHack.log", dir );
	}
	
	formatex( log, sizeof (log ) -1,"|%s| %s ", logtime, message);
	write_file( file, log, -1 );
	
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public WriteDefaultCommands( )
{
	
	new configsdir[ 64 ], file[ 128 ],text[ 32 ];
	
	get_configsdir( configsdir, sizeof ( configsdir ) -1 );
	formatex( file, sizeof ( file ) -1,"%s/HackCommands.ini", configsdir );
	
	
	for( new i = 0; i < 113 ; i++ )
	{
		
		formatex( text, sizeof ( text ) -1,"^"%s^"", DefaultHackCmds[ i ] );
		write_file( file , text, -1 );
		
	}
	
	Log( "[INFO] - Noul fisier ce contine comenzile default a fost creat cu succes.(%s)", file );
	
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public CreateNewCommandsFile( )
{
	new configsdir[ 64 ], file[ 128 ];
	
	get_configsdir( configsdir, sizeof ( configsdir ) -1 );
	formatex( file, sizeof ( file ) -1,"%s/HackCommands.ini", configsdir );
	
	if( file_exists( file ) )
	{
		delete_file( file );
	}
	
	write_file( file ,";Aici treceti una sub alta comenzi de KzHack / xHack !",-1);
	write_file( file ,";", -1 );
	write_file( file ,";", -1 );
	
	WriteDefaultCommands( );
	LoadHackCommands( );
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public RemoveHackBan( i )
{
	for( new x = i ; x < HackBans ; x++ )
	{
		if( x + 1 == HackBans )
		{
			
			copy( HackBannedIp[ x ], sizeof ( HackBannedIp[ ] ) -1, "" );
			copy( HackBannedSteamId[ x ], sizeof ( HackBannedSteamId[ ] ) -1, "" );
			copy( HackBannedName[ x ], sizeof ( HackBannedName[ ] ) -1, "" );
			copy( HackBannedTime[ x ], sizeof ( HackBannedTime[ ] ) -1, "" );
			copy( HackBannedCommand[ x ], sizeof ( HackBannedCommand[ ] ) -1, "" );
			copy( HackBannedReason[ x ], sizeof ( HackBannedReason[ ] ) -1, "" );
			
		}
		else
		{
			copy( HackBannedIp[ x ], sizeof ( HackBannedIp[ ] ) -1, HackBannedIp[ x + 1 ]);
			copy( HackBannedSteamId[ x ], sizeof ( HackBannedSteamId[ ] ) -1, HackBannedSteamId[ x + 1 ] );
			copy( HackBannedName[ x ], sizeof ( HackBannedName[ ] ) -1, HackBannedName[ x + 1 ] );
			copy( HackBannedTime[ x ], sizeof ( HackBannedTime[ ] ) -1, HackBannedTime[ x + 1 ] );
			copy( HackBannedCommand[ x ], sizeof ( HackBannedCommand[ ] ) -1, HackBannedCommand[ x + 1 ] );
			copy( HackBannedReason[ x ], sizeof ( HackBannedReason[ ] ) -1, HackBannedReason[ x + 1 ] );
		}
	}
	
	HackBans--;
	
	ReWriteBans( );
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public ReWriteBans( )
{
	new configsdir[ 64 ], file[ 128 ];
	
	get_configsdir( configsdir, sizeof ( configsdir ) -1 );
	formatex( file, sizeof ( file ) -1,"%s/HackersData.txt", configsdir );
	
	new f = fopen( file, "wt" );
	
	fprintf( f, ";Ip-uri / Steamid-uri blocate datorita KzHack / xHack !^n" );
	fprintf( f, ";^n" );
	fprintf( f, ";^n" );
	
	static HackBanIp[ 32 ], HackBanSteamId[ 35 ], HackBanName[ 32 ], HackBanTime[ 32 ], HackBanCommand[ 32 ], HackBanReason[ 32 ];
	
	for( new i = 0 ; i < HackBans ; i++ )
	{
		
		copy( HackBanIp , sizeof ( HackBanIp ) - 1, HackBannedIp[ i ] );
		copy( HackBanSteamId , sizeof ( HackBanSteamId ) - 1, HackBannedSteamId[ i ] );
		copy( HackBanName , sizeof ( HackBanName ) - 1, HackBannedName[ i ] );
		copy( HackBanTime , sizeof ( HackBanTime ) - 1, HackBannedTime[ i ] );
		copy( HackBanCommand , sizeof ( HackBanCommand ) - 1, HackBannedCommand[ i ] );
		copy( HackBanReason , sizeof ( HackBanReason ) - 1, HackBannedReason[ i ] );
		
		fprintf( f, "^"%s^" ^"%s^" ^"%s^" ^"%s^" ^"%s^" ^"%s^"^n",\
		HackBanIp,\
		HackBanSteamId,\
		HackBanName,\
		HackBanTime,\
		HackBanCommand,\
		HackBanReason
		);
	}
	
	fclose(f);
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public PrintConsoleInfo( id, const authid [ ], const ip[ ], const name[ ], const logtime[ ], const command[ ], const reason[ ] )
{
	new plugin_info[ 128 ];
	formatex( plugin_info, sizeof ( plugin_info ) -1,"echo ^"******%s v%s by %s ******^"", PLUGIN, VERSION, "Askhanar");
	
	new site[ 64 ];
	get_pcvar_string( cvar_site, site, sizeof ( site ) -1 );
	
	client_cmd( id, "clear" );
	client_cmd( id, "echo ^"*************************************************^"");
	client_cmd( id, "echo ^"********Informatii despre Banarea accesului pe server********^"");
	client_cmd( id, "echo ^"*    ^"");
	client_cmd( id, "echo ^"*    Nume: %s^"", name );
	client_cmd( id, "echo ^"*    Steamid: %s^"", authid );
	client_cmd( id, "echo ^"*    Ip: %s^"", ip);
	client_cmd( id, "echo ^"*    Motiv: %s ^"", reason );
	client_cmd( id, "echo ^"*    Durata: Permanenta^"");
	client_cmd( id, "echo ^"*    Comanda detectata: %s^"", command );
	client_cmd( id, "echo ^"*    Data/Ora: %s^"", logtime );
	client_cmd( id, "echo ^"*    Daca te simti neindreptatit contacteaza-ne pe:^"");
	client_cmd( id, "echo ^"*    %s^"",site);
	client_cmd( id, "echo ^"*    ^"");
	client_cmd( id, "echo ^"************************************************^"");
	client_cmd( id, "%s", plugin_info );
	client_cmd( id, "echo ^"************************************************^"");
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public PrintConsoleTimeoutInfo( id )
{
	new plugin_info[ 128 ];
	formatex( plugin_info, sizeof ( plugin_info ) -1,"echo ^"********%s v%s by %s ********^"", PLUGIN, VERSION, "Askhanar");
	
	client_cmd( id, "clear" );
	client_cmd( id, "echo ^"****************************************************^"");
	client_cmd( id, "echo ^"************** Motivul pentru care ai primit kick **************^"");
	client_cmd( id, "echo ^"****************************************************^"");
	client_cmd( id, "echo ^"*    ^"");
	client_cmd( id, "echo ^"*    Server-ul a incercat sa te scaneze de KzHack / xHack si,^"");
	client_cmd( id, "echo ^"*    Nu a reusit sa determine daca ai sau nu KzHack / xHack de aceea,^"");
	client_cmd( id, "echo ^"*    A decis sa iti dea kick pentru a evita ban-urile pe nedrept.^"");
	client_cmd( id, "echo ^"*    Acest lucru s-a intamplat din cauza ca raspunsul tau in legatura cu,^"");
	client_cmd( id, "echo ^"*    Comenzile trimise de catre server este 'putin' intarziat.^"");
	client_cmd( id, "echo ^"*    Te poti reconecta pe server fara nicio problama.^"");
	client_cmd( id, "echo ^"*    ^"");
	client_cmd( id, "echo ^"****************************************************^"");
	client_cmd( id, "%s", plugin_info );
	client_cmd( id, "echo ^"****************************************************^"");
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public TaskDisconnectPlayer( id )
{
	if( id < KICKTASK )
	{
		id -= HACKTASK;
		server_cmd( "kick #%i ^"Scuze, verifica-ti consola !^"", get_user_userid( id ) );
		return 1;
	}
	
	id -= KICKTASK;
	server_cmd( "kick #%i ^"Accesul pe server iti este blocat, motiv KzHack sau xHack, verifica-ti consola !^"", get_user_userid( id ) );
	
	return 0;
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public ClearChat( id )
{
	if( id == All )
	{
		client_print( 0, print_chat, "");
		client_print( 0, print_chat, "");
		client_print( 0, print_chat, "");
		client_print( 0, print_chat, "");
		client_print( 0, print_chat, "");
		client_print( 0, print_chat, "");
		
		return 1;
	}
	
	client_print( id, print_chat, "");
	client_print( id, print_chat, "");
	client_print( id, print_chat, "");
	client_print( id, print_chat, "");
	client_print( id, print_chat, "");
	client_print( id, print_chat, "");
	
	return 0;

}
/*================================================================================================*/
/*======================================= - ¦ Askhanar ¦ - =======================================*/
/*=================================== - | End of Plugin xD | - ===================================*/
/*================================================================================================*/
