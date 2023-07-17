

#include <a_samp>
#include <ysi\y_hooks>

#define DIALOG_BANRAU 2005

#define RAUMUONG 12 // So luong Spawn
#define INVALID_FLOAT -1

#define THUHOACH_THOIGIAN 20 // 2s = 1 Bo Rau
#define TIME_RESPAWN_RAUBAN 160 // 120s se respawn lai Rau
#define TIME_RUARAU_RAUBAN 20 // 5s = 1 Bo
#define LAMSACH_THOIGIAN 20 // 10s = 1 Bo Rau

#define GIARAUMUONG 3000 // 3k 1 Bo

enum raumuong_enum {
	raumuong_id,
	Text3D:raumuong_label,
	bool:raumuong_status,
	Float:raumuong_X,
	Float:raumuong_Y,
	Float:raumuong_Z,
}

new TimeLamsach[MAX_PLAYERS];
new DynamicCP_Hairau[2]; // 0 = Rua // 1 = Ban
new TimeHairau[MAX_PLAYERS];
new bool:Hairau[MAX_PLAYERS] = false;
new Raumuong[RAUMUONG][raumuong_enum];
new Float:raumuong_pos[RAUMUONG][] = {
	{-958.4013,-558.3531,25.4829,281.4483},
	{-945.3890,-555.7181,25.6775,281.4483},
	{-928.7277,-554.9111,25.6612,265.4681},
	{-915.0934,-555.9917,25.5848,265.4681},
	{-909.3572,-568.1166,24.0929,176.7940},
	{-926.1577,-571.3970,23.4656,89.0598},
	{-943.5983,-571.3793,23.4384,88.7465},
	{-961.9530,-566.8024,24.2674,63.9929},
	{-974.7053,-562.3823,25.1077,79.6597},
	{-982.2004,-567.7385,24.8446,134.8069},
	{-972.6105,-577.6101,23.1250,238.2079},
	{-958.6008,-585.7993,23.1250,246.3547}
	
};

stock IsPlayerNearRaumuong(playerid, Float:range) {
	for(new i = 0 ; i < RAUMUONG; i ++) {
		if(Raumuong[i][raumuong_X] != INVALID_FLOAT && IsPlayerInRangeOfPoint(playerid, range, Raumuong[i][raumuong_X],Raumuong[i][raumuong_Y],Raumuong[i][raumuong_Z]+0.5)) {
			return i;
		}
	}
	return INVALID_FLOAT;
}

forward RaumuongCreate(iMar);
public RaumuongCreate(iMar) {
	Raumuong[iMar][raumuong_label] = CreateDynamic3DTextLabel("[{00abff}Rau Muong /thuhoach]", -1, raumuong_pos[iMar][0],raumuong_pos[iMar][1],raumuong_pos[iMar][2]-0.2, 5);
	Raumuong[iMar][raumuong_id] = CreateDynamicObject(19833, raumuong_pos[iMar][0],raumuong_pos[iMar][1],raumuong_pos[iMar][2]-1.2, 0,0,0);

	Raumuong[iMar][raumuong_X] = raumuong_pos[iMar][0],
	Raumuong[iMar][raumuong_Y] = raumuong_pos[iMar][1],
	Raumuong[iMar][raumuong_Z] = raumuong_pos[iMar][2];

	Raumuong[iMar][raumuong_status] = false;
	printf("[RAUMUONG] Raumuong %d | X%f | Y%f | Z%f", iMar, Raumuong[iMar][raumuong_X],Raumuong[iMar][raumuong_Y],Raumuong[iMar][raumuong_Z]);
	return 1;
}


forward OnPlayerHarvestLamsach(playerid);
public OnPlayerHarvestLamsach(playerid) {

	// Player
	ClearAnimations(playerid);
	TogglePlayerControllable(playerid, true);
	SendClientMessage(playerid, -1, "{00abff}Nong Dan: Ban Nhan 5 Bo Rau Sach Hay Ban Cho Cac Ba Gia Hang Rong");
	PlayerInfo[playerid][pRausach] +=5; // 5 rau sach
	PlayerInfo[playerid][pRauban] -=5; // -5 rau ban
	return 1;
}

forward OnPlayerHarvestRaumuong(playerid, iMar);
public OnPlayerHarvestRaumuong(playerid, iMar) {

	// Player
	ClearAnimations(playerid);
	Hairau[playerid] = false;
	PlayerInfo[playerid][pRauban] ++; // rau + 1
	TogglePlayerControllable(playerid, true);
	SendClientMessage(playerid, -1, "{00abff}Nong Dan: Ban da nhan duoc 1 Bo Rau Ban !");
	// Raumuong Var
	Raumuong[iMar][raumuong_X] = INVALID_FLOAT; //
	DestroyDynamicObject(Raumuong[iMar][raumuong_id]);
	DestroyDynamic3DTextLabel(Raumuong[iMar][raumuong_label]);
	SetTimerEx("RaumuongCreate", TIME_RESPAWN_RAUBAN*1000, 0, "d", iMar);
	// Debug
	printf("Destroy RauMuong %d", iMar);
	return 1;
}

forward OnPlayerCBCannabiss(playerid);
public OnPlayerCBCannabiss(playerid) {
	if(PlayerInfo[playerid][pRauban] >= 1) {
		PlayerInfo[playerid][pRauban] -= 1;
		PlayerInfo[playerid][pRausach] ++;
		SendClientMessage(playerid, -1, "{00abff}Nong Dan: Ban da nhan 1 Bo Rau Sach!");
	}
	else {
		SetPVarInt(playerid, "DangCheBien", 0);
		TogglePlayerControllable(playerid, true); // Freeze player
		SendClientMessage(playerid, -1, "{00abff}Nong Dan: Ban Da Rua Rau Sach Ban Co The Dem Ban Cho Cac Sieu Thi /trogiupnongdan!");
		KillTimer(PlayerInfo[playerid][pRuarauTime]);
	}
	return 1;
}

hook OnGameModeInit() {
	new i = 0;
	while(i < RAUMUONG) {
		RaumuongCreate(i);
		i ++;
	}

	CreateActor(53,-1969.0382,866.6827,45.2031,274.9900); //NPC BAN RAU
	CreateActor(39,-1761.6367,-189.9472,1.9609,181.1575); // NPC rua rau
	CreateActor(158,-958.4013,-558.3531,25.4829,281.4483); // NPCNONGDAN
	CreateDynamic3DTextLabel("{009933}Vi Tri Rua Sach Rau\n/lamsach\nDe Thuc Hien", COLOR_YELLOW, -1761.6367,-189.9472,1.9609+0.6,18.0);
	CreateDynamic3DTextLabel("{CC0033}Ba Ban Rau\n{009900}/banrau", COLOR_YELLOW, -1969.0382,866.6827,45.2031+0.6,18.0);
	CreateDynamic3DTextLabel("{009933}Nong Dan", COLOR_YELLOW, 1590.4384,-1992.3826,34.4605+0.6,18.0);
	//DynamicCP_Hairau[0] = CreateDynamicCP(-489.1620,610.9698,1.7739, 1, .streamdistance = 2); // Rua
	DynamicCP_Hairau[1] = CreateDynamicCP(-29.0181,-185.1304,1003.5469, 1, .streamdistance = 2); // Ban
	return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
	if(Hairau[playerid] == true) { // Kiem tra neu nguoi choi dang thu hoach
		KillTimer(TimeHairau[playerid]); // Dung timer.
		Raumuong[GetPVarInt(playerid, "_iRaumuong")][raumuong_status] = false; // Rau co the thu hoach
	}
	if(GetPVarInt(playerid, "DangCheBien") == 1) {
		KillTimer(PlayerInfo[playerid][pRuarauTime]);
	}
	return 1;
}


hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
	if(dialogid == DIALOG_BANRAU) {
		if(response) {
			if(strval(inputtext) > 0) {
				if(PlayerInfo[playerid][pRausach] >= strval(inputtext)) {
					new string[128];
					PlayerInfo[playerid][pRausach] -= strval(inputtext);
					GivePlayerCash(playerid, strval(inputtext)*GIARAUMUONG);
					format(string, 128, "{00abff}Nong Dan: Ban da ban %d Rau Sach va nhan duoc $%d", strval(inputtext), strval(inputtext)*GIARAUMUONG);
					SendClientMessage(playerid, -1, string);
				}
				else
					SendClientMessage(playerid, -1,"{00abff}Nong Dan: So luong khong hop le! hay kiem tra lai so luong cua ban");
			}
			else
				SendClientMessage(playerid, -1,"{00abff}Nong Dan: So luong can ban phai lon hon 0!");
		}
	}
	return 1;
}


CMD:kiemtrasoluong(playerid) {
	new string[32+11];
	SendClientMessageEx(playerid, -1,"Tong So Luong Rau Ban Va Sach Cua Ban.");
	format(string, 32+11, "{00CC00}Rau Ban So Luong: %d", PlayerInfo[playerid][pRauban]);
	SendClientMessage(playerid, -1, string);
	format(string, 32+11, "{33CC00}Rau Sach So Luong: %d", PlayerInfo[playerid][pRausach]);
	SendClientMessage(playerid, -1, string);
	return 1;
}
CMD:thuhoach(playerid) {
	new iRaumuong = IsPlayerNearRaumuong(playerid, 1);
    if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "Xuong xe de ban ey");
	if(PlayerCuffed[playerid] >= 1 || PlayerInfo[playerid][pJailTime] > 0 || GetPVarInt(playerid, "Injured")) return SendClientMessageEx( playerid, COLOR_WHITE, "Ban khong the lam dieu do vao luc nay" );
	//if(iRaumuong == INVALID_FLOAT) SendClientMessage(playerid, -1, "{00abff}Nong Dan: Ban khong dung gan cay nao de thu hoach ca!");
	else {
		if(Raumuong[iRaumuong][raumuong_status] == false) {
			if(Hairau[playerid] == false) {
				if(PlayerInfo[playerid][pRauban] < 25) {
					Hairau[playerid] = true; // Bat dau hai
					Raumuong[iRaumuong][raumuong_status] = true; // Chuyen trang thai tu chua bi hai thanh bi hai cua can sa
					TogglePlayerControllable(playerid, false); // Freeze nguoi choi lai.
					SetPVarInt(playerid, "_iRaumuong", iRaumuong);
					ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 1, 0); // Thuc hien thanh dong (RP)
					SendClientMessage(playerid, -1, "{00abff}Nong Dan: Ban dang Thu Hoach");
					SendClientMessage(playerid, -1, "{00abff}Nong Dan: Voi Long Doi Chut...");
					TimeHairau[playerid] = SetTimerEx("OnPlayerHarvestRaumuong", THUHOACH_THOIGIAN*1000, 0, "ii", playerid, iRaumuong); // Timer thu hoach
				}
				else
					SendClientMessage(playerid, -1, "{00abff}Nong Dan: So Luong Trong Nguoi Cua Ban Da Day Ban Can Di Lam Sach");
			}
			else
				SendClientMessage(playerid, -1, "{00abff}Nong Dan: Ban khong the thuc hien vao luc nay!");
		}
		else
			SendClientMessage(playerid, -1, "{00abff}Nong Dan:dang co nguoi thu hoach hay tim cho khac");
	}
	return 1;
}
CMD:lamsach(playerid)
{
		if (IsPlayerInRangeOfPoint(playerid, 3.0, -489.1620,610.9698,1.7739))
        {
				if(PlayerInfo[playerid][pRauban] >= 5) { // rau ban > rau sach
			{
				if(GetPVarInt(playerid, "DangCheBien") == 0)
			  {
			   	TogglePlayerControllable(playerid, false); // Freeze nguoi choi lai.
				ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0); // Thuc hien thanh dong (RP)
				TimeLamsach[playerid] = SetTimerEx("OnPlayerHarvestLamsach", LAMSACH_THOIGIAN*1000, 0, "ii", playerid); // Timer Lam Sach
}
				}
				
			}
				else
				SendClientMessage(playerid, -1,"[{00b300}Nong Dan GvR{33CC33}]:Ban Can So Luong 5 Rau Ban Moi Co The Rua!");	
	
		}
		else
		SendClientMessage(playerid, -1, "Ban Khong Dung Gan Vi Tri Rua Rau");

		return 1;
}
CMD:banrau(playerid)
{
	if (IsPlayerInRangeOfPoint(playerid, 5.0, -214.2878,1091.5020,19.7422)) 
	{
	ShowPlayerDialog(playerid, DIALOG_BANRAU, DIALOG_STYLE_INPUT, "Ban Rau Sach", "Vui Long Nhap So Luong", "O", "X");
	}
	else SendClientMessage(playerid, -1, "Ban khong o gan quay ban hang");
	return 1;
}

 
