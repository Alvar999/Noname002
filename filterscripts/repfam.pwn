// Sripter : MrDiHoc
// Fanpage : fb.com/choigta
// Group   : fb.com/group/choigta
// Forum   : forum.choigta.com
// Var
new Text3D:familylabel;
// Add duoi Onplayerconnect
Delete3DTextLabel(familylabel);
// Add Cuoi gamemodes
CMD:repfam(playerid,params[])
{
	if(PlayerInfo[playerid][pFMember] < INVALID_FAMILY_ID)
	{
		new string[128]	;
		if(GetPVarInt(playerid, "RepFam") ==0) 
		{
			new family = PlayerInfo[playerid][pFMember];
		    SetPVarInt(playerid, "RepFam", 1);
		    format(string, 128, "Family : %s\nRank : %i", FamilyInfo[family][FamilyName],PlayerInfo[playerid][pRank]);
		    familylabel = Create3DTextLabel(string, 0x40FFFFFF, 30.0, 40.0, 0.0, 40.0, 0);
		    Attach3DTextLabelToPlayer(familylabel, playerid, 0.0, 0.0, -0.5);
		    SendClientMessage(playerid, -1, "Ban da bat ten family");
		}
		else 
		{
			DeletePVar(playerid, "RepFam");
			Delete3DTextLabel(familylabel);
			SendClientMessage(playerid, -1, "Ban da tat ten family");
		}
	}
	else SendClientMessage(playerid, -1, "Ban khong co trong family");
    return 1;
}