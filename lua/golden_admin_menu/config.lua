GAdmin_Menu.Config = GAdmin_Menu.Config or {}
GAdmin_Menu.Lang = GAdmin_Menu.Lang  or {}



GAdmin_Menu.Config.MenuKey = KEY_F6 -- The key to open the menu



GAdmin_Menu.Config.MenuCommand = "!amenu" -- The command to open the menu

GAdmin_Menu.Config.StaffCommand = "!staff" -- The command to open the staff menu

GAdmin_Menu.Config.PowerCommand = "!power" -- The command to open the power menu

GAdmin_Menu.Config.MaskCommand = "!mask" -- The command to open the mask menu



GAdmin_Menu.Config.Title = "GOLDEN - Admin Menu" -- The title of the menu


-- Admin ranks
GAdmin_Menu.Config.AdminRanks = {
	["superadmin"] = true,	
	["admin"] = true,
}
GAdmin_Menu.Config.Debug = true -- Enable debug mode (prints debug messages to console) 

GAdmin_Menu.Config.Language = "en" -- The language to use

GAdmin_Menu.Lang["en"] = {
	["nil"] = "Nil",
	["staffActions"] = "Staff Actions :",
	["setStaffMod"] = "Staff Mod",
	["modMask"] = "Mod Mask",
	["modPower"] = "Mod Power",
	["selectedPlayer"] = "Selected player :",
	["selectPlayer"] = "Select a player ...",

	["name"] = "Name",
	["steamID64"] = "SteamID64",
	["group"] = "Group",
	["money"] = "Money",
	["job"] = "Job",
	["health"] = "Health",
	["armor"] = "Armor",
	["hunger"] = "Hunger",
	["dead"] = "Dead",
	["no"] = "No",
	["yes"] = "Yes",

	
	["actions"] = "Actions",
	["teleport"] = "Teleport",
	["bring"] = "Bring",
	["goto"] = "Goto",
	["freeze"] = "Freeze",
	["unfreeze"] = "Unfreeze",
	["kick"] = "Kick",
	["ban"] = "Ban",

	["needToSelecPlayer"] = "You need to select a player!",
	["cannotDoOnYourself"] = "You cannot do this action on yourself!",


	["reason"] = "Reason",
	["duration"] = "Duration",
	["confirm"] = "Confirm",

	["notAdmin"] = "You are not an admin!",





}

function GAdmin_Menu:GetLanguage(key)

	local lang = GAdmin_Menu.Config.Language or "en"

	if not key then key = "nil" end

	if GAdmin_Menu.Lang[lang] and GAdmin_Menu.Lang[lang][key] then
		return GAdmin_Menu.Lang[lang][key]
	end

end