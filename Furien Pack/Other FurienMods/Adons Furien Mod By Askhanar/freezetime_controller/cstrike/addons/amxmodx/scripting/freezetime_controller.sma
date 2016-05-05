#include <amxmodx>

#pragma semicolon 1

#define PLUGIN "FreezeTime Controller"
#define VERSION "1.0"

new const g_szFileName[    ]  =  "maps_freezetime.ini";

new g_iMpFreezeTimeValue;
new pc_MpFreezetime;

new g_szFile[  128  ];

public plugin_precache(  )
{
	new szConfigsDir[ 64 ];
	get_localinfo( "amxx_configsdir", szConfigsDir, sizeof ( szConfigsDir ) -1  ); 
	
	formatex(  g_szFile, sizeof ( g_szFile ) -1, "%s/%s", szConfigsDir, g_szFileName  );
	
	if(  !file_exists(  g_szFile  )  )
	{
		write_file(  g_szFile,  "// De aici este setat cvar-ul 'mp_freezetime' pentru fiecare harta in parte.",  -1  );
		write_file(  g_szFile,  "// Treceti hartile in felul urmator:",  -1  );
		write_file(  g_szFile,  "// < nume_harta > < valoare mp_freezetime >",  -1  );
		write_file(  g_szFile,  "// Ex: de_dust2 5",  -1  );
		write_file(  g_szFile,  "// Pe harta de_dust2 va fi setat mp_freezetime 5",  -1  );
		write_file(  g_szFile,  "// Daca harta nu este gasita in acest fisier, va ramane valorea predefinita in 'server.cfg' sau 'amxx.cfg'",  -1  );
		write_file(  g_szFile,  "// Liniile care au in fata ';' sau '//' NU sunt citite!",  -1  );
	}
	
}

public plugin_init( )
{
	register_plugin( PLUGIN, VERSION, "Askhanar" );
	
	
	pc_MpFreezetime  =  get_cvar_pointer(  "mp_freezetime"  );
	
	set_task(  1.0,  "SetMapFreezeTime",  112233  );
	
}

public SetMapFreezeTime(    )
{
	new szMapName[ 32 ];
	get_mapname(  szMapName, sizeof ( szMapName ) -1  );
	
	if( MapHasCustomFreezeTime(  szMapName  )  )
	{
		server_print(  "[FreezeTime Controller] Cvar-ul 'mp_freezetime' a fost setat pe '%i'",  g_iMpFreezeTimeValue  );
		server_print(  "[FreezeTime Controller] Valoarea a fost incarcata din %s",  g_szFile );
		set_pcvar_num(  pc_MpFreezetime, g_iMpFreezeTimeValue  );
	}
	
	else
	{
		server_print(  "[FreezeTime Controller] Aceasta harta ( %s ) nu a fost gasita in %s",  szMapName,  g_szFile  );
		server_print(  "[FreezeTime Controller] Cvar-ului 'mp_freezetine' i-a ramas setata valorea predefinita in 'server.cfg' sau 'amxx.cfg'"  );
	}
		
}
	
stock bool:MapHasCustomFreezeTime(  const  szMapName[    ]  )
{
	
	new iFile  =  fopen( g_szFile, "rt"  );
	new bool:bMapHasCustomFreezeTime  =  false;
	
	if( iFile )
	{
		
		new szData[ 128 ];
		new szFileMapName[ 32 ], szFileMPFreezeTimeValue[ 5 ];
		
		while(  !feof( iFile )  ) 
		{
			
			fgets(  iFile, szData, sizeof ( szData ) -1  );
			
			if( !szData[ 0 ] || szData[ 0 ] == ';' || ( szData[ 0 ] == '/' && szData[ 1 ] == '/' ) ) 
				continue;
				
			parse( szData, szFileMapName, sizeof ( szFileMapName ) -1,\
				szFileMPFreezeTimeValue, sizeof ( szFileMPFreezeTimeValue ) -1  );
				
			if(  equal(  szMapName, szFileMapName  )  )
			{
				
				bMapHasCustomFreezeTime  =  true;
				g_iMpFreezeTimeValue  =  str_to_num(  szFileMPFreezeTimeValue  );
				break;
			}
		}
		
	}
	
	fclose(  iFile  );
	
	return bMapHasCustomFreezeTime;
	
}