#include <amxmodx>
#include <amxmisc>
#include <ColorChat>

#define PLUGIN	"TimeLimit Vote"
#define AUTHOR	"sPuf ?"
#define VERSION	"1.0.1"

#pragma semicolon 1

new Options[8];
new g_timelimit;
new bool:VoteEnded = false;
new seconds;
new g_hud;

new const CTIME[8] = {
	0,
	20,
	25,
	30,
	35,
	40,
	50,
	60
};

public plugin_cfg() {
	g_timelimit = get_cvar_pointer("mp_timelimit");
}
public plugin_init() 
{
	register_plugin(PLUGIN, VERSION, AUTHOR);
	set_task(168.0, "begin_countdown");
	register_clcmd("say /vote","vote");
	
	g_hud = CreateHudSyncObj();
}
public vote(id) 
{
	if(get_user_flags(id) & ADMIN_SLAY && !VoteEnded) 
	{
		VoteEnded = false;
		begin_countdown();
	}
	return 1;
}
public begin_countdown()
{
	if(!VoteEnded)
	{
		seconds = 10;
		set_task(2.0,"begin_now");
	}
}
public begin_now()
{
	if(seconds <= 0 )
	{
		start_vote();
		client_cmd(0,"spk ^"Gman/Gman_Choose%d^"",random_num(1,2));
		return 1;
	}
	if(seconds == 5) client_cmd(0,"spk ^"fvox/five  _comma four  _comma three  _comma two  _comma one^"");
	
	set_hudmessage(49, 159, 249, -1.0, 0.29, 0, 0.0, 2.0, 0.0, 1.0, 4);
	ShowSyncHudMsg(0, g_hud, "Un vot pentru a seta durata hartii^nVa incepe in %d secund%s !",seconds,seconds == 1? "a" : "e");
	
	seconds -= 1;
	set_task(1.0,"begin_now");
	
	return 0;
}
	
public start_vote()
{
	if(VoteEnded) return 1;

	new menu = menu_create("\r Cat timp vrei sa joci aceasta harta ?", "menu_handler");
	new Minutes[8][64],Key[8][5];
	for (new i = 1; i< 8;i++)
	{
		formatex(Minutes[i], 63, "%d minute", CTIME[i]);
		formatex(Key[i], 4, "%d",i);
		menu_additem(menu,Minutes[i],Key[i]);
	}
	
	/*
	menu_additem(menu, "\w20 minute", "1", 0);
	menu_additem(menu, "\w25 minute", "2", 0);
	menu_additem(menu, "\w30 minute", "3", 0);
	menu_additem(menu, "\w35 minute", "4", 0);
	menu_additem(menu, "\w40 minute", "5", 0);
	menu_additem(menu, "\w50 minute", "6", 0);
	menu_additem(menu, "\w60 minute", "7", 0);*/
	menu_addblank(menu, 0);
	menu_setprop(menu, MPROP_EXIT, MEXIT_ALL);
	
	new players[32], inum;
	get_players(players, inum, "ch");
	for(new i = 0; i < inum; i++)
	{
		menu_display(players[i], menu, 0);
	}
	
	set_task(15.0, "finish_vote");
	
	Options[1] = Options[2] = Options[3] = Options[4] = Options[5] = Options[6] = Options[7] = 0;
	
	return 1;
}

public menu_handler(id, menu, item)
{
	if (item == MENU_EXIT || VoteEnded)
	{
		return PLUGIN_HANDLED;
	}
	
	new data[6], name[32];
	new access, callback;
	
	menu_item_getinfo(menu, item, access, data, 5, _, _, callback);
	
	new key = str_to_num(data);
	get_user_name(id, name, 31);
	
	new players[32], inum, i;
	get_players(players, inum, "ch");
	for(i = 0; i < inum; i++) {
		if(is_user_connected(players[i])) {
			ColorChat(players[i], RED, "^x04[D/C]^x03 %s^x01 a votat pentru^x03 %d^x01 minute !", name,CTIME[key]);
		}
	}
	++Options[key];
	return PLUGIN_HANDLED;
}

public finish_vote()
{
	new bool:Won = false,wtime;
	if(Options[1] > Options[2] && Options[1] > Options[3] && Options[1] > Options[4] && Options[1] > Options[5] && Options[1] > Options[6] && Options[1] > Options[7] )
	{
		new players[32], inum, i;
		get_players(players, inum, "ch");
		for(i = 0; i < inum; i++) {
			if(is_user_connected(players[i])) {
				ColorChat(players[i], RED, "^x04[D/C]^x01 Optiunea de^x03 20^x01 minute a castigat cu^x03 %d^x01 vot%s !",Options[1],Options[1] == 1 ? "" : "uri");
			}
		}
		wtime = 20;
		Won = true;
	}
	
	else if(!Won && Options[2] > Options[1] && Options[2] > Options[3] && Options[2] > Options[4] && Options[2] > Options[5] && Options[2] > Options[6] && Options[2] > Options[7] )
	{
		new players[32], inum, i;
		get_players(players, inum, "ch");
		for(i = 0; i < inum; i++) {
			if(is_user_connected(players[i])) {
				ColorChat(players[i], RED, "^x04[D/C]^x01 Optiunea de^x03 25^x01 minute a castigat cu^x03 %d^x01 vot%s !",Options[2],Options[2] == 1 ? "" : "uri");
			}
		}
		wtime = 25;
		Won = true;
	}
	else if(!Won && Options[3] > Options[1] && Options[3] > Options[2] && Options[3] > Options[4] && Options[3] > Options[5] && Options[3] > Options[6] && Options[3] > Options[7] )
	{
		new players[32], inum, i;
		get_players(players, inum, "ch");
		for(i = 0; i < inum; i++) {
			if(is_user_connected(players[i])) {
				ColorChat(players[i], RED, "^x04[D/C]^x01 Optiunea de^x03 30^x01 minute a castigat cu^x03 %d^x01 vot%s !",Options[3],Options[3] == 1 ? "" : "uri");
			}
		}
		wtime = 30;
		Won = true;
	}
	
	else if(!Won && Options[4] > Options[1] && Options[4] > Options[2] && Options[4] > Options[3] && Options[4] > Options[5] && Options[4] > Options[6] && Options[4] > Options[7] )
	{
		new players[32], inum, i;
		get_players(players, inum, "ch");
		for(i = 0; i < inum; i++) {
			if(is_user_connected(players[i])) {
				ColorChat(players[i], RED, "^x04[D/C]^x01 Optiunea de^x03 35^x01 minute a castigat cu^x03 %d^x01 vot%s !",Options[4],Options[4] == 1 ? "" : "uri");
			}
		}
		wtime = 35;
		Won = true;
	}
	
	else if(!Won && Options[5] > Options[1] && Options[5] > Options[2] && Options[5] > Options[3] && Options[5] > Options[4] && Options[5] > Options[6] && Options[5] > Options[7] )
	{
		new players[32], inum, i;
		get_players(players, inum, "ch");
		for(i = 0; i < inum; i++) {
			if(is_user_connected(players[i])) {
				ColorChat(players[i], RED, "^x04[D/C]^x01 Optiunea de^x03 40^x01 minute a castigat cu^x03 %d^x01 vot%s !",Options[5],Options[5] == 1 ? "" : "uri");
			}
		}
		wtime = 40;
		Won = true;
	}
	else if(!Won && Options[6] > Options[1] && Options[6] > Options[2] && Options[6] > Options[3] && Options[6] > Options[4] && Options[6] > Options[5] && Options[6] > Options[7] )
	{
		new players[32], inum, i;
		get_players(players, inum, "ch");
		for(i = 0; i < inum; i++) {
			if(is_user_connected(players[i])) {
				ColorChat(players[i], RED, "^x04[D/C]^x01 Optiunea de^x03 50^x01 minute a castigat cu^x03 %d^x01 vot%s !",Options[6],Options[6] == 1 ? "" : "uri");
			}
		}
		wtime = 50;
		Won = true;
	}
	else if(!Won && Options[7] > Options[1] && Options[7] > Options[2] && Options[7] > Options[3] && Options[7] > Options[4] && Options[7] > Options[5] && Options[7] > Options[6] )
	{
		new players[32], inum, i;
		get_players(players, inum, "ch");
		for(i = 0; i < inum; i++) {
			if(is_user_connected(players[i])) {
				ColorChat(players[i], RED, "^x04[D/C]^x01 Optiunea de^x03 60^x01 minute a castigat cu^x03 %d^x01 vot%s !",Options[7],Options[7] == 1 ? "" : "uri");
			}
		}
		wtime = 60;
		Won = true;
	}
	if(Won)
	{
		client_cmd(0,"spk ^"barney/letsgo^"");
		set_pcvar_num(g_timelimit, wtime );
		VoteEnded = true;
		return 1;
	}
	else if( Options[1] == 0 && Options[2] == 0 && Options[3] == 0
		&& Options[4] == 0 && Options[5] == 0 && Options[6] == 0 && Options[7] == 0)
	{
		new players[32], inum, i;
		get_players(players, inum, "ch");
		for(i = 0; i < inum; i++) {
			if(is_user_connected(players[i])) {
				ColorChat(players[i], RED, "^x04[D/C]^x03 Votul a esuat !");
				client_cmd(players[i],"spk ^"barney/waitin^"");
			}
		}
		VoteEnded = true;
		return 1;
	}
	else 
	{
		new total_time,vote_counts;

		for(new i = 1;i < 7; i++)
		{
			while( Options[i] >= 1 )
			{
				Options[i] -= 1;
				total_time += CTIME[i];
				vote_counts++;
			}
		}
		
		new final_time = total_time / vote_counts;
		set_pcvar_num(g_timelimit, final_time );
		new players[32], inum, i;
		get_players(players, inum, "ch");
		for(i = 0; i < inum; i++) {
			if(is_user_connected(players[i])) {
				client_cmd(players[i],"spk ^"barney/letsgo^"");
				ColorChat(players[i], RED, "^x04[D/C]^x01 Timpul va fi setat din media facuta,^x03 %d^x01 minute !", final_time);
			}
		}
		VoteEnded = true;
		return 1;
		
	}
	return 0;
}