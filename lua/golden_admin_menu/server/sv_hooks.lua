-- Called when the server is initialized
hook.Add("Initialize", "GAdmin_Menu:Initialize", function()
	print("[GAdmin_Menu] Addon successfully initialized!")
end)


hook.Add("PlayerSay", "GAdmin_Menu:PlayerSay", function(ply, text, team)
    local text = string.lower(text)
    if text == GAdmin_Menu.Config.StaffCommand then
		if not GAdmin_Menu.Config.AdminRanks[ply:GetUserGroup()] then
			GAdmin_Menu:Notify(ply, "You are not an admin!")
			return 
		end
        GAdmin_Menu:SetToStaffMode(ply)
		return ""

	elseif text == GAdmin_Menu.Config.MenuCommand then
		if not GAdmin_Menu.Config.AdminRanks[ply:GetUserGroup()] then 
			GAdmin_Menu:Notify(ply, "You are not an admin!")
			return
		end
		GAdmin_Menu:AdminMenu(ply)
		return ""

	elseif text == GAdmin_Menu.Config.MaskCommand then
		if not GAdmin_Menu.Config.AdminRanks[ply:GetUserGroup()] then 
			GAdmin_Menu:Notify(ply, "You are not an admin!")
			return
		end
			GAdmin_Menu:ModMask(ply)
		return ""

	elseif text == GAdmin_Menu.Config.PowerCommand then
		if not GAdmin_Menu.Config.AdminRanks[ply:GetUserGroup()] then
			GAdmin_Menu:Notify(ply, "You are not an admin!")
			return
		end
		GAdmin_Menu:ModPower(ply)
		return ""

    end
	return
end)

hook.Add("PlayerButtonDown", "GAdmin_Menu:PlayerButtonDown", function(ply, button)
	if button == GAdmin_Menu.Config.MenuKey then
		if not GAdmin_Menu.Config.AdminRanks[ply:GetUserGroup()] then return end
		GAdmin_Menu:AdminMenu(ply)
	end
end)

hook.Add("PlayerDisconnected", "GAdmin_Menu:PlayerDisconnected", function(ply)
	if ply:GetNWBool("GAdmin:StaffMode") then
		ply:SetNWBool("GAdmin:StaffMode", false)
	end

	if ply:GetNWBool("GAdmin:ModMask") then
		ply:SetNWBool("GAdmin:ModMask", false)
	end

	if ply:GetNWBool("GAdmin:ModPower") then
		ply:SetNWBool("GAdmin:ModPower", false)
	end
end)


--[[  NOT USED ANYMORE
hook.Add("Think", "GAdmin_Menu:Think", function()
	for k, v in pairs(player.GetAll()) do
		if v:GetMoveType() == MOVETYPE_NOCLIP then 
			v:SetNWBool("GAdmin:NoClip", true)
		else
			v:SetNWBool("GAdmin:NoClip", false)
		end

	end
end)
]]
hook.Add("EntityEmitSound", "GAdmin_Menu:EntityEmitSound", function(data)
	local ply = data.Entity
    if ply:GetClass() == "player" then
		if ply:GetNWBool("GAdmin:StaffMode") or ply:GetNWBool("GAdmin:ModMask") then 
			return false
		else
			return true
		end
	end
end)

hook.Add("PlayerFootstep", "GAdmin_Menu:PlayerFootstep", function(ply, pos, foot, soundName, volume, filter)
	if ply:GetNWBool("GAdmin:StaffMode") or ply:GetNWBool("GAdmin:ModMask") then 
		return true
	else
		return false
	end
end)