-- Network strings registration
util.AddNetworkString("GAdmin_Menu:UpdateCache")
util.AddNetworkString("GAdmin_Menu:OpenMenu")
util.AddNetworkString("GAdmin_Menu:SetAdminMode")
util.AddNetworkString("GAdmin_Menu:DarkrpNotify")
util.AddNetworkString("GAdmin_Menu:SetClass")
util.AddNetworkString("GAdmin_Menu:OpenSimpleMenu")

-- Called when the client ask for a server cache update
net.Receive("GAdmin_Menu:UpdateCache", function(_, pPlayer)

	if not IsValid(pPlayer) then return end
	
	local iCurTime = CurTime()
	if (pPlayer.iGAdmin_MenuCooldown or 0) > iCurTime then return end
	pPlayer.iGAdmin_MenuCooldown = iCurTime + 1

	GAdmin_Menu.Cache = net.ReadTable()
	print("[GAdmin_Menu] Server cache updated!")

end) 

net.Receive("GAdmin_Menu:SetAdminMode", function(len, ply)

	if not IsValid(ply) then return end	
	local iCurTime = CurTime()
	if (ply.iGAdmin_MenuCooldown or 0) > iCurTime then return end
	ply.iGAdmin_MenuCooldown = iCurTime + 1

	if not GAdmin_Menu.Config.AdminRanks[ply:GetUserGroup()] then  
        GAdmin_Menu:Notify(ply, "You are not an admin!")
        return
    end

	GAdmin_Menu:SetToStaffMode(ply)

end)



