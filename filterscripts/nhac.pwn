#include <a_samp>
#include <zcmd>
#include <gvc>
#define  DIALOG_TIMKIEM_NHAC (1)


CMD:nct(playerid, params[])
{
    GVC_ENTER_KEY(playerid, params);
}

CMD:nctdl(playerid, params[])
{
    ShowPlayerDialog(playerid, DIALOG_TIMKIEM_NHAC, DIALOG_STYLE_INPUT, "GvC Tim Kiem Nhac", "Hay dien` ten bai hat vao day", "Tim Kiem", "Close");
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_TIMKIEM_NHAC)
    {
        if(response)
        {
            GVC_ENTER_KEY(playerid, inputtext);
        }
        else
        {
            GameTextForPlayer(playerid, "Da dong bang tim kiem", 3000, 4);
        }
    }
}
