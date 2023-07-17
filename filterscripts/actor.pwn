#include <a_samp>

#include <a_samp>
#include <a_actor>

new Actor1;
new Actor2;
new Actor3;
new Actor4;
new Actor6;
new Actor7;
new Actor12;
new Actor13;
new Actor14;

public OnGameModeInit()
{
    Actor1 = CreateActor(285, 1546.3818, -1677.7904, 13.5622, 44.8202);//PD ACTOR 1
    Actor2 = CreateActor(285, 1546.1542, -1673.1738, 13.5618, 114.0676);//PD ACTOR 2
    Actor3 = CreateActor(293, 2460.7007,-1651.8455,13.4473,91.4837);//Bao Ve Grove 1
    Actor4 = CreateActor(293, 2461.6846,-1665.8597,13.4735,81.2160);//Bao Ve Grove 2
    Actor6 = CreateActor(71, 1799.6764,-1580.1570,14.0926,303.7309); //Bao Ve Vip 1
    Actor7 = CreateActor(71, 1798.0558,-1576.3610,14.0625,279.1223); //Bao Ve Vip 2
    Actor12 = CreateActor(105, 2452.0740,-1666.7881,13.4762,206.4414); //Noi Chuyen Grove 1
    Actor13 = CreateActor(106, 2454.0251,-1667.3936,13.4780,130.6140); //Noi Chuyen Grove 2
	Actor14 = CreateActor(107, 2452.6248,-1668.8237,13.4822,343.6594); //Noi Chuyen Grove 3
    ApplyActorAnimation(Actor1, "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0);
    ApplyActorAnimation(Actor2, "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0);
    ApplyActorAnimation(Actor3, "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0);
    ApplyActorAnimation(Actor4, "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0);
    ApplyActorAnimation(Actor6, "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0);
    ApplyActorAnimation(Actor7, "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0);
    ApplyActorAnimation(Actor12, "GANGS", "prtial_gngtlkA", 4.0, 1, 0, 0, 0, 0);
    ApplyActorAnimation(Actor13, "GANGS", "prtial_gngtlkA", 4.0, 1, 0, 0, 0, 0);
    ApplyActorAnimation(Actor14, "GANGS", "prtial_gngtlkA", 4.0, 1, 0, 0, 0, 0);
	return 1;
}




public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
