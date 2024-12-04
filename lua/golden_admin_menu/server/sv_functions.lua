-- Notify a player with the specified message
function GAdmin_Menu:Notify(pPlayer, sContent)

	if not IsValid(pPlayer) or not pPlayer:IsPlayer() then return end

	if DarkRP then
		return DarkRP.notify(pPlayer, 0, 7, sContent)
	end

	return pPlayer:PrintMessage(HUD_PRINTTALK, sContent)
	
end

--[[ Functions ]]--
function GAdmin_Menu:SetToStaffMode(ply)
    if not IsValid(ply) then return end	

    if ply:GetNWBool("GAdmin:StaffMode") then
        ply:SetNWBool("GAdmin:StaffMode", false)
 
        RunConsoleCommand("sa", "uncloak", ply:Nick())
        RunConsoleCommand("sa", "ungod", ply:Nick())

        GAdmin_Menu:Notify(ply, GAdmin_Menu:GetLanguage("leaveStaffMode"))

        GAdmin_Menu:ModMask(ply)
        GAdmin_Menu:ModPower(ply)

    else

        ply:SetNWBool("GAdmin:StaffMode", true)

        RunConsoleCommand("sa", "cloak", ply:Nick())
        RunConsoleCommand("sa", "god", ply:Nick())

        GAdmin_Menu:Notify(ply, GAdmin_Menu:GetLanguage("joinStaffMode"))

        GAdmin_Menu:ModMask(ply)
        GAdmin_Menu:ModPower(ply)

    end

end

function GAdmin_Menu:ModMask(ply)
    if not IsValid(ply) then return end	

    if ply:GetNWBool("GAdmin:ModMask") then
        ply:SetNWBool("GAdmin:ModMask", false)
        GAdmin_Menu:Notify(ply, GAdmin_Menu:GetLanguage("unmasked"))
    else
        ply:SetNWBool("GAdmin:ModMask", true)
        GAdmin_Menu:Notify(ply, GAdmin_Menu:GetLanguage("masked"))
    end
end

function GAdmin_Menu:ModPower(ply)
    if not IsValid(ply) then return end	

    if ply:GetNWBool("GAdmin:ModPower") then
        ply:SetNWBool("GAdmin:ModPower", false)
        GAdmin_Menu:Notify(ply, GAdmin_Menu:GetLanguage("depowered"))
    else
        ply:SetNWBool("GAdmin:ModPower", true)
        GAdmin_Menu:Notify(ply, GAdmin_Menu:GetLanguage("powered"))
    end


end

function GAdmin_Menu:AdminMenu(ply)
    if not IsValid(ply) then return end	
    net.Start("GAdmin_Menu:OpenMenu")
    net.Send(ply)
end