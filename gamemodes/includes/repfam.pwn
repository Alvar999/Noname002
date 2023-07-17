
#include <YSI\y_hooks>

new Text3D:fRepfamtext[MAX_PLAYERS];
new fRepfam[MAX_PLAYERS];
new fRepfamTimer[MAX_PLAYERS];

CMD:ondutygangs(playerid, params[])
{
 new
  string[128],
  iGroupID = PlayerInfo[playerid][pMember],
  iRank = PlayerInfo[playerid][pRank];
 if(gettime() < fRepfamTimer[playerid])
 {
  SendClientMessageEx(playerid, COLOR_GRAD1, "Ban Phai Doi 1P Truoc Khi Su Dung Tiep Tuc Lenh Nay");
  return 1;
 }
 if(PlayerInfo[playerid][pFMember] == INVALID_FAMILY_ID || iGroupID != INVALID_GROUP_ID)
 {
        if(fRepfam[playerid] == 1)
        {
   			SendClientMessageEx(playerid, COLOR_RED, "Ban Da Tat REPFAM.");
   			Delete3DTextLabel(fRepfamtext[playerid]);
 			fRepfam[playerid] = 0;
        }
        else
        {
   			//new fam = PlayerInfo[playerid][pFMember];
            fRepfamTimer[playerid] = gettime()+60;
            SendClientMessageEx(playerid, COLOR_GREEN, "Ban Da Bat REPFAM");
            format(string, sizeof(string), "{%s}%s", Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName]);
            fRepfam[playerid] = 1;
            fRepfamtext[playerid] = Create3DTextLabel(string, 0xFFFFFFFF, 0, 0, 0, 25, 0, 1);
            Attach3DTextLabelToPlayer(fRepfamtext[playerid], playerid, 0.0, 0.0, 0.0);
        }
    }
    else
    {
        SendClientMessageEx(playerid, COLOR_GRAD1, "Ban Khong O To Chuc Nao Do");
    }
    return 1;
}


/*forward RepFamNames(playerid);
public RepFamNames(playerid) {
	if (GetPVarInt(playerid, "RepFam") == 1)
	{
		new fam = GetPVarInt(playerid, "gt_Fam");
		SetPlayerChatBubble(playerid,FamilyInfo[fam][FamilyName],FamilyInfo[fam][FamilyColor],25.0,500);
	}
}

hook OnPlayerConnect(playerid) {
    SetPVarInt(playerid,"RepFam",0);
    RepFam[playerid] = 0;
    RepFamTimer[playerid] = 0;
} */


hook OnPlayerDisconnect(playerid) {
	if(fRepfam[playerid] == 1)  {
        fRepfam[playerid] = 0;
        Delete3DTextLabel(fRepfamtext[playerid]);
        fRepfamTimer[playerid] = 0;
	}
	return 1;
}

