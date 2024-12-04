GAdmin_Menu.Config = GAdmin_Menu.Config or {}
GAdmin_Menu.Lang = GAdmin_Menu.Lang  or {}

-- Admin ranks
GAdmin_Menu.Config.AdminRanks = {
	["superadmin"] = true,	
	["admin"] = true,
}

GAdmin_Menu.Config.Title = "GOLDEN - Admin Menu" -- The title of the menu


GAdmin_Menu.Config.MenuKey = KEY_F6 -- The key to open the menu

GAdmin_Menu.Config.MenuCommand = "!amenu" -- The command to open the menu

GAdmin_Menu.Config.StaffCommand = "!staff" -- The command to open the staff menu

GAdmin_Menu.Config.PowerCommand = "!power" -- The command to open the power menu

GAdmin_Menu.Config.MaskCommand = "!mask" -- The command to open the mask menu


GAdmin_Menu.Config.Debug = true -- Enable debug mode (prints debug messages to console) 


GAdmin_Menu.Config.Language = "en" -- The language to use

GAdmin_Menu.Config.AdminSystem = "sadmin" -- The admin system to use

function GAdmin_Menu:GetLanguage(key)

	local lang = GAdmin_Menu.Config.Language or "en"
	if not key then key = "nil" end

	if GAdmin_Menu.Lang[lang] and GAdmin_Menu.Lang[lang][key] then
		return GAdmin_Menu.Lang[lang][key]
	end
end

function GAdmin_Menu:GetAdminSystem()

	local sys = GAdmin_Menu.Config.AdminSystem or "nil"
	if GAdmin_Menu.AdminSystem[sys] then
		return GAdmin_Menu.AdminSystem[sys]
	end
end



