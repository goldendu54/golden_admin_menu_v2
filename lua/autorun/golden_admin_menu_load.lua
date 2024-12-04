-- Loader file for 'golden_admin_menu'
-- Automatically created by gcreator (github.com/MaaxIT)
GAdmin_Menu = {}

local addon_version = "1.0.0"

-- Make loading functions
local function Inclu(f) return include("golden_admin_menu/"..f) end
local function AddCS(f) return AddCSLuaFile("golden_admin_menu/"..f) end
local function IncAdd(f) return Inclu(f), AddCS(f) end

-- Load addon files
IncAdd("config.lua")
IncAdd("constants.lua")

if SERVER then

	Inclu("server/sv_functions.lua")
	Inclu("server/sv_hooks.lua")
	Inclu("server/sv_network.lua")

	AddCS("client/cl_functions.lua")
	AddCS("client/cl_hooks.lua")
	AddCS("client/cl_network.lua")

	MsgC(Color(255, 0, 0), "[GAdmin Menu] ", Color(255, 255, 255), "Addon loaded successfully! Version: "..addon_version.."\n")

else

	Inclu("client/cl_functions.lua")
	Inclu("client/cl_hooks.lua")
	Inclu("client/cl_network.lua")

end

-- Auto load the language folder and the language files
local language_folder = "golden_admin_menu/languages/"
local files, folders = file.Find(language_folder.."*", "LUA")
for k, v in pairs(files) do
	if string.GetExtensionFromFilename(v) == "lua" then
		IncAdd("languages/"..v)
	end
end

-- Auto load the admin systems
local admin_systems_folder = "golden_admin_menu/admin_systems/"
local files, folders = file.Find(admin_systems_folder.."*", "LUA")
for k, v in pairs(files) do
	if string.GetExtensionFromFilename(v) == "lua" then
		IncAdd("admin_systems/"..v)
	end
end

