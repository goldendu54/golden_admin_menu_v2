-- Called when the server ask for an update
net.Receive("GAdmin_Menu:OpenMenu", function(len, ply)

	GAdmin_Menu:OpenMenus(ply)

end)