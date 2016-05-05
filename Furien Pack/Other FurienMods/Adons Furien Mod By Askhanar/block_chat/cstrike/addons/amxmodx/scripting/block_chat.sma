	

    #include <amxmodx>
     
    #define PLUGIN "Block Chat"
    #define VERSION "1.0"
     
     
    // --| CC_ColorChat.
    enum Color
    {
       NORMAL = 1,       // Culoarea care o are jucatorul setata in cvar-ul scr_concolor.
       GREEN,          // Culoare Verde.
       TEAM_COLOR,       // Culoare Rosu, Albastru, Gri.
       GREY,          // Culoarea Gri.
       RED,          // Culoarea Rosu.
       BLUE,          // Culoarea Albastru.
    };
     
    new TeamName[  ][  ] =
    {
       "",
       "TERRORIST",
       "CT",
       "SPECTATOR"
    };
    // --| CC_ColorChat.
     
    // --| Tag-ul mesajului din chat.
    new const g_szTag[ ] = "[Anti Spam]";
    // --| ---------------------------------
     
    // --| Cate secunde este blocat chat`ul.
    new const Float:g_fNoFloodSeconds = 4.0;
    // --| ---------------------------------
     
    // --| Cate secunde este blocat chat`ul ( x secunde de la conectare ).
    new const Float:g_fBlockedSeconds = 25.0;
    // --| ---------------------------------
     
    // --| De aici e treaba mea .
    new Float:g_fGameTime[ 33 ];
    new Float:g_fGameTimeSecond[ 33 ];
     
    public plugin_init( )
    {
       register_plugin( PLUGIN, VERSION, "Askhanar" );
       
       register_clcmd( "say","ClCmdSayOrSayTeam" );
       register_clcmd( "say_team","ClCmdSayOrSayTeam" );
       
       // Add your code here...
    }
     
    public client_connect( id )
    {
       g_fGameTime[ id ] = get_gametime( ) + g_fBlockedSeconds;
       g_fGameTimeSecond[ id ] = 0.0;
    }
     
    public client_disconnect( id )
    {
       g_fGameTime[ id ] = 0.0;
       g_fGameTimeSecond[ id ] = 0.0;
    }
     
    public ClCmdSayOrSayTeam( id )
    {
       static Float:fGameTime;
       fGameTime = get_gametime( );
       
       if( g_fGameTime[ id ] > fGameTime && ~get_user_flags(id) & ADMIN_KICK )
       {
         
          ColorChat( id, RED, "^x04%s^x01 Doar ce te-ai conectat pe server, asteapta^x03 %.1f^x01 secunde !", g_szTag, g_fGameTime[ id ] - fGameTime );
          return PLUGIN_HANDLED;
       }
       else if( g_fGameTimeSecond[ id ] > fGameTime && ~get_user_flags(id) & ADMIN_KICK )
       {
          ColorChat( id, RED, "^x04%s^x01 Asteapta^x03 %.1f^x01 secunde pentru a putea scrie din nou !", g_szTag, g_fGameTimeSecond[ id ] - fGameTime );
          return PLUGIN_HANDLED;
       }
       
       g_fGameTimeSecond[ id ] = fGameTime + g_fNoFloodSeconds;
       
       return PLUGIN_CONTINUE;
       
    }
     
    // --| CC_ColorChat.
    ColorChat(  id, Color:iType, const msg[  ], { Float, Sql, Result, _}:...  )
    {
       
       // Daca nu se afla nici un jucator pe server oprim TOT. Altfel dam de erori..
       if( !get_playersnum( ) ) return;
       
       new szMessage[ 256 ];
     
       switch( iType )
       {
           // Culoarea care o are jucatorul setata in cvar-ul scr_concolor.
          case NORMAL:   szMessage[ 0 ] = 0x01;
         
          // Culoare Verde.
          case GREEN:   szMessage[ 0 ] = 0x04;
         
          // Alb, Rosu, Albastru.
          default:    szMessage[ 0 ] = 0x03;
       }
     
       vformat(  szMessage[ 1 ], 251, msg, 4  );
     
       // Ne asiguram ca mesajul nu este mai lung de 192 de caractere.Altfel pica server-ul.
       szMessage[ 192 ] = '^0';
       
     
       new iTeam, iColorChange, iPlayerIndex, MSG_Type;
       
       if( id )
       {
          MSG_Type  =  MSG_ONE_UNRELIABLE;
          iPlayerIndex  =  id;
       }
       else
       {
          iPlayerIndex  =  CC_FindPlayer(  );
          MSG_Type = MSG_ALL;
       }
       
       iTeam  =  get_user_team( iPlayerIndex );
       iColorChange  =  CC_ColorSelection(  iPlayerIndex,  MSG_Type, iType);
     
       CC_ShowColorMessage(  iPlayerIndex, MSG_Type, szMessage  );
         
       if(  iColorChange  )   CC_Team_Info(  iPlayerIndex, MSG_Type,  TeamName[ iTeam ]  );
     
    }
     
    CC_ShowColorMessage(  id, const iType, const szMessage[  ]  )
    {
       
       static bool:bSayTextUsed;
       static iMsgSayText;
       
       if(  !bSayTextUsed  )
       {
          iMsgSayText  =  get_user_msgid( "SayText" );
          bSayTextUsed  =  true;
       }
       
       message_begin( iType, iMsgSayText, _, id  );
       write_byte(  id  );      
       write_string(  szMessage  );
       message_end(  );
    }
     
    CC_Team_Info( id, const iType, const szTeam[  ] )
    {
       static bool:bTeamInfoUsed;
       static iMsgTeamInfo;
       if(  !bTeamInfoUsed  )
       {
          iMsgTeamInfo  =  get_user_msgid( "TeamInfo" );
          bTeamInfoUsed  =  true;
       }
       
       message_begin( iType, iMsgTeamInfo, _, id  );
       write_byte(  id  );
       write_string(  szTeam  );
       message_end(  );
     
       return 1;
    }
     
    CC_ColorSelection(  id, const iType, Color:iColorType)
    {
       switch(  iColorType  )
       {
         
          case RED:   return CC_Team_Info(  id, iType, TeamName[ 1 ]  );
          case BLUE:   return CC_Team_Info(  id, iType, TeamName[ 2 ]  );
          case GREY:   return CC_Team_Info(  id, iType, TeamName[ 0 ]  );
     
       }
     
       return 0;
    }
     
    CC_FindPlayer(  )
    {
       new iMaxPlayers  =  get_maxplayers(  );
       
       for( new i = 1; i <= iMaxPlayers; i++ )
          if(  is_user_connected( i )  )
             return i;
       
       return -1;
    }

