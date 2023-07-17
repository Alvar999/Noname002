#define FILTERSCRIPT
#include <a_samp>
#include <zcmd>
#define MAX_OBJ 50
#define SAVING
// -----------------------------------------------------------------------------
enum VutSungEnum
{
	Float:ObjPos[3],
	ObjID,
	ObjData[2]
};
new VutSungDB[MAX_OBJ][VutSungEnum];
// -----------------------------------------------------------------------------
new TenVuKhi[48][] = {
	"Nothink", "Brass Knuckles", "Golf Club", "Nitestick", "Knife", "Baseball Bat",
	"Showel", "Pool Cue", "Katana", "Chainsaw", "Purple Dildo", "Small White Dildo",
	"Long White Dildo", "Vibrator", "Flowers", "Cane", "Grenade", "Tear Gas", "Molotov",
	"Vehicle Missile", "Hydra Flare", "Jetpack", "Glock", "Silenced Colt", "Desert Eagle",
	"Shotgun", "Sawn Off", "Combat Shotgun", "Micro UZI", "MP5", "AK47", "M4", "Tec9",
	"Rifle", "Sniper Rifle", "Rocket Launcher", "HS Rocket Launcher", "Flamethrower", "Minigun",
	"Satchel Charge", "Detonator", "Spraycan", "Fire Extinguisher", "Camera", "Nightvision",
	"Infrared Vision", "Parachute", "Fake Pistol"
};
// -----------------------------------------------------------------------------
new GunObjects[47] = {
	0,331,333,334,335,336,337,338,339,341,321,322,323,324,325,326,342,343,344,
	0,0,0,346,347,348,349,350,351,352,353,355,356,372,357,358,359,360,361,362,
	363,364,365,366,367,368,368,371
};
// -----------------------------------------------------------------------------
public OnFilterScriptInit()
{
	for(new n = 0; n < MAX_OBJ; n++) VutSungDB[n][ObjID] = -1;
 	print("\n");
	print(" Drop Gun ZCMD");
	#if defined SAVING
	new File:file = fopen("FileDropGun.ini", io_read);
    if(file)
    {
        new buffer[256], FileCoords[5][20];
        for(new g = 0; g < MAX_OBJ; g++)
        {
            fread(file, buffer);
            check(buffer, FileCoords, ',');
            VutSungDB[g][ObjPos][0] = floatstr(FileCoords[0]);
			VutSungDB[g][ObjPos][1] = floatstr(FileCoords[1]);
			VutSungDB[g][ObjPos][2] = floatstr(FileCoords[2]);
			VutSungDB[g][ObjData][0] = strval(FileCoords[3]);
			VutSungDB[g][ObjData][1] = strval(FileCoords[4]);
			if(VutSungDB[g][ObjData][0] > 0 && VutSungDB[g][ObjData][1] != 0 && VutSungDB[g][ObjPos][0] != 0)
			{
				VutSungDB[g][ObjID] = CreateObject(GunObjects[VutSungDB[g][ObjData][0]], VutSungDB[g][ObjPos][0], VutSungDB[g][ObjPos][1], VutSungDB[g][ObjPos][2]-1, 93.7, 120.0, 120.0);
				printf("* %s Loader: %f,%f,%f", TenVuKhi[VutSungDB[g][ObjData][0]], VutSungDB[g][ObjPos][0], VutSungDB[g][ObjPos][1], VutSungDB[g][ObjPos][2]-1);
			}
        }
    }
    else print("He Thong: Khong the Open File \"FileDropGun.ini\"");
	#endif
	return 1;
}
// -----------------------------------------------------------------------------
public OnFilterScriptExit()
{
    #if defined SAVING 
    new File:file = fopen("FileDropGun.ini", io_append);
    if(file)
    {
        fclose(file);
		for(new g = 0, buffer[50]; g < MAX_OBJ; g++)
		{
			format(buffer, sizeof(buffer), "%f,%f,%f,%d,%d\n",
			VutSungDB[g][ObjPos][0],
			VutSungDB[g][ObjPos][1],
			VutSungDB[g][ObjPos][2],
			VutSungDB[g][ObjData][0],
			VutSungDB[g][ObjData][1]);
			if(g == 0) file = fopen("FileDropGun.ini", io_write);
			else file = fopen("FileDropGun.ini", io_append);
			fwrite(file, buffer);
			fclose(file);
			if(VutSungDB[g][ObjData][0] > 0 && VutSungDB[g][ObjPos][1] != 0)
			{
			    DestroyObject(VutSungDB[g][ObjID]);
				printf("* %s saved: %f,%f,%f", TenVuKhi[VutSungDB[g][ObjData][0]], VutSungDB[g][ObjPos][0], VutSungDB[g][ObjPos][1], VutSungDB[g][ObjPos][2]-1);
			}
		}
    }
    else print("He Thong: Khong the Open File \"FileDropGun.ini\"");
	#endif
	return 1;
}
// ------------------------------------Command----------------------------------
CMD:vutsung(playerid, params[])
    {
        if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 1;
        new GunID = GetPlayerWeapon(playerid);
        new GunAmmo = GetPlayerAmmo(playerid);
        if(GunID > 0 && GunAmmo != 0)
        {
            new f = MAX_OBJ+1;
            for(new a = 0; a < MAX_OBJ; a++)
            {
                if(VutSungDB[a][ObjPos][0] == 0.0)
                {
                    f = a;
                    break;
                }
            }
            if(f > MAX_OBJ) return SendClientMessage(playerid, 0x33AA3300, "Ban khong the vut vu khi trong thoi diem nay!!");
			XoaSungKhoiNguoiChoi(playerid, GunID);
			VutSungDB[f][ObjData][0] = GunID;
			VutSungDB[f][ObjData][1] = GunAmmo;
            GetPlayerPos(playerid, VutSungDB[f][ObjPos][0], VutSungDB[f][ObjPos][1], VutSungDB[f][ObjPos][2]);
            VutSungDB[f][ObjID] = CreateObject(GunObjects[GunID], VutSungDB[f][ObjPos][0], VutSungDB[f][ObjPos][1], VutSungDB[f][ObjPos][2]-1, 93.7, 120.0, 120.0);
            new buffer[50];
			format(buffer, sizeof(buffer), "Ban da vut %s", TenVuKhi[VutSungDB[f][ObjData][0]]);
			SendClientMessage(playerid, 0x33AA3300, buffer);
        }
        return 1;
    }
CMD:nhatsung(playerid, params[])
    {
        if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 1;
        new f = MAX_OBJ+1;
		for(new a = 0; a < MAX_OBJ; a++)
		{
		    if(IsPlayerInRangeOfPoint(playerid, 5.0, VutSungDB[a][ObjPos][0], VutSungDB[a][ObjPos][1], VutSungDB[a][ObjPos][2]))
		    {
		        f = a;
		        break;
		    }
		}
		if(f > MAX_OBJ) return SendClientMessage(playerid, 0x33AA3300, "Ban khong o gan bat cu vu khi nao!");
		DestroyObject(VutSungDB[f][ObjID]);
		GivePlayerWeapon(playerid, VutSungDB[f][ObjData][0], VutSungDB[f][ObjData][1]);
		VutSungDB[f][ObjPos][0] = 0.0;
		VutSungDB[f][ObjPos][1] = 0.0;
		VutSungDB[f][ObjPos][2] = 0.0;
		VutSungDB[f][ObjID] = -1;
		//VutSungDB[f][ObjData][0] = 0;
		VutSungDB[f][ObjData][1] = 0;
		new buffer[50];
		format(buffer, sizeof(buffer), "Ban da nhat %s", TenVuKhi[VutSungDB[f][ObjData][0]]);
  		SendClientMessage(playerid, 0x33AA3300, buffer);
  		return 1;
    }
// -----------------------------------------------------------------------------
stock XoaSungKhoiNguoiChoi(playerid, weaponid)
{ 
	new plyWeapons[12] = 0;
	new plyAmmo[12] = 0;
	for(new sslot = 0; sslot != 12; sslot++)
	{
		new wep, ammo;
		GetPlayerWeaponData(playerid, sslot, wep, ammo);
		if(wep != weaponid && ammo != 0) GetPlayerWeaponData(playerid, sslot, plyWeapons[sslot], plyAmmo[sslot]);
	}
	ResetPlayerWeapons(playerid);
	for(new sslot = 0; sslot != 12; sslot++) if(plyAmmo[sslot] != 0) GivePlayerWeapon(playerid, plyWeapons[sslot], plyAmmo[sslot]);
	return 1;
}
stock check(const strsrc[], strdest[][], delimiter)
{ 
	new i, li;
	new aNum;
	new len;
	while(i <= strlen(strsrc))
	{
	    if(strsrc[i]==delimiter || i==strlen(strsrc))
		{
	        len = strmid(strdest[aNum], strsrc, li, i, 128);
	        strdest[aNum][len] = 0;
	        li = i+1;
	        aNum++;
		}
		i++;
	}
	return 1;
}
