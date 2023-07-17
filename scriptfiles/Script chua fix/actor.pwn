//FS Create By Sarah

#include <a_samp>
#include <a_actor>

new Actor1;
new Actor2;
new Actor3;
new Actor4;
new Actor5;
new Actor6;
new Actor7;
new Actor8;
new Actor9;
new Actor10;
new Actor11;
new Actor15;
new Actor18;

public OnGameModeInit()
{
    Actor1 = CreateActor(103, 2135.278076, -1728.791503, 13.541131, 341.345001);
    Actor2 = CreateActor(102, 2136.150878, -1727.666137, 13.540307, 146.739852);
    Actor3 = CreateActor(102, 2134.766845, -1727.462280, 13.540158, 215.987167);
    Actor4 = CreateActor(7, 2095.0840,-1778.9840,13.5469,72.4439); // /smoke
    Actor5 = CreateActor(291, 2072.2390,-1772.3837,13.5559,357.7141); // /chat
    Actor6 = CreateActor(292, 2072.2166,-1771.5565,13.5563,182.1554); // /chat
    Actor7 = CreateActor(305, 373.1156,-129.1119,1002.0313,271.0829); // /siteat
    Actor8 = CreateActor(294, 1801.5133,-1578.9180,14.0691,297.9133); // /crossmar
    Actor9 = CreateActor(294, 1800.4028,-1574.6558,14.0625,276.4613); // /crossmar
    Actor10 = CreateActor(71, 1543.8285,-1631.9478,13.3828,95.7131);
    Actor11 = CreateActor(71, 1580.8154,-1634.1244,13.5621,2.8206);
    Actor15 = CreateActor(280,1552.3932,-1673.6938,16.1953,87.4635); //
    Actor18 = CreateActor(132,2096.4060,-1765.9580,13.5648,87.0773); // hurt
    ApplyActorAnimation(Actor1, "GANGS", "prtial_gngtlkA", 4.0, 1, 0, 0, 0, 0);
    ApplyActorAnimation(Actor2, "GANGS", "prtial_gngtlkA", 4.0, 1, 0, 0, 0, 0);
    ApplyActorAnimation(Actor3, "GANGS", "prtial_gngtlkA", 4.0, 1, 0, 0, 0, 0);
    ApplyActorAnimation(Actor4, "SMOKING", "M_smklean_loop", 4.0, 1, 0, 0, 0, 0);
    ApplyActorAnimation(Actor5, "GANGS", "prtial_gngtlkA", 4.0, 1, 0, 0, 0, 0);
    ApplyActorAnimation(Actor6, "GANGS", "prtial_gngtlkA", 4.0, 1, 0, 0, 0, 0);
    ApplyActorAnimation(Actor7, "FOOD", "FF_Sit_Eat2", 4.0, 1, 0, 0, 0, 0);
    ApplyActorAnimation(Actor8, "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0);
    ApplyActorAnimation(Actor9, "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0);
    ApplyActorAnimation(Actor10, "COP_AMBIENT", "Coplook_loop", 4.0, 0, 1, 1, 1, -1);
    ApplyActorAnimation(Actor11, "COP_AMBIENT", "Coplook_loop", 4.0, 0, 1, 1, 1, -1);
    ApplyActorAnimation(Actor15, "COP_AMBIENT", "Coplook_loop", 4.0, 0, 1, 1, 1, -1);
    ApplyActorAnimation(Actor18, "SWAT", "gnstwall_injurd", 4.0, 1, 0, 0, 0, 0);
	return 1;
}


