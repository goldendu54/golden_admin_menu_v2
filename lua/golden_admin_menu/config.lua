GAdmin_Menu.Config = {}

GAdmin_Menu.Config.MenuKey = KEY_F6 -- The key to open the menu

GAdmin_Menu.Config.MenuCommand = "!amenu" -- The command to open the menu

GAdmin_Menu.Config.StaffCommand = "!staff" -- The command to open the staff menu

GAdmin_Menu.Config.PowerCommand = "!power" -- The command to open the power menu

GAdmin_Menu.Config.MaskCommand = "!mask" -- The command to open the mask menu

-- Admin ranks
GAdmin_Menu.Config.AdminRanks = {
	["superadmin"] = true,	
	["gstaff"] = true,
	["sadmin"] = true,
	["admin"] = true,
	["administrator"] = true,
	["moderator"] = true,
	["moderator-test"] = true,
}

GAdmin_Menu.Config.PremiumRanks = {
	["superadmin"] = true,	
	["gstaff"] = true,
	["sadmin"] = true,
	["admin"] = true,
	["administrator"] = true,
	["moderator"] = true,
	["moderator-test"] = true,
	["elite"] = true,
	["vip+"] = true,
	["vip"] = true,

}


GAdmin_Menu.Config.EliteRanks = {
	["superadmin"] = true,	
	["gstaff"] = true,
	["sadmin"] = true,
	["admin"] = true,
	["administrator"] = true,
	["moderator"] = true,
	["moderator-test"] = true,
	["elite"] = true,
}
GAdmin_Menu.Config.VipPRanks = {
	["superadmin"] = true,	
	["gstaff"] = true,
	["sadmin"] = true,
	["admin"] = true,
	["administrator"] = true,
	["moderator"] = true,
	["moderator-test"] = true,
	["elite"] = true,
	["vip+"] = true,
}

GAdmin_Menu.Config.VipRanks = {
	["superadmin"] = true,	
	["gstaff"] = true,
	["sadmin"] = true,
	["admin"] = true,
	["administrator"] = true,
	["moderator"] = true,
	["moderator-test"] = true,
	["elite"] = true,
	["vip+"] = true,
	["vip"] = true,

}

 
 
GAdmin_Menu.Config.Police_Job = {
	["Commissaire de Police *VIP*"] = true,
	["Agent de Police"] = true,
	["Mastodonte de la  Police *VIP+*"] = true,
	["Recrue de Police"] = true,
	["Commandant du GIPN"] = true,
	["Sniper du GIPN"] = true,
	["Membre du GIPN"] = true,
	["Médecin du GIPN"] = true,
	["Agent du GIPN"] = true,
}

GAdmin_Menu.Config.GunDealerJob = {
	["Vendeur d'armes"] = true,
}

GAdmin_Menu.Config.GunDealerJobHeavy = {
	["Vendeur d'armes lourdes"] = true,
}

GAdmin_Menu.IsStaff = function(ply)
	if GAdmin_Menu.Config.AdminRanks[ply:GetUserGroup()] then
		return true
	end
	return false
end

GAdmin_Menu.IsPremium = function(ply)
	if GAdmin_Menu.Config.PremiumRanks[ply:GetUserGroup()] then
		return true
	end
	return false
end