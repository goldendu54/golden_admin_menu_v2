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

    if ply:GetNWBool("GAdmin:StaffMode") then
        ply:SetNWBool("GAdmin:StaffMode", false)
 
        RunConsoleCommand("sa", "uncloak", ply:Nick())
        RunConsoleCommand("sa", "ungod", ply:Nick())

        GAdmin_Menu:Notify(ply, "Vous avez quitté le mode staff.")

        GAdmin_Menu:ModMask(ply)
        GAdmin_Menu:ModPower(ply)

    else

        ply:SetNWBool("GAdmin:StaffMode", true)

        RunConsoleCommand("sa", "cloak", ply:Nick())
        RunConsoleCommand("sa", "god", ply:Nick())

        GAdmin_Menu:Notify(ply, "Vous avez rejoint le mode staff.")

        GAdmin_Menu:ModMask(ply)
        GAdmin_Menu:ModPower(ply)

    end



end



function GAdmin_Menu:ModMask(ply)

    if ply:GetNWBool("GAdmin:ModMask") then
        ply:SetNWBool("GAdmin:ModMask", false)

        GAdmin_Menu:Notify(ply, "You have been unmasked!")
    else
        
        ply:SetNWBool("GAdmin:ModMask", true)

        GAdmin_Menu:Notify(ply, "You have been masked!")

        ply:EmitSound("player/suit_sprint.wav")
    end
end

function GAdmin_Menu:ModPower(ply)

    if ply:GetNWBool("GAdmin:ModPower") then
        ply:SetNWBool("GAdmin:ModPower", false)

        GAdmin_Menu:Notify(ply, "You have been depowered!")
    else
        
        ply:SetNWBool("GAdmin:ModPower", true)

        GAdmin_Menu:Notify(ply, "You have been powered!")

        ply:EmitSound("player/suit_sprint.wav")
    end


end


function GAdmin_Menu:AdminMenu(ply)

    net.Start("GAdmin_Menu:OpenMenu")
    net.Send(ply)

end


function GAdmin_Menu:Simple_Gestion(ply)

    net.Start("GAdmin_Menu:OpenSimpleMenu")
    net.Send(ply)

end