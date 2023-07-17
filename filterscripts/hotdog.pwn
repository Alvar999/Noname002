#include <a_samp>
#pragma tabsize 0
#define COLOR_DARKGOLD 0x808000AA
#define COLOR_RED 0xFF0000AA
#define COLOR_YELLOW 0xFFFF00AA


#define HotPoint1 2009.0814,-1728.1830,13.4533
#define HotPoint2 2009.0692,-1640.7626,13.4465
#define HotPoint3 2075.3311,-1643.5902,13.4073
#define HotPoint4 2138.3816,-1616.8345,13.4692
#define HotPoint5 2172.3430,-1675.6588,14.9697
#define HotPoint6 2308.7888,-1665.8096,14.3982
#define HotPoint7 1878.0465,-1625.4724,13.4297
#define HotPoint8 2376.7712,-1907.2572,13.2880
#define HotPoint9 2238.4990,-1902.2578,13.4472
#define HotPoint10 1131.9427,-2037.3005,68.9129
#define HotPoint11 1023.0640,-1363.2471,13.5604
#define Refillpoint 1023.0640,-1363.2471,13.5604

new hotdog = 0;
new hotinfo;

public OnFilterScriptInit()
{
        AddStaticVehicle(588,1012.7839,-1367.5126,13.2657,0.6484,1,1); // dog1
        AddStaticVehicle(588,1007.5398,-1367.6776,13.2262,359.8999,1,1); // dog2
        AddStaticVehicle(588,1001.1543,-1367.5645,13.1791,0.8526,1,1); // dog3

    hotinfo = CreatePickup(2355,1,1017.7097,-1342.0332,13.5469,-1);
}

public OnPlayerCommandText(playerid, cmdtext[])
{
        if (strcmp("/giaohotdog", cmdtext, true, 10) == 0)
        {
        if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 588)
        {
            hotdog = 1;
                    SetPlayerCheckpoint(playerid, HotPoint1, 3.0);
                GameTextForPlayer(playerid, "~g~Ban dang chuan bi giao hotdog chuc vui ve!", 3000, 3);
                        return 1;
            }
                SendClientMessage(playerid, COLOR_RED,"You have to be in a hotdog van to start the job");
        }
        if (strcmp("asdsadasd", cmdtext, true, 10) == 0)
        {
                return 1;
        }
        return 0;
}
public OnPlayerEnterCheckpoint(playerid)
{
if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 588)
   {
     if (IsPlayerInRangeOfPoint(playerid, 7.0,HotPoint1))
     {
          SetPlayerCheckpoint(playerid, HotPoint2, 7.0);
          GameTextForPlayer(playerid, "~g~Da chuyen duoc 1 chiec banh hotdog!", 3000, 3);
         }
     if (IsPlayerInRangeOfPoint(playerid, 7.0,HotPoint2))
     {
          SetPlayerCheckpoint(playerid, HotPoint3, 7.0);
          GameTextForPlayer(playerid, "~g~Da chuyen duoc 2 chiec banh hotdog!", 3000, 3);
         }
     if (IsPlayerInRangeOfPoint(playerid, 7.0,HotPoint3))
     {
          SetPlayerCheckpoint(playerid, HotPoint4, 7.0);
          GameTextForPlayer(playerid, "~g~Da chuyen duoc 3 chiec banh hotdog!", 3000, 3);
         }
     if (IsPlayerInRangeOfPoint(playerid, 7.0,HotPoint4))
     {
          SetPlayerCheckpoint(playerid, HotPoint5, 7.0);
          GameTextForPlayer(playerid, "~g~Da chuyen duoc 4 chiec banh hotdog!", 3000, 3);
         }
     if (IsPlayerInRangeOfPoint(playerid, 7.0,HotPoint5))
     {
          SetPlayerCheckpoint(playerid, Refillpoint, 7.0);
          GameTextForPlayer(playerid, "~g~Da chuyen duoc 5 chiec banh hotdog!, da het banh hotdog hay quay ve va lay them banh", 5000, 3);
         }
     if (IsPlayerInRangeOfPoint(playerid, 7.0,Refillpoint))
     {
          SetPlayerCheckpoint(playerid, HotPoint6, 7.0);
          GameTextForPlayer(playerid, "~g~Da lay hotdog", 3000, 3);
         }
     if (IsPlayerInRangeOfPoint(playerid, 7.0,HotPoint6))
     {
          SetPlayerCheckpoint(playerid, HotPoint7, 7.0);
          GameTextForPlayer(playerid, "~g~Da chuyen duoc 6 chiec banh hotdog!", 3000, 3);
         }
     if (IsPlayerInRangeOfPoint(playerid, 7.0,HotPoint7))
     {
          SetPlayerCheckpoint(playerid, HotPoint8, 7.0);
          GameTextForPlayer(playerid, "~g~Da chuyen duoc 7 chiec banh hotdog!", 3000, 3);
         }
     if (IsPlayerInRangeOfPoint(playerid, 7.0,HotPoint8))
     {
          SetPlayerCheckpoint(playerid, HotPoint9, 7.0);
          GameTextForPlayer(playerid, "~g~Da chuyen duoc 8 chiec banh hotdog!", 3000, 3);
         }
     if (IsPlayerInRangeOfPoint(playerid, 7.0,HotPoint9))
     {
          SetPlayerCheckpoint(playerid, HotPoint10, 7.0);
          GameTextForPlayer(playerid, "~g~Da chuyen duoc 9 chiec banh hotdog!", 3000, 3);
         }
     if (IsPlayerInRangeOfPoint(playerid, 7.0,HotPoint10))
     {
          SetPlayerCheckpoint(playerid, HotPoint11, 7.0);
          GameTextForPlayer(playerid, "~g~Da chuyen duoc 10 chiec banh hotdog!, tro ve diem lay banh", 3000, 3);
         }
     if (IsPlayerInRangeOfPoint(playerid, 7.0,HotPoint11))
     {
             GivePlayerMoney(playerid, 5000);
             GameTextForPlayer(playerid, "~g~Ban da giao banh xong va nhan duoc 5000$ tu ong chu tiem", 5000, 3);
         new veh;
         veh = GetPlayerVehicleID(playerid);
         SetVehicleToRespawn(veh);
         DisablePlayerCheckpoint(playerid);
         hotdog = 0;
     }
   }
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
     if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 588)
     {
         SendClientMessage(playerid, COLOR_RED, "De lam viec hotdog hay /giaohotdog");
     }
     return 0;
}
public OnPlayerExitVehicle(playerid, vehicleid)
{
        if((hotdog) == 1)
        {
            hotdog = 0;
            SendClientMessage(playerid, COLOR_RED, "Ban da ra khoi xe , hay len xe lai de lam viec.");

        }else if((hotdog) == 0){

                //Nothing
 }
}
public OnPlayerDeath(playerid, killerid, reason)
{
          DisablePlayerCheckpoint(playerid);
          hotdog = 0;
          return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
    if(pickupid == hotinfo)
        {
    GameTextForPlayer(playerid, "~g~/giaohotdog de bat dau cong viec", 3000, 3);
        }
}
