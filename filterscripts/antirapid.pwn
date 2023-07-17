#include <a_samp>
new shotTime[MAX_PLAYERS];
new shot[MAX_PLAYERS];
---------------------------------------------------------

public OnPlayerConnect(playerid)
{
        shotTime[playerid] = 0;
        shot[playerid] = 0;
        return 1;
}
---------------------------------------------------------------
public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
         if(weaponid != 38)
        {
                if((gettime() - shotTime[playerid]) < 1)
                {
                    shot[playerid]+=1;
                }
                else
                {
                    shot[playerid]=0;
                }
                if(shot[playerid] > 5)
                {
                            new string[ 128 ], WeaponName[128];
                    GetWeaponName( weaponid, WeaponName, sizeof( WeaponName ) );
                                format(string, sizeof(string), "{AA3333}GvN Warning{FFFF00}: %s (ID: %d) co the dang su dung Rapid Hack ! Sung: %s", GetPlayerNameEx(playerid), playerid, WeaponName);
                                ABroadCast(COLOR_YELLOW, string, 2);
                }
                shotTime[playerid] = gettime();
        }
