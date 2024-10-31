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
        GAdmin_Menu:Notify(ply, GAdmin_Menu:GetLanguage("notAdmin"))
        return
    end

	net.Start("GAdmin_Menu:SetAdminMode")
	net.SendToServer()
end


function GAdmin_Menu:Notify(target, message)
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

if GAdmin_Menu.Config.Debug then
	--// Print every 5 minutes the timestamp in the console //--
	timer.Create("GAdmin_Menu:Timestamp", 240, 0, function()
		MsgC(Color(255, 255, 255), "-------------------- " .. os.date("%d/%m/%Y %X") .. " --------------------\n")
	end)
end

function draw.Circle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is needed for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end

// -- New Panel UI -- //

local MainPanel
function GAdmin_Menu:OpenMenus(ply, target)

	ply = ply or LocalPlayer()
	target = target or LocalPlayer()
	local admin = LocalPlayer()

	if IsValid(MainPanel) then
		MainPanel:Remove()
	end

	MainPanel = vgui.Create("DFrame")
	MainPanel:SetSize(RX(1200), RY(800))
	MainPanel:Center()
	MainPanel:SetTitle("")
	MainPanel:MakePopup()
	MainPanel.Paint = function(self, w, h)
		surface.SetDrawColor( GAdmin_Menu.Constants["colors"]["background"] )
        surface.DrawRect( 0, 0, w, h )

    end 

	MainPanelHeader = vgui.Create("DPanel", MainPanel)
	MainPanelHeader:Dock( TOP )
	MainPanelHeader:SetTall( 40 )
	MainPanelHeader:DockMargin( -5, -30, -5, 0 )
	MainPanelHeader:InvalidateLayout( true )
	MainPanelHeader.Paint = function( me, w, h )
		surface.SetDrawColor( GAdmin_Menu.Constants["colors"]["header"] )
        surface.DrawRect( 0, 0, w, h )

		draw.SimpleText( GAdmin_Menu.Config.Title, "OS_UI.Font.21", w / 2, h / 2, GAdmin_Menu.Constants["colors"]["Grey"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	MainPanelHeader.Close = vgui.Create("DButton", MainPanelHeader)
	MainPanelHeader.Close:Dock( RIGHT )
	MainPanelHeader.Close:DockMargin( 0, 0, 5, 0 )
	MainPanelHeader.Close:SetWide( 30 )
	MainPanelHeader.Close:SetText("")
	MainPanelHeader.Close.Paint = function( me, w, h )

		surface.SetDrawColor(GAdmin_Menu.Constants["colors"]["Red"])
		draw.NoTexture()
		draw.Circle( w / 2, h / 2, 7, 50 )

	end
	MainPanelHeader.Close.DoClick = function()
		MainPanel:Remove()
	end

	// -- Staff Button Tab -- //
	TabAdmin_Button = vgui.Create( "DPanel", MainPanel )
	TabAdmin_Button:Dock( BOTTOM )
	TabAdmin_Button:SetTall( 80 )
	TabAdmin_Button:DockMargin( 0, 0, 0, 0 )
	TabAdmin_Button.Paint = function( me, w, h )
		surface.SetDrawColor( GAdmin_Menu.Constants["colors"]["header"] )
		surface.DrawRect( 0, 0, w, h )
	end

	TabAdmin_Label = vgui.Create( "DLabel", TabAdmin_Button )
	TabAdmin_Label:Dock( TOP )
	TabAdmin_Label:SetTall( 90 )
	TabAdmin_Label:DockMargin( 5, 5, 0, 0 )
	TabAdmin_Label:SetText( GAdmin_Menu:GetLanguage("staffActions") )
	TabAdmin_Label:SetFont( "OS_UI.Font.21" )
	TabAdmin_Label:SetTextColor( GAdmin_Menu.Constants["colors"]["Grey"] )
	TabAdmin_Label:SizeToContents()

	local bsapce = 90
	TabAdmin_Button.Btn1 = vgui.Create("DButton", TabAdmin_Button)
	TabAdmin_Button.Btn1:Dock( LEFT )
	TabAdmin_Button.Btn1:DockMargin( bsapce, 5, 0, 5 )
	TabAdmin_Button.Btn1:SetWide( 200 )	
	TabAdmin_Button.Btn1:SetText( GAdmin_Menu:GetLanguage("setStaffMod") )
	TabAdmin_Button.Btn1:SetFont("OS_UI.Font.20")
	TabAdmin_Button.Btn1:SetTextColor( GAdmin_Menu.Constants["colors"]["White"])
	TabAdmin_Button.Btn1.DoClick = function(self)
		RunConsoleCommand("say", GAdmin_Menu.Config.StaffCommand)
	end

	TabAdmin_Button.Btn1.Think = function(self)
		self.Paint = function(me, w, h)
			if admin:GetNWBool("GAdmin:StaffMode") then
				draw.RoundedBox( 6, 0, 0, w, h, GAdmin_Menu.Constants["colors"]["Red"] )
			else
				draw.RoundedBox( 6, 0, 0, w, h, GAdmin_Menu.Constants["colors"]["Green"] )
			end
		end
	end

	TabAdmin_Button.Btn2 = vgui.Create("DButton", TabAdmin_Button)
	TabAdmin_Button.Btn2:Dock( LEFT )
	TabAdmin_Button.Btn2:DockMargin( bsapce, 5, 0, 5 )
	TabAdmin_Button.Btn2:SetWide( 200 )
	TabAdmin_Button.Btn2:SetText( GAdmin_Menu:GetLanguage("modMask") )
	TabAdmin_Button.Btn2:SetFont("OS_UI.Font.20")
	TabAdmin_Button.Btn2:SetTextColor( GAdmin_Menu.Constants["colors"]["White"])
	TabAdmin_Button.Btn2.DoClick = function(self)
		RunConsoleCommand("say", GAdmin_Menu.Config.MaskCommand)
	end

	TabAdmin_Button.Btn2.Think = function(self)
		self.Paint = function(me, w, h)
			if admin:GetNWBool("GAdmin:ModMask") then
				draw.RoundedBox(6, 0, 0, w, h, GAdmin_Menu.Constants["colors"]["Red"])
			else
				draw.RoundedBox(6, 0, 0, w, h, GAdmin_Menu.Constants["colors"]["Green"])
			end
		end
	end

	TabAdmin_Button.Btn3 = vgui.Create("DButton", TabAdmin_Button)
	TabAdmin_Button.Btn3:Dock( LEFT )
	TabAdmin_Button.Btn3:DockMargin( bsapce, 5, 0, 5 )
	TabAdmin_Button.Btn3:SetWide( 200 )
	TabAdmin_Button.Btn3:SetText( GAdmin_Menu:GetLanguage("modPower") )
	TabAdmin_Button.Btn3:SetFont("OS_UI.Font.20")
	TabAdmin_Button.Btn3:SetTextColor( GAdmin_Menu.Constants["colors"]["White"])
	TabAdmin_Button.Btn3.DoClick = function(self)
		RunConsoleCommand("say", GAdmin_Menu.Config.PowerCommand)
	end

	TabAdmin_Button.Btn3.Think = function(self)
		self.Paint = function(me, w, h)
			if admin:GetNWBool("GAdmin:ModPower") then
				draw.RoundedBox(6, 0, 0, w, h, GAdmin_Menu.Constants["colors"]["Red"])
			else
				draw.RoundedBox(6, 0, 0, w, h, GAdmin_Menu.Constants["colors"]["Green"])
			end
		end
	end
	// -- End Staff Button Tab -- //

	// -- Player Model Tab -- //

	TabPlayer = vgui.Create( "DPanel", MainPanel )
	TabPlayer:Dock( LEFT )
	TabPlayer:SetWide( 300 )
	TabPlayer:DockMargin( 0, 5, 5, 5 )
	TabPlayer.Paint = function( me, w, h )
		surface.SetDrawColor( GAdmin_Menu.Constants["colors"]["header"] )
		surface.DrawRect( 0, 0, w, h )
	end

	TabPlayer.Label = vgui.Create( "DLabel", TabPlayer )
	TabPlayer.Label:Dock( TOP )
	TabPlayer.Label:SetTall( 30 )
	TabPlayer.Label:DockMargin( 5, 5, 5, 5 )
	TabPlayer.Label:SetText( GAdmin_Menu:GetLanguage("selectedPlayer") )
	TabPlayer.Label:SetFont( "OS_UI.Font.21" )
	TabPlayer.Label:SetTextColor( GAdmin_Menu.Constants["colors"]["Grey"] )
	TabPlayer.Label:SizeToContents()

	TabPlayer.Model = vgui.Create("DModelPanel", TabPlayer)
	TabPlayer.Model:Dock( TOP )
	TabPlayer.Model:SetTall( 450 )
	TabPlayer.Model:DockMargin( 5, 5, 5, 5 )
	TabPlayer.Model:SetModel( ply:GetModel() )
	TabPlayer.Model:SetCamPos( Vector( 35, 10, 050 ) )
	function TabPlayer.Model:LayoutEntity( Entity ) return end


	TabPlayer.ComboBox = vgui.Create( "DComboBox", TabPlayer )
	TabPlayer.ComboBox:Dock( BOTTOM )
	TabPlayer.ComboBox:DockMargin( 5, 5, 5, 5 )
	TabPlayer.ComboBox:SetTall( 30 )
	TabPlayer.ComboBox:SetValue( GAdmin_Menu:GetLanguage("selectPlayer") )
	TabPlayer.ComboBox:SetFont( "OS_UI.Font.20" )
	TabPlayer.ComboBox.Paint = function( self, w, h )
		draw.RoundedBox( 6, 0, 0, w, h, GAdmin_Menu.Constants["colors"]["header"] )
	end

	for k, v in pairs( player.GetAll() ) do
		if v == ply then continue end
		TabPlayer.ComboBox:AddChoice( v:Nick() )
	end

	TabPlayer.ComboBox.OnSelect = function( panel, index, value, data )

		for k, v in pairs( player.GetAll() ) do
			if v:Nick() == value then
				target = v
				Player_Selected = v
				break
			end
		end

		if IsValid( target ) then
			TabPlayer.Model:SetModel( target:GetModel() )
		end
	end

	// -- Player Information Tab -- //
	TabPlayer_Info = vgui.Create( "DPanel", MainPanel )
	TabPlayer_Info:Dock( FILL )
	TabPlayer_Info:DockMargin( 5, 5, 5, 5 )
	TabPlayer_Info.Paint = function( me, w, h )
		OS_UI.DrawRect( 0, 0, w, h, GAdmin_Menu.Constants["colors"]["header"] )
	end

	TabPlayer_Info_Label = vgui.Create( "DLabel", TabPlayer_Info )
	TabPlayer_Info_Label:Dock( TOP )
	TabPlayer_Info_Label:SetTall( 30 )
	TabPlayer_Info_Label:DockMargin( 5, 5, 5, 5 )
	TabPlayer_Info_Label:SetText( "Informations du joueur : " )
	TabPlayer_Info_Label:SetFont( "OS_UI.Font.21" )
	TabPlayer_Info_Label:SetTextColor( GAdmin_Menu.Constants["colors"]["Grey"] )
	TabPlayer_Info_Label:SizeToContents()

	local Player_Info = {
		{ GAdmin_Menu:GetLanguage("name"), target:Nick() },
		{ GAdmin_Menu:GetLanguage("steamID64"), target:SteamID64() },
		{ GAdmin_Menu:GetLanguage("group"), target:GetUserGroup() },
		{ GAdmin_Menu:GetLanguage("money"), DarkRP.formatMoney( target:getDarkRPVar("money") ) },
		{ GAdmin_Menu:GetLanguage("job"), target:getDarkRPVar("job") },
		{ GAdmin_Menu:GetLanguage("health"), target:Health() },
		{ GAdmin_Menu:GetLanguage("armor"), target:Armor() },
		{ GAdmin_Menu:GetLanguage("hunger"), target:getDarkRPVar("Energy") or 0 },
		{ GAdmin_Menu:GetLanguage("dead"), target:Alive() and GAdmin_Menu:GetLanguage("no") or GAdmin_Menu:GetLanguage("yes") },
	}

	for k, v in pairs( Player_Info ) do
		ilabel = vgui.Create( "DLabel", TabPlayer_Info )
		ilabel:Dock( TOP )
		ilabel:SetTall( 30 )
		ilabel:DockMargin( 5, 25, 5, 5 )
		ilabel:SetFont( "OS_UI.Font.20" )
		ilabel:SetTextColor( GAdmin_Menu.Constants["colors"]["White"] )
		ilabel:SizeToContents()
		ilabel.Think = function(self)
			self:SetText( v[1] .. " : " .. v[2] )
		end	
	end

	//-- Player Button Tab --//
	TabPlayer_Button = vgui.Create( "DPanel", MainPanel )
	TabPlayer_Button:Dock( RIGHT )
	TabPlayer_Button:SetWide( 300 )
	TabPlayer_Button:DockMargin( 5, 5, 0, 5 )
	TabPlayer_Button.Paint = function( me, w, h )
		surface.SetDrawColor( GAdmin_Menu.Constants["colors"]["header"] )
		surface.DrawRect( 0, 0, w, h )
	end

	local btn_tbl = {
		[1] = {
			name = GAdmin_Menu:GetLanguage("goto"),
			func = function()

				if GAdmin_Menu:TargetCheck() == false then return end

				RunConsoleCommand("sa", "goto", target:Nick())
			end
		},
		[2] = {
			name = "bring",
			func = function()
				if GAdmin_Menu:TargetCheck() == false then return end

				RunConsoleCommand("sa", "bring", target:Nick())
			end
		},
		[3] = {
			name = "Return",
			func = function()
				if GAdmin_Menu:TargetCheck() == false then return end

				RunConsoleCommand("sa", "return", target:Nick())
			end
		},
		[4] = {
			name = target:IsFrozen() and "Unfreeze" or "Freeze",
			func = function()
				if GAdmin_Menu:TargetCheck() == false then return end

				if target:IsFrozen() then
					RunConsoleCommand("sa", "unfreeze", target:Nick())
				else
					RunConsoleCommand("sa", "freeze", target:Nick())
				end
			end
		},
		[5] = {
			name = "Spectate",
			func = function()
				if GAdmin_Menu:TargetCheck() == false then return end

				RunConsoleCommand("sa", "spectate", target:Nick())
			end
		},
		[6] = {
			name = "Kick",
			func = function()
				if GAdmin_Menu:TargetCheck() == false then return end

				self:SetVisible(false)
				/*
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

			

*/

				RequestPanel = vgui.Create("GAdmin_RequestPanel")
				RequestPanel:SetTitle(GAdmin_Menu.Config.Title.. " - " .. GAdmin_Menu:GetLanguage("kick"))
				RequestPanel:AcceptFunction(function(reason)
					RunConsoleCommand("sa", "kick", target:Nick(), reason)
					self:SetVisible(true)
					
				end)
				RequestPanel:MakePopup()

				


			end
		},
		[7] = {
			name = "Ban",
			func = function()
				if GAdmin_Menu:TargetCheck() == false then return end

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
				if GAdmin_Menu:TargetCheck() == false then return end
				RunConsoleCommand("sa", "slay", Player_Selected:Nick())
			end
		},
		[10] = {
			name = "Set Health",
			func = function()
				if GAdmin_Menu:TargetCheck() == false then return end
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
				if GAdmin_Menu:TargetCheck() == false then return end
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
		local btn = vgui.Create("DButton", TabPlayer_Button)
		btn:Dock( TOP )
		btn:DockMargin( 5, 5, 5, 5 )
		btn:SetTall( 30 )
		btn:SetText( v.name )
		btn:SetFont( "OS_UI.Font.20" )
		btn:SetTextColor( OS_UI.Colors.WHITE )
		btn.DoClick = v.func
		btn.Paint = function( me, w, h )
			draw.RoundedBox( 6, 0, 0, w, h, GAdmin_Menu.Constants["colors"]["Red"] )
		end
	end
	
	

end

function GAdmin_Menu:TargetCheck()
	if target == nil then 
		notification.AddLegacy( GAdmin_Menu:GetLanguage("needToSelecPlayer"), 2, 3)
		return false
	end

	if target == LocalPlayer() then
		notification.AddLegacy( GAdmin_Menu:GetLanguage("cannotDoOnYourself"), 2, 3)
		return false 
	end

	return true
end




local PANEL = {}

function PANEL:Init()

	self.GAdmin_MenuNumberRequest = false
	self.GAdmin_MenuReasonRequest = false
	self.GAdmin_MenuTitle = ""
	self.GAdmin_NumberTitle = ""
	self.GAdmin_ReasonTitle = ""

	if self.GAdmin_MenuNumberRequest and self.GAdmin_MenuReasonRequest then
		self:SetSize( RX(400), RY(300) )
	else
		self:SetSize( RX(400), RY(200) )
	end
	self:Center()
	self:SetTitle("")
	self:MakePopup()
	self.Paint = function(self, w, h)
		surface.SetDrawColor( GAdmin_Menu.Constants["colors"]["background"] )
		surface.DrawRect( 0, 0, w, h )
	end

	self.Header = vgui.Create("DPanel", self)
	self.Header:Dock( TOP )
	self.Header:SetTall( 40 )
	self.Header:DockMargin( -5, -30, -5, 0 )
	self.Header:InvalidateLayout( true )
	self.Header.Paint = function( me, w, h )
		surface.SetDrawColor( GAdmin_Menu.Constants["colors"]["header"] )
		surface.DrawRect( 0, 0, w, h )
		draw.SimpleText( self.GAdmin_MenuTitle, "OS_UI.Font.21", w / 2, h / 2, GAdmin_Menu.Constants["colors"]["Grey"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	self.Header.Close = vgui.Create("DButton", self.Header)
	self.Header.Close:SetSize( 12, 12 )
	self.Header.Close:SetPos( self.Header:GetWide() - 22, self.Header:GetTall() / 2 - 6 )
	self.Header.Close:SetText("")
	self.Header.Close.Paint = function(self, w, h)
		draw.Circle( w / 2, h / 2, 6, 6, GAdmin_Menu.Constants["colors"]["Red"] )
	end
	self.Header.Close.DoClick = function()
		self:Close()
	end

	if self.GAdmin_MenuNumberRequest then

		self.Number_Request_Text = vgui.Create( "DLabel", self )
		self.Number_Request_Text:Dock( TOP )
		self.Number_Request_Text:SetTall( 30 )
		self.Number_Request_Text:DockMargin( 5, 5, 5, 5 )
		self.Number_Request_Text:SetText( self.GAdmin_NumberTitle )
		self.Number_Request_Text:SetFont( "OS_UI.Font.20" )

		self.Number_Request = vgui.Create( "DTextEntry", self )
		self.Number_Request:Dock( TOP )
		self.Number_Request:DockMargin( 30, 10, 30, 5 )
		self.Number_Request:SetTall( 30 )
		self.Number_Request:SetFont( "OS_UI.Font.20" )
		self.Number_Request:SetNumeric( true )
		self.Number_Request.Paint = function( me, w, h )
			draw.RoundedBox( 6, 0, 0, w, h, GAdmin_Menu.Constants["colors"]["background"] )
		end
		
		self.Number_Request.OnChange = function( self )
			self.GAdmin_MenuNumberRequestValue = self:GetValue()
		end

	end

	if self.GAdmin_MenuReasonRequest then

		self.Reason_Request_Text = vgui.Create( "DLabel", self )
		self.Reason_Request_Text:Dock( TOP )
		self.Reason_Request_Text:SetTall( 30 )
		self.Reason_Request_Text:DockMargin( 5, 5, 5, 5 )
		self.Reason_Request_Text:SetText( self.GAdmin_ReasonTitle )
		self.Reason_Request_Text:SetFont( "OS_UI.Font.20" )
		
		self.Reason_Request = vgui.Create( "DTextEntry", self )
		self.Reason_Request:Dock( TOP )
		self.Reason_Request:DockMargin( 30, 10, 30, 5 )
		self.Reason_Request:SetTall( 30 )
		self.Reason_Request:SetFont( "OS_UI.Font.20" )
		self.Reason_Request.Paint = function( me, w, h )
			draw.RoundedBox( 6, 0, 0, w, h, GAdmin_Menu.Constants["colors"]["background"] )
		end

		self.Reason_Request.OnChange = function( self )
			self.GAdmin_MenuReasonRequestValue = self:GetValue()
		end

	end

	self.Accept = vgui.Create( "DButton", self )
	self.Accept:Dock( TOP )
	self.Accept:DockMargin( 100, 10, 120, 5 )
	self.Accept:SetTall( 30 )
	self.Accept:SetText( GAdmin_Menu:GetLanguage("confirm") )
	self.Accept:SetTextColor( GAdmin_Menu.Constants["colors"]["White"] )
	self.Accept:SetFont( "OS_UI.Font.20" )
	self.Accept.Paint = function( me, w, h )
		draw.RoundedBox( 6, 0, 0, w, h, GAdmin_Menu.Constants["colors"]["Green"] )
	end

end

function PANEL:SetRequestType( type )

	if type == 1 then
		--"number"
		self.GAdmin_MenuNumberRequest = true
		self.GAdmin_MenuReasonRequest = false
	elseif type == 2 then
		--"reason"
		self.GAdmin_MenuNumberRequest = false
		self.GAdmin_MenuReasonRequest = true
	elseif type == 3 then
		--"number and reason"
		self.GAdmin_MenuNumberRequest = true
		self.GAdmin_MenuReasonRequest = true
	end

end

function PANEL:SetTitle( title )
	self.GAdmin_MenuTitle = title
end

function PANEL:SetNumberTitle( title )
	self.GAdmin_NumberTitle = title
end

function PANEL:SetReasonTitle( title )
	self.GAdmin_ReasonTitle = title
end

function PANEL:GetNumberRequest()
	return self.GAdmin_MenuNumberRequestValue
end

function PANEL:GetReasonRequest()
	return self.GAdmin_MenuReasonRequestValue
end

function PANEL:AcceptFunction( func )
	self.Accept.DoClick = func
end

vgui.Register("GAdmin_RequestPanel", PANEL, "DFrame")



