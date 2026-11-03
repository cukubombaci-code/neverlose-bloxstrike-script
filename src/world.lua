-- src/world.lua (Full+Full Çökme Korumalı & Scope Bozmayan Sürüm)
local World = {}
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local settings = {
    Fullbright = false,
    FullbrightValue = 3,
    FOVEnabled = false,
    FOVValue = 90,
    RemoveFog = false
}

-- Orijinal ayarları güvenli yedekleme (Saat ve Gölgeler dahil)
local original = {
    Ambient = Color3.fromRGB(128, 128, 128),
    OutdoorAmbient = Color3.fromRGB(128, 128, 128),
    Brightness = 1,
    FogEnd = 10000,
    FogStart = 0,
    FogColor = Color3.fromRGB(192, 192, 192),
    ClockTime = 14,
    GlobalShadows = true,
    FOV = 70
}

pcall(function()
    original.Ambient = Lighting.Ambient
    original.OutdoorAmbient = Lighting.OutdoorAmbient
    original.Brightness = Lighting.Brightness
    original.FogEnd = Lighting.FogEnd
    original.FogStart = Lighting.FogStart
    original.FogColor = Lighting.FogColor
    original.ClockTime = Lighting.ClockTime
    original.GlobalShadows = Lighting.GlobalShadows
    if workspace.CurrentCamera then
        original.FOV = workspace.CurrentCamera.FieldOfView
    end
end)

function World.Set(key, value)
    if settings[key] ~= nil then
        settings[key] = value
        World.Update()
    end
end

function World.Update()
    pcall(function()
        -- 1. FULLBRIGHT
        if settings.Fullbright then
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Lighting.Brightness = settings.FullbrightValue
            Lighting.GlobalShadows = false
            Lighting.ClockTime = 12
        else
            Lighting.Ambient = original.Ambient
            Lighting.OutdoorAmbient = original.OutdoorAmbient
            Lighting.Brightness = original.Brightness
            Lighting.GlobalShadows = original.GlobalShadows
            Lighting.ClockTime = original.ClockTime
        end
        
        -- 2. REMOVE FOG
        if settings.RemoveFog then
            Lighting.FogEnd = 999999
            Lighting.FogStart = 999999
        else
            Lighting.FogEnd = original.FogEnd
            Lighting.FogStart = original.FogStart
            Lighting.FogColor = original.FogColor
        end
        
        -- 3. FOV CHANGER (Sadece değiştiğinde uygula ki sniper scope bozulmasın)
        local cam = workspace.CurrentCamera
        if cam then
            if settings.FOVEnabled then
                cam.FieldOfView = settings.FOVValue
            else
                cam.FieldOfView = original.FOV
            end
        end
    end)
end

return World
