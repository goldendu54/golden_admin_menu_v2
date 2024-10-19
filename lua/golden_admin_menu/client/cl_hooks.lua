if !CLIENT then return end

resource.AddFile("resource/fonts/Righteous.ttf")

--[[ Create fonts ]]--
local function RespFont(font) return font/1920*ScrW() end
for i=1, 100 do
	surface.CreateFont("Righteous"..i, {
		font = "Circular Std Medium",
		extended = false,
		size = RespFont(i),
		weight = 600,
	})
end


ContextMenuOpen = false

hook.Add("OnScreenSizeChanged", "GAdmin:Respondsives", function() 
    x = ScrW()
    y = ScrH()
end) 

RX = RX or function(x) return x / 1920 * ScrW() end
RY = RY or function(y) return y / 1080 * ScrH() end




