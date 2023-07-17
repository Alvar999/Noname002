Em moi tap choi code samp nen mng thong cam

forward AntiHackSpeedCar();
public AntiHackSpeedCar()
{
foreach(new playerid : Player) {
new newcar = GetPlayerVehicleID(playerid), Float:pos[3];
if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && !IsAPlane(newcar) && !IsABoat(newcar))
{
if(GetSpeedKM(playerid) > 180)
{
GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
SetPlayerPos(playerid, pos[0], pos[1], pos[2]+5);
SendClientMessageEx(playerid, COLOR_LIGHTRED, "Tat [Hacking] Ngay Neu May Con Thuong Bo Me May");
FlyCar[playerid] += 1;
//====//
if(FlyCar[playerid] == 2)
{
new string[256];
format(string, sizeof(string), "AdmCmd: %s da bi kick boi System, Ly do: Hack Speed Car", GetPlayerNameEx(playerid));
SendClientMessageToAllEx(COLOR_LIGHTRED, string);
KickWithMessage(playerid, "Ban da bi kick, ly do: Hack Speed Car");
}
}
}
}
}

/*forward AntiHackFly();
public AntiHackFly()
{
foreach(new playerid : Player) {
new closestcar = GetClosestCar(playerid);
if(PlayerInfo[playerid][pAdmin] == 0 && GetPVarInt(playerid, "Injured") == 0 && GetPlayerAnimationIndex(playerid) != 1130 && GetPlayerAnimationIndex(playerid) != 984)
{
if(!IsPlayerInAnyVehicle(playerid))
{
if(!IsPlayerInRangeOfVehicle(playerid, closestcar, 20.0))
{
if(GetSpeedPlayer(playerid) > 200)
{
new string[128];
format(string, sizeof(string), "AdmCmd: %s da bi kick boi System, ly do: Hack Fly", GetPlayerNameEx(playerid));
SendClientMessageToAll(COLOR_LIGHTRED, string);
KickWithMessage(playerid, "Ban da bi kick, Ly do: Hack Fly");
}
}
}
}
}
}

forward spam2(playerid);
public spam2(playerid)
{
DeletePVar(playerid, "spam1");
return 1;
}*/
