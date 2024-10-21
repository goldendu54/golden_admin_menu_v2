-- Loader file for 'golden_admin_menu'
-- Automatically created by gcreator (github.com/MaaxIT)
GAdmin_Menu = {}

local addon_version = ""

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
