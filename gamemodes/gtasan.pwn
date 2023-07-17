

#define SERVER_GM_TEXT "GRN-VN"
#include <a_samp>
#pragma tabsize 0
#include <a_mysql>	
#include <progress>
#include <streamer>
#include <yom_buttons>		
#include <ZCMD>
#include <sscanf2>
#include <foreach>
#include <YSI\y_timers>
#include <YSI\y_utils>
#include <compat>
//#include <PawnPlus>

#if defined SOCKET_ENABLED
#include <socket>
#endif
#include "./includes/Gta.pwn"
#include "./includes/NCS.pwn"
//#include "./includes/haican.pwn"
#include "./includes/TX.pwn"
#include "./includes/cuopbank.pwn"
#include "./includes/daumo.pwn"
#include "./includes/nongdan.pwn"
#include "./includes/chatgo.pwn"
#include "./includes/khaithacda.pwn"
#include "./includes/cuacay.pwn"
//module
#include "./module/chungminhnhandan.pwn"
#include "./module/bekhoacong.pwn"
#include "./module/khoangsan.pwn"
#include "./module/phucvujob.pwn"
#include "./module/vongquay.pwn"
//anti
#include "./anti/antigod.pwn"
#include "./anti/antislap.pwn"
#include "./anti/antishot.pwn"
#include "./anti/antifly.pwn"


main() {}

public OnGameModeInit()
{
	print("Dang chuan bi tai gamemode, xin vui long cho doi...");
	print("Ghi nguon vao dit me may thang Dau buoi");
	g_mysql_Init();
	return 1;
}

public OnGameModeExit()
{
    g_mysql_Exit();
	return 1;
}
