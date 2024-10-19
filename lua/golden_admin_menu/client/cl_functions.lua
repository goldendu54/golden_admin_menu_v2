GAdmin_Menu.Fonts = {}

-- Automatic responsive functions
RX = RX or function(x) return x / 1920 * ScrW() end
RY = RY or function(y) return y / 1080 * ScrH() end

-- Automatic font-creation function
function GAdmin_Menu:Font(iSize, iWidth)

	iSize = iSize or 15
	iWidth = iWidth or 500

	local sName = ("GAdmin_Menu:Font:%i:%i"):format(iSize, iWidth)
	if not GAdmin_Menu.Fonts[sName] then

		surface.CreateFont(sName, {
			font = "Arial",
			size = RX(iSize),
			width = iWidth,
			extended = false
		})

		GAdmin_Menu.Fonts[sName] = true

	end

	return sName

end




function GAdmin_Menu:SetAdminMode(ply)

	if not GAdmin_Menu.Config.AdminRanks[ply:GetUserGroup()] then  
        GAdmin_Menu:Notify(ply, "You are not an admin!")
        return
    end

	net.Start("GAdmin_Menu:SetAdminMode")
	net.SendToServer()
end


function GAdmin_Menu:DarkrpNotify(target, message)
	notification.AddLegacy(message, 2, 3)
end

function GAdmin_Menu.Player_Get_All()
    local players = {}
    for k, v in pairs(player.GetAll()) do
      local staff_mode = v:GetNWBool("GAdmin:ModMask")
      if staff_mode == false then
        table.insert(players, v)
      end
    end
    return players
end


--// Print every 5 minutes the timestamp in the console //--
timer.Create("GAdmin_Menu:Timestamp", 240, 0, function()
    MsgC(Color(255, 255, 255), "-------------------- " .. os.date("%d/%m/%Y %X") .. " --------------------\n")
end)

// -- New Panel UI -- //

local MainPanel
function GAdmin_Menu:OpenMenus(ply, target)

	ply = ply or LocalPlayer()

	if IsValid(MainPanel) then
		MainPanel:Remove()
	end

	MainPanel = vgui.Create("DFrame")
	MainPanel:SetSize(RX(1200), RY(800))
	MainPanel:Center()
	MainPanel:SetTitle("")
	MainPanel:MakePopup()
	MainPanel.Paint = function(self, w, h)
		OS_UI.DrawRect( 0, 0, w, h, OS_UI.Colors.BASE_BACKGROUND )
        
    end 

	self = MainPanel

	self.Header = vgui.Create("DPanel", self)
	self.Header:Dock( TOP )
	self.Header:SetTall( 40 )
	self.Header:DockMargin( -5, -30, -5, 0 )
	self.Header:InvalidateLayout( true )
	self.Header.Paint = function( me, w, h )
		OS_UI.DrawRect( 0, 0, w, h, OS_UI.Colors.BASE_HEADER )
		OS_UI.DrawText( OS_UI.Settings.Server_Name .. " - Menu Administratif ", "OS_UI.Font.21", w / 2, h / 2, OS_UI.Colors.GREY, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
    
	OS_UI.CreateIconObject( self.Header, OS_UI.Icons.CIRCLE, self:GetWide() - 22, self.Header:GetTall() / 2 - 6, 12, 12, true, function()
		self:Close()
	end )

	

	// -- Staff Button Tab -- //
	self.TabAdmin_Button = vgui.Create( "DPanel", self )
	self.TabAdmin_Button:Dock( BOTTOM )
	self.TabAdmin_Button:SetTall( 80 )
	self.TabAdmin_Button:DockMargin( 0, 0, 0, 0 )
	self.TabAdmin_Button.Paint = function( me, w, h )
		OS_UI.DrawRect( 0, 0, w, h, OS_UI.Colors.BASE_HEADER )
	end

	self.TabAdmin_Label = vgui.Create( "DLabel", self.TabAdmin_Button )
	self.TabAdmin_Label:Dock( TOP )
	self.TabAdmin_Label:SetTall( 90 )
	self.TabAdmin_Label:DockMargin( 5, 5, 0, 0 )
	self.TabAdmin_Label:SetText( "Action de Staff : " )
	self.TabAdmin_Label:SetFont( "OS_UI.Font.21" )
	self.TabAdmin_Label:SetTextColor( OS_UI.Colors.GREY )
	self.TabAdmin_Label:SizeToContents()



	local bsapce = 90

	self.TabAdmin_Button.Btn1 = vgui.Create("DButton", self.TabAdmin_Button)
	self.TabAdmin_Button.Btn1:Dock( LEFT )
	self.TabAdmin_Button.Btn1:DockMargin( bsapce, 5, 0, 5 )
	self.TabAdmin_Button.Btn1:SetWide( 200 )	
	self.TabAdmin_Button.Btn1:SetText("Se mettre en Service")
	self.TabAdmin_Button.Btn1:SetFont("OS_UI.Font.20")
	self.TabAdmin_Button.Btn1:SetTextColor(OS_UI.Colors.WHITE)
	self.TabAdmin_Button.Btn1.DoClick = function(self)
		RunConsoleCommand("say", GAdmin_Menu.Config.StaffCommand)
	end

	self.TabAdmin_Button.Btn1.Think = function(self)
		self.Paint = function(me, w, h)
			if LocalPlayer():GetNWBool("GAdmin:StaffMode") then
				OS_UI.DrawRoundedBox(6, 0, 0, w, h, OS_UI.Colors.RED)
			else
				OS_UI.DrawRoundedBox(6, 0, 0, w, h, OS_UI.Colors.GREEN)
			end
		end
	end

	self.TabAdmin_Button.Btn2 = vgui.Create("DButton", self.TabAdmin_Button)
	self.TabAdmin_Button.Btn2:Dock( LEFT )
	self.TabAdmin_Button.Btn2:DockMargin( bsapce, 5, 0, 5 )
	self.TabAdmin_Button.Btn2:SetWide( 200 )
	self.TabAdmin_Button.Btn2:SetText("Mod Mask")
	self.TabAdmin_Button.Btn2:SetFont("OS_UI.Font.20")
	self.TabAdmin_Button.Btn2:SetTextColor(OS_UI.Colors.WHITE)
	self.TabAdmin_Button.Btn2.DoClick = function(self)
		RunConsoleCommand("say", GAdmin_Menu.Config.MaskCommand)
	end

	self.TabAdmin_Button.Btn2.Think = function(self)
		self.Paint = function(me, w, h)
			if LocalPlayer():GetNWBool("GAdmin:ModMask") then
				OS_UI.DrawRoundedBox(6, 0, 0, w, h, OS_UI.Colors.RED)
			else
				OS_UI.DrawRoundedBox(6, 0, 0, w, h, OS_UI.Colors.GREEN)
			end
		end
	end

	self.TabAdmin_Button.Btn3 = vgui.Create("DButton", self.TabAdmin_Button)
	self.TabAdmin_Button.Btn3:Dock( LEFT )
	self.TabAdmin_Button.Btn3:DockMargin( bsapce, 5, 0, 5 )
	self.TabAdmin_Button.Btn3:SetWide( 200 )
	self.TabAdmin_Button.Btn3:SetText("Mod Power")
	self.TabAdmin_Button.Btn3:SetFont("OS_UI.Font.20")
	self.TabAdmin_Button.Btn3:SetTextColor(OS_UI.Colors.WHITE)
	self.TabAdmin_Button.Btn3.DoClick = function(self)
		RunConsoleCommand("say", GAdmin_Menu.Config.PowerCommand)
	end

	self.TabAdmin_Button.Btn3.Think = function(self)
		self.Paint = function(me, w, h)
			if LocalPlayer():GetNWBool("GAdmin:ModPower") then
				OS_UI.DrawRoundedBox(6, 0, 0, w, h, OS_UI.Colors.RED)
			else
				OS_UI.DrawRoundedBox(6, 0, 0, w, h, OS_UI.Colors.GREEN)
			end
		end
	end
	// -- End Staff Button Tab -- //

	// -- Player Model Tab -- //

	self.TabPlayer = vgui.Create( "DPanel", self )
	self.TabPlayer:Dock( LEFT )
	self.TabPlayer:SetWide( 300 )
	self.TabPlayer:DockMargin( 0, 5, 5, 5 )
	self.TabPlayer.Paint = function( me, w, h )
		OS_UI.DrawRect( 0, 0, w, h, OS_UI.Colors.BASE_HEADER )
	end

	self.TabPlayer.Label = vgui.Create( "DLabel", self.TabPlayer )
	self.TabPlayer.Label:Dock( TOP )
	self.TabPlayer.Label:SetTall( 30 )
	self.TabPlayer.Label:DockMargin( 5, 5, 5, 5 )
	self.TabPlayer.Label:SetText( "Joueur sélectionné : " )
	self.TabPlayer.Label:SetFont( "OS_UI.Font.21" )
	self.TabPlayer.Label:SetTextColor( OS_UI.Colors.GREY )
	self.TabPlayer.Label:SizeToContents()

	self.TabPlayer.Model = vgui.Create("DModelPanel", self.TabPlayer)
	self.TabPlayer.Model:Dock( TOP )
	self.TabPlayer.Model:SetTall( 450 )
	self.TabPlayer.Model:DockMargin( 5, 5, 5, 5 )
	self.TabPlayer.Model:SetModel( LocalPlayer():GetModel() )
	self.TabPlayer.Model:SetCamPos( Vector( 35, 10, 050 ) )
	function self.TabPlayer.Model:LayoutEntity( Entity ) return end


	self.TabPlayer.ComboBox = vgui.Create( "DComboBox", self.TabPlayer )
	self.TabPlayer.ComboBox:Dock( BOTTOM )
	self.TabPlayer.ComboBox:DockMargin( 5, 5, 5, 5 )
	self.TabPlayer.ComboBox:SetTall( 30 )
	self.TabPlayer.ComboBox:SetValue( "Sélectionnez un utilisateur .." )
	self.TabPlayer.ComboBox:SetFont( "OS_UI.Font.20" )
	self.TabPlayer.ComboBox.Paint = function( me, w, h )
		OS_UI.DrawRoundedBox( 6, 0, 0, w, h, OS_UI.Colors.BASE_BACKGROUND )
		me:DrawTextEntryText( OS_UI.Colors.WHITE, OS_UI.Colors.RED, OS_UI.Colors.WHITE )
	end

	for k, v in pairs( player.GetAll() ) do
		if v == ply then continue end
		self.TabPlayer.ComboBox:AddChoice( v:Nick() )
	end


	self.TabPlayer.ComboBox.OnSelect = function( panel, index, value, data )

		// remove all old labels
		for k, v in pairs( self.TabPlayer_Info:GetChildren() ) do

			if v == self.TabPlayer_Info_Label then continue end
			v:Remove()
		end

		local target = nil
		for k, v in pairs( player.GetAll() ) do
			if v:Nick() == value then
				target = v
				Player_Selected = v
				break
			end
		end

		if IsValid( target ) then
			self.TabPlayer.Model:SetModel( target:GetModel() )

			// remove all old labels
			for k, v in pairs( self.TabPlayer_Info:GetChildren() ) do

				if v == self.TabPlayer_Info_Label then continue end
				v:Remove()
			end
			
			local Player_Info = {
				{ "Nom", Player_Selected:Nick() },
				{ "SteamID64", Player_Selected:SteamID64() },
				{ "Groupe", Player_Selected:GetUserGroup() },
				{ "Argent", DarkRP.formatMoney( Player_Selected:getDarkRPVar("money") ) },
				{ "Job", Player_Selected:getDarkRPVar("job") },
				{ "Santé", Player_Selected:Health() },
				{ "Armure", Player_Selected:Armor() },
				{ "Faim", Player_Selected:getDarkRPVar("Energy") or 0 },
				{ "Mort", Player_Selected:Alive() and "Non" or "Oui" },
			}

		
			for k, v in pairs( Player_Info ) do
				ilabel = vgui.Create( "DLabel", self.TabPlayer_Info )
				ilabel:Dock( TOP )
				ilabel:SetTall( 30 )
				ilabel:DockMargin( 5, 25, 5, 5 )
				ilabel:SetFont( "OS_UI.Font.20" )
				ilabel:SetTextColor( OS_UI.Colors.WHITE )
				ilabel:SizeToContents()
				ilabel:SetText( v[1] .. " : " .. v[2] )
				
			end



		end
	end


	// -- Player Information Tab -- //
	self.TabPlayer_Info = vgui.Create( "DPanel", self )
	self.TabPlayer_Info:Dock( FILL )
	self.TabPlayer_Info:DockMargin( 5, 5, 5, 5 )
	self.TabPlayer_Info.Paint = function( me, w, h )
		OS_UI.DrawRect( 0, 0, w, h, OS_UI.Colors.BASE_HEADER )
	end

	self.TabPlayer_Info_Label = vgui.Create( "DLabel", self.TabPlayer_Info )
	self.TabPlayer_Info_Label:Dock( TOP )
	self.TabPlayer_Info_Label:SetTall( 30 )
	self.TabPlayer_Info_Label:DockMargin( 5, 5, 5, 5 )
	self.TabPlayer_Info_Label:SetText( "Informations du joueur : " )
	self.TabPlayer_Info_Label:SetFont( "OS_UI.Font.21" )
	self.TabPlayer_Info_Label:SetTextColor( OS_UI.Colors.GREY )
	self.TabPlayer_Info_Label:SizeToContents()

	
	local Player_Selected = target or ply
	local ilabel 

	for k, v in pairs( player.GetAll() ) do
		if v:Nick() == Player_Selected then
			target = v
			Player_Selected = v
			break
		end
	end

	if IsValid( target ) then
		self.TabPlayer.Model:SetModel( target:GetModel() )

		// remove all old labels

		
		local Player_Info = {
			{ "Nom", Player_Selected:Nick() },
			{ "SteamID64", Player_Selected:SteamID64() },
			{ "Groupe", Player_Selected:GetUserGroup() },
			{ "Argent", DarkRP.formatMoney( Player_Selected:getDarkRPVar("money") ) },
			{ "Job", Player_Selected:getDarkRPVar("job") },
			{ "Santé", Player_Selected:Health() },
			{ "Armure", Player_Selected:Armor() },
			{ "Faim", Player_Selected:getDarkRPVar("Energy") or 0 },
			{ "Mort", Player_Selected:Alive() and "Non" or "Oui" },
		}

	
		for k, v in pairs( Player_Info ) do
			ilabel = vgui.Create( "DLabel", self.TabPlayer_Info )
			ilabel:Dock( TOP )
			ilabel:SetTall( 30 )
			ilabel:DockMargin( 5, 25, 5, 5 )
			ilabel:SetFont( "OS_UI.Font.20" )
			ilabel:SetTextColor( OS_UI.Colors.WHITE )
			ilabel:SizeToContents()
			ilabel:SetText( v[1] .. " : " .. v[2] )
			
		end

	end

	


	

	//-- Player Button Tab --//
	self.TabPlayer_Button = vgui.Create( "DPanel", self )
	self.TabPlayer_Button:Dock( RIGHT )
	self.TabPlayer_Button:SetWide( 300 )
	self.TabPlayer_Button:DockMargin( 5, 5, 0, 5 )
	self.TabPlayer_Button.Paint = function( me, w, h )
		OS_UI.DrawRect( 0, 0, w, h, OS_UI.Colors.BASE_HEADER )
	end

	local btn_tbl = {
		[1] = {
			name = "Se téléporter",
			func = function()

				if Player_Selected == nil then 
					notification.AddLegacy( "Vous devez sélectionner un joueur!", 2, 3)
					return
				end

				if Player_Selected == LocalPlayer() then
					notification.AddLegacy( "Vous ne pouvez pas effectuer cette action sur vous-même!", 2, 3)
					return
				end

				RunConsoleCommand("sa", "goto", Player_Selected:Nick())
			end
		},
		[2] = {
			name = "bring",
			func = function()
				if Player_Selected == nil then 
					notification.AddLegacy( "Vous devez sélectionner un joueur!", 2, 3)
					return
				end

				if Player_Selected == LocalPlayer() then
					notification.AddLegacy( "Vous ne pouvez pas effectuer cette action sur vous-même!", 2, 3)
					return
				end
				RunConsoleCommand("sa", "bring", Player_Selected:Nick())
			end
		},
		[3] = {
			name = "Return",
			func = function()
				if Player_Selected == nil then 
					notification.AddLegacy( "Vous devez sélectionner un joueur!", 2, 3)
					return
				end

				if Player_Selected == LocalPlayer() then
					notification.AddLegacy( "Vous ne pouvez pas effectuer cette action sur vous-même!", 2, 3)
					return
				end
				RunConsoleCommand("sa", "return", Player_Selected:Nick())
			end
		},
		[4] = {
			name = Player_Selected:IsFrozen() and "Unfreeze" or "Freeze",
			func = function()
				if Player_Selected == nil then 
					notification.AddLegacy( "Vous devez sélectionner un joueur!", 2, 3)
					return
				end

				if Player_Selected == LocalPlayer() then
					notification.AddLegacy( "Vous ne pouvez pas effectuer cette action sur vous-même!", 2, 3)
					return
				end

				if Player_Selected:IsFrozen() then
					RunConsoleCommand("sa", "unfreeze", Player_Selected:Nick())
				else
					RunConsoleCommand("sa", "freeze", Player_Selected:Nick())
				end
			end
		},
		[5] = {
			name = "Spectate",
			func = function()
				if Player_Selected == nil then 
					notification.AddLegacy( "Vous devez sélectionner un joueur!", 2, 3)
					return
				end

				if Player_Selected == LocalPlayer() then
					notification.AddLegacy( "Vous ne pouvez pas effectuer cette action sur vous-même!", 2, 3)
					return
				end
				RunConsoleCommand("sa", "spectate", Player_Selected:Nick())
			end
		},
		[6] = {
			name = "Kick",
			func = function()

				if Player_Selected == nil then 
					notification.AddLegacy( "Vous devez sélectionner un joueur!", 2, 3)
					return
				end

				if Player_Selected == LocalPlayer() then
					notification.AddLegacy( "Vous ne pouvez pas vous Kick vous-même!", 2, 3)
					return
				end

				self:SetVisible(false)
			
				local RFrame = vgui.Create("DFrame")
				RFrame:SetSize(RX(400), RY(200))
				RFrame:Center()
				RFrame:SetTitle("")
				RFrame:MakePopup()
				RFrame.Paint = function(self, w, h)
					OS_UI.DrawRect( 0, 0, w, h, OS_UI.Colors.BASE_BACKGROUND )
				end
			
				RFrame.Header = vgui.Create("DPanel", RFrame)
				RFrame.Header:Dock( TOP )
				RFrame.Header:SetTall( 40 )
				RFrame.Header:DockMargin( -5, -30, -5, 0 )
				RFrame.Header:InvalidateLayout( true )
				RFrame.Header.Paint = function( me, w, h )
					OS_UI.DrawRect( 0, 0, w, h, OS_UI.Colors.BASE_HEADER )
					OS_UI.DrawText( "Menu Administratif - KICK ", "OS_UI.Font.21", w / 2, h / 2, OS_UI.Colors.GREY, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end
			
				OS_UI.CreateIconObject( RFrame.Header, OS_UI.Icons.CIRCLE, RFrame:GetWide() - 22, RFrame.Header:GetTall() / 2 - 6, 12, 12, true, function()
					RFrame:Close()
				end )
			
				RFrame.Text = vgui.Create("DLabel", RFrame)
				RFrame.Text:Dock( TOP )
				RFrame.Text:SetTall( 30 )
				RFrame.Text:DockMargin( 5, 5, 5, 5 )
				RFrame.Text:SetText( "Temps (en minutes) :" )
				RFrame.Text:SetFont( "OS_UI.Font.20" )
				RFrame.Text:SetTextColor( OS_UI.Colors.GREY )
				RFrame.Text:SizeToContents()

				RFrame.Time_Request = vgui.Create( "DTextEntry", RFrame )
				RFrame.Time_Request:Dock( TOP )
				RFrame.Time_Request:DockMargin( 30, 10, 30, 5 )
				RFrame.Time_Request:SetTall( 30 )
				RFrame.Time_Request:SetFont( "OS_UI.Font.20" )


				RFrame.Time_Request.Paint = function( me, w, h )
					OS_UI.DrawRoundedBox( 6, 0, 0, w, h, OS_UI.Colors.BASE_HEADER )
					me:DrawTextEntryText( OS_UI.Colors.WHITE, OS_UI.Colors.RED, OS_UI.Colors.WHITE )
				end

				RFrame.Accept = vgui.Create( "DButton", RFrame )
				RFrame.Accept:Dock( TOP )
				RFrame.Accept:DockMargin( 100, 10, 120, 5 )
				RFrame.Accept:SetTall( 30 )
				RFrame.Accept:SetText( "Confirmer" )
				RFrame.Accept:SetTextColor( OS_UI.Colors.WHITE )
				RFrame.Accept:SetFont( "OS_UI.Font.20" )
				RFrame.Accept.Paint = function( me, w, h )
					OS_UI.DrawRoundedBox( 6, 0, 0, w, h, OS_UI.Colors.GREEN )
				end

				RFrame.Accept.DoClick = function()
					RunConsoleCommand("sa", "kick", Player_Selected:Nick(), RFrame.Time_Request:GetValue())

					RFrame:Close()

					self:SetVisible(true)	

				end
			end
		},
		[7] = {
			name = "Ban",
			func = function()

				if Player_Selected == nil then 
					notification.AddLegacy( "Vous devez sélectionner un joueur!", 2, 3)
					return
				end

				if Player_Selected == LocalPlayer() then
					notification.AddLegacy( "Vous ne pouvez pas vous bannir!", 2, 3)
					return
				end

				self:SetVisible(false)
			
				local RFrame = vgui.Create("DFrame")
				RFrame:SetSize(RX(400), RY(300))
				RFrame:Center()
				RFrame:SetTitle("")
				RFrame:MakePopup()
				RFrame.Paint = function(self, w, h)
					OS_UI.DrawRect( 0, 0, w, h, OS_UI.Colors.BASE_BACKGROUND )
				end
			
				RFrame.Header = vgui.Create("DPanel", RFrame)
				RFrame.Header:Dock( TOP )
				RFrame.Header:SetTall( 40 )
				RFrame.Header:DockMargin( -5, -30, -5, 0 )
				RFrame.Header:InvalidateLayout( true )
				RFrame.Header.Paint = function( me, w, h )
					OS_UI.DrawRect( 0, 0, w, h, OS_UI.Colors.BASE_HEADER )
					OS_UI.DrawText( "Menu Administratif - BAN ", "OS_UI.Font.21", w / 2, h / 2, OS_UI.Colors.GREY, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end
			
				OS_UI.CreateIconObject( RFrame.Header, OS_UI.Icons.CIRCLE, RFrame:GetWide() - 22, RFrame.Header:GetTall() / 2 - 6, 12, 12, true, function()
					RFrame:Close()

					self:SetVisible(true)
				end )
			
				RFrame.Text = vgui.Create("DLabel", RFrame)
				RFrame.Text:Dock( TOP )
				RFrame.Text:SetTall( 30 )
				RFrame.Text:DockMargin( 5, 5, 5, 5 )
				RFrame.Text:SetText( "Temps (en minutes) :" )
				RFrame.Text:SetFont( "OS_UI.Font.20" )
				RFrame.Text:SetTextColor( OS_UI.Colors.GREY )
				RFrame.Text:SizeToContents()

				RFrame.Time_Request = vgui.Create( "DTextEntry", RFrame )
				RFrame.Time_Request:Dock( TOP )
				RFrame.Time_Request:DockMargin( 30, 10, 30, 5 )
				RFrame.Time_Request:SetTall( 30 )
				RFrame.Time_Request:SetFont( "OS_UI.Font.20" )
				RFrame.Time_Request:SetNumeric( true )

				RFrame.Time_Request.Paint = function( me, w, h )
					OS_UI.DrawRoundedBox( 6, 0, 0, w, h, OS_UI.Colors.BASE_HEADER )
					me:DrawTextEntryText( OS_UI.Colors.WHITE, OS_UI.Colors.RED, OS_UI.Colors.WHITE )
				end

				RFrame.Reason = vgui.Create("DLabel", RFrame)
				RFrame.Reason:Dock( TOP )
				RFrame.Reason:SetTall( 30 )
				RFrame.Reason:DockMargin( 5, 5, 5, 5 )
				RFrame.Reason:SetText( "Raison :" )
				RFrame.Reason:SetFont( "OS_UI.Font.20" )
				RFrame.Reason:SetTextColor( OS_UI.Colors.GREY )
				RFrame.Reason:SizeToContents()


				RFrame.Reason_Request = vgui.Create( "DTextEntry", RFrame )
				RFrame.Reason_Request:Dock( TOP )
				RFrame.Reason_Request:DockMargin( 30, 10, 30, 5 )
				RFrame.Reason_Request:SetTall( 30 )
				RFrame.Reason_Request:SetFont( "OS_UI.Font.20" )
				RFrame.Reason_Request:SetPlaceholderText("Raison")

				RFrame.Reason_Request.Paint = function( me, w, h )
					OS_UI.DrawRoundedBox( 6, 0, 0, w, h, OS_UI.Colors.BASE_HEADER )
					me:DrawTextEntryText( OS_UI.Colors.WHITE, OS_UI.Colors.RED, OS_UI.Colors.WHITE )
				end

				RFrame.Accept = vgui.Create( "DButton", RFrame )
				RFrame.Accept:Dock( TOP )
				RFrame.Accept:DockMargin( 100, 10, 120, 5 )
				RFrame.Accept:SetTall( 30 )
				RFrame.Accept:SetText( "Confirmer" )
				RFrame.Accept:SetTextColor( OS_UI.Colors.WHITE )
				RFrame.Accept:SetFont( "OS_UI.Font.20" )
				RFrame.Accept.Paint = function( me, w, h )
					OS_UI.DrawRoundedBox( 6, 0, 0, w, h, OS_UI.Colors.GREEN )
				end

				RFrame.Accept.DoClick = function()
					RunConsoleCommand("sa", "ban", Player_Selected:Nick(), RFrame.Time_Request:GetValue(), RFrame.Reason_Request:GetValue())

					RFrame:Close()

					self:SetVisible(true)	

				end


			end
		},
		[8] = {
			name = "Slay",
			func = function()
				if Player_Selected == nil then 
					notification.AddLegacy( "Vous devez sélectionner un joueur!", 2, 3)
					return
				end

				if Player_Selected == LocalPlayer() then
					notification.AddLegacy( "Vous ne pouvez pas effectuer cette action sur vous-même!", 2, 3)
					return
				end
				RunConsoleCommand("sa", "slay", Player_Selected:Nick())
			end
		},
		[10] = {
			name = "Set Health",
			func = function()
				if Player_Selected == nil then 
					notification.AddLegacy( "Vous devez sélectionner un joueur!", 2, 3)
					return
				end

				if Player_Selected == LocalPlayer() then
					notification.AddLegacy( "Vous ne pouvez pas effectuer cette action sur vous-même!", 2, 3)
					return
				end
				self:SetVisible(false)

				local RFrame = vgui.Create("DFrame")
				RFrame:SetSize(RX(400), RY(200))
				RFrame:Center()
				RFrame:SetTitle("")
				RFrame:MakePopup()
				RFrame.Paint = function(self, w, h)
					OS_UI.DrawRect( 0, 0, w, h, OS_UI.Colors.BASE_BACKGROUND )
				end

				RFrame.Header = vgui.Create("DPanel", RFrame)
				RFrame.Header:Dock( TOP )
				RFrame.Header:SetTall( 40 )
				RFrame.Header:DockMargin( -5, -30, -5, 0 )
				RFrame.Header:InvalidateLayout( true )
				RFrame.Header.Paint = function( me, w, h )
					OS_UI.DrawRect( 0, 0, w, h, OS_UI.Colors.BASE_HEADER )
					OS_UI.DrawText( "Menu Administratif - SET HEALTH ", "OS_UI.Font.21", w / 2, h / 2, OS_UI.Colors.GREY, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end

				OS_UI.CreateIconObject( RFrame.Header, OS_UI.Icons.CIRCLE, RFrame:GetWide() - 22, RFrame.Header:GetTall() / 2 - 6, 12, 12, true, function()
					RFrame:Close()

					self:SetVisible(true)
				end )

				RFrame.Text = vgui.Create("DLabel", RFrame)
				RFrame.Text:Dock( TOP )
				RFrame.Text:SetTall( 30 )
				RFrame.Text:DockMargin( 5, 5, 5, 5 )
				RFrame.Text:SetText( "Vie :" )
				RFrame.Text:SetFont( "OS_UI.Font.20" )
				RFrame.Text:SetTextColor( OS_UI.Colors.GREY )
				RFrame.Text:SizeToContents()	

				RFrame.Health_Request = vgui.Create( "DTextEntry", RFrame )
				RFrame.Health_Request:Dock( TOP )
				RFrame.Health_Request:DockMargin( 30, 10, 30, 5 )
				RFrame.Health_Request:SetTall( 30 )
				RFrame.Health_Request:SetFont( "OS_UI.Font.20" )
				RFrame.Health_Request:SetNumeric( true )

				RFrame.Health_Request.Paint = function( me, w, h )
					OS_UI.DrawRoundedBox( 6, 0, 0, w, h, OS_UI.Colors.BASE_HEADER )
					me:DrawTextEntryText( OS_UI.Colors.WHITE, OS_UI.Colors.RED, OS_UI.Colors.WHITE )
				end

				RFrame.Accept = vgui.Create( "DButton", RFrame )
				RFrame.Accept:Dock( TOP )
				RFrame.Accept:DockMargin( 100, 10, 120, 5 )
				RFrame.Accept:SetTall( 30 )
				RFrame.Accept:SetText( "Confirmer" )
				RFrame.Accept:SetTextColor( OS_UI.Colors.WHITE )
				RFrame.Accept:SetFont( "OS_UI.Font.20" )
				RFrame.Accept.Paint = function( me, w, h )
					OS_UI.DrawRoundedBox( 6, 0, 0, w, h, OS_UI.Colors.GREEN )
				end

				RFrame.Accept.DoClick = function()
					RunConsoleCommand("sa", "hp", Player_Selected:Nick(), RFrame.Health_Request:GetValue())

					RFrame:Close()
					self:SetVisible(true)	
				end

			end
		},
		[11] = {
			name = "Set Armor",
			func = function()
				if Player_Selected == nil then 
					notification.AddLegacy( "Vous devez sélectionner un joueur!", 2, 3)
					return
				end

				if Player_Selected == LocalPlayer() then
					notification.AddLegacy( "Vous ne pouvez pas effectuer cette action sur vous-même!", 2, 3)
					return
				end
				self:SetVisible(false)

				local RFrame = vgui.Create("DFrame")
				RFrame:SetSize(RX(400), RY(200))
				RFrame:Center()
				RFrame:SetTitle("")
				RFrame:MakePopup()
				RFrame.Paint = function(self, w, h)
					OS_UI.DrawRect( 0, 0, w, h, OS_UI.Colors.BASE_BACKGROUND )
				end

				RFrame.Header = vgui.Create("DPanel", RFrame)
				RFrame.Header:Dock( TOP )
				RFrame.Header:SetTall( 40 )
				RFrame.Header:DockMargin( -5, -30, -5, 0 )
				RFrame.Header:InvalidateLayout( true )
				RFrame.Header.Paint = function( me, w, h )
					OS_UI.DrawRect( 0, 0, w, h, OS_UI.Colors.BASE_HEADER )
					OS_UI.DrawText( "Menu Administratif - SET ARMOR ", "OS_UI.Font.21", w / 2, h / 2, OS_UI.Colors.GREY, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end

				OS_UI.CreateIconObject( RFrame.Header, OS_UI.Icons.CIRCLE, RFrame:GetWide() - 22, RFrame.Header:GetTall() / 2 - 6, 12, 12, true, function()
					RFrame:Close()

					self:SetVisible(true)
				end )

				RFrame.Text = vgui.Create("DLabel", RFrame)
				RFrame.Text:Dock( TOP )
				RFrame.Text:SetTall( 30 )
				RFrame.Text:DockMargin( 5, 5, 5, 5 )
				RFrame.Text:SetText( "Armure :" )
				RFrame.Text:SetFont( "OS_UI.Font.20" )
				RFrame.Text:SetTextColor( OS_UI.Colors.GREY )
				RFrame.Text:SizeToContents()

				RFrame.Armor_Request = vgui.Create( "DTextEntry", RFrame )
				RFrame.Armor_Request:Dock( TOP )
				RFrame.Armor_Request:DockMargin( 30, 10, 30, 5 )
				RFrame.Armor_Request:SetTall( 30 )
				RFrame.Armor_Request:SetFont( "OS_UI.Font.20" )
				RFrame.Armor_Request:SetNumeric( true )

				RFrame.Armor_Request.Paint = function( me, w, h )
					OS_UI.DrawRoundedBox( 6, 0, 0, w, h, OS_UI.Colors.BASE_HEADER )
					me:DrawTextEntryText( OS_UI.Colors.WHITE, OS_UI.Colors.RED, OS_UI.Colors.WHITE )
				end

				RFrame.Accept = vgui.Create( "DButton", RFrame )
				RFrame.Accept:Dock( TOP )
				RFrame.Accept:DockMargin( 100, 10, 120, 5 )
				RFrame.Accept:SetTall( 30 )
				RFrame.Accept:SetText( "Confirmer" )
				RFrame.Accept:SetTextColor( OS_UI.Colors.WHITE )
				RFrame.Accept:SetFont( "OS_UI.Font.20" )
				RFrame.Accept.Paint = function( me, w, h )
					OS_UI.DrawRoundedBox( 6, 0, 0, w, h, OS_UI.Colors.GREEN )
				end

				RFrame.Accept.DoClick = function()
					RunConsoleCommand("sa", "armor", Player_Selected:Nick(), RFrame.Armor_Request:GetValue())

					RFrame:Close()
					self:SetVisible(true)	
				end

			end
		},
		[12] = {
			name = "Copier le SteamID64",
			func = function()
				SetClipboardText(Player_Selected:SteamID64())
				notification.AddLegacy( "SteamID64 copié dans le presse-papiers!", 2, 3)
			end
		},
	}

	for k, v in pairs( btn_tbl ) do
		local btn = vgui.Create("DButton", self.TabPlayer_Button)
		btn:Dock( TOP )
		btn:DockMargin( 5, 5, 5, 5 )
		btn:SetTall( 30 )
		btn:SetText( v.name )
		btn:SetFont( "OS_UI.Font.20" )
		btn:SetTextColor( OS_UI.Colors.WHITE )
		btn.DoClick = v.func

		btn.Paint = function( me, w, h )
			OS_UI.DrawRoundedBox( 6, 0, 0, w, h, OS_UI.Colors.RED )
		end
	end
	
	

end