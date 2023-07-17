
#include <a_samp>
#include <ysi\y_hooks>

#define DIALOG_BANCANSA 2602

#define MARIJUANA 43 // So luong Spawn
#define INVALID_FLOAT -1

#define THUHOACH_TIME 10 // 2s = 1 Go
#define TIME_RESPAWN_CANSA 60 // 10s se respawn lai Go
#define TIME_CHEBIEN_CANSA 10 // 5s = 1 tui'

#define GIATUICANSA 7000 // 10k 1 tui

enum marijuana_enum {
	marijuana_id,
	Text3D:marijuana_label,
	bool:marijuana_status,
	Float:marijuana_X,
	Float:marijuana_Y,
	Float:marijuana_Z,
}

new DynamicCP_Harvest[3]; // 0 = Che bien // 1 = Ban

new TimeHarvest[MAX_PLAYERS];
new bool:HarvestCan[MAX_PLAYERS] = false;
new Marijuana[MARIJUANA][marijuana_enum];
new Float:marijuna_pos[MARIJUANA][] = {
	{22.4383,1486.7786,12.7500},
	{27.8525,1493.1648,13.1762},
	{33.6034,1500.1158,13.3456},
	{27.9304,1509.0408,12.7500},
	{20.0060,1518.3362,13.3297},
	{2.0658,1528.4098,13.5074},
	{-8.7291,1525.7211,13.4911},
	{-19.8787,1517.5389,12.7500},
	{-23.3578,1525.6487,13.0163},
	{-12.4662,1526.5966,13.1732},
	{-3.7335,1532.1838,13.4373},
	{28.9400,1523.7725,13.3743},
	{26.5674,1537.3033,13.2495},
	{16.2405,1541.1627,13.5439},
	{4.9616,1538.4583,13.2199},
	{-4.5872,1526.8246,12.7500},
	{-5.8324,1513.6606,12.7500},
	{43.4870,1551.2888,12.7500},
	{31.4887,1546.7561,12.7500},
	{11.9772,1530.3447,12.7500},
	{-12.1339,1511.3788,12.7500},
	{-5.8324,1513.6606,12.7500},
	//
	{-32.8676,1544.0912,12.7500},
	{-7.4581,1564.9795,12.7500},
	{5.4277,1562.5084,12.7500},
	{20.1089,1559.9086,12.7500},
	{33.6029,1564.6974,12.7560},
	{38.2591,1543.1772,12.7500},
	{40.5573,1533.9747,12.7500},
	{48.4457,1527.2223,12.7500},
	{44.3208,1519.4703,12.7500},
	{46.5780,1510.0428,12.7500},
	{53.2310,1510.2994,12.7500},
	{15.1572,1500.1100,12.7500},
	{10.7900,1512.2675,12.7560},
	{-0.3399,1503.9462,12.7560},
	{-11.4369,1503.5757,12.7500},
	{-24.8199,1504.4348,12.7500},
	{-37.8765,1512.1039,12.7560},
	{-40.0640,1525.8958,12.7560},
	{-32.7106,1536.2782,12.7500},
	{-19.6525,1536.6704,12.7560},
	//
	{-23.0702,1512.1006,12.7845}
};

stock IsPlayerNearMarijuana(playerid, Float:range) {
	for(new i = 0 ; i < MARIJUANA; i ++) {
		if(Marijuana[i][marijuana_X] != INVALID_FLOAT && IsPlayerInRangeOfPoint(playerid, 3.0, Marijuana[i][marijuana_X],Marijuana[i][marijuana_Y],Marijuana[i][marijuana_Z]+0.5)) {
			return i;
		}
	}
	return INVALID_FLOAT;
}

forward MarijuanaCreate(iMar);
public MarijuanaCreate(iMar) {
	Marijuana[iMar][marijuana_label] = CreateDynamic3DTextLabel("[{00cc00}Cay Go{ffffff}]\n{FFFFFF}(/chatgo)", -1, marijuna_pos[iMar][0],marijuna_pos[iMar][1],marijuna_pos[iMar][2]-0.2, 5);
	Marijuana[iMar][marijuana_id] = CreateDynamicObject(655, marijuna_pos[iMar][0],marijuna_pos[iMar][1],marijuna_pos[iMar][2]-1.2, 0,0,0);

	Marijuana[iMar][marijuana_X] = marijuna_pos[iMar][0],
	Marijuana[iMar][marijuana_Y] = marijuna_pos[iMar][1],
	Marijuana[iMar][marijuana_Z] = marijuna_pos[iMar][2];

	Marijuana[iMar][marijuana_status] = false;
	//printf("[MARIJUANA] Marijuana %d | X%f | Y%f | Z%f", iMar, Marijuana[iMar][marijuana_X],Marijuana[iMar][marijuana_Y],Marijuana[iMar][marijuana_Z]);
	return 1;
}

forward OnPlayerHarvestMarijuana(playerid, iMar);
public OnPlayerHarvestMarijuana(playerid, iMar) {

	// Player
	ClearAnimations(playerid);
	HarvestCan[playerid] = false;
	PlayerInfo[playerid][pCansa] ++; // Can sa + 1
	TogglePlayerControllable(playerid, true);
	SendClientMessage(playerid, -1, "[{00b300}GRN-VN{ffffff}]: Ban da nhan duoc 1 Go !");
	RemovePlayerWeapon(playerid, 9);
	// Marijuana Var
	Marijuana[iMar][marijuana_X] = INVALID_FLOAT; //
	DestroyDynamicObject(Marijuana[iMar][marijuana_id]);
	DestroyDynamic3DTextLabel(Marijuana[iMar][marijuana_label]);
	SetTimerEx("MarijuanaCreate", TIME_RESPAWN_CANSA*1000, 0, "d", iMar);
	// Debug
	printf("Destroy Marijuana %d", iMar);
	return 1;
}

forward OnPlayerCBCannabis(playerid);
public OnPlayerCBCannabis(playerid) {
	if(PlayerInfo[playerid][pCansa] >= 2) {
		PlayerInfo[playerid][pCansa] -= 2;
		PlayerInfo[playerid][pTuicansa] ++;
		SendClientMessage(playerid, -1, "[{00b300}GRN-VN{ffffff}]: Ban da nhan 1 tui Go!");
	}
	else {
		SetPVarInt(playerid, "DangCheBien", 0);
		TogglePlayerControllable(playerid, true); // Freeze player
		SendClientMessage(playerid, -1, "[{00b300}GRN-VN{ffffff}]: Ban da che bien thanh cong!");
		KillTimer(PlayerInfo[playerid][pChebienTime]);
	}
	return 1;
}

hook OnGameModeInit() {
	new i = 0;
	while(i < MARIJUANA) {
		MarijuanaCreate(i);
		i ++;
	}

	CreateDynamicObject(1578, -734.9782, 1546.1810, 38.7007, 0.0000, 0.0000, 0.0000); //drug_green
	CreateDynamicObject(2370, -734.8424, 1545.8629, 37.9039, 0.0000, 0.0000, -0.6999); //Shop_set_1_Table
	CreateDynamicObject(1578, -734.9782, 1546.8013, 38.7007, 0.0000, 0.0000, 0.0000); //drug_green
	CreateDynamicObject(1578, -734.2282, 1546.8013, 38.7007, 0.0000, 0.0000, 0.0000); //drug_green
	CreateDynamicObject(1578, -734.2282, 1546.1707, 38.7007, 0.0000, 0.0000, 0.0000); //drug_green
	CreateDynamicObject(1578, -734.9782, 1545.5705, 38.7007, 0.0000, 0.0000, 0.0000); //drug_green
	CreateDynamicObject(1578, -734.2282, 1545.5601, 38.7007, 0.0000, 0.0000, 0.0000); //drug_green

	DynamicCP_Harvest[0] = CreateDynamicCP(2355.8970,-648.1890,128.0547, 1, .streamdistance = 2); // Che bien
	//DynamicCP_Harvest[1] = CreateDynamicCP(2850.9456,-1532.5598,11.0991, 1, .streamdistance = 2); // Ban
	DynamicCP_Harvest[2] = CreateDynamicCP(-380.8940,1113.2659,19.6427, 1, .streamdistance = 2);
	return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
	if(HarvestCan[playerid] == true) { // Kiem tra neu nguoi choi dang thu hoach
		KillTimer(TimeHarvest[playerid]); // Dung timer.
		Marijuana[GetPVarInt(playerid, "_iMarijuana")][marijuana_status] = false; // Cay co the thu hoach
	}
	if(GetPVarInt(playerid, "DangCheBien") == 1) {
		KillTimer(PlayerInfo[playerid][pChebienTime]);
	}
	return 1;
}

public OnPlayerEnterDynamicCP(playerid, checkpointid) {
	if(checkpointid == DynamicCP_Harvest[0]) {// Che bien
		if(PlayerInfo[playerid][pCansa] >= 2) { // 2 Go = 1 tui Go
			if(GetPVarInt(playerid, "DangCheBien") == 0)
			{
			TogglePlayerControllable(playerid, false); // Freeze player
			SetPVarInt(playerid, "DangCheBien", 1);
			SendClientMessage(playerid, -1,"[{00b300}GRN-VN{ffffff}]: Dang che bien!!!!");
			PlayerInfo[playerid][pChebienTime] = SetTimerEx("OnPlayerCBCannabis", TIME_CHEBIEN_CANSA*1000, 1, "i", playerid);
			}
		}
		else
			SendClientMessage(playerid, -1,"[{00b300}GRN-VN{ffffff}]: Ban can phai co 2 Go de co the che bien!");
	}
	/*if(checkpointid == DynamicCP_Harvest[1]) { // Ban Go
		if(PlayerInfo[playerid][pTuicansa] > 0) {
			new string[128];
			format(string, 128, "Go cua ban: %d\nGia tien $%d/tui\nNhap so luong ban muon ban:", PlayerInfo[playerid][pTuicansa], GIATUICANSA);
			ShowPlayerDialog(playerid, DIALOG_BANCANSA, DIALOG_STYLE_INPUT, "Ban Go", string,"Ban","Huy");
		}
		else
			SendClientMessage(playerid, -1,"[{00b300}GRN-VN{ffffff}]: Ban can phai co Go de buoc vao day!");
	}*/
/*	if(checkpointid == DynamicCP_Harvest[2]) {
		if(PlayerInfo[playerid][pGoiPot] >= 20) {
			if(GetPVarInt(playerid, "DangCheBien") == 0)
			{
			TogglePlayerControllable(playerid, false);
			SetPVarInt(playerid, "DangCheBien", 1);
			SendClientMessage(playerid, -1,"Dang doi pot xin vui long doi.........");
			PlayerInfo[playerid][pChebienTime] = SetTimerEx("OnPlayerCBCannabisss", TIME_CHEBIEN_CANSA*1000, 1, "i", playerid);
			}
		}
		else
			SendClientMessage(playerid, -1,"[{00b300}GRN-VN{ffffff}]: Ban can phai co 20 Goi pot");
	}*/
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
	if(dialogid == DIALOG_BANCANSA) {
		if(response) {
			if(strval(inputtext) > 0) {
				if(PlayerInfo[playerid][pTuicansa] >= strval(inputtext)) {
					new string[128];
					PlayerInfo[playerid][pTuicansa] -= strval(inputtext);
					GivePlayerCash(playerid, strval(inputtext)*GIATUICANSA);
					format(string, 128, "[{00b300}GRN-VN{ffffff}]: Ban da ban %d khoi va nhan duoc $%d tien", strval(inputtext), strval(inputtext)*GIATUICANSA);
					SendClientMessage(playerid, -1, string);
				}
				else
					SendClientMessage(playerid, -1,"[{00b300}GRN-VN{ffffff}]: So luong khong hop le! hay kiem tra lai so luong cua ban");
			}
			else
				SendClientMessage(playerid, -1,"[{00b300}GRN-VN{ffffff}]: So luong can ban phai lon hon 0!");
		}
	}
	return 1;
}

CMD:chatgo(playerid) {
	new iMarijuana = IsPlayerNearMarijuana(playerid, 1);
    if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "[{00b300}GRN-VN{ffffff}]: Vui long xuong xe");
	if(PlayerCuffed[playerid] >= 1 || PlayerInfo[playerid][pJailTime] > 0 || GetPVarInt(playerid, "Injured")) return SendClientMessageEx( playerid, COLOR_WHITE, "Ban khong the lam dieu do vao luc nay" );
	if(iMarijuana == INVALID_FLOAT) SendClientMessage(playerid, -1, "[{00b300}GRN-VN{ffffff}]: Ban khong dung gan cay nao de thu hoach ca!");
	else {
		if(Marijuana[iMarijuana][marijuana_status] == false) {
			if(HarvestCan[playerid] == false) {
				if(PlayerInfo[playerid][pCansa] < 50) {
					HarvestCan[playerid] = true; // Bat dau hai
					Marijuana[iMarijuana][marijuana_status] = true; // Chuyen trang thai tu chua bi hai thanh bi hai cua Go
					TogglePlayerControllable(playerid, false); // Freeze nguoi choi lai.
					SetPVarInt(playerid, "_iMarijuana", iMarijuana);
					GivePlayerWeapon(playerid, 9, 1000);
					ApplyAnimation(playerid, "PED", "BIKE_elbowL", 4.1, 1, 0, 0, 1, 0); // Thuc hien thanh dong (RP)
					SendClientMessage(playerid, -1, "[{00b300}GRN-VN{ffffff}]: Ban dang chat Go ...");
					TimeHarvest[playerid] = SetTimerEx("OnPlayerHarvestMarijuana", THUHOACH_TIME*1000, 0, "ii", playerid, iMarijuana); // Timer thu hoach

				}
				else
					SendClientMessage(playerid, -1, "[{00b300}GRN-VN{ffffff}]: Go da day` ! Ban can di che bien");
			}
			else
				SendClientMessage(playerid, -1, "[{00b300}GRN-VN{ffffff}]: Ban khong the thuc hien vao luc nay!");
		}
		else
			SendClientMessage(playerid, -1, "[{00b300}GRN-VN{ffffff}]: Cay nay dang co nguoi thu hoach");
	}
	return 1;
}

CMD:caygo(playerid) {
	new string[32+11];
	format(string, 32+11, "Go : %d", PlayerInfo[playerid][pCansa]);
	SendClientMessage(playerid, -1, string);
	format(string, 32+11, "Go Tinh che: %d", PlayerInfo[playerid][pTuicansa]);
	SendClientMessage(playerid, -1, string);
	return 1;
}

CMD:bango(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 5.0, 2850.9456,-1532.5598,11.0991))
	{
		if(PlayerInfo[playerid][pTuicansa] > 0)
		{
			new string[128];
			format(string, 128, "Go cua ban: %d\nGia tien $%d/tui\nNhap so luong ban muon ban:", PlayerInfo[playerid][pTuicansa], GIATUICANSA);
			ShowPlayerDialog(playerid, DIALOG_BANCANSA, DIALOG_STYLE_INPUT, "Ban Go", string,"Ban","Huy");
		}
		else SendClientMessage(playerid, -1,"[{00b300}GRN-VN{ffffff}]: Ban can phai co Go tinh che de buoc vao day!");
	}
	return 1;
}

