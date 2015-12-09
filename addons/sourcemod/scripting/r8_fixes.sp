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

public void OnPluginStart()
{
	HookEvent("bomb_begindefuse", Event_BombBeginDefuse);
	HookEvent("bomb_abortdefuse", Event_BombEndDefuse);
	HookEvent("bomb_defused", Event_BombEndDefuse);
}

public Action Event_BombBeginDefuse(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	int weapon = GetPlayerWeaponSlot(client, 1);
	if(weapon > -1)
	{
		SetEntPropFloat(weapon, Prop_Send, "m_flNextSecondaryAttack", GetGameTime() + 100.0);
	}
}

public Action Event_BombEndDefuse(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	int weapon = GetPlayerWeaponSlot(client, 1);
	if(weapon > -1)
	{
		SetEntPropFloat(weapon, Prop_Send, "m_flNextSecondaryAttack", GetGameTime() + 1.0);
	}
}
