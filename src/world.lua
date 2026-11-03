-- src/world.lua (Mobil Uyumlu & Güvenli Fullbright, Sis ve FOV)
local World = {}
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

local settings = {
    Fullbright = false,
    FullbrightValue = 3,   -- Parlaklık şiddeti (1 ile 10 arası)
    
    FOVEnabled = false,
    FOVValue = 90,         -- Varsayılan genişletilmiş FOV
    
    RemoveFog = false
}

-- Orijinal ayarları güvenli yedekleme
local original = {
    Ambient = Color3.fromRGB(128, 128, 128),
    OutdoorAmbient = Color3.fromRGB(128, 128, 128),
    Brightness = 1,
    FogEnd = 10000,
    FogStart = 0,
    FOV = 70
}

-- Güvenli başlangıç yedeği al
pcall(function()
    original.Ambient = Lighting.Ambient
    original.OutdoorAmbient = Lighting.OutdoorAmbient
    original.Brightness = Lighting.Brightness
    original.FogEnd = Lighting.FogEnd
    original.FogStart = Lighting.FogStart
    original.FOV = Camera.FieldOfView
end)

function World.Set(key, value)
    if settings[key] ~= nil then
        settings[key] = value
        World.Update()
    end
end

function World.Update()
    pcall(function()
        -- Fullbright
        if settings.Fullbright then
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Lighting.Brightness = settings.FullbrightValue
            Lighting.ClockTime = 12
        else
            Lighting.Ambient = original.Ambient
            Lighting.OutdoorAmbient = original.OutdoorAmbient
            Lighting.Brightness = original.Brightness
        end
        
        -- Remove Fog
        if settings.RemoveFog then
            Lighting.FogEnd = 999999
            Lighting.FogStart = 999999
        else
            Lighting.FogEnd = original.FogEnd
            Lighting.FogStart = original.FogStart
        end
        
        -- FOV Changer
        if settings.FOVEnabled then
            Camera.FieldOfView = settings.FOVValue
        else
            Camera.FieldOfView = original.FOV
        end
    end)
end

-- Kamerayı kontrol et (Sadece FOV aktifse çalışır, performansı korur)
RunService.RenderStepped:Connect(function()
    if settings.FOVEnabled then
        pcall(function()
            if Camera.FieldOfView ~= settings.FOVValue then
                Camera.FieldOfView = settings.FOVValue
            end
        end)
    end
end)

return World
