#pragma semicolon 1

#include <sourcemod>

public Plugin myinfo = 
{
	name = "R8 Revolver Fixes",
	author = "necavi",
	description = "A selection of fixes for the R8 Revolver.",
	version = "0.0.1",
	url = ""
};

bool g_bCanUseSecondary[MAXPLAYERS + 1] = true;

public void OnPluginStart()
{
	HookEvent("bomb_begindefuse", Event_BombBeginDefuse);
	HookEvent("bomb_abortdefuse", Event_BombEndDefuse);
	HookEvent("bomb_defused", Event_BombEndDefuse);
	HookEvent("round_start", Event_RoundStart);
}

public Action Event_BombBeginDefuse(Event event, const char[] name, bool dontBroadcast)
{
	g_bCanUseSecondary[GetClientOfUserId(event.GetInt("userid"))] = false;
	PrintToServer("Player %N can no longer use secondary fire.", GetClientOfUserId(event.GetInt("userid")));
}

public Action Event_BombEndDefuse(Event event, const char[] name, bool dontBroadcast)
{
	g_bCanUseSecondary[GetClientOfUserId(event.GetInt("userid"))] = true;
	PrintToServer("Player %N can again use secondary fire.", GetClientOfUserId(event.GetInt("userid")));
}

public Action Event_RoundStart(Event event, const char[] name, bool dontBroadcast)
{
	for (int i = 1; i < MaxClients; i++)
	{
		g_bCanUseSecondary[i] = true;
	}
}

public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &subtype, int &cmdnum, int &tickcount, int &seed, int mouse[2])
{
	if(!g_bCanUseSecondary[client] && (buttons & IN_ATTACK2))
	{
		buttons &= ~IN_ATTACK2;
	}
}