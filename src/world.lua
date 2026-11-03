-- src/world.lua (Gelişmiş Fullbright ve FOV)
local World = {}
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

local settings = {
    Fullbright = false,
    FullbrightValue = 3,   -- Parlaklık şiddeti (1 ile 10 arası)
    
    FOVEnabled = false,
    FOVValue = 90,         -- Varsayılan FOV
    
    RemoveFog = false
}

-- Orijinal ayarları yedekle (kapatınca eski haline dönmesi için)
local original = {
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    Brightness = Lighting.Brightness,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart,
    FOV = Camera.FieldOfView
}

function World.Set(key, value)
    if settings[key] ~= nil then
        settings[key] = value
        World.Update() -- Değer değiştiği an güncelle
    end
end

function World.Update()
    -- Fullbright (Parlaklık ayarlanabilir)
    if settings.Fullbright then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = settings.FullbrightValue
        Lighting.ClockTime = 12 -- Gündüz
    else
        Lighting.Ambient = original.Ambient
        Lighting.OutdoorAmbient = original.OutdoorAmbient
        Lighting.Brightness = original.Brightness
    end
    
    -- Remove Fog
    if settings.RemoveFog then
        Lighting.FogEnd = 100000
        Lighting.FogStart = 100000
    else
        Lighting.FogEnd = original.FogEnd
        Lighting.FogStart = original.FogStart
    end
    
    -- FOV Changer
    if settings.FOVEnabled then
        Camera.FieldOfView = settings.FOVValue
    else
        Camera.FieldOfView = 70 -- Orijinal Roblox FOV
    end
end

-- Kamerayı sürekli kontrol et (oyun kamerayı sıfırlarsa diye)
RunService.RenderStepped:Connect(function()
    if settings.FOVEnabled and Camera.FieldOfView ~= settings.FOVValue then
        Camera.FieldOfView = settings.FOVValue
    end
end)

return World
