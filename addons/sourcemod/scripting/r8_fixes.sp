#pragma semicolon 1

#include <sourcemod>
#include <sdktools>

public Plugin myinfo = 
{
	name = "R8 Revolver Fixes",
	author = "necavi",
	description = "A selection of fixes for the R8 Revolver.",
	version = "0.0.1",
	url = ""
};

ConVar g_cvFreezetime;

public void OnPluginStart()
{
	HookEvent("bomb_begindefuse", Event_BombBeginDefuse);
	HookEvent("bomb_abortdefuse", Event_BombEndDefuse);
	HookEvent("bomb_defused", Event_BombEndDefuse);
	HookEvent("round_start", Event_RoundStart);
	HookEvent("round_freeze_end", Event_RoundFreezeEnd);
	g_cvFreezetime = FindConVar("mp_freezetime");
}

public Action Event_RoundStart(Event event, const char[] name, bool dontBroadcast)
{
	if(g_cvFreezetime.IntValue > 0)
	{
		for (new i = 1; i <= MaxClients; i++)
		{
			if(IsClientConnected(i) && IsClientInGame(i))
			{
				DisableSecondary(i);
			}
		}
	}
}

public Action Event_RoundFreezeEnd(Event event, const char[] name, bool dontBroadcast)
{
	for (new i = 1; i <= MaxClients; i++)
	{
		if(IsClientConnected(i) && IsClientInGame(i))
		{
			EnableSecondary(i);
		}
	}
}

public Action Event_BombBeginDefuse(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	DisableSecondary(client);
}

public Action Event_BombEndDefuse(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	EnableSecondary(client);
}

DisableSecondary(int client)
{
	int weapon = GetPlayerWeaponSlot(client, 1);
	if(weapon > -1)
	{
		SetEntPropFloat(weapon, Prop_Send, "m_flNextSecondaryAttack", GetGameTime() + 100.0);
	}	
}
EnableSecondary(int client)
{
	int weapon = GetPlayerWeaponSlot(client, 1);
	if(weapon > -1)
	{
		SetEntPropFloat(weapon, Prop_Send, "m_flNextSecondaryAttack", GetGameTime() + 1.0);
	}	
}