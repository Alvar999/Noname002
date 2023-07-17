//============================== BE PHUONG 3 TUOI ============================//
//========================== fb.com/nguyenduyphuong.dz =======================//

#include <YSI\y_hooks>

new HeThongTaiXiu = 0;
new Phientaixiu = 1;
new KetQuaTaiXiu = 0;
new TimeTaiXiu = 300;
new ChonTaiAll = 0;
new ChonXiuAll = 0;
new TienCuocTaiAll = 0;
new TienCuocTraAll = 0;
new TienCuocXiuAll = 0;
new IdTaiWin = -1;
new IdXiuWin = -1;
new TienIdTaiWin = -1;
new TienIdXiuWin = -1;
new TTPhienTaiXiu[10000][500];
new TTWinTaiXiu[10000][500];
new ChonTaiXiu[MAX_PLAYERS];
new TimeChonTaiXiu[MAX_PLAYERS];
new TienCuocTaiXiu[MAX_PLAYERS];

hook OnPlayerConnect(playerid)
{
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if(ChonTaiXiu[playerid] == 1)
    {
        ChonTaiAll--;
        TienCuocTaiAll -= TienCuocTaiXiu[playerid];
        TienCuocTaiXiu[playerid] = 0;
        ChonTaiXiu[playerid] = 0;
    }
    if(ChonTaiXiu[playerid] == 2)
    {
        ChonXiuAll--;
        TienCuocXiuAll -= TienCuocTaiXiu[playerid];
        TienCuocTaiXiu[playerid] = 0;
        ChonTaiXiu[playerid] = 0;
    }
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	return 1;
}

hook OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

CMD:edittaixiu(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 99999)
 	{
		new chon[32];
	    if(sscanf(params, "s[32]", chon))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /edittaixiu [ chon ]");
			SendClientMessageEx(playerid, COLOR_GREY, "chon: tai - xiu - ngaunhien - thang - thua");
			return 1;
		}
		else if(strcmp(chon,"tai",true) == 0)
		{
	        HeThongTaiXiu = 1;
	        SendClientMessageEx(playerid, -1,"ban da thay doi he thong Tai Xiu là [TAI]");
		}
		else if(strcmp(chon,"xiu",true) == 0)
		{
	        HeThongTaiXiu = 2;
	        SendClientMessageEx(playerid, -1,"ban da thay doi he thong Tai Xiu là [XIU]");
		}
		else if(strcmp(chon,"ngaunhien",true) == 0)
		{
	        HeThongTaiXiu = 0;
	        SendClientMessageEx(playerid, -1,"ban da thay doi he thong Tai Xiu là [Ngau Nhien]");
		}
		else if(strcmp(chon,"thang",true) == 0)
		{
	        HeThongTaiXiu = 3;
	        SendClientMessageEx(playerid, -1,"ban da thay doi he thong Tai Xiu là [ben nao nhieu tien cuoc ben do thang]");
		}
		else if(strcmp(chon,"thua",true) == 0)
		{
	        HeThongTaiXiu = 4;
	        SendClientMessageEx(playerid, -1,"ban da thay doi he thong Tai Xiu là [ben nao it tien cuoc ben do thang]");
		}
	}
	return 1;
}
CMD:taixiu(playerid, params[])
{

    new string[128], chon[32],tiencuoc;
	if(sscanf(params, "s[32]d", chon, tiencuoc))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /taixiu [ chon ] [so tien cuoc]");
		SendClientMessageEx(playerid, COLOR_GREY, "chon: tai - xiu");
		SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /taixiuinfo de xem danh sách cuoc");
		SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /thongtinphien de xem chi tiet cua Phien");
		return 1;
	}
	else if(tiencuoc < 1 || tiencuoc > 5000000) return SendClientMessageEx(playerid, COLOR_GREY, "[TAI XIU] - thông báo - tien cuoc khong the nho hon 1 va lon hon 5 trieu");
	else if(ChonTaiXiu[playerid] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "[TAI XIU] - thông báo - ban da dat cuoc roi");
	else if(PlayerInfo[playerid][pCash] < tiencuoc) return SendClientMessageEx(playerid, COLOR_GREY, "[TAI XIU] - thông báo - ban khong co nhieu tien de dat cuoc");
    else if(strcmp(chon,"tai",true) == 0)
	{
        ChonTaiXiu[playerid] = 1;
        TienCuocTaiXiu[playerid] = tiencuoc;
        GivePlayerCash(playerid,-tiencuoc);
        ChonTaiAll++;
        TienCuocTaiAll += tiencuoc;
        TimeChonTaiXiu[playerid] = TimeTaiXiu;
        format(string,sizeof(string),"[tai xiu]ban da dat cuoc %d$ vao{ff0000} Tai{FFFFFF} o Phien [tai xiu] so %d",tiencuoc,Phientaixiu);
        SendClientMessageEx(playerid, -1, string);
        if(tiencuoc > TienIdTaiWin)
        {
            IdTaiWin = playerid;
            TienIdTaiWin = tiencuoc;
        }
	}
	else if(strcmp(chon,"xiu",true) == 0)
	{
        ChonTaiXiu[playerid] = 2;
        TienCuocTaiXiu[playerid] = tiencuoc;
        GivePlayerCash(playerid,-tiencuoc);
        ChonXiuAll++;
        TienCuocXiuAll += tiencuoc;
        TimeChonTaiXiu[playerid] = TimeTaiXiu;
        format(string,sizeof(string),"[tai xiu]ban da dat cuoc %d$ vao{3aea46} Xiu{FFFFFF} o Phien [tai xiu] so %d",tiencuoc,Phientaixiu);
        SendClientMessageEx(playerid, -1, string);
        if(tiencuoc > TienIdXiuWin)
        {
            IdXiuWin = playerid;
            TienIdXiuWin = tiencuoc;
        }
	}
	return 1;
}
CMD:taixiuinfo(playerid, params[])
{//3aea46
	new string[128],taixiu[32],taixiuid[32],string2[1024];
	switch(ChonTaiXiu[playerid])
	{
		case 1: taixiu = "{ff0000}Tai{ffffff}";
		case 2: taixiu = "{ffec8b}Xiu{ffffff}";
    }
	format(string,sizeof(string),"{FFFFFF}_____________{ffec8b}Tai Xiu{FF0000}[%d]_{FFFF00}[con %d giay]{FFFFFF}_____________",Phientaixiu,TimeTaiXiu);
	SendClientMessageEx(playerid, -1, string);
	format(string,sizeof(string),"{ff0000}Tai {ffffff}(%d nguoi)>>> VS <<<{3aea46}Xiu {ffffff}(%d nguoi)",ChonTaiAll,ChonXiuAll);
	SendClientMessageEx(playerid, -1, string);
	format(string,sizeof(string),"{ff0000}Tai {2d68cc}($%s)>>> VS <<<{3aea46}Xiu {2d68cc}($%s)",number_format(TienCuocTaiAll),number_format(TienCuocXiuAll));
	SendClientMessageEx(playerid, -1, string);
	if(ChonTaiXiu[playerid] > 0)
	{
		format(string,sizeof(string),"ban da dat cuoc vao %s so tien %s $",taixiu,number_format(TienCuocTaiXiu[playerid]));
 		SendClientMessageEx(playerid, -1, string);
	}
	new szDialog[1024];
	foreach(new i: Player)
	{
	    switch(ChonTaiXiu[i])
		{
			case 1: taixiuid = "{ff0000}Tai{ffffff}";
			case 2: taixiuid = "{2d68cc}Xiu{ffffff}";
    	}
		if(ChonTaiXiu[i] > 0)
		{
			format(szDialog, sizeof(szDialog), "%s\n%s\t%s\t%s", szDialog, GetPlayerNameEx(i),taixiuid,number_format(TienCuocTaiXiu[i]));
		}
	}
	format(string2,sizeof(string2),"Ten\tDat cuoc vao\tso tien\n%s",szDialog);
	if(!isnull(szDialog))
	{
 		strdel(szDialog, 0, 1);
	  	ShowPlayerDialog(playerid, 123,DIALOG_STYLE_TABLIST_HEADERS, "Tai Xiu info",string2,"chon", "thoat");
 	}
	return 1;
}
CMD:thongtinphien(playerid, params[])
{
	new number;
    if(sscanf(params, "d", number))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /thongtinphien [phien]");
	}
	new string1[128];
	format(string1,sizeof(string1),"Phieu Tai Xiu %d",number);
    SetPVarInt(playerid,"phien",number);
  	ShowPlayerDialog(playerid, 123,DIALOG_STYLE_LIST,string1,TTPhienTaiXiu[number],"chon", "thoat");

	return 1;
}
///
task eventtaixiu[1000]()
{
    if(TimeTaiXiu > 0)
	{
	    TimeTaiXiu--;
	}
	if(TimeTaiXiu == 0)
	{
	    new string[1024],string2[1024],ketqua[32];
	    if(HeThongTaiXiu == 0)
	    {
			switch(random(4))
			{
	        	case 0,2: KetQuaTaiXiu = 1;
				case 1,3: KetQuaTaiXiu = 2;
			}
		}
		if(HeThongTaiXiu == 1)
	    {
			KetQuaTaiXiu = 1;
		}
		if(HeThongTaiXiu == 2)
	    {
			KetQuaTaiXiu = 2;
		}
		if(HeThongTaiXiu == 3 && TienCuocTaiAll > TienCuocXiuAll)
	    {
			KetQuaTaiXiu = 1;
		}
		if(HeThongTaiXiu == 3 && TienCuocTaiAll < TienCuocXiuAll)
	    {
			KetQuaTaiXiu = 2;
		}
		if(HeThongTaiXiu == 3 && TienCuocTaiAll == TienCuocXiuAll)
	    {
			switch(random(4))
			{
	        	case 0,2: KetQuaTaiXiu = 1;
				case 1,3: KetQuaTaiXiu = 2;
			}
		}
		if(HeThongTaiXiu == 4 && TienCuocTaiAll > TienCuocXiuAll)
	    {
			KetQuaTaiXiu = 2;
		}
		if(HeThongTaiXiu == 4 && TienCuocTaiAll < TienCuocXiuAll)
	    {
			KetQuaTaiXiu = 1;
		}
		if(HeThongTaiXiu == 4 && TienCuocTaiAll == TienCuocXiuAll)
	    {
			switch(random(4))
			{
	        	case 0,2: KetQuaTaiXiu = 1;
				case 1,3: KetQuaTaiXiu = 2;
			}
		}
		switch(KetQuaTaiXiu)
		{
		    case 1: ketqua = "{ff0000}Tai{ffffff}";
		    case 2: ketqua = "{3aea46}Xiu{ffffff}";
		}
		new totalwealth;
		totalwealth = TienCuocTaiAll + TienCuocXiuAll - TienCuocTraAll;
	    foreach(new i: Player)
		{
			if(TimeChonTaiXiu[i] < 10)
			{
			    if(TienCuocTaiXiu[i] > 0)
			    {
					format(string,sizeof(string),"[tai xiu]ban duoc tra lai %d$ va loai khoi phien nay de can bang giua tai va xiu",TienCuocTaiXiu[i]);
            		SendClientMessageEx(i, -1, string);
            		SendClientMessageEx(i, -1, "[TAI XIU] Co gang tham gia som hon de khong bi loai ra nhe");
            		GivePlayerCash(i,TienCuocTaiXiu[i]);
                    TienCuocTraAll = TienCuocTraAll + TienCuocTaiXiu[i];
				}
				if(TienCuocTaiAll == 0 && KetQuaTaiXiu == 1)
				{
            		format(string,sizeof(string),"[TAI XIU] Phien so %d tuyen bo: %s thang( Tong tien cuoc: %s$)",Phientaixiu,ketqua,number_format(totalwealth));
            		SendClientMessageEx(i, -1, string);
				}
				if(TienCuocTaiAll > 0 && KetQuaTaiXiu == 1)
				{
            		format(string,sizeof(string),"[TAI XIU] Phien so %d tuyen bo: %s thang( Tong tien cuoc: %s$ - An nhieu nhat: %s [%s$])",Phientaixiu,ketqua,number_format(totalwealth),GetPlayerNameEx(IdTaiWin),number_format(TienIdTaiWin*2));
            		SendClientMessageEx(i, -1, string);
				}
				if(TienCuocXiuAll == 0 && KetQuaTaiXiu == 2)
				{
            		format(string,sizeof(string),"[TAI XIU] Phien so %d tuyen bo: %s thang( Tong tien cuoc: %s$)",Phientaixiu,ketqua,number_format(totalwealth));
            		SendClientMessageEx(i, -1, string);
				}
				if(TienCuocXiuAll > 0 && KetQuaTaiXiu == 2)
				{
            		format(string,sizeof(string),"[TAI XIU] Phien so %d tuyen bo: %s thang( Tong tien cuoc: %s$ - An nhieu nhat: %s [%s$])",Phientaixiu,ketqua,number_format(totalwealth),GetPlayerNameEx(IdXiuWin),number_format(TienIdXiuWin*2));
            		SendClientMessageEx(i, -1, string);
				}
            	ChonTaiXiu[i] = 0;
				TimeChonTaiXiu[i] = 0;
				TienCuocTaiXiu[i ]= 0;
			}
			if(TimeChonTaiXiu[i] >= 10)
			{
				if(ChonTaiXiu[i] == KetQuaTaiXiu)
				{
     				if(TienCuocTaiAll == 0 && KetQuaTaiXiu == 1)
					{
	            		format(string,sizeof(string),"[TAI XIU] Phien so %d tuyen bo: %s thang( Tong tien cuoc: %s$)",Phientaixiu,ketqua,number_format(totalwealth));
	            		SendClientMessageEx(i, -1, string);
					}
					if(TienCuocTaiAll > 0 && KetQuaTaiXiu == 1)
					{
	            		format(string,sizeof(string),"[TAI XIU] Phien so %d tuyen bo: %s thang( Tong tien cuoc: %s$ - An nhieu nhat: %s [%s$])",Phientaixiu,ketqua,number_format(totalwealth),GetPlayerNameEx(IdTaiWin),number_format(TienIdTaiWin*2));
	            		SendClientMessageEx(i, -1, string);
					}
					if(TienCuocXiuAll == 0 && KetQuaTaiXiu == 2)
					{
	            		format(string,sizeof(string),"[TAI XIU] Phien so %d tuyen bo: %s thang( Tong tien cuoc: %s$)",Phientaixiu,ketqua,number_format(totalwealth));
	            		SendClientMessageEx(i, -1, string);
					}
					if(TienCuocXiuAll > 0 && KetQuaTaiXiu == 2)
					{
	            		format(string,sizeof(string),"[TAI XIU] Phien so %d tuyen bo: %s thang( Tong tien cuoc: %s$ - An nhieu nhat: %s [%s$])",Phientaixiu,ketqua,number_format(totalwealth),GetPlayerNameEx(IdXiuWin),number_format(TienIdXiuWin*2));
	            		SendClientMessageEx(i, -1, string);
					}
	            	format(string,sizeof(string),"[TAI XIU] ban da thang trong phien nay va ban nhan duoc %d$",TienCuocTaiXiu[i]*2);
	            	SendClientMessageEx(i, -1, string);
	            	format(string2, sizeof(string2),"%s\n%s\t%s",
					string2,
					GetPlayerNameEx(i),number_format(TienCuocTaiXiu[i]));
	            	GivePlayerCash(i,TienCuocTaiXiu[i]-TienCuocTaiXiu[i]*3/100);
	            	GivePlayerCash(i,TienCuocTaiXiu[i]);
	            	ChonTaiXiu[i] = 0;
					TimeChonTaiXiu[i] = 0;
					TienCuocTaiXiu[i ]= 0;
				}
				else if(ChonTaiXiu[i] != KetQuaTaiXiu)
				{
	         		if(TienCuocTaiAll == 0 && KetQuaTaiXiu == 1)
					{
	            		format(string,sizeof(string),"[TAI XIU] Phien so %d tuyen bo: %s thang( Tong tien cuoc: %s$)",Phientaixiu,ketqua,number_format(totalwealth));
	            		SendClientMessageEx(i, -1, string);
					}
					if(TienCuocTaiAll > 0 && KetQuaTaiXiu == 1)
					{
	            		format(string,sizeof(string),"[TAI XIU] Phien so %d tuyen bo: %s thang( Tong tien cuoc: %s$ - An nhieu nhat: %s [%s$])",Phientaixiu,ketqua,number_format(totalwealth),GetPlayerNameEx(IdTaiWin),number_format(TienIdTaiWin*2));
	            		SendClientMessageEx(i, -1, string);
					}
					if(TienCuocXiuAll == 0 && KetQuaTaiXiu == 2)
					{
	            		format(string,sizeof(string),"[TAI XIU] Phien so %d tuyen bo: %s thang( Tong tien cuoc: %s$)",Phientaixiu,ketqua,number_format(totalwealth));
	            		SendClientMessageEx(i, -1, string);
					}
					if(TienCuocXiuAll > 0 && KetQuaTaiXiu == 2)
					{
	            		format(string,sizeof(string),"[TAI XIU] Phien so %d tuyen bo: %s thang( Tong tien cuoc: %s$ - An nhieu nhat: %s [%s$])",Phientaixiu,ketqua,number_format(totalwealth),GetPlayerNameEx(IdXiuWin),number_format(TienIdXiuWin*2));
	            		SendClientMessageEx(i, -1, string);
					}
	            	if(ChonTaiXiu[i] > 0)
	            	{
	            		SendClientMessageEx(i, -1, "[TAI XIU] ban da thua trong phien nay");
					}
	            	ChonTaiXiu[i] = 0;
					TimeChonTaiXiu[i] = 0;
					TienCuocTaiXiu[i ]= 0;
				}
			}
		}
		new year, month, day;
		getdate(year, month, day);
		format(TTPhienTaiXiu[Phientaixiu], sizeof(string), "Thoi gian: %d/%d/%d - %d:%d:%d\n\
		Ket qua: %s\n\
		Tong tien tai: %s\n\
		Tong tien xiu: %s\n\
		Tong tien hoan tra: %s\n\
		{ffec8b}>> chi tiet nguoi thang cuoc",
		month, day, year, hour, minuite,second,
		ketqua,
		number_format(TienCuocTaiAll),
		number_format(TienCuocXiuAll),
		number_format(TienCuocTraAll));
	 	format(TTWinTaiXiu[Phientaixiu], sizeof(string2), "%s",string2);
		Phientaixiu++;
		KetQuaTaiXiu = 0;
		TimeTaiXiu = 120;
		ChonTaiAll = 0;
		ChonXiuAll = 0;
		TienCuocTaiAll = 0;
		TienCuocXiuAll = 0;
		IdTaiWin = -1;
		IdXiuWin = -1;
		TienIdTaiWin = -1;
		TienIdXiuWin = -1;
		TienCuocTraAll = 0;
	}
	return 1;
}
