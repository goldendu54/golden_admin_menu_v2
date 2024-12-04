GAdmin_Menu.AdminSystem = GAdmin_Menu.AdminSystem or {}

GAdmin_Menu.AdminSystem["sadmin"] = {
	["goto"] = function(ply, target)
		RunConsoleCommand("sa", "goto", target:Nick())
	end,

	["bring"] = function(ply, target)
		RunConsoleCommand("sa", "bring", target:Nick())
	end,

	["return"] = function(ply, target)
		RunConsoleCommand("sa", "return", target:Nick())
	end,

	["freeze"] = function(ply, target)
		RunConsoleCommand("sa", "freeze", target:Nick())
	end,

	["unfreeze"] = function(ply, target)
		RunConsoleCommand("sa", "unfreeze", target:Nick())
	end,

	["kick"] = function(ply, target, reason)
		if not reason then reason = "No reason" end
		RunConsoleCommand("sa", "kick", target:Nick(), reason)
	end,

	["ban"] = function(ply, target, duration, reason)
		if not duration then duration = 0 end
		if not reason then reason = "No reason" end
		RunConsoleCommand("sa", "ban", target:Nick(), duration, reason)
	end,

	["spectate"] = function(ply)
		RunConsoleCommand("sa", "spectate", target:Nick())
	end,

	["slay"] = function(ply, target)
		RunConsoleCommand("sa", "slay", target:Nick())
	end,

	["setHealth"] = function(ply, target, health)
		RunConsoleCommand("sa", "sethealth", target:Nick(), health)
	end,

	["setArmor"] = function(ply, target, armor)
		RunConsoleCommand("sa", "setarmor", target:Nick(), armor)
	end,



}