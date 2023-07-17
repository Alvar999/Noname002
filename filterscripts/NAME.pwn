//Reupload tai svo.vn //

#include <a_samp>

#define NAME_DRAWDISTANCE (10) // The distance of the 3d text nametags to appear.

new Text3D:NameTag[MAX_PLAYERS];
new playerName[MAX_PLAYER_NAME];

public OnGameModeInit()
{
    SetNameTagDrawDistance(0.0);
    ShowNameTags(false);
    return 1;
}

public OnPlayerConnect(playerid)
{
    playerName = p_name( playerid );
    NameTag[playerid] = Create3DTextLabel( playerName, 0xFFFFFFFF, 0, 0, 0, NAME_DRAWDISTANCE, 0, 1 );
    Attach3DTextLabelToPlayer(NameTag[playerid], playerid, 0.0, 0.0, 0.2);
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    Delete3DTextLabel( NameTag[playerid] );
    return 1;
}

stock p_name( playerid )
{
    new p_namev[MAX_PLAYER_NAME];
    GetPlayerName(playerid, p_namev, MAX_PLAYER_NAME);
    return p_namev;
}
