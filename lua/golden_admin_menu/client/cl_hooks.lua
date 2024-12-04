if !CLIENT then return end

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

hook.Add("OnScreenSizeChanged", "GAdmin:Respondsives", function() 
    x = ScrW()
    y = ScrH()
end) 