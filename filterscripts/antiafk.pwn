#include <a_samp>
#define SCM SendClientMessage
#define SCMToAll SendClientMessageToAll
#define Sec(%0) (( %0 ) * ( 1000 ))
#define Min(%0) (( %0 ) * ( 1000*60 ))
#define Sati(%0) (( %0 ) * ( 1000*60*60 ))
///======================================================= SCRIPT ====================///
public OnFilterScriptInit()
{
   SetTimer("AntiAFK",Min(5),true);
return 1;
}
forward AntiAFK(playerid);
public AntiAFK(playerid)
{
SCM(playerid,-1,"[Anti] Ban da bi kick ra khoi server vi AFK qua 5 phut...");
Kick(playerid);
SCMToAll(-1,"%s da bi kick khoi server ,Li Do : AFK",GetName(playerid));
return 1;
}
stock GetName(playerid)
{
    new pName[MAX_PLAYER_NAME];

    GetPlayerName(playerid, pName, MAX_PLAYER_NAME);
    return pName;
}
