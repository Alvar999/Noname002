#define         FILTERSCRIPT
#include        <a_samp>
#include    <streamer>
#include    <zcmd>
#pragma tabsize 0

#define     VAULT_VIRTUALWORLD      (69)
#define     PICKUP_COOLDOWN         (3)
#define     DEPOSIT_MIN             (3500)
#define     DEPOSIT_MAX             (10000)

enum    e_objecttypes
{
        TYPE_LASER1 = 2,
        TYPE_LASER2,
        TYPE_LASER3,
        TYPE_VAULTDOOR = 6
};

enum    e_labeltypes
{
        Text3D: TYPE_KEYPAD,
        Text3D: TYPE_EXPLOSIVE,
        Text3D: TYPE_TIMELOCK
};

enum    e_bankcontrols
{
        bool: Alarm,
        bool: LasersOn,
        VaultDoorState,
        KeypadHackTime,
        DoorInteractionTime
};

new
        BankEntryPickup = -1, BankExitPickup = -1, VaultEntryPickup = -1, VaultExitPickup = -1,
        AlarmArea = -1,
    VaultObjects[8] = {INVALID_OBJECT_ID, ...},
        Text3D: VaultLabels[e_labeltypes] = {Text3D: INVALID_3DTEXT_ID, ...},
        Text3D: InsideVaultLabels[8] = {Text3D: INVALID_3DTEXT_ID, ...},
        BankControls[e_bankcontrols],
        bool: DepositRobbed[8];

new
        RobberyTimer[MAX_PLAYERS] = {-1, ...},
        RobberyCounter[MAX_PLAYERS],
        RobberyType[MAX_PLAYERS],
        RobberyCash[MAX_PLAYERS],
        RobberyEscape[MAX_PLAYERS] = {-1, ...};

new
        Float: DepositCoords[8][3] = {
                {2141.9255, 1629.3380, 993.5761},
                {2141.9255, 1633.2180, 993.5761},
                {2141.9255, 1637.0980, 993.5761},
                {2141.9255, 1640.9780, 993.5761},
                {2146.5600, 1629.3040, 993.5761},
                {2146.5600, 1633.1840, 993.5761},
                {2146.5600, 1637.0640, 993.5761},
                {2146.5600, 1640.9440, 993.5761}
        };

new
        Float: GetawayLocations[][3] = {
        {405.4649, 2451.4956, 16.5000},
        {-1647.8981, 2497.6980, 86.2031},
        {-911.9169, -498.3112, 25.9609}
        };

forward RobberyUpdate(playerid);
forward ResetLasers();
forward OpenVaultDoor(type, seconds);
forward ResetVaultDoor();
forward DisableAlarm();

stock ConvertToMinutes(time)
{
    // http://forum.sa-mp.com/showpost.php?p=3223897&postcount=11
    new string[15];//-2000000000:00 could happen, so make the string 15 chars to avoid any errors
    format(string, sizeof(string), "%02d:%02d", time / 60, time % 60);
    return string;
}

stock ResetRobbery(playerid, destroy = 0)
{
        if(RobberyTimer[playerid] != -1) KillTimer(RobberyTimer[playerid]);
    RobberyTimer[playerid] = -1;
    RobberyCounter[playerid] = 0;
    RobberyType[playerid] = 0;
    if(destroy)
    {
                if(IsValidDynamicCP(RobberyEscape[playerid])) DestroyDynamicCP(RobberyEscape[playerid]);
                RobberyEscape[playerid] = -1;
                RobberyCash[playerid] = 0;
        }

        return 1;
}

stock GetClosestDeposit(playerid, Float: range = 2.0)
{
        new id = -1, Float: dist = range, Float: tempdist;
        for(new i; i < sizeof(DepositCoords); ++i)
        {
            tempdist = GetPlayerDistanceFromPoint(playerid, DepositCoords[i][0], DepositCoords[i][1], DepositCoords[i][2]);
                if(tempdist > range) continue;
                if(tempdist <= dist)
                {
                        dist = tempdist;
                        id = i;
                        break;
                }
        }

        return id;
}

stock RandomEx(min, max)
        return random(max - min) + min;

stock TriggerAlarm(reason = 0)
{
        if(BankControls[Alarm]) return 1;
    for(new i; i < GetMaxPlayers(); ++i)
        {
                if(!IsPlayerConnected(i)) continue;
                if(RobberyType[i] == 1)
                {
                        ResetRobbery(i);
                        ClearAnimations(i, 1);
                }

                if(!GetPVarInt(i, "InsideBank")) continue;
                SetPVarInt(i, "Alarm", 1);
        PlayerPlaySound(i, 3401, 0.0, 0.0, 0.0);
        }

        SetTimer("DisableAlarm", 120000, false);
        BankControls[Alarm] = true;
        SendClientMessageToAll(-1, (reason == 1) ? ("He thong bank da bi xam nhap!") : ("Bank dang bi xam nhap!"));
        return 1;
}

public OnFilterScriptInit()
{
        BankEntryPickup = CreatePickup(19197, 1, 1457.2706,-1009.9210,26.8438);
        BankExitPickup = CreatePickup(19197, 1, 2305.5591, -16.1253, 27.0, -1);
        VaultEntryPickup = CreatePickup(19197, 1, 2315.5637, -0.1449, 27.0, -1);
        VaultExitPickup = CreatePickup(19197, 1, 2144.2788, 1602.5975, 998.0, VAULT_VIRTUALWORLD);

        AlarmArea = CreateDynamicRectangle(2130.6169, 1607.9010, 2156.9197,1625.2343, VAULT_VIRTUALWORLD, 1);

        VaultObjects[0] = CreateDynamicObject(19446, 2144.333, 1601.475, 1001.387, 90.000, 90.199, 0.000, VAULT_VIRTUALWORLD); // wall
        VaultObjects[1] = CreateDynamicObject(2947, 2145.037, 1601.421, 996.776, 0.000, 0.000, -89.500, VAULT_VIRTUALWORLD); // door
        VaultObjects[TYPE_LASER1] = CreateDynamicObject(18643, 2142.983, 1606.679, 993.188, 0.000, 0.000, 0.000, VAULT_VIRTUALWORLD); // laser
        VaultObjects[TYPE_LASER2] = CreateDynamicObject(18643, 2142.983, 1606.679, 993.938, 0.000, 0.000, 0.000, VAULT_VIRTUALWORLD); // laser
        VaultObjects[TYPE_LASER3] = CreateDynamicObject(18643, 2142.983, 1606.679, 994.688, 0.000, 0.000, 0.000, VAULT_VIRTUALWORLD); // laser
        VaultObjects[5] = CreateDynamicObject(19273, 2146.116, 1604.895, 994.118, 0.000, 0.000, 270.000, VAULT_VIRTUALWORLD); // keypad
        VaultObjects[TYPE_VAULTDOOR] = CreateDynamicObject(19799, 2143.185, 1626.965, 994.298, 0.000, -0.400, -180.000, VAULT_VIRTUALWORLD); // vault door
        VaultObjects[7] = CreateDynamicObject(2922, 2140.361, 1626.826, 993.978, 0.000, 0.000, 180.000, VAULT_VIRTUALWORLD); // timelock

        VaultLabels[TYPE_KEYPAD] = CreateDynamic3DTextLabel("Dieu Khien Bao Dong\n{FFFFFF}/hacklaser de tat no", 0xF39C12FF, 2145.85, 1604.9456, 993.5684, 15.0, .testlos = 1, .worldid = VAULT_VIRTUALWORLD);
    VaultLabels[TYPE_TIMELOCK] = CreateDynamic3DTextLabel("Cua Dieu Khien Mo Cong\n{FFFFFF}/hackpass (cham & im lang)", 0xF39C12FF, 2140.2610, 1626.25, 993.6882, 10.0, .testlos = 1, .worldid = VAULT_VIRTUALWORLD);

        for(new i; i < sizeof(InsideVaultLabels); ++i)
        {
                InsideVaultLabels[i] = CreateDynamic3DTextLabel("De Lay Tien\n{FFFFFF}/laytien", 0x2ECC71FF, DepositCoords[i][0], DepositCoords[i][1], DepositCoords[i][2], 15.0, .testlos = 1, .worldid = VAULT_VIRTUALWORLD);
        }

        BankControls[LasersOn] = true;
        return 1;
}

public OnFilterScriptExit()
{
        DestroyPickup(BankEntryPickup);
        DestroyPickup(BankExitPickup);
        DestroyPickup(VaultEntryPickup);
    DestroyPickup(VaultExitPickup);

        for(new i; i < GetMaxPlayers(); ++i)
        {
            if(!IsPlayerConnected(i)) continue;
            if(GetPVarInt(i, "Alarm"))
            {
                        SetPVarInt(i, "Alarm", 0);
                PlayerPlaySound(i, 3402, 0.0, 0.0, 0.0);
                }

            ClearAnimations(i, 1);
                ResetRobbery(i, 1);
        }

        return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    ResetRobbery(playerid, 1);
        return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    ResetRobbery(playerid, 1);
        return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
        if(GetPVarInt(playerid, "BankPickupCooldown") > gettime()) return 1;
        if(pickupid == BankEntryPickup) {
            SetPVarInt(playerid, "InsideBank", 1);
                SetPlayerPos(playerid, 2305.5591, -16.1253, 26.7496);
                SetPVarInt(playerid, "BankPickupCooldown", gettime() + PICKUP_COOLDOWN);

                if(BankControls[Alarm])
                {
            SetPVarInt(playerid, "Alarm", 1);
                PlayerPlaySound(playerid, 3401, 0.0, 0.0, 0.0);
                }
        }else if(pickupid == BankExitPickup) {
            SetPVarInt(playerid, "InsideBank", 0);
                SetPlayerPos(playerid, 1459.4373,-1009.9220,26.8438);
                SetPVarInt(playerid, "BankPickupCooldown", gettime() + PICKUP_COOLDOWN);

                if(GetPVarInt(playerid, "Alarm"))
                {
            SetPVarInt(playerid, "Alarm", 0);
                PlayerPlaySound(playerid, 3402, 0.0, 0.0, 0.0);
                }

                if(RobberyCash[playerid] > 0 && !IsValidDynamicCP(RobberyEscape[playerid]))
                {
                    new id = random(sizeof(GetawayLocations));
                    RobberyEscape[playerid] = CreateDynamicCP(GetawayLocations[id][0], GetawayLocations[id][1], GetawayLocations[id][2], 3.0, .playerid = playerid, .streamdistance = 5000.0);
                    SendClientMessage(playerid, -1, "Hay Den Dia Diem Cuop Bank , Ban Chet thi Nhiem vu se that bai.");
                }
        }else if(pickupid == VaultEntryPickup) {
            if(!GetPVarInt(playerid, "animsloaded"))
            {
                ApplyAnimation(playerid, "BOMBER", "null", 0.0, 0, 0, 0, 0, 0);
                ApplyAnimation(playerid, "ROB_BANK", "CAT_Safe_Rob", 4.0, 1, 0, 0, 0, 0, 1);
                ApplyAnimation(playerid, "COP_AMBIENT", "null", 0.0, 0, 0, 0, 0, 0);
            ApplyAnimation(playerid, "ROB_BANK", "null", 0.0, 0, 0, 0, 0, 0);
                        SetPVarInt(playerid, "animsloaded", 1);
                }

            SetPlayerInterior(playerid, 1);
            SetPlayerVirtualWorld(playerid, VAULT_VIRTUALWORLD);
        SetPlayerPos(playerid, 2144.2788, 1602.5975, 997.7766);
                SetPVarInt(playerid, "BankPickupCooldown", gettime() + PICKUP_COOLDOWN);
        }else if(pickupid == VaultExitPickup) {
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
        SetPlayerPos(playerid, 2315.5637, -0.1449, 26.7422);
                SetPVarInt(playerid, "BankPickupCooldown", gettime() + PICKUP_COOLDOWN);
        }

        return 1;
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
        if(areaid == AlarmArea && BankControls[LasersOn] && !BankControls[Alarm]) TriggerAlarm();
        return 1;
}

public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
        if(checkpointid == RobberyEscape[playerid])
        {
            new string[128];
                format(string, sizeof(string), "Da Cuop Nha Bank Thanh Cong Va Duoc {2ECC71}$%d.", RobberyCash[playerid]);
                SendClientMessage(playerid, -1, string);

                GivePlayerMoney(playerid, RobberyCash[playerid]);
                RobberyCash[playerid] = 0;
                DestroyDynamicCP(RobberyEscape[playerid]);
                RobberyEscape[playerid] = -1;
        }

        return 1;
}

public RobberyUpdate(playerid)
{
        if(RobberyCounter[playerid] > 1) {
            RobberyCounter[playerid]--;

        new string[32];
                switch(RobberyType[playerid])
                {
                        case 1: format(string, sizeof(string), "~w~Dang Hack Password: %s%d", (RobberyCounter[playerid] <= 5) ? ("~r~~h~") : ("~y~"), RobberyCounter[playerid]);
                        case 2: format(string, sizeof(string), "~w~Dang Lay Tien: %s%d", (RobberyCounter[playerid] <= 3) ? ("~r~~h~") : ("~y~"), RobberyCounter[playerid]);
                }

                GameTextForPlayer(playerid, string, 1000, 3);
        }else if(RobberyCounter[playerid] == 1) {
        switch(RobberyType[playerid])
                {
                        case 1:
                        {
                                BankControls[LasersOn] = false;
                                SetDynamicObjectPos(VaultObjects[TYPE_LASER1], 2142.983, 1606.679, 990.0);
                                SetDynamicObjectPos(VaultObjects[TYPE_LASER2], 2142.983, 1606.679, 990.0);
                                SetDynamicObjectPos(VaultObjects[TYPE_LASER3], 2142.983, 1606.679, 990.0);
                                SetTimer("ResetLasers", 240000, false);
                                SendClientMessage(playerid, -1, "Ban da tat he thong bao dong.");
                                SendClientMessage(playerid, -1, "Bao dong se bat lai sau 4 phut");
                        }

                        case 2:
                        {
                            new cash = RandomEx(DEPOSIT_MIN, DEPOSIT_MAX), string[128];
                            if(BankControls[VaultDoorState] == 2) cash -= floatround(cash * 5, floatround_floor); // explosion damaged deposit boxes, 10% damage penalty
                                RobberyCash[playerid] += cash;
                                format(string, sizeof(string), "Ban da lay {2ECC71}$%d .", cash);
                                SendClientMessage(playerid, -1, string);
                                SendClientMessage(playerid, -1, "Hay chay thoat nhe");
                        }
                }

                ClearAnimations(playerid, 1);
                ResetRobbery(playerid);
        }

        return 1;
}

public ResetLasers()
{
    BankControls[LasersOn] = true;
    SetDynamicObjectPos(VaultObjects[TYPE_LASER1], 2142.983, 1606.679, 993.188);
        SetDynamicObjectPos(VaultObjects[TYPE_LASER2], 2142.983, 1606.679, 993.938);
        SetDynamicObjectPos(VaultObjects[TYPE_LASER3], 2142.983, 1606.679, 994.688);

        return 1;
}

public OpenVaultDoor(type, seconds)
{
        if(seconds > 1) {
            seconds--;

            new string[128];
        switch(type)
                {
                        case 2: format(string, sizeof(string), "Cua Bank - 1\n{FFFFFF}/plantbomb De mo canh cua (nhanh & nguy hiem)\n{2ECC71}%s", ConvertToMinutes(seconds));
                        case 3: format(string, sizeof(string), "Cua Bank - 2\n{FFFFFF}/hackpass de hack he thong cua (cham & im lang)\n{2ECC71}%s", ConvertToMinutes(seconds));
                }

                UpdateDynamic3DTextLabelText((type == 2) ? VaultLabels[TYPE_EXPLOSIVE] : VaultLabels[TYPE_TIMELOCK], 0xF39C12FF, string);
        SetTimerEx("OpenVaultDoor", 1000, false, "ii", type, seconds);
        }else if(seconds == 1) {
        BankControls[VaultDoorState] = type;
                SetTimer("ResetVaultDoor", 120000, false);

                switch(type)
                {
                        case 2:
                        {
                            // explosive
                            CreateExplosion(2144.1624, 1626.25, 993.6882, 11, 5.0);
                                SetDynamicObjectPos(VaultObjects[TYPE_VAULTDOOR], 2143.185, 1626.965, 985.298);
                UpdateDynamic3DTextLabelText(VaultLabels[TYPE_EXPLOSIVE], 0xF39C12FF, "Cua Bank - 1\n{FFFFFF}/plantbomb de mo canh cua (nhanh & nguy hiem)");
                                TriggerAlarm(1);
                        }

                        case 3:
                        {
                            // timelock
                                MoveDynamicObject(VaultObjects[TYPE_VAULTDOOR], 2143.185, 1626.965, 994.35, 0.01, 0.000, -0.400, -270.0);
                UpdateDynamic3DTextLabelText(VaultLabels[TYPE_TIMELOCK], 0xF39C12FF, "Cua Bank - 2\n{FFFFFF}/hackpass de bat dau hack (cham & im lang)");
                        }
                }
        }

        return 1;
}

public ResetVaultDoor()
{
        switch(BankControls[VaultDoorState])
        {
                case 2: SetDynamicObjectPos(VaultObjects[TYPE_VAULTDOOR], 2143.185, 1626.965, 994.298);
                case 3: MoveDynamicObject(VaultObjects[TYPE_VAULTDOOR], 2143.185, 1626.965, 994.298, 0.01, 0.000, -0.400, -180.0);
        }

        for(new i; i < sizeof(DepositCoords); ++i)
        {
                DepositRobbed[i] = false;
                Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, InsideVaultLabels[i], E_STREAMER_COLOR, 0x2ECC71FF);
        }

        BankControls[VaultDoorState] = 0; // closed
        return 1;
}

public DisableAlarm()
{
        BankControls[Alarm] = false;
        for(new i; i < GetMaxPlayers(); ++i)
        {
                if(!IsPlayerConnected(i)) continue;
                if(!GetPVarInt(i, "Alarm")) continue;
                SetPVarInt(i, "Alarm", 0);
        PlayerPlaySound(i, 3402, 0.0, 0.0, 0.0);
        }

        return 1;
}

CMD:hacklaser(playerid, params[])
{
        if(!IsPlayerInRangeOfPoint(playerid, 1.5, 2145.85, 1604.9456, 993.5684)) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Ban khong o gan dieu khien dien tu.");
        if(BankControls[Alarm]) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}He Thong Da Bao Dong.");
        if(!BankControls[LasersOn]) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Cua da duoc hack.");
        if(BankControls[KeypadHackTime] > gettime())
        {
            new string[72];
                format(string, sizeof(string), "ERROR: {FFFFFF}Ban phai tro %s de hack pass ngan hang.", ConvertToMinutes(BankControls[KeypadHackTime] - gettime()));
                SendClientMessage(playerid, 0xE74C3CFF, string);
                return 1;
        }

        ApplyAnimation(playerid, "COP_AMBIENT", "COPBROWSE_LOOP", 4.1, 1, 0, 0, 0, 0, 1);
        BankControls[KeypadHackTime] = gettime() + 600;
        RobberyType[playerid] = 1;
        RobberyCounter[playerid] = 60;
        RobberyTimer[playerid] = SetTimerEx("RobberyUpdate", 1000, true, "i", playerid);
        return 1;
}

CMD:plansasadtbomb(playerid, params[])
{
    if(!IsPlayerInRangeOfPoint(playerid, 1.5, 2144.1624, 1626.25, 99999999.0))
        if(BankControls[VaultDoorState] != 0) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Canh cua dang bi hack hoac dang mo.");
        if(BankControls[DoorInteractionTime] > gettime())
        {
            new string[72];
                format(string, sizeof(string), "ERROR: {FFFFFF}da dat bomb cho %s de mo cua.", ConvertToMinutes(BankControls[DoorInteractionTime] - gettime()));
                SendClientMessage(playerid, 0xE74C3CFF, string);
                return 1;
        }

        ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 1, 1, 0, 0, 1);
        BankControls[DoorInteractionTime] = gettime() + 600;
        BankControls[VaultDoorState] = 1; // opening
        SetTimerEx("OpenVaultDoor", 1000, false, "ii", 2, 6);
        SendClientMessage(playerid, -1, "Dat dat boom boom se no sau 6 giay!");
        return 1;
}

CMD:hackpass(playerid, params[])
{
    if(!IsPlayerInRangeOfPoint(playerid, 1.5, 2140.2610, 1626.25, 993.6882)) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Ban khong dung gan cua");
        if(BankControls[Alarm]) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}He Thong Da Tat.");
        if(BankControls[VaultDoorState] != 0) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Canh cua dang bi hack hoac dang mo.");
        if(BankControls[DoorInteractionTime] > gettime())
        {
            new string[72];
                format(string, sizeof(string), "ERROR: {FFFFFF}Ban phai cho %s de mo canh cua.", ConvertToMinutes(BankControls[DoorInteractionTime] - gettime()));
                SendClientMessage(playerid, 0xE74C3CFF, string);
                return 1;
        }
        ApplyAnimation(playerid,  "BD_FIRE", "wash_up", 4.0, 1, 0, 0, 0, 0, 1);
        BankControls[DoorInteractionTime] = gettime() + 1200;
        BankControls[VaultDoorState] = 1; // opening
        SetTimerEx("OpenVaultDoor", 1000, false, "ii", 3, 1000);
        SendClientMessage(playerid, -1, "Ban dang tien thanh hack pass");
        SendClientMessageToAll(-1, "Bank Dang Bi Xam Nhap");
        return 1;
}

CMD:laytien(playerid, params[])
{
    if(BankControls[VaultDoorState] < 2) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Ban khong the lay tien vi cua bank chua mo.");
        new id = GetClosestDeposit(playerid);
        if(id == -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Ban khong o gan dia diem lay tien.");
        if(DepositRobbed[id]) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}ban da lay tien hay cho mot chut.");
        DepositRobbed[id] = true;
        Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, InsideVaultLabels[id], E_STREAMER_COLOR, 0xE74C3CFF);
        ApplyAnimation(playerid, "ROB_BANK", "CAT_Safe_Rob", 4.0, 1, 0, 0, 0, 0, 1);
        RobberyType[playerid] = 2;
        RobberyCounter[playerid] = 10;
        RobberyTimer[playerid] = SetTimerEx("RobberyUpdate", 1000, true, "i", playerid);
        return 1;
}
