//Created by: b0yz no1
//Textdraw ten server don gian

#include <a_samp>

new Text:Textdraw1;

public OnGameModeInit()
{

    	Textdraw1 = TextDrawCreate(499.000000, 96.000000, "GRN-VN");
        TextDrawBackgroundColor(Textdraw1, 65535);
        TextDrawFont(Textdraw1, 1);
        TextDrawLetterSize(Textdraw1, 0.500000, 2.000000);
        TextDrawColor(Textdraw1, 16711935);
        TextDrawSetOutline(Textdraw1, 1);
        TextDrawSetProportional(Textdraw1, 1);
    	return 1;
}

public OnPlayerSpawn(playerid)
{
    TextDrawShowForPlayer(playerid, Textdraw1);
    return 1;
}
