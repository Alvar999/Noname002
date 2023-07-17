#include <YSI\y_hooks>

CMD:khaithacda(playerid, params[])
{
    if(PlayerInfo[playerid][pJob] == 35)
    {
        new randomselect = random(16);
		switch(randomselect)
		{
			case 0: SetPlayerCheckpoint(playerid,603.6992,928.3613,-41.4224, 2);
			case 1: SetPlayerCheckpoint(playerid,603.9424,924.8304,-41.8789, 2);
			case 2: SetPlayerCheckpoint(playerid,604.0784,922.1595,-42.2279, 2);
			case 3: SetPlayerCheckpoint(playerid,602.6038,918.4731,-42.7563, 2);
			case 4: SetPlayerCheckpoint(playerid,599.6226,914.5256,-43.7136, 2);
			case 5: SetPlayerCheckpoint(playerid,596.5000,914.5460,-43.6334, 2);
			case 6: SetPlayerCheckpoint(playerid,592.2615,914.3746,-43.2491, 2);
			case 7: SetPlayerCheckpoint(playerid,588.3050,917.0852,-43.0519, 2);
			case 8: SetPlayerCheckpoint(playerid,584.8570,921.9732,-42.6660, 2);
			case 9: SetPlayerCheckpoint(playerid,557.1722,919.7247,-42.9167, 2);
			case 10: SetPlayerCheckpoint(playerid,556.0187,914.9270,-42.7478, 2);
			case 11: SetPlayerCheckpoint(playerid,552.5648,910.9966,-42.5273, 2);
			case 12: SetPlayerCheckpoint(playerid,547.4881,908.6873,-42.5772, 2);
			case 13: SetPlayerCheckpoint(playerid,541.3118,909.8188,-42.2790, 2);
			case 14: SetPlayerCheckpoint(playerid,536.5325,912.9378,-42.6017, 2);
			case 15: SetPlayerCheckpoint(playerid,535.5552,920.5277,-42.2427, 2);
		}
		GivePlayerValidWeapon(playerid, 6, 4);
		KhaiThacCP[playerid] = 1;

    }else SendClientMessage(playerid, -1, "Ban chua nhan cong viec nay.");
	return 1;
}

forward KKBatDau(playerid);
public KKBatDau(playerid)
{
    GameTextForPlayer(playerid, "~y~DANG KHAI THAC DA...", 3000, 3);

	ApplyAnimation(playerid, "BASEBALL", "Bat_4", 4.1, 1, 0, 0, 1, 0, 1);
	SetTimerEx("KKHoanThanh", 30000, 0, "i", playerid);
	return 1;
}

forward KKHoanThanh(playerid);
public KKHoanThanh(playerid)
{
    ClearAnimations(playerid);

	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
	SetPlayerAttachedObject(playerid, 9, 2936, 5, 0.105, 0.086, 0.22, -80.3, 3.3, 28.7, 0.35, 0.35, 0.35, 0, 0);
	KhaiThacCP[playerid] = 2;
	SetPlayerCheckpoint(playerid,600.5392,867.8318,-42.9609, 2);
}

hook OnPlayerEnterCheckpoint(playerid)
{
    if(KhaiThacCP[playerid] == 1)
	{
		DisablePlayerCheckpoint(playerid);
		KKBatDau(playerid);
		return 1;
	}
	if(KhaiThacCP[playerid] == 2)
	{
		new string[1000];
		new money = 2500+random(500);
		DisablePlayerCheckpoint(playerid);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		RemovePlayerAttachedObject(playerid, 9);
		PlayerInfo[playerid][pCash] += money;
		format(string, 1000, "{00FF00}[!] {FFFFFF}Ban da giao thanh cong va nhan duoc %d$\n", money);
		strcat(string,"Su dung : /khaithacda de tiep tuc .");
		ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "KHAI KHOANG",string,"Dong y","");
		DeletePVar(playerid,"KKBatDau");
		DeletePVar(playerid,"KKHoanThanh");

		KhaiThacCP[playerid] = 0;
		return 1;
	}
	return 1;
}
