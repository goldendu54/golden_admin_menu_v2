-- Called when the server is initialized
hook.Add("Initialize", "GAdmin_Menu:Initialize", function()
	print("[GAdmin_Menu] Addon successfully initialized!")
end)


hook.Add("PlayerSay", "GAdmin_Menu:PlayerSay", function(ply, text, team)
	if not IsValid(ply) then return end	

    local text = string.lower(text)
    if text == GAdmin_Menu.Config.StaffCommand then
		if not GAdmin_Menu.Config.AdminRanks[ply:GetUserGroup()] then
			GAdmin_Menu:Notify(ply, GAdmin_Menu:GetLanguage("notAdmin"))
			return 
		end
        GAdmin_Menu:SetToStaffMode(ply)
		return ""

	elseif text == GAdmin_Menu.Config.MenuCommand then
		if not GAdmin_Menu.Config.AdminRanks[ply:GetUserGroup()] then 
			GAdmin_Menu:Notify(ply, GAdmin_Menu:GetLanguage("notAdmin"))
			return
		end
		GAdmin_Menu:AdminMenu(ply)
		return ""

	elseif text == GAdmin_Menu.Config.MaskCommand then
		if not GAdmin_Menu.Config.AdminRanks[ply:GetUserGroup()] then 
			GAdmin_Menu:Notify(ply, GAdmin_Menu:GetLanguage("notAdmin"))
			return
		end
			GAdmin_Menu:ModMask(ply)
		return ""

	elseif text == GAdmin_Menu.Config.PowerCommand then
		if not GAdmin_Menu.Config.AdminRanks[ply:GetUserGroup()] then
			GAdmin_Menu:Notify(ply, GAdmin_Menu:GetLanguage("notAdmin"))
			return
		end
		GAdmin_Menu:ModPower(ply)
		return ""

    end
	return
end)

hook.Add("PlayerButtonDown", "GAdmin_Menu:PlayerButtonDown", function(ply, button)
	if not IsValid(ply) then return end	

	if button == GAdmin_Menu.Config.MenuKey then
		if not GAdmin_Menu.Config.AdminRanks[ply:GetUserGroup()] then return end
		GAdmin_Menu:AdminMenu(ply)
	end
end)

hook.Add("PlayerDisconnected", "GAdmin_Menu:PlayerDisconnected", function(ply)
	ply:SetNWBool("GAdmin:StaffMode", nil)
	ply:SetNWBool("GAdmin:ModMask", nil)
	ply:SetNWBool("GAdmin:ModPower", nil)
end)

hook.Add("EntityEmitSound", "GAdmin_Menu:EntityEmitSound", function(data)
	local ply = data.Entity
	if not IsValid(ply) then return end	
    if ply:GetClass() == "player" then
		if ply:GetNWBool("GAdmin:StaffMode") or ply:GetNWBool("GAdmin:ModMask") then 
			return false
		else
			return true
		end
	end
end)

hook.Add("PlayerFootstep", "GAdmin_Menu:PlayerFootstep", function(ply, pos, foot, soundName, volume, filter)
	if not IsValid(ply) then return end	
	if ply:GetNWBool("GAdmin:StaffMode") or ply:GetNWBool("GAdmin:ModMask") then 
		return true
	else
		return false
	end
end)