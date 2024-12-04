-- Network strings registration
util.AddNetworkString("GAdmin_Menu:OpenMenu")
util.AddNetworkString("GAdmin_Menu:SetAdminMode")

net.Receive("GAdmin_Menu:SetAdminMode", function(len, ply)
	if not IsValid(ply) then return end	
	local iCurTime = CurTime()
	if (ply.iGAdmin_MenuCooldown or 0) > iCurTime then return end
	ply.iGAdmin_MenuCooldown = iCurTime + 1

	if not GAdmin_Menu.Config.AdminRanks[ply:GetUserGroup()] then  
        GAdmin_Menu:Notify(ply, GAdmin_Menu:GetLanguage("notAdmin"))
        return
    end

	GAdmin_Menu:SetToStaffMode(ply)

end)



