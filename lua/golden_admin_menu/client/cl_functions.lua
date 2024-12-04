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

	local MainPanelHeader = vgui.Create("DPanel", MainPanel)
	MainPanelHeader:Dock( TOP )
	MainPanelHeader:SetTall( 40 )
	MainPanelHeader:DockMargin( -5, -30, -5, 0 )
	MainPanelHeader:InvalidateLayout( true )
	MainPanelHeader.Paint = function( self, w, h )
		surface.SetDrawColor( GAdmin_Menu.Constants["colors"]["header"] )
        surface.DrawRect( 0, 0, w, h )

		draw.SimpleText( GAdmin_Menu.Config.Title, "OS_UI.Font.21", w / 2, h / 2, GAdmin_Menu.Constants["colors"]["Grey"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	MainPanelHeader.Close = vgui.Create("DButton", MainPanelHeader)
	MainPanelHeader.Close:Dock( RIGHT )
	MainPanelHeader.Close:DockMargin( 0, 0, 5, 0 )
	MainPanelHeader.Close:SetWide( 30 )
	MainPanelHeader.Close:SetText("")
	MainPanelHeader.Close.Paint = function( self, w, h )

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
	TabAdmin_Button.Paint = function( self, w, h )
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
		self.Paint = function(self, w, h)
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
		self.Paint = function(self, w, h)
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
		self.Paint = function(self, w, h)
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
	TabPlayer.Paint = function( self, w, h )
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
	local TabPlayer_Info = vgui.Create( "DPanel", MainPanel )
	TabPlayer_Info:Dock( FILL )
	TabPlayer_Info:DockMargin( 5, 5, 5, 5 )
	TabPlayer_Info.Paint = function( self, w, h )
		surface.SetDrawColor( GAdmin_Menu.Constants["colors"]["header"] )
		surface.DrawRect( 0, 0, w, h )
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
	TabPlayer_Button.Paint = function( self, w, h )
		surface.SetDrawColor( GAdmin_Menu.Constants["colors"]["header"] )
		surface.DrawRect( 0, 0, w, h )
	end

local btn_tbl = {
		[1] = {
			name = GAdmin_Menu:GetLanguage("goto"),
			func = function()
				if GAdmin_Menu:TargetCheck(target) == false then return end

				local sys = GAdmin_Menu:GetAdminSystem()
				if sys then
					sys["goto"](ply, target)
				end
			end
		},
		[2] = {
			name = "bring",
			func = function()
				if GAdmin_Menu:TargetCheck(target) == false then return end

				local sys = GAdmin_Menu:GetAdminSystem()
				if sys then
					sys["bring"](ply, target)
				end
			end
		},
		[3] = {
			name = "Return",
			func = function()
				if GAdmin_Menu:TargetCheck(target) == false then return end

				local sys = GAdmin_Menu:GetAdminSystem()
				if sys then
					sys["return"](ply, target)
				end
			end
		},
		[4] = {
			name = target:IsFrozen() and "Unfreeze" or "Freeze",
			func = function()
				if GAdmin_Menu:TargetCheck(target) == false then return end

				if target:IsFrozen() then

					local sys = GAdmin_Menu:GetAdminSystem()
					if sys then
						sys["unfreeze"](ply, target)
					end
				else

					local sys = GAdmin_Menu:GetAdminSystem()
					if sys then
						sys["freeze"](ply, target)
					end
				end
			end
		},
		[5] = {
			name = "Spectate",
			func = function()
				if GAdmin_Menu:TargetCheck(target) == false then return end

				local sys = GAdmin_Menu:GetAdminSystem()
				if sys then
					sys["spectate"](ply, target)
				end
			end
		},
		[6] = {
			name = "Kick",
			func = function()
				if GAdmin_Menu:TargetCheck(target) == false then return end

				MainPanel:SetVisible(false)

				local tbl = {
					title = "Menu Administratif - KICK",
					types = 2,
					reasonTitle = "Raison :",
					accept = "Confirmer",
					cancel = "Annuler",
					func = function( reason, time )

						local sys = GAdmin_Menu:GetAdminSystem()
						if sys then
							sys["kick"](ply, target, reason)
						end

						MainPanel:SetVisible(true)
					end
				}
				GAdmin_Menu:RequestMenu(tbl)
			end
		},
		[7] = {
			name = "Ban",
			func = function()
				if GAdmin_Menu:TargetCheck(target) == false then return end

				MainPanel:SetVisible(false)
			
				local tbl = {
					title = "Menu Administratif - BAN",
					types = 2,
					reasonTitle = "Raison :",
					timeTitle = "Temps (en minutes) :",
					accept = "Confirmer",
					cancel = "Annuler",
					func = function( reason, time )

						local sys = GAdmin_Menu:GetAdminSystem()
						if sys then
							sys["ban"](ply, target, time, reason)
						end

						MainPanel:SetVisible(true)
					end
				}
				GAdmin_Menu:RequestMenu(tbl)
			end
		},
		[8] = {
			name = "Slay",
			func = function()
				if GAdmin_Menu:TargetCheck(target) == false then return end

				local sys = GAdmin_Menu:GetAdminSystem()
				if sys then
					sys["slay"](ply, target)
				end
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
				RFrame.Header.Paint = function( self, w, h )
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

				RFrame.Health_Request.Paint = function( self, w, h )
					OS_UI.DrawRoundedBox( 6, 0, 0, w, h, OS_UI.Colors.BASE_HEADER )
					self:DrawTextEntryText( OS_UI.Colors.WHITE, OS_UI.Colors.RED, OS_UI.Colors.WHITE )
				end

				RFrame.Accept = vgui.Create( "DButton", RFrame )
				RFrame.Accept:Dock( TOP )
				RFrame.Accept:DockMargin( 100, 10, 120, 5 )
				RFrame.Accept:SetTall( 30 )
				RFrame.Accept:SetText( "Confirmer" )
				RFrame.Accept:SetTextColor( OS_UI.Colors.WHITE )
				RFrame.Accept:SetFont( "OS_UI.Font.20" )
				RFrame.Accept.Paint = function( self, w, h )
					OS_UI.DrawRoundedBox( 6, 0, 0, w, h, OS_UI.Colors.GREEN )
				end

				RFrame.Accept.DoClick = function()
					RunConsoleCommand("sa", "hp", Player_Selected:Nick(), RFrame.Health_Request:GetValue())

					RFrame:Close()
					self:SetVisible(true)	
				end

				tbl = {
					title = "Menu Administratif - SET HEALTH",
					types = 2,
					reasonTitle = "Raison :",
					accept = "Confirmer",
					cancel = "Annuler",
					func = function( reason, time )
						RunConsoleCommand("sa", "hp", target:Nick(), reason)
						MainPanel:SetVisible(true)
					end
				}

				GAdmin_Menu:RequestMenu(tbl)

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
				RFrame.Header.Paint = function( self, w, h )
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

				RFrame.Armor_Request.Paint = function( self, w, h )
					OS_UI.DrawRoundedBox( 6, 0, 0, w, h, OS_UI.Colors.BASE_HEADER )
					self:DrawTextEntryText( OS_UI.Colors.WHITE, OS_UI.Colors.RED, OS_UI.Colors.WHITE )
				end

				RFrame.Accept = vgui.Create( "DButton", RFrame )
				RFrame.Accept:Dock( TOP )
				RFrame.Accept:DockMargin( 100, 10, 120, 5 )
				RFrame.Accept:SetTall( 30 )
				RFrame.Accept:SetText( "Confirmer" )
				RFrame.Accept:SetTextColor( OS_UI.Colors.WHITE )
				RFrame.Accept:SetFont( "OS_UI.Font.20" )
				RFrame.Accept.Paint = function( self, w, h )
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
		btn.Paint = function( self, w, h )
			draw.RoundedBox( 6, 0, 0, w, h, GAdmin_Menu.Constants["colors"]["Red"] )
		end
	end
	
	

end

function GAdmin_Menu:TargetCheck(target)
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

function GAdmin_Menu:RequestMenu(tbl)

	local RequestMenu = vgui.Create("DFrame")
	if tbl.types == 3 then
		RequestMenu:SetSize( RX(400), RY(300) )
	else
		RequestMenu:SetSize( RX(400), RY(200) )
	end
	RequestMenu:Center()
	RequestMenu:SetTitle("")
	RequestMenu:MakePopup()
	RequestMenu:ShowCloseButton(false)
	RequestMenu.Paint = function(self, w, h)
		surface.SetDrawColor( GAdmin_Menu.Constants["colors"]["background"] )
		surface.DrawRect( 0, 0, w, h )
	end

	RequestMenu.Header = vgui.Create("DPanel", RequestMenu)
	RequestMenu.Header:Dock( TOP )
	RequestMenu.Header:SetTall( 40 )
	RequestMenu.Header:DockMargin( -5, -30, -5, 0 )
	RequestMenu.Header:InvalidateLayout( true )
	RequestMenu.Header.Paint = function( self, w, h )
		surface.SetDrawColor( GAdmin_Menu.Constants["colors"]["header"] )
		surface.DrawRect( 0, 0, w, h )
		draw.SimpleText( tbl.title, "OS_UI.Font.21", w/ 2 - RequestMenu.Header:GetTall()/ 2.5 , h/ 2, GAdmin_Menu.Constants["colors"]["Grey"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	RequestMenu.Header.Close = vgui.Create("DButton", RequestMenu.Header)
	RequestMenu.Header.Close:SetSize( RequestMenu.Header:GetTall(), RequestMenu.Header:GetTall() )
	RequestMenu.Header.Close:Dock( RIGHT )
	RequestMenu.Header.Close:DockMargin( 5,0, 0, 0 )
	RequestMenu.Header.Close:SetText("")
	RequestMenu.Header.Close.Paint = function(self, w, h)
		surface.SetDrawColor(GAdmin_Menu.Constants["colors"]["Red"])
		draw.NoTexture()
		draw.Circle( w / 2, h / 2, 7, 50 )
		
	end
	RequestMenu.Header.Close.DoClick = function()
		RequestMenu:Close()
	end


	if tbl.types == 1 then

		RequestMenu.Number_Request_Text = vgui.Create( "DLabel", RequestMenu )
		RequestMenu.Number_Request_Text:Dock( TOP )
		RequestMenu.Number_Request_Text:SetTall( 30 )
		RequestMenu.Number_Request_Text:DockMargin( 5, 0, 5, 0 )
		RequestMenu.Number_Request_Text:SetText( tbl.numberTitle )
		RequestMenu.Number_Request_Text:SetFont( "OS_UI.Font.20" )

		RequestMenu.Number_Request = vgui.Create( "DTextEntry", RequestMenu )
		RequestMenu.Number_Request:Dock( TOP )
		RequestMenu.Number_Request:DockMargin( 30, 0, 30, 0)
		RequestMenu.Number_Request:SetTall( 30 )
		RequestMenu.Number_Request:SetFont( "OS_UI.Font.20" )
		RequestMenu.Number_Request:SetNumeric( true )
		RequestMenu.Number_Request.Paint = function( self, w, h )
			draw.RoundedBox( 6, 0, 0, w, h, GAdmin_Menu.Constants["colors"]["header"] )
			self:DrawTextEntryText( GAdmin_Menu.Constants["colors"]["White"], GAdmin_Menu.Constants["colors"]["Grey"], GAdmin_Menu.Constants["colors"]["White"] )
		end

	elseif tbl.types == 2 then
		RequestMenu.Reason_Request_Text = vgui.Create( "DLabel", RequestMenu )
		RequestMenu.Reason_Request_Text:Dock( TOP )
		RequestMenu.Reason_Request_Text:SetTall( 30 )
		RequestMenu.Reason_Request_Text:DockMargin( 5, 0, 5, 0 )
		RequestMenu.Reason_Request_Text:SetText( tbl.reasonTitle )
		RequestMenu.Reason_Request_Text:SetFont( "OS_UI.Font.20" )

		
		RequestMenu.Reason_Request = vgui.Create( "DTextEntry", RequestMenu )
		RequestMenu.Reason_Request:Dock( TOP )
		RequestMenu.Reason_Request:DockMargin( 30, 10, 30, 0 )
		RequestMenu.Reason_Request:SetTall( 30 )
		RequestMenu.Reason_Request:SetFont( "OS_UI.Font.20" )
		RequestMenu.Reason_Request.Paint = function( self, w, h )
			draw.RoundedBox( 6, 0, 0, w, h, GAdmin_Menu.Constants["colors"]["header"] )
			self:DrawTextEntryText( GAdmin_Menu.Constants["colors"]["White"], GAdmin_Menu.Constants["colors"]["Grey"], GAdmin_Menu.Constants["colors"]["White"] )
		end

	elseif tbl.types == 3 then

		RequestMenu.Number_Request_Text = vgui.Create( "DLabel", RequestMenu )
		RequestMenu.Number_Request_Text:Dock( TOP )
		RequestMenu.Number_Request_Text:SetTall( 30 )
		RequestMenu.Number_Request_Text:DockMargin( 5, 0, 5, 0 )
		RequestMenu.Number_Request_Text:SetText( tbl.numberTitle )
		RequestMenu.Number_Request_Text:SetFont( "OS_UI.Font.20" )

		RequestMenu.Number_Request = vgui.Create( "DTextEntry", RequestMenu )
		RequestMenu.Number_Request:Dock( TOP )
		RequestMenu.Number_Request:DockMargin( 30, 0, 30, 0)
		RequestMenu.Number_Request:SetTall( 30 )
		RequestMenu.Number_Request:SetFont( "OS_UI.Font.20" )
		RequestMenu.Number_Request:SetNumeric( true )
		RequestMenu.Number_Request.Paint = function( self, w, h )
			draw.RoundedBox( 6, 0, 0, w, h, GAdmin_Menu.Constants["colors"]["header"] )
			self:DrawTextEntryText( GAdmin_Menu.Constants["colors"]["White"], GAdmin_Menu.Constants["colors"]["Grey"], GAdmin_Menu.Constants["colors"]["White"] )
		end


		RequestMenu.Reason_Request_Text = vgui.Create( "DLabel", RequestMenu )
		RequestMenu.Reason_Request_Text:Dock( TOP )
		RequestMenu.Reason_Request_Text:SetTall( 30 )
		RequestMenu.Reason_Request_Text:DockMargin( 5, 0, 5, 0 )
		RequestMenu.Reason_Request_Text:SetText( tbl.reasonTitle )
		RequestMenu.Reason_Request_Text:SetFont( "OS_UI.Font.20" )
		
		RequestMenu.Reason_Request = vgui.Create( "DTextEntry", RequestMenu )
		RequestMenu.Reason_Request:Dock( TOP )
		RequestMenu.Reason_Request:DockMargin( 30, 0, 30, 0 )
		RequestMenu.Reason_Request:SetTall( 30 )
		RequestMenu.Reason_Request:SetFont( "OS_UI.Font.20" )
		RequestMenu.Reason_Request.Paint = function( self, w, h )
			draw.RoundedBox( 6, 0, 0, w, h, GAdmin_Menu.Constants["colors"]["header"] )
			self:DrawTextEntryText( GAdmin_Menu.Constants["colors"]["White"], GAdmin_Menu.Constants["colors"]["Grey"], GAdmin_Menu.Constants["colors"]["White"] )
		end

	end

	RequestMenu.Accept = vgui.Create( "DButton", RequestMenu )
	RequestMenu.Accept:Dock( TOP )
	RequestMenu.Accept:DockMargin( 100, 10, 120, 0 )
	RequestMenu.Accept:SetTall( 30 )
	RequestMenu.Accept:SetText( GAdmin_Menu:GetLanguage("confirm") )
	RequestMenu.Accept:SetTextColor( GAdmin_Menu.Constants["colors"]["White"] )
	RequestMenu.Accept:SetFont( "OS_UI.Font.20" )
	RequestMenu.Accept.Paint = function( self, w, h )
		draw.RoundedBox( 6, 0, 0, w, h, GAdmin_Menu.Constants["colors"]["Green"] )
	end
	RequestMenu.Accept.DoClick = function()
		RequestMenu:Close()

		if tbl.types == 1 then
			tbl.func(nil, RequestMenu.Number_Request:GetValue())
		elseif tbl.types == 2 then
			tbl.func(RequestMenu.Reason_Request:GetValue(), nil)
		elseif tbl.types == 3 then
			tbl.func(RequestMenu.Number_Request:GetValue(), RequestMenu.Reason_Request:GetValue())
		end
		
	end

end
