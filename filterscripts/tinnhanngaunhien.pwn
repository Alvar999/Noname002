//~~~~~~~~~~~~~~ [ Ai lay thi de lai nguon, uong nuoc nho nguon cua nguoi lam ] ~~~~~~~~~~~~~~~~~~~~~~~//
#include                                        <               a_samp           >
#include                                        <               foreach          >
#pragma tabsize 0
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
new Text:ServerMessages[10];
new racku;
new RandomMessages[][] = // Tin nhan ngau nhien
{
        "Neu ban thac mac vi ly do gi hay /newb",
        "Neu thay hack/cheat/cleo - hay su dung /baocao",
        "Forum : chua co",
		"Facebook Admin Server: chua co",
		"Facebook Admin Server: chua update",
		"Van De Hack KOS se bi prison 30 phut va HCVK 25 gio"
};
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
public OnFilterScriptInit()
{
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
        ServerMessages[0] = TextDrawCreate(510.000000, 431.000000, "_");
        TextDrawBackgroundColor(ServerMessages[0], 255);
        TextDrawFont(ServerMessages[0], 1);
        TextDrawLetterSize(ServerMessages[0], 0.500000, 1.000000);
        TextDrawColor(ServerMessages[0], -1);
        TextDrawSetOutline(ServerMessages[0], 0);
        TextDrawSetProportional(ServerMessages[0], 1);
        TextDrawSetShadow(ServerMessages[0], 1);
        TextDrawUseBox(ServerMessages[0], 1);
        TextDrawBoxColor(ServerMessages[0], 120);
        TextDrawTextSize(ServerMessages[0], 140.000000, 0.000000);
        TextDrawSetSelectable(ServerMessages[0], 0);

        ServerMessages[1] = TextDrawCreate(510.000000, 431.000000, "_");
        TextDrawBackgroundColor(ServerMessages[1], 255);
        TextDrawFont(ServerMessages[1], 1);
        TextDrawLetterSize(ServerMessages[1], 0.500000, -0.700000);
        TextDrawColor(ServerMessages[1], -1);
        TextDrawSetOutline(ServerMessages[1], 0);
        TextDrawSetProportional(ServerMessages[1], 1);
        TextDrawSetShadow(ServerMessages[1], 1);
        TextDrawUseBox(ServerMessages[1], 1);
        TextDrawBoxColor(ServerMessages[1], 50135039);
        TextDrawTextSize(ServerMessages[1], 140.000000, 0.000000);
        TextDrawSetSelectable(ServerMessages[1], 0);

        ServerMessages[2] = TextDrawCreate(510.000000, 446.000000, "_");
        TextDrawBackgroundColor(ServerMessages[2], 255);
        TextDrawFont(ServerMessages[2], 1);
        TextDrawLetterSize(ServerMessages[2], 0.500000, -0.600000);
        TextDrawColor(ServerMessages[2], -1);
        TextDrawSetOutline(ServerMessages[2], 0);
        TextDrawSetProportional(ServerMessages[2], 1);
        TextDrawSetShadow(ServerMessages[2], 1);
        TextDrawUseBox(ServerMessages[2], 1);
        TextDrawBoxColor(ServerMessages[2], 50135039);
        TextDrawTextSize(ServerMessages[2], 140.000000, 0.000000);
        TextDrawSetSelectable(ServerMessages[2], 0);

        ServerMessages[3] = TextDrawCreate(322.000000, 430.000000, "LSRPVN");
        TextDrawAlignment(ServerMessages[3], 2);
        TextDrawBackgroundColor(ServerMessages[3], 255);
        TextDrawFont(ServerMessages[3], 3);
        TextDrawLetterSize(ServerMessages[3], 0.340000, 1.100000);
        TextDrawColor(ServerMessages[3], -1);
        TextDrawSetOutline(ServerMessages[3], 1);
        TextDrawSetProportional(ServerMessages[3], 1);
        TextDrawSetSelectable(ServerMessages[3], 0);
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
        SetTimer("MenjajPoruke", 50, true);
        racku = 0;
        return 1;
}
public OnFilterScriptExit()
{
        TextDrawDestroy(ServerMessages[0]);
        TextDrawDestroy(ServerMessages[1]);
        TextDrawDestroy(ServerMessages[2]);
        TextDrawDestroy(ServerMessages[3]);
        return 1;
}

public OnPlayerConnect(playerid)
{
        return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
        return 1;
}


public OnPlayerDeath(playerid, killerid, reason)
{
        return 1;
}

public OnVehicleSpawn(vehicleid)
{
        return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
        return 1;
}

public OnPlayerText(playerid, text[])
{
        return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
        return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
        return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
        return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
        return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
        return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
        return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
        return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
        return 1;
}

public OnRconCommand(cmd[])
{
        return 1;
}

public OnPlayerRequestSpawn(playerid)
{
        return 1;
}

public OnObjectMoved(objectid)
{
        return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
        return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
        return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
        return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
        return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
        return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
        return 1;
}

public OnPlayerExitedMenu(playerid)
{
        return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
        return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
        return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
        return 1;
}

public OnPlayerUpdate(playerid)
{
        return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
        return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
        return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
        return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
        return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
        return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
        return 1;
}

forward MenjajPoruke();
public MenjajPoruke()
{
        if(racku == 0)
        {
            TextDrawColor(ServerMessages[3], 0xFFFFFFFF);
            racku = 1;
            foreach(Player, i)
            {
                TextDrawShowForPlayer(i, ServerMessages[3]);
                }
        }
        else if(racku == 1)
        {
        TextDrawColor(ServerMessages[3], 0xFFFFFF99);
            racku = 2;
            foreach(Player, i)
            {
                TextDrawShowForPlayer(i, ServerMessages[3]);
                }
        }
        else if(racku == 2)
        {
        TextDrawColor(ServerMessages[3], 0xFFFFFF88);
            racku = 3;
            foreach(Player, i)
            {
                TextDrawShowForPlayer(i, ServerMessages[3]);
                }
        }
        else if(racku == 3)
        {
        TextDrawColor(ServerMessages[3], 0xFFFFFF77);
            racku = 4;
            foreach(Player, i)
            {
                TextDrawShowForPlayer(i, ServerMessages[3]);
                }
        }
        else if(racku == 4)
        {
        TextDrawColor(ServerMessages[3], 0xFFFFFF66);
            racku = 5;
            foreach(Player, i)
            {
                TextDrawShowForPlayer(i, ServerMessages[3]);
                }
        }
        else if(racku == 5)
        {
        TextDrawColor(ServerMessages[3], 0xFFFFFF55);
            racku = 6;
            foreach(Player, i)
            {
                TextDrawShowForPlayer(i, ServerMessages[3]);
                }
        }
        else if(racku == 6)
        {
        TextDrawColor(ServerMessages[3], 0xFFFFFF44);
            racku = 7;
            foreach(Player, i)
            {
                TextDrawShowForPlayer(i, ServerMessages[3]);
                }
        }
        else if(racku == 7)
        {
        TextDrawColor(ServerMessages[3], 0xFFFFFF33);
            racku = 8;
            foreach(Player, i)
            {
                TextDrawShowForPlayer(i, ServerMessages[3]);
                }
        }
        else if(racku == 8)
        {
        TextDrawColor(ServerMessages[3], 0xFFFFFF22);
            racku = 9;
            foreach(Player, i)
            {
                TextDrawShowForPlayer(i, ServerMessages[3]);
                }
        }
        else if(racku == 9)
        {
        TextDrawColor(ServerMessages[3], 0xFFFFFF11);
            racku = 10;
            foreach(Player, i)
            {
                TextDrawShowForPlayer(i, ServerMessages[3]);
                }
        }
        else if(racku == 10)
        {
        TextDrawColor(ServerMessages[3], 0xFFFFFF00);
            racku = 11;
            foreach(Player, i)
            {
                TextDrawShowForPlayer(i, ServerMessages[3]);
                }
        }
        else if(racku == 11)
        {
        TextDrawSetString(ServerMessages[3], RandomMessages[random(sizeof(RandomMessages))]);
            racku = 12;
        }
        else if(racku == 12)
        {
        TextDrawColor(ServerMessages[3], 0xFFFFFF11);
            racku = 13;
            foreach(Player, i)
            {
                TextDrawShowForPlayer(i, ServerMessages[3]);
                }
        }
        else if(racku == 13)
        {
        TextDrawColor(ServerMessages[3], 0xFFFFFF22);
            racku = 14;
            foreach(Player, i)
            {
                TextDrawShowForPlayer(i, ServerMessages[3]);
                }
        }
        else if(racku == 14)
        {
        TextDrawColor(ServerMessages[3], 0xFFFFFF33);
            racku = 15;
            foreach(Player, i)
            {
                TextDrawShowForPlayer(i, ServerMessages[3]);
                }
        }
        else if(racku == 15)
        {
        TextDrawColor(ServerMessages[3], 0xFFFFFF44);
            racku = 16;
            foreach(Player, i)
            {
                TextDrawShowForPlayer(i, ServerMessages[3]);
                }
        }
        else if(racku == 16)
        {
        TextDrawColor(ServerMessages[3], 0xFFFFFF55);
            racku = 17;
            foreach(Player, i)
            {
                TextDrawShowForPlayer(i, ServerMessages[3]);
                }
        }
        else if(racku == 17)
        {
        TextDrawColor(ServerMessages[3], 0xFFFFFF66);
            racku = 18;
            foreach(Player, i)
            {
                TextDrawShowForPlayer(i, ServerMessages[3]);
                }
        }
        else if(racku == 18)
        {
        TextDrawColor(ServerMessages[3], 0xFFFFFF77);
            racku = 19;
            foreach(Player, i)
            {
                TextDrawShowForPlayer(i, ServerMessages[3]);
                }
        }
        else if(racku == 19)
        {
        TextDrawColor(ServerMessages[3], 0xFFFFFF88);
            racku = 20;
            foreach(Player, i)
            {
                TextDrawShowForPlayer(i, ServerMessages[3]);
                }
        }
        else if(racku == 20)
        {
        TextDrawColor(ServerMessages[3], 0xFFFFFF99);
            racku = 21;
            foreach(Player, i)
            {
                TextDrawShowForPlayer(i, ServerMessages[3]);
                }
        }
        else if(racku == 21)
        {
        TextDrawColor(ServerMessages[3], 0xFFFFFFFF);
            racku = 22;
            foreach(Player, i)
            {
                TextDrawShowForPlayer(i, ServerMessages[3]);
                }
        }
        //~~~~~~~~~~~~~~~~~~~~~~~ [ Neko vrijeme da Text ostane ] ~~~~~~~~~~~~~~~~//
        //~~~~~~~~~~ [ Doing nothing to leave text visible for some time ] ~~~~~~~//
        else if(racku == 22)
        {
                racku = 23;
        }
        else if(racku == 23)
        {
                racku = 24;
        }
        else if(racku == 24)
        {
                racku = 25;
        }
        else if(racku == 25)
        {
                racku = 26;
        }
        else if(racku == 26)
        {
                racku = 27;
        }
        else if(racku == 27)
        {
                racku = 28;
        }
        else if(racku == 28)
        {
                racku = 29;
        }
        else if(racku == 29)
        {
                racku = 30;
        }
        else if(racku == 30)
        {
                racku = 31;
        }
        else if(racku == 31)
        {
                racku = 32;
        }
        else if(racku == 32)
        {
                racku = 33;
        }
        else if(racku == 33)
        {
                racku = 34;
        }
        else if(racku == 34)
        {
                racku = 35;
        }
        else if(racku == 35)
        {
                racku = 0;
        }
        return 1;
}
