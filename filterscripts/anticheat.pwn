#define FILTERSCRIPT

#define COLOR_NOTES 0x2894FFFF
#define COLOR_NOTES2 0xFF0000AA

#define WEBSITE "www.google.com"
#define BOT_NAME "zBlock"

#define DIALOG_LOCKMODE 1
#define DIALOG_SETTINGS 2
#define DIALOG_SUSPECTS 3

#define ResetMoneyBar ResetPlayerMoney
#define UpdateMoneyBar GivePlayerMoney

#include <a_samp>
#include <zcmd>
#include <sscanf2>
#include <foreach>
#pragma tabsize 0

#if defined FILTERSCRIPT

new DB:zBlock;
new
        datestring[ 24 ],
        timestring[ 24 ]
;
new
        bool: Muted[ MAX_PLAYERS char ],
        bool: ACDetected[ MAX_PLAYERS char ],
        bool: FirstSpawn[ MAX_PLAYERS char ],
        bool: AdminImmunity[ MAX_PLAYERS char ],
        bool: LoggedIn[ MAX_PLAYERS char ],
        AntiSpam[ MAX_PLAYERS ],
        MutedTimes[ MAX_PLAYERS ],
        ACTimesDetected[ MAX_PLAYERS ],
        WarnForAdvert[ MAX_PLAYERS ],
        RCONLoginFails[ MAX_PLAYERS ],
        Cash[ MAX_PLAYERS ]
;
new
        DefaultPass = 1,
        ServerLocked = 0,
        BanForMoneyHack = 0,
        BanForSpeedHack = 1
;
public OnFilterScriptInit()
{
        print("--------------------------------------");
        print("Loading zBlock Anti-Cheat. . .");
        print("--------------------------------------\n");

        zBlock = db_open("zBlock.db");
    db_query(zBlock, "CREATE TABLE IF NOT EXISTS `BANNED` (`NAME`, `IP`, `REASON`, `ADMIN`, `DATE`, `TIME`)");

    if(!fexist("/zblock"))
        {
            print("WARNING: folder 'zblock' at 'scriptfiles' does NOT exist");
                print("ERROR: server has crashed due to a missing folder (scriptfiles/zblock)");
        }
        if(!fexist("/zblock/password.txt"))
        {
            print("WARNING: 'password.txt' does NOT exist at the 'scriptfiles/zblock' folder");
            print("NOTIFICATION: attempting to create 'password.txt'");
                SetTimer("CheckForFile", 5000, false);
                fcreate("/zblock/password.txt");
        }
        else
        {
                new
                        File: zBlockstuff = fopen("/zblock/password.txt", io_read),
                string[50]
                ;
            if(zBlockstuff)
        {
                if (!fread(zBlockstuff, string))
                        {
                            new
                                        File: zBlockstuff2 = fopen("/zblock/password.txt", io_write)
                                ;
                                fwrite(zBlockstuff2, "defaultpassword5791");
                                fclose(zBlockstuff2);
                                DefaultPass = 1;
                                print("** zBlock: 'password.txt' was empty, default password was writen");
                        }
                        else
                        {
                        if(!strcmp(string, "defaultpassword5791", true))
                    {
                                        DefaultPass = 1;
                                        print("** zBlock: Server is using the default password\n** zBlock: Please change it for your own safety.");
                        }
                    else
                    {
                        DefaultPass = 0;
                        print("** zBlock: Server is NOT using the default password\n** zBlock: The 'CP' is ready for use.");
                                }
                        }
                        fclose(zBlockstuff);
        }
                return 1;
        }
        SetTimer("AntiCheat", 6500, true);
        foreach(Player, i)
        {
            ResetInfo(i);
        }
        ServerLocked = 0;
        BanForMoneyHack = 0;
        BanForSpeedHack = 1;
        return 1;
}

public OnFilterScriptExit()
{
        print("\n--------------------------------------");
        print("zBlock Anti-Cheat has been disabled. . .");
        print("--------------------------------------\n");
        return 1;
}

#endif

public OnPlayerConnect(playerid)
{
        if(ServerLocked == 1)
        {
        SendClientMessage(playerid, COLOR_NOTES2, "zBlock: The server is in 'Lock-Mode #1', you can't connect.");
        SetTimerEx("KickTimer", 100, false, "i", playerid);
    }
    else
    {
            new Query[120], DBResult:Result, day, month, year, second, minute, hour, reason[20] = "Ban Evade";
                getdate(day, month, year);
                gettime(hour, minute, second);

                format(Query, sizeof(Query), "SELECT `NAME` FROM `BANNED` WHERE `NAME` = '%s'", DB_Escape(GetName(playerid)));
                Result = db_query(zBlock, Query);
                if(db_num_rows(Result))
                {
                        ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FC4949}Ban detected.", "{FFFFFF}Our system has detected that your username is banned.\nIf you think this is a mistake visit our website.\n"WEBSITE"", "Close", "");
                        printf(">> %s has been kicked from OnPlayerConnect - Username ban detection", GetName(playerid));
                        SetTimerEx("KickTimer", 100, false, "i", playerid);

                    format(Query, sizeof(Query), "SELECT `IP` FROM `BANNED` WHERE `IP` = '%s'", DB_Escape(PlayerIP(playerid)));
                        Result = db_query(zBlock, Query);
                        if(!db_num_rows(Result))
                        {
                                format(datestring, sizeof(datestring), "%i-%i-%i", day, month, year);
                                format(timestring, sizeof(timestring), "%i:%i:%i", hour, minute, second);

                                format(Query, sizeof(Query), "INSERT INTO `BANNED` (`NAME`, `IP`, `REASON`, `ADMIN`, `DATE`, `TIME`) VALUES ('%s', '%s', '%s', '%s', '%s', '%s')", DB_Escape(GetName(playerid)), DB_Escape(PlayerIP(playerid)), reason, BOT_NAME, datestring, timestring);
                                Result = db_query(zBlock, Query);
                        }
                }
                else
                {
                        format(Query, sizeof(Query), "SELECT `IP` FROM `BANNED` WHERE `IP` = '%s'", DB_Escape(PlayerIP(playerid)));
                        Result = db_query(zBlock, Query);
                        if(db_num_rows(Result))
                        {
                                ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FC4949}Ban detected.", "{FFFFFF}Our system has detected that your ip is banned.\nIf you think this is a mistake visit our website.\n"WEBSITE"", "Close", "");
                                printf(">> %s has been kicked from OnPlayerConnect - IP ban detection", GetName(playerid));
                                SetTimerEx("KickTimer", 100, false, "i", playerid);

                            format(Query, sizeof(Query), "SELECT `NAME` FROM `BANNED` WHERE `NAME` = '%s'", DB_Escape(GetName(playerid)));
                                Result = db_query(zBlock, Query);
                                if(!db_num_rows(Result))
                                {
                                        format(datestring, sizeof(datestring), "%i-%i-%i", day, month, year);
                                        format(timestring, sizeof(timestring), "%i:%i:%i", hour, minute, second);

                                        format(Query, sizeof(Query), "INSERT INTO `BANNED` (`NAME`, `IP`, `REASON`, `ADMIN`, `DATE`, `TIME`) VALUES ('%s', '%s', '%s', '%s', '%s', '%s')", DB_Escape(GetName(playerid)), DB_Escape(PlayerIP(playerid)), reason, BOT_NAME, datestring, timestring);
                                        Result = db_query(zBlock, Query);
                                }
                        }
                }

                ResetInfo(playerid);
        }
        return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    ResetInfo(playerid);
        return 1;
}
public OnPlayerRequestSpawn(playerid)
{
    if(ServerLocked == 2)
    {
        SendClientMessage(playerid, COLOR_NOTES2, "zBlock: The server is in 'Lock-Mode #2', you can't spawn.");
        return 0;
    }
    return 1;
}
public OnPlayerSpawn(playerid)
{
        if(FirstSpawn{ playerid })
        {
                TogglePlayerControllable(playerid, 0);
                SendClientMessage(playerid, COLOR_NOTES2, "* Please wait for the server to processes you, and sets up data for you.");
                SetTimerEx("EndProcessing", 3500, false, "i", playerid);
        }
        return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
        return 1;
}

public OnPlayerText(playerid, text[])
{
        new stringz[108];
        if(!AdminImmunity{ playerid })
        {
                if(!Muted{ playerid })
                {
                        AntiSpam[playerid]++;
                        if(AntiSpam[playerid] >= 3 && AntiSpam[playerid] < 4) SendClientMessage(playerid, COLOR_NOTES2, "zBlock: Please stop flooding.");
                    else if(AntiSpam[playerid] >= 4)
                    {
                        Muted{ playerid } = true;
                            MutedTimes[playerid]++;
                            if(MutedTimes[playerid] < 2)
                        {
                                        SendClientMessage(playerid, COLOR_NOTES, "zBlock: You've been muted for 5 seconds due to flooding the chat.");
                                    SetTimerEx("Unmute", 5000, false, "i", playerid);
                                }
                                else if(MutedTimes[playerid] < 5 && MutedTimes[playerid] >= 2)
                                {
                                SendClientMessage(playerid, COLOR_NOTES, "zBlock: You've been muted for 20 seconds due to flooding the chat.");
                                    SetTimerEx("Unmute", 20000, false, "i", playerid);
                                }
                                else if(MutedTimes[playerid] >= 5)
                                {
                                        Muted{ playerid } = false;
                                        format(stringz, sizeof(stringz), "zBlock: %s(%d) has been kicked for constant flood ( %d mutes )", GetName(playerid), playerid, MutedTimes[playerid]);
                                        SendClientMessageToAll(COLOR_NOTES2, stringz);

                                        format(stringz, sizeof(stringz), "zBlock: You've been kicked for constant flood ( %d mutes )", MutedTimes[playerid]);
                                        SendClientMessage(playerid, COLOR_NOTES2, stringz);

                                        SetTimerEx("KickTimer", 100, false, "i", playerid);
                                }
                        }
                }
                SetTimerEx("ResetAntiSpam", 1700, false, "i", playerid);
        }

        if(strfind(text, ":", true) != -1)
        {
                new i_numcount, i_period, i_pos;
                while(text[i_pos])
                {
                        if('0' <= text[i_pos] <= '9') i_numcount ++;
                        else if(text[i_pos] == '.') i_period ++;
                        i_pos++;
                }
                if(i_numcount >= 8 && i_period >= 3)
                {
                        WarnForAdvert[playerid]++;
                        if(WarnForAdvert[playerid] < 2)
                        {
                                format(stringz, sizeof(stringz), "zBlock: Advertising here isn't allowed.. ( %d warnings )", WarnForAdvert[playerid]);
                                SendClientMessage(playerid, COLOR_NOTES2, stringz);

                                format(stringz, sizeof(stringz), "zBlock: Player %s(%d) has tried to advertise on the main-chat!", GetName(playerid), playerid);
                                SendMessageToAdmins(COLOR_NOTES2, stringz);

                                printf("* zBlock: Advertise attempt by %s, proof: %s", GetName(playerid), text);
                                return 0;
                        }
                        else if(WarnForAdvert[playerid] >= 2)
                        {
                                new Query[240], reason[20] = "Advertisement", day, month, year, second, minute, hour;
                                getdate(day, month, year);
                                gettime(hour, minute, second);

                                format(datestring, sizeof(datestring), "%i-%i-%i", day, month, year);
                                format(timestring, sizeof(timestring), "%i:%i:%i", hour, minute, second);

                                format(Query, sizeof(Query), "INSERT INTO `BANNED` (`NAME`, `IP`, `REASON`, `ADMIN`, `DATE`, `TIME`) VALUES ('%s', '%s', '%s', '%s', '%s', '%s')", DB_Escape(GetName(playerid)), DB_Escape(PlayerIP(playerid)), reason, BOT_NAME, datestring, timestring);
                                db_query(zBlock, Query);
                                SetTimerEx("KickTimer", 100, false, "i", playerid);

                                printf("* zBlock: Ban applied on '%s'\n* zBlock: Reason: Advertisement\n* zBlock: Proof: %s", GetName(playerid), text);

                                format(stringz, sizeof(stringz), "zBlock: %s(%d) has been banned for advertising", GetName(playerid), playerid);
                                SendClientMessageToAll(COLOR_NOTES2, stringz);
                                return 0;
                        }
                }
        }
        return 1;
}
public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
        new stringz[72];
        if(strfind(cmdtext, ":", true) != -1)
        {
                new i_numcount, i_period, i_pos;
                while(cmdtext[i_pos])
                {
                        if('0' <= cmdtext[i_pos] <= '9') i_numcount ++;
                        else if(cmdtext[i_pos] == '.') i_period ++;
                        i_pos++;
                }
                if(i_numcount >= 8 && i_period >= 3)
                {
                        WarnForAdvert[playerid]++;
                        if(WarnForAdvert[playerid] < 2)
                        {
                                format(stringz, sizeof(stringz), "zBlock: Advertising here isn't allowed.. ( %d warnings )", WarnForAdvert[playerid]);
                                SendClientMessage(playerid, COLOR_NOTES2, stringz);

                                format(stringz, sizeof(stringz), "zBlock: Player %s(%d) has tried to advertise via a command!", GetName(playerid), playerid);
                                SendMessageToAdmins(COLOR_NOTES2, stringz);

                                printf("* zBlock: Advertise attempt by %s, proof: %s", GetName(playerid), cmdtext);
                                return 0;
                        }
                        else if(WarnForAdvert[playerid] >= 2)
                        {
                                new Query[240], reason[20] = "Advertisement", day, month, year, second, minute, hour;
                                getdate(day, month, year);
                                gettime(hour, minute, second);

                                format(datestring, sizeof(datestring), "%i-%i-%i", day, month, year);
                                format(timestring, sizeof(timestring), "%i:%i:%i", hour, minute, second);

                                format(Query, sizeof(Query), "INSERT INTO `BANNED` (`NAME`, `IP`, `REASON`, `ADMIN`, `DATE`, `TIME`) VALUES ('%s', '%s', '%s', '%s', '%s', '%s')", DB_Escape(GetName(playerid)), DB_Escape(PlayerIP(playerid)), reason, BOT_NAME, datestring, timestring);
                                db_query(zBlock, Query);
                                SetTimerEx("KickTimer", 100, false, "i", playerid);

                                printf("* zBlock: Ban applied on '%s'\n* zBlock: Reason: Advertisement\n* zBlock: Proof: %s", GetName(playerid), cmdtext);

                                format(stringz, sizeof(stringz), "zBlock: %s(%d) has been banned for advertising", GetName(playerid), playerid);
                                SendClientMessageToAll(COLOR_NOTES2, stringz);
                                return 0;
                        }
                }
        }
    return 1;
}
CMD:zblock_login(playerid, params[])
{
        new FirstParam[50], string[82];
    if(fexist("/zblock/password.txt"))
    {
        if(!DefaultPass)
        {
                if(sscanf(params, "s[50]", FirstParam)) return SendClientMessage(playerid, COLOR_NOTES, "/zblock_login (password)");
                        if(isnull(params)) return SendClientMessage(playerid, COLOR_NOTES2, "* You didn't type anything in the Password 'slot'!");

                        new
                                File: zBlockstuff = fopen("/zblock/password.txt", io_read)
                        ;
                        if(zBlockstuff)
                        {
                            if(!LoggedIn{ playerid })
                            {
                                fread(zBlockstuff, string);
                                fclose(zBlockstuff);
                                        if(!strcmp(FirstParam, string, true))
                                        {
                                            LoggedIn{ playerid } = true;
                                            AdminImmunity{ playerid } = true;

                                            format(string, sizeof(string), "zBlock: %s(%d) has logged in the zBlock 'CP', and has received his 'Immunity'", GetName(playerid), playerid);
                                            SendMessageToAdmins(COLOR_NOTES, string);
                                        }
                                        else SendClientMessage(playerid, COLOR_NOTES2, "zBlock: Invalid Password!");
                                }
                                else SendClientMessage(playerid, COLOR_NOTES, "zBlock: You're already logged in!");
                        }
                        else SendClientMessage(playerid, COLOR_NOTES2, "zBlock: Can't find 'password.txt' file..");
                }
                else SendClientMessage(playerid, COLOR_NOTES2, "zBlock: Server is using Default Password, logging in is forbidden!");
        }
        FirstParam = "\0", string = "\0";
        return 1;
}
CMD:zblock(playerid, params[])
{
        new FirstParam[18], SecondParam[50], messagestring[112], extradialog[240], string[82], hackerstring[148], count = 0;
        if(fexist("/zblock/password.txt"))
        {
                new
                        File: zBlockstuff = fopen("/zblock/password.txt", io_read)
                ;
                if(zBlockstuff)
                {
                        fread(zBlockstuff, string);
                        fclose(zBlockstuff);
                }
                if(LoggedIn{ playerid })
                {
                        if(sscanf(params, "s[18]", FirstParam)) return SendClientMessage(playerid, COLOR_NOTES, "/zblock (hackers/changepassword/lock/settings)");
                        {
                                if(strcmp(FirstParam, "suspects", true, 8) == 0 || strcmp(FirstParam, "hackers", true, 7) == 0 )
                                {
                                        if(AdminImmunity{ playerid })
                                        {
                                                foreach(Player, i)
                                                {
                                                        if(ACTimesDetected[i] >= 1) count++;
                                                }
                                                if(count >= 1)
                                                {
                                                        foreach(Player, i)
                                                        {
                                                                if(ACTimesDetected[i] >= 1)
                                                                {
                                                                        format(hackerstring, sizeof(hackerstring), "{FFCC66}%s\n%s(%d) - IP: %s - Has been detected %d times", hackerstring, GetName(i), i, PlayerIP(i), ACTimesDetected[i]);
                                                                }
                                                        }
                                                        ShowPlayerDialog(playerid, DIALOG_SUSPECTS, DIALOG_STYLE_MSGBOX, "{FF9933}zBlock CP {FF6633}(v1.5)", hackerstring, "Close", "");
                                                }
                                                else ShowPlayerDialog(playerid, DIALOG_SUSPECTS, DIALOG_STYLE_MSGBOX, "{FF9933}zBlock CP {FF6633}(v1.5)", "{FFCC66}No hackers detected", "Close", "");
                                        }
                                }
                                else if(strcmp(FirstParam, "changepassword", true, 14) == 0)
                                {
                                        if(IsPlayerAdmin(playerid) && AdminImmunity{ playerid })
                                        {
                                                if(zBlockstuff)
                                                {
                                                    if(sscanf(params, "s[50]", SecondParam))
                                                        {
                                                                SendClientMessage(playerid, COLOR_NOTES, "/zblock (changepassword) (newpass)");
                                                        }
                                                    else
                                                    {
                                                        if(!isnull(SecondParam))
                                                        {
                                                                SecondParam = "\0";

                                                                        zBlockstuff = fopen("/zblock/password.txt", io_write);
                                                                fwrite(zBlockstuff, SecondParam);
                                                                fclose(zBlockstuff);

                                                                        format(messagestring, sizeof(messagestring), "zBlock: %s(%d) has changed the password to %s", GetName(playerid), playerid, SecondParam);
                                                                SendMessageToAdmins(COLOR_NOTES2, messagestring);

                                                                        printf("* zBlock: PASS CHANGE! %s has changed the password to %s!", GetName(playerid), SecondParam);
                                                                }
                                                        }
                                                }
                                        }
                                        else SendClientMessage(playerid, COLOR_NOTES2, "zBlock: You aren't an RCON admin, or an zBlock 'CP admin'!");
                                }
                                else if(strcmp(FirstParam, "lock", true, 4) == 0)
                                {
                                    if(IsPlayerAdmin(playerid) && AdminImmunity{ playerid })
                                        {
                                                if(zBlockstuff)
                                                {
                                                        if(ServerLocked == 0)
                                                        {
                                                                ShowPlayerDialog(playerid, DIALOG_LOCKMODE, DIALOG_STYLE_LIST, "{FF9933}zBlock CP {FF6633}(v1.5)", "{FF9933}Lock Mode #1 {FF6633}- Disable connections\n{FF9933}Lock Mode #2 {FF6633}- Disable spawning", "Select", "Close");
                                                        }
                                                        else if(ServerLocked == 1)
                                                        {
                                                                ShowPlayerDialog(playerid, DIALOG_LOCKMODE, DIALOG_STYLE_LIST, "{FF9933}zBlock CP {FF6633}(v1.5)", "{FF9933}Lock Mode #0 {FF6633}- Disable lock-mode\n{FF9933}Lock Mode #2 {FF6633}- Disable spawning", "Select", "Close");
                                                        }
                                                        else if(ServerLocked == 2)
                                                        {
                                                                ShowPlayerDialog(playerid, DIALOG_LOCKMODE, DIALOG_STYLE_LIST, "{FF9933}zBlock CP {FF6633}(v1.5)", "{FF9933}Lock Mode #0 {FF6633}- Disable lock-mode\n{FF9933}Lock Mode #1 {FF6633}- Disable connections", "Select", "Close");
                                                        }
                                                }
                                        }
                                        else SendClientMessage(playerid, COLOR_NOTES2, "zBlock: You aren't an RCON admin, or an zBlock 'CP admin'!");
                                }
                                else if(strcmp(FirstParam, "settings", true, 8) == 0)
                                {
                                        if(AdminImmunity{ playerid })
                                        {
                                                if(zBlockstuff)
                                                {
                                                        if(!BanForMoneyHack)
                                                        {
                                                                format(extradialog, sizeof(extradialog), "{FF9933}Enable {FF6633}'Ban for Money-Hack'");
                                                        }
                                                        else
                                                        {
                                                                format(extradialog, sizeof(extradialog), "{FF9933}Disable {FF6633}'Ban for Money-Hack'");
                                                        }
                                                        if(!BanForSpeedHack)
                                                        {
                                                                format(extradialog, sizeof(extradialog), "%s\n{FF9933}Enable {FF6633}'Ban for Speed-Hack'", extradialog);
                                                        }
                                                        else
                                                        {
                                                                format(extradialog, sizeof(extradialog), "%s\n{FF9933}Disable {FF6633}'Ban for Speed-Hack'", extradialog);
                                                        }
                                                        ShowPlayerDialog(playerid, DIALOG_SETTINGS, DIALOG_STYLE_LIST, "{FF9933}zBlock CP {FF6633}(v1.5)", extradialog, "Select", "Close");
                                                }
                                        }
                                }
                        }
                }
                else SendClientMessage(playerid, COLOR_NOTES2, "zBlock: You have to be logged in via the zBlock 'CP'!");
        }
        else SendClientMessage(playerid, COLOR_NOTES2, "zBlock: File 'password.txt' does NOT exist, zBlock CP is DISABLED.");

        FirstParam = "\0", SecondParam = "\0", messagestring = "\0", hackerstring = "\0", string = "\0", extradialog = "\0";
        return 1;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
        new string[92];
        switch(dialogid)
        {
            case DIALOG_LOCKMODE:
            {
                if(response)
                {
                        if(ServerLocked == 0)
                        {
                                switch(listitem)
                                {
                                    case 0:
                                    {
                                                        ServerLocked = 1;
                                                        format(string, sizeof(string), "zBlock: %s(%d) has enabled Lock-Mode #1 ( Connections will be 'rejected' )", GetName(playerid), playerid);
                                                        SendClientMessageToAll(COLOR_NOTES2, string);
                                                        foreach(Player, i)
                                                        {
                                                                PlayerPlaySound(i, 1085, 0.0, 0.0, 0.0);
                                                        }
                                                }
                                                case 1:
                                                {
                                                    ServerLocked = 2;
                                                        format(string, sizeof(string), "zBlock: %s(%d) has enabled Lock-Mode #2 ( Spawning is disabled )", GetName(playerid), playerid);
                                                        SendClientMessageToAll(COLOR_NOTES2, string);
                                                foreach(Player, i)
                                                        {
                                                                PlayerPlaySound(i, 1085, 0.0, 0.0, 0.0);
                                                        }
                                            }
                                        }
                                }
                                else if(ServerLocked == 1)
                                {
                                    switch(listitem)
                                    {
                                    case 0:
                                    {
                                                        ServerLocked = 0;
                                                        format(string, sizeof(string), "zBlock: %s(%d) has disabled Lock-Mode ( Spawning/Connecting is allowed )", GetName(playerid), playerid);
                                                        SendClientMessageToAll(COLOR_NOTES, string);
                                                        foreach(Player, i)
                                                        {
                                                                PlayerPlaySound(i, 1083, 0.0, 0.0, 0.0);
                                                        }
                                                }
                                                case 1:
                                                {
                                                    ServerLocked = 2;
                                                        format(string, sizeof(string), "zBlock: %s(%d) has enabled Lock-Mode #2 ( Spawning is disabled )", GetName(playerid), playerid);
                                                        SendClientMessageToAll(COLOR_NOTES2, string);
                                                        foreach(Player, i)
                                                        {
                                                                PlayerPlaySound(i, 1085, 0.0, 0.0, 0.0);
                                                        }
                                            }
                                        }
                                }
                                else if(ServerLocked == 2)
                                {
                                    switch(listitem)
                            {
                                    case 0:
                                    {
                                                        ServerLocked = 0;
                                                        format(string, sizeof(string), "zBlock: %s(%d) has disabled Lock-Mode ( Spawning/Connecting is allowed )", GetName(playerid), playerid);
                                                        SendClientMessageToAll(COLOR_NOTES, string);
                                                        foreach(Player, i)
                                                        {
                                                                PlayerPlaySound(i, 1083, 0.0, 0.0, 0.0);
                                                        }
                                                }
                                                case 1:
                                                {
                                                    ServerLocked = 1;
                                                        format(string, sizeof(string), "zBlock: %s(%d) has enabled Lock-Mode #1 ( Connections will be 'rejected' )", GetName(playerid), playerid);
                                                        SendClientMessageToAll(COLOR_NOTES2, string);
                                                        foreach(Player, i)
                                                        {
                                                                PlayerPlaySound(i, 1085, 0.0, 0.0, 0.0);
                                                        }
                                                }
                                        }
                                }
                        }
                }
                case DIALOG_SETTINGS:
                {
                    if(response)
                    {
                            switch(listitem)
                            {
                                case 0:
                                {
                                                if(!BanForMoneyHack)
                                                {
                                                    BanForMoneyHack = 1;
                                                    format(string, sizeof(string), "zBlock: %s(%d) has enabled the 'Ban for Money-Hack' feature.", GetName(playerid), playerid);
                                                        SendClientMessageToAll(COLOR_NOTES, string);
                                                        foreach(Player, i)
                                                        {
                                                                PlayerPlaySound(i, 1085, 0.0, 0.0, 0.0);
                                                        }
                                                }
                                                else
                                                {
                                                    BanForMoneyHack = 0;
                                                    format(string, sizeof(string), "zBlock: %s(%d) has disabled the 'Ban for Money-Hack' feature.", GetName(playerid), playerid);
                                                        SendClientMessageToAll(COLOR_NOTES2, string);
                                                        SendMessageToAdmins(COLOR_NOTES2, "zBlock: The hacked money will be removed!");
                                                        foreach(Player, i)
                                                        {
                                                                PlayerPlaySound(i, 1085, 0.0, 0.0, 0.0);
                                                        }
                                                }
                                        }
                                        case 1:
                                        {
                                            if(!BanForSpeedHack)
                                                {
                                                    BanForSpeedHack = 1;
                                                    format(string, sizeof(string), "zBlock: %s(%d) has enabled the 'Ban for Speed-Hack' feature.", GetName(playerid), playerid);
                                                        SendClientMessageToAll(COLOR_NOTES, string);
                                                        foreach(Player, i)
                                                        {
                                                                PlayerPlaySound(i, 1085, 0.0, 0.0, 0.0);
                                                        }
                                                }
                                                else
                                                {
                                                    BanForSpeedHack = 0;
                                                    format(string, sizeof(string), "zBlock: %s(%d) has disabled the 'Ban for Speed-Hack' feature.", GetName(playerid), playerid);
                                                        SendClientMessageToAll(COLOR_NOTES2, string);
                                                        foreach(Player, i)
                                                        {
                                                                PlayerPlaySound(i, 1085, 0.0, 0.0, 0.0);
                                                        }
                                                }
                                        }
                                }
                        }
                }
        }
        return 1;
}
public OnPlayerExitVehicle(playerid, vehicleid)
{
        return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
        return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
        return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
        return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
        return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
        new stringz[92];
        if(!success)
        {
                foreach(Player, i)
                {
                    GetPlayerIp(i, ip, 16);

                    if(strcmp(PlayerIP(i),ip) == 0)
                    {
                        RCONLoginFails[i]++;
                        if(RCONLoginFails[i] <= 2)
                        {
                            SendClientMessage(i, COLOR_NOTES2, "zBlock: Please don't try to get the RCON pass..");
                            return 0;
                                }
                                else
                                {
                                    RCONLoginFails[i] = 0;

                                    new Query[240], DBResult:result, day, month, year, second, minute, hour;
                                    new reason[20] = "RCON Login Attempt";

                                        getdate(day, month, year);
                                        gettime(hour, minute, second);
                                        format(datestring, sizeof(datestring), "%i-%i-%i", day, month, year);
                                        format(timestring, sizeof(timestring), "%i:%i:%i", hour, minute, second);

                                        format(Query, sizeof(Query), "INSERT INTO `BANNED` (`NAME`, `IP`, `REASON`, `ADMIN`, `DATE`, `TIME`) VALUES ('%s', '%s', '%s', '%s', '%s', '%s')", DB_Escape(GetName(i)), DB_Escape(PlayerIP(i)), reason, BOT_NAME, datestring, timestring);
                                        result = db_query(zBlock, Query);
                                        if(result) printf(">> SQLITE: successfully added %s's ban info", GetName(i));
                                        else printf(">> SQLITE: could not add %s's ban info", GetName(i));


                                        SetTimerEx("KickTimer", 100, false, "i", i);

                                        format(stringz, sizeof(stringz), "* {F81414}zBlock has banned {FFFFFF}%s(%d) {F81414}for {FFFFFF}RCON Login attempts!", GetName(i), i);
                                        SendClientMessageToAll(-1, stringz);
                                }
                        }
                }
        }
        else
        {
            foreach(Player, i)
                {
                    GetPlayerIp(i, ip, 16);
                    if(strcmp(PlayerIP(i),ip) == 0)
                    {
                        if(!AdminImmunity{ i })
                        {
                                SendClientMessage(i, COLOR_NOTES, "zBlock: RCON login successfull, use '/zblock_login (password)' to get your 'Immunity'");
                                }
                        }
                }
        }
        return 1;
}

public OnPlayerUpdate(playerid)
{
        return 1;
}

/***** STOCKs, zBlock TIMERs etc. *****/

stock SendMessageToAdmins(color, text[])
{
    foreach(Player, i)
    {
        if(AdminImmunity{ i })
        {
            SendClientMessage(i, color, text);
        }
    }
}

stock GetName(playerid)
{
        new pnameid[24];
        GetPlayerName(playerid,pnameid,sizeof(pnameid));
        return pnameid;
}
stock PlayerIP(playerid)
{
        new str[16];
        GetPlayerIp(playerid, str, sizeof(str));
        return str;
}

stock ResetInfo(playerid)
{
        Muted{ playerid } = false;
        ACDetected{ playerid } = false;
        AdminImmunity{ playerid } = false;
        LoggedIn{ playerid } = false;

        AntiSpam[playerid] = 0;
        MutedTimes[playerid] = 0;
        ACTimesDetected[playerid] = 0;
        WarnForAdvert[playerid] = 0;
        RCONLoginFails[playerid] = 0;
}
stock DB_Escape(text[])
{
    new
        ret[80 * 2],
        ch,
        i,
        j;
    while ((ch = text[i++]) && j < sizeof (ret))
    {
        if (ch == '\'')
        {
            if (j < sizeof (ret) - 2)
            {
                ret[j++] = '\'';
                ret[j++] = '\'';
            }
        }
        else if (j < sizeof (ret))
        {
            ret[j++] = ch;
        }
        else
        {
            j++;
        }
    }
    ret[sizeof (ret) - 1] = '\0';
    return ret;
}
stock GetPlayerSpeed(playerid)
{
    new Float:ST[4];
    if(IsPlayerInAnyVehicle(playerid))
    GetVehicleVelocity(GetPlayerVehicleID(playerid),ST[0],ST[1],ST[2]);
    else GetPlayerVelocity(playerid,ST[0],ST[1],ST[2]);
    ST[3] = floatsqroot(floatpower(floatabs(ST[0]), 2.0) + floatpower(floatabs(ST[1]), 2.0) + floatpower(floatabs(ST[2]), 2.0)) * 179.28625;
    return floatround(ST[3]);
}
stock GivePlayerCash(playerid, money)
{
    Cash[playerid] += money;
    ResetMoneyBar(playerid);
    UpdateMoneyBar(playerid,Cash[playerid]);
    return Cash[playerid];
}
stock SetPlayerCash(playerid, money)
{
    Cash[playerid] = money;
    ResetMoneyBar(playerid);
    UpdateMoneyBar(playerid,Cash[playerid]);
    return Cash[playerid];
}
stock ResetPlayerCash(playerid)
{
    Cash[playerid] = 0;
    ResetMoneyBar(playerid);
    UpdateMoneyBar(playerid,Cash[playerid]);
    return Cash[playerid];
}
stock GetPlayerCash(playerid)
{
    return Cash[playerid];
}
forward KickTimer(playerid);
public KickTimer(playerid)
{
    Kick(playerid);
    return 1;
}
forward Unmute(playerid);
public Unmute(playerid)
{
        Muted{ playerid } = false;
    return 1;
}
forward ResetAntiSpam(playerid);
public ResetAntiSpam(playerid)
{
    AntiSpam[playerid] = 0;
        return 1;
}
forward AntiCheat();
public AntiCheat()
{
        new Float:health, Float:armour, reason[24], stringz[120];
        new Float:x,Float:y,Float:z;
        new anim;
        new Difference, Result;

        new Query[240], DBResult:result, day, month, year, second, minute, hour;
        getdate(day, month, year);
        gettime(hour, minute, second);

        format(datestring, sizeof(datestring), "%i-%i-%i", day, month, year);
        format(timestring, sizeof(timestring), "%i:%i:%i", hour, minute, second);

        foreach(Player, i)
        {
            GetPlayerHealth(i, health);
            GetPlayerArmour(i, armour);
            anim = GetPlayerAnimationIndex(i);
                GetPlayerVelocity(i,x,y,z);

        if(!AdminImmunity{ i })
            {
                        if(GetPlayerWeapon(i) == 38)
                        {
                    reason = "Minigun";
                        format(stringz, sizeof(stringz), "* {F81414}zBlock has banned {FFFFFF}%s(%d) {F81414}for using {FFFFFF}Weapon Hacks!", GetName(i), i);
                        SendClientMessageToAll(-1, stringz);
                                SetTimerEx("KickTimer", 100, false, "i", i);

                                format(Query, sizeof(Query), "INSERT INTO `BANNED` (`NAME`, `IP`, `REASON`, `ADMIN`, `DATE`, `TIME`) VALUES ('%s', '%s', '%s', '%s', '%s', '%s')", DB_Escape(GetName(i)), DB_Escape(PlayerIP(i)), reason, BOT_NAME, datestring, timestring);
                                result = db_query(zBlock, Query);

                                if(result) printf(">> SQLITE: successfully added %s's ban info", GetName(i));
                                else printf(">> SQLITE: could not add %s's ban info", GetName(i));

                                printf("« ANTI-CHEAT has banned %s for using Weapon-Hacks!", GetName(i));
                        }
                        if(x <= -0.800000  || y <= -0.800000 || z <= -0.800000 && anim == 1008)
                        {
                                if(GetPlayerWeapon(i) != 46)
                            {
                                ACTimesDetected[i]++;
                                if(ACTimesDetected[i] < 3)
                                {
                                                format(stringz, sizeof(stringz), "* {F81414}zBlock has detected {FFFFFF}%s(%d){F81414} using {FFFFFF}Fly hacks!", GetName(i), i);
                                                SendMessageToAdmins(-1, stringz);
                                        }
                                        else if(ACTimesDetected[i] >= 3)
                                        {
                                            reason = "Fly hack";
                                        format(stringz, sizeof(stringz), "* {F81414}zBlock has banned {FFFFFF}%s(%d) {F81414}for using {FFFFFF}Fly Hacks!", GetName(i), i);
                                        SendClientMessageToAll(-1, stringz);
                                                SetTimerEx("KickTimer", 100, false, "i", i);

                                                format(Query, sizeof(Query), "INSERT INTO `BANNED` (`NAME`, `IP`, `REASON`, `ADMIN`, `DATE`, `TIME`) VALUES ('%s', '%s', '%s', '%s', '%s', '%s')", DB_Escape(GetName(i)), DB_Escape(PlayerIP(i)), reason, BOT_NAME, datestring, timestring);
                                                result = db_query(zBlock, Query);

                                                if(result) printf(">> SQLITE: successfully added %s's ban info", GetName(i));
                                                else printf(">> SQLITE: could not add %s's ban info", GetName(i));

                                                printf("zBlock: %s has been banned for using Fly-Hacks!", GetName(i));
                                        }
                                }
                        }
                        if(armour >= 100)
                        {
                            if(ACTimesDetected[i] == 0)
                            {
                        ACTimesDetected[i]++;

                        format(stringz, sizeof(stringz), "* {F81414}zBlock has detected {FFFFFF}%s(%d) {F81414}POSSIBLY using {FFFFFF}Armour hacks!", GetName(i), i);
                                        SendMessageToAdmins(-1, stringz);
                                }
                        }
                        if(GetPlayerSpeed(i) > 271)
                        {
                                ACTimesDetected[i]++;
                        if(ACTimesDetected[i] <= 4)
                            {
                                        format(stringz, sizeof(stringz), "zBlock: %s(%d) is possibly Speed-Hacking, KM/H: %d - %d warnings", GetName(i), i, GetPlayerSpeed(i), ACTimesDetected[i]);
                                    SendMessageToAdmins(COLOR_NOTES2, stringz);
                                    printf("zBlock: %s has been detected using Speed-Hacks | %d KM/H, %d/5 warnings |", GetName(i), GetPlayerSpeed(i), ACTimesDetected[i]);
                                }
                                else
                                {
                                    if(BanForSpeedHack)
                                    {
                                            reason = "Speed Hack";
                                                format(stringz, sizeof(stringz), "zBlock: %s(%d) has been BANNED for using Speed-Hacks %d warnings", GetName(i), i, ACTimesDetected[i]);
                                                SendMessageToAdmins(COLOR_NOTES2, stringz);

                                                SetTimerEx("KickTimer", 100, false, "i", i);

                                                format(stringz, sizeof(stringz), "* {F81414}zBlock has banned {FFFFFF}%s(%d) {F81414}for using Speed hacks!", GetName(i), i);
                                                SendClientMessageToAll(-1, stringz);
                                                printf("zBlock: %s has been banned for using Speed-Hacks!", GetName(i));

                                                format(Query, sizeof(Query), "INSERT INTO `BANNED` (`NAME`, `IP`, `REASON`, `ADMIN`, `DATE`, `TIME`) VALUES ('%s', '%s', '%s', '%s', '%s', '%s')", DB_Escape(GetName(i)), DB_Escape(PlayerIP(i)), reason, BOT_NAME, datestring, timestring);
                                                result = db_query(zBlock, Query);
                                                if(result) printf(">> SQLITE: successfully added %s's ban info", GetName(i));
                                                else printf(">> SQLITE: could not add %s's ban info", GetName(i));
                                        }
                                }
                                printf("*** zBlock: %s | Possibly speed-hacking, %d/271", GetName(i), GetPlayerSpeed(i));
                        }
                        if(GetPlayerCash(i) > GetPlayerMoney(i))
                        {
                                if(!BanForMoneyHack)
                                {
                                        ACDetected{ i } = true;
                                        ACTimesDetected[i]++;

                                        if(!ACDetected { i })
                                        {
                                                format(stringz, sizeof(stringz), "zBlock: %s(%d) is ( possibly ) Money-Hacking, money reset.", GetName(i), i);
                                                SendMessageToAdmins(COLOR_NOTES2, stringz);
                                                format(stringz, sizeof(stringz), "zBlock: Summary about %s's warning: SSM: %d$ PSM: %d$", GetPlayerCash(i), GetPlayerMoney(i));
                                                SendMessageToAdmins(COLOR_NOTES2, stringz);
                                        }

                                        Difference = GetPlayerCash(i) - GetPlayerMoney(i);
                                        Result = GetPlayerCash(i) - Difference;
                                        SetPlayerCash(i, Result);
                                }
                                else
                                {
                                    ACTimesDetected[i]++;
                                        reason = "Money hack";
                                    Difference = GetPlayerCash(i) - GetPlayerMoney(i);
                                    Result = GetPlayerCash(i) - Difference;

                                    printf("* zBlock: Adding ban on '%s' due to Money-Hacks", GetName(i));
                                    printf("* zBlock: Proof: (SERVER SIDE) %d$ - (PLAYER SIDE) %d$, %d$ difference.", GetPlayerCash(i), GetPlayerMoney(i), Difference);

                                        SetTimerEx("KickTimer", 100, false, "i", i);

                                        format(stringz, sizeof(stringz), "* {F81414}zBlock has banned {FFFFFF}%s(%d) {F81414}for using Money hacks!", GetName(i), i);
                                        SendClientMessageToAll(-1, stringz);

                                        format(Query, sizeof(Query), "INSERT INTO `BANNED` (`NAME`, `IP`, `REASON`, `ADMIN`, `DATE`, `TIME`) VALUES ('%s', '%s', '%s', '%s', '%s', '%s')", DB_Escape(GetName(i)), DB_Escape(PlayerIP(i)), reason, BOT_NAME, datestring, timestring);
                                        result = db_query(zBlock, Query);
                                        if(result) printf(">> SQLITE: successfully added %s's ban info", GetName(i));
                                        else printf(">> SQLITE: could not add %s's ban info", GetName(i));
                                }
                        }
                }
        }
        return 1;
}
forward EndProcessing(playerid);
public EndProcessing(playerid)
{
        new Float:x, Float:y, Float:z, reason[18] = "s0beit client", stringz[112];
        GetPlayerCameraFrontVector(playerid, x, y, z);
        #pragma unused x
        #pragma unused y
        if(z < -0.8)
        {

            SendClientMessage(playerid, COLOR_NOTES, "Processed successfully.");

            ACDetected{ playerid } = true;
                FirstSpawn{ playerid } = true;

            ACTimesDetected[playerid]++;
                if(ACTimesDetected[playerid] == 1)
                {
                        printf("« ANTI-CHEAT has detected %s using Hacked Client - s0beit! »", GetName(playerid));
                }
                else if(ACTimesDetected[playerid] == 2)
                {
                        SpawnPlayer(playerid);
                        printf("« ANTI-CHEAT has detected %s using Hacked Client - s0beit! »", GetName(playerid));
                }
                else if(ACTimesDetected[playerid] >= 3)
                {
                        SetTimerEx("KickTimer", 100, false, "i", playerid);

                        SendClientMessage(playerid, -1, "{F81414}zBlock {FFFFFF}- {F81414}You've been banned for using {FFFFFF}s0beit {F81414}client!");
                        format(stringz, sizeof(stringz), "* {F81414}zBlock has banned {FFFFFF}%s(%d){F81414} for using {FFFFFF}s0beit {F81414}client!", GetName(playerid), playerid);
                        SendClientMessageToAll(-1, stringz);

                        printf("« ANTI-CHEAT has banned %s for Hacked Client - s0beit! »", GetName(playerid));
                SetPlayerSpecialAction(playerid,SPECIAL_ACTION_HANDSUP);

                new Query[240], DBResult:result,  day, month, year, second, minute, hour;
                        getdate(day, month, year);
                        gettime(hour, minute, second);

                        format(datestring, sizeof(datestring), "%i-%i-%i", day, month, year);
                        format(timestring, sizeof(timestring), "%i:%i:%i", hour, minute, second);

                        format(Query, sizeof(Query), "INSERT INTO `BANNED` (`NAME`, `IP`, `REASON`, `ADMIN`, `DATE`, `TIME`) VALUES ('%s', '%s', '%s', '%s', '%s', '%s')", DB_Escape(GetName(playerid)), DB_Escape(PlayerIP(playerid)), reason, BOT_NAME, datestring, timestring);
                        result = db_query(zBlock, Query);
                        if(result) printf(">> SQLITE: successfully added %s's ban info", GetName(playerid));
                        else printf(">> SQLITE: could not add %s's ban info", GetName(playerid));
                }
        }
        else
        {
                SendClientMessage(playerid, -1, "Processed successfully.");
                FirstSpawn{ playerid } = false;
                TogglePlayerControllable(playerid, 1);
        }
        return 1;
}
forward CheckForFile();
public CheckForFile()
{
        new slhour, slminute, slsecond, slyear, slmonth, slday;
        if(fexist("/zblock/password.txt"))
        {
            print("NOTIFICATION: 'password.txt' has been successfully created'");
            print("INFO: File location: /scriptfiles/zBlock/\nINFO: Automatically set the default password.");
        gettime(slhour, slminute, slsecond);
                getdate(slyear, slmonth, slday);

                new File:zBlockstuff = fopen("/zblock/password.txt", io_write);
        if(zBlockstuff)
                {
                        fwrite(zBlockstuff, "defaultpassword5791");
                        fclose(zBlockstuff);
                }
        }
        else print("WARNING: could NOT create 'password.txt' at 'scriptfiles/zblock'");
        return 1;
}
forward fcreate(filename[]);
public fcreate(filename[])
{
    if (fexist(filename)){return false;}
    new File:fhandle = fopen(filename,io_write);
    fclose(fhandle);
    return true;
}
