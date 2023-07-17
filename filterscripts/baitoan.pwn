/*
                     __          ____
/'\_/`\  __        /\ \        /\  _`\
/\      \/\_\    ___\ \ \___    \ \ \/\ \  __  __    ___    ___
\ \ \__\ \/\ \ /' _ `\ \  _ `\   \ \ \ \ \/\ \/\ \  /'___\ /'___\
\ \ \_/\ \ \ \/\ \/\ \ \ \ \ \   \ \ \_\ \ \ \_\ \/\ \__//\ \__/
  \ \_\\ \_\ \_\ \_\ \_\ \_\ \_\   \ \____/\ \____/\ \____\ \____\
   \/_/ \/_/\/_/\/_/\/_/\/_/\/_/    \/___/  \/___/  \/____/\/____/

Subject :
Date : 12:00 SA | 16/11/2014
Noi Dung : Code ve cau hoi ve bai toan !


*/
#include <a_samp>

// Colours
#define COLOR_GREEN         0x00CC00FF
#define COLOR_RED           0xFF0000FF
#define COLOR_YELLOW        0xFFFF00FF
#define COLOR_ORANGE        0xEE9911FF

#define E_TIME              600
#define E_MAX_NUMBER        50
#define E_MIN_NUMBER        30
#define E_CASH              10000

#if E_MAX_NUMBER < E_MIN_NUMBER
    #error "MAX_NUMBER shouldn't be less than MIN_NUMBER"
#endif

enum E_SERVER_DATA
{
    bool: E_STARTED,
    E_ANSWER,
    E_START_TIME,
    E_TIMER,
}
new gServerData[E_SERVER_DATA];

forward LoadGame();

public OnFilterScriptInit()
{
    print("Maths script is starting...");
    print("Time between tests: " #E_TIME " seconds");
    print("Min number: " #E_MIN_NUMBER "  Max number: " #E_MAX_NUMBER );

    LoadGame();

    SetTimer("LoadGame",E_TIME*1000,true);
    return 1;
}

public OnFilterScriptExit()
{
    print("Maths script has been unloaded!");
    return 1;
}

public OnPlayerText(playerid, text[])
{
    if(gServerData[E_STARTED] && strval(text) == gServerData[E_ANSWER]) {
        CallRemoteFunction("GivePlayerMoney", "ii", playerid,10000);

        new msg[128],name[MAX_PLAYER_NAME];
        GetPlayerName(playerid,name,sizeof(name));
        format(msg,sizeof(msg),"%s Qua thong minh da giai duoc bai toan %i giay (Ket qua: %i)",name, GetTimerInSeconds(GetTickCount(),gServerData[E_START_TIME]), gServerData[E_ANSWER]);
        SendClientMessageToAll(COLOR_YELLOW,msg);
        print(msg);

        gServerData[E_STARTED] = false;
        gServerData[E_ANSWER] = 0;
        gServerData[E_START_TIME] = 0;
        return 1;
    }
    return 1;
}

public LoadGame()
{
    new E_NUM1 = random(E_MAX_NUMBER-E_MIN_NUMBER) + E_MIN_NUMBER,
        E_NUM2 = random(E_MAX_NUMBER-E_MIN_NUMBER) + E_MIN_NUMBER,
        E_NUM3 = random(E_MAX_NUMBER-E_MIN_NUMBER) + E_MIN_NUMBER,
        E_NUM4 = random(E_MAX_NUMBER-E_MIN_NUMBER) + E_MIN_NUMBER;

    gServerData[E_STARTED] = true;
    gServerData[E_ANSWER] = E_NUM1 + E_NUM2 - E_NUM3 + E_NUM4;
    gServerData[E_START_TIME] = GetTickCount();

    new msg[128];
    format(msg,sizeof(msg),"Ai giai duoc bai toan nay tui cho %i$ --> %i + %i - %i + %i = ?",E_CASH,E_NUM1,E_NUM2,E_NUM3,E_NUM4);
    SendClientMessageToAll(COLOR_YELLOW,msg);
    print(msg);
}

GetTimerInSeconds(now, started)
{
   new secs, ms;
   ms = now - started;
   while(ms > 999) {
       secs++;
       ms = ms-1000;
   }
   return secs;
}

