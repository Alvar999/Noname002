#include <ysi\y_hooks>
#include <a_samp>

enum //attach slot
{
    SLOT_HAT,//0
    SLOT_MASK,//1
    SLOT_TOY1,//2
    SLOT_TOY2,//3
    SLOT_TOY3,//4
    SLOT_TOY4,//5
    //
    SLOT_WEAPON2,//6
    SLOT_WEAPON6,//7
    SLOT_BLEED,//8
    SLOT_BAG//9
}
hook OnPlayerUpdate(playerid)
{
    if(IsPlayerNPC(playerid)) return 1;
    new weaponid2,weaponid6,weaponid3,weaponid4,weaponid5,ammo,weaponid10;
    GetPlayerWeaponData(playerid,2,weaponid2,ammo);
    GetPlayerWeaponData(playerid,3,weaponid3,ammo);
    GetPlayerWeaponData(playerid,4,weaponid4,ammo);
    GetPlayerWeaponData(playerid,5,weaponid5,ammo);
    GetPlayerWeaponData(playerid,6,weaponid6,ammo);
    GetPlayerWeaponData(playerid,10,weaponid10,ammo);
    if(weaponid5 > 0)
    {
        if(GetPlayerWeapon(playerid) == weaponid5)
        {
        RemovePlayerAttachedObject(playerid,SLOT_TOY4);
        }
        else
        {
        SetPlayerAttachedObject(playerid,SLOT_TOY4, GetWeaponModel(weaponid5), 1, 0.2,-0.125,-0.1,0.0,25.0,180.0);
        }
    }
    else if(weaponid5 == 0)
    {
    RemovePlayerAttachedObject(playerid,SLOT_TOY4);
    }
    if(weaponid3 > 0)
    {
        if(GetPlayerWeapon(playerid) == weaponid3)
        {
        RemovePlayerAttachedObject(playerid,SLOT_TOY2);
        }
        else
        {
        SetPlayerAttachedObject(playerid,SLOT_TOY2, GetWeaponModel(weaponid3), 1, 0.2,-0.125,-0.1,0.0,25.0,180.0);
        }
    }
    else if(weaponid3 == 0)
    {
    RemovePlayerAttachedObject(playerid,SLOT_TOY2);
    }
    if(weaponid4 > 0)
    {
        if(GetPlayerWeapon(playerid) == weaponid4)
        {
        RemovePlayerAttachedObject(playerid,SLOT_TOY3);
        }
        else
        {
        SetPlayerAttachedObject(playerid,SLOT_TOY3, GetWeaponModel(weaponid4), 8,0.0,-0.1,0.15, -100.0, 0.0, 0.0);
        }
    }
    else if(weaponid4 == 0)
    {
    RemovePlayerAttachedObject(playerid,SLOT_TOY3);
    }
    if(weaponid10 == 15)
    {
       if(GetPlayerWeapon(playerid) != 15)
       {
       SetPlayerAttachedObject(playerid,SLOT_MASK, 8,0.0,-0.1,0.15, -100.0, 0.0, 0.0);
       }
       else
       {
        RemovePlayerAttachedObject(playerid,SLOT_MASK);
       }
    }
    if(weaponid2 > 0)
    {
        if(GetPlayerWeapon(playerid) == weaponid2)
        {
        RemovePlayerAttachedObject(playerid,SLOT_WEAPON2);
        }
        else
        {
        SetPlayerAttachedObject(playerid,SLOT_WEAPON2, GetWeaponModel(weaponid2), 7,0.0,0.0,-0.10, -100.0, 0.0, 0.0);
        }
    }
    else if(weaponid2 == 0)
    {
    RemovePlayerAttachedObject(playerid,SLOT_WEAPON2);
    }
    if(weaponid6 > 0)
    {
        if(GetPlayerWeapon(playerid) == weaponid6)
        {
        RemovePlayerAttachedObject(playerid,SLOT_WEAPON6);
        }
        else
        {
        SetPlayerAttachedObject(playerid, SLOT_WEAPON6, GetWeaponModel(weaponid6), 1, 0.2,-0.125,-0.1,0.0,25.0,180.0);
        }

    }
    else if(weaponid6 == 0)
        {
        RemovePlayerAttachedObject(playerid,SLOT_WEAPON6);
        }
    return 1;
}
stock GetWeaponModel(weaponid)
{
    switch(weaponid)
    {
        case 1: return 331;
        case 2: return 333;
        case 3: return 334;
        case 4: return 335;
        case 5: return 336;
        case 6: return 337;
        case 7: return 338;
        case 8: return 339;
        case 9: return 341;
        case 10: return 321;
        case 11: return 322;
        case 12: return 323;
        case 13: return 324;
        case 14: return 325;
        case 15: return 326;
        case 16: return 342;
        case 17: return 343;
        case 18: return 344;
        case 22: return 346;
        case 23: return 347;
        case 24: return 348;
        case 25: return 349;
        case 28: return 352;
        case 29: return 353;
        case 31: return 356;
        case 33: return 357;
        case 34: return 358;
        default: return -1;
    }
    return -1;
}