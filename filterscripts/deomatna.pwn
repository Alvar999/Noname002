#include <a_samp>

#define COLOR_ALICEBLUE 0xF0F8FFFF

public OnFilterScriptInit()
{
        print("\n--------------------------------------");
        print("      Mask system by Dominic Zane Version 1.0 ");
        print("--------------------------------------\n");
        return 1;
}

public OnFilterScriptExit()
{
        return 1;
}


//Mask System
new masked[MAX_PLAYERS];
new maskid[MAX_PLAYERS];

public OnPlayerText(playerid, text[])
{
    if(masked[playerid])
    {
        new string[128];// This is string what we use.
        format(string, sizeof(string), "La Mat((%d)): %s", maskid[playerid], text);
        ProxDetector(30.0, playerid, string, -1,-1,-1,-1,-1);
        return 0;
    }
    return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
        if (strcmp("/deomatna", cmdtext, true, 10) == 0)
        {
                if(masked[playerid] == 0)
                {
                        new string[128];
                        masked[playerid] = 1;
                        maskid[playerid] = random(200);
                        format(string, sizeof(string), "Ban da deo mat na.", GetPlayerNameEx(playerid));
                        ProxDetector(30.0, playerid, string, COLOR_ALICEBLUE,COLOR_ALICEBLUE,COLOR_ALICEBLUE,COLOR_ALICEBLUE,COLOR_ALICEBLUE);
                        for(new i = 0; i < MAX_PLAYERS; i++) ShowPlayerNameTagForPlayer(i, playerid, false);
                }
                else
                {
                        masked[playerid] = 0;
                        new string[128];
                        format(string, sizeof(string), "Nguoi La Mat ((%d)) da thao mat na.", maskid[playerid]);
                        ProxDetector(30.0, playerid, string, COLOR_ALICEBLUE,COLOR_ALICEBLUE,COLOR_ALICEBLUE,COLOR_ALICEBLUE,COLOR_ALICEBLUE);
                        RemovePlayerAttachedObject(playerid, 9);
                        for(new a = 0; a < MAX_PLAYERS; a++) ShowPlayerNameTagForPlayer(a, playerid, true);
                }
                return 1;
        }
        if (strcmp("/thaomatna", cmdtext, true, 10) == 0)
        {
        new string[128], name[MAX_PLAYER_NAME+1];
        for (new i = 0; i < MAX_PLAYERS; i++)
        {
            if(IsPlayerConnected(i))
            {
                if(masked[playerid] == 1)
                {
                    GetPlayerName(i, name, sizeof(name));
                    format(string, sizeof(string),"%s%s\n", string, name);
                }
            }
        }
        SendClientMessage(playerid, -1, string);
        }
        return 0;
}


forward ProxDetector(Float:radi, playerid, string[],col1,col2,col3,col4,col5);
public ProxDetector(Float:radi, playerid, string[],col1,col2,col3,col4,col5) {
    if(IsPlayerConnected(playerid)) {
        new Float:posx, Float:posy, Float:posz, Float:oldposx, Float:oldposy, Float:oldposz, Float:tempposx, Float:tempposy, Float:tempposz;
        GetPlayerPos(playerid, oldposx, oldposy, oldposz);
        for(new i = 0; i < MAX_PLAYERS; i++) {
            if(IsPlayerConnected(i) && (GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i))) {
                GetPlayerPos(i, posx, posy, posz), tempposx = (oldposx -posx), tempposy = (oldposy -posy), tempposz = (oldposz -posz);
                if (((tempposx < radi/16) && (tempposx > -radi/16)) && ((tempposy < radi/16) && (tempposy > -radi/16)) && ((tempposz < radi/16) && (tempposz > -radi/16))) { // 16
                    SendClientMessage(i, col1, string); }
                else if (((tempposx < radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy > -radi/8)) && ((tempposz < radi/8) && (tempposz > -radi/8))) { // 8
                    SendClientMessage(i, col2, string); }
                else if (((tempposx < radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy > -radi/4)) && ((tempposz < radi/4) && (tempposz > -radi/4))) { // 4
                    SendClientMessage(i, col3, string); }
                else if (((tempposx < radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy > -radi/2)) && ((tempposz < radi/2) && (tempposz > -radi/2))) { // 2
                                        SendClientMessage(i, col4, string); }
                else if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi))) { // 1
                    SendClientMessage(i, col5, string); }
            } else { SendClientMessage(i, col1, string); } } }
        return 1; }

stock GetPlayerNameEx(playerid)
{
     new pName[25];
     GetPlayerName(playerid, pName, sizeof(pName));
     return pName;
}
