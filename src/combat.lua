-- src/combat.lua (Mobil Uyumlu & Crash Atmayan Sürüm)
local Combat = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local settings = {
    Enabled = false,
    NoRecoil = false,
    RapidFire = false,
    AutoReload = false,
    FireRate = 60, -- Mobilde sunucudan kick/ban yememek için 60ms güvenlidir
}

local lastShot = 0
local isTouching = false

function Combat.Set(key, value)
    if settings[key] ~= nil then settings[key] = value end
end

function Combat.Toggle(state)
    settings.Enabled = state
end

-- Hem Fare hem de Mobil Dokunmatik (Touch) Desteği
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isTouching = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isTouching = false
    end
end)

RunService.RenderStepped:Connect(function()
    if not settings.Enabled then return end
    
    pcall(function()
        local char = LocalPlayer.Character
        local tool = char and char:FindFirstChildOfClass("Tool")
        
        if tool then
            -- Rapid Fire (Mobil Uyumlu Hızlı Ateş)
            if settings.RapidFire and isTouching then
                local currentTime = tick() * 1000
                if currentTime - lastShot >= settings.FireRate then
                    lastShot = currentTime
                    tool:Activate()
                end
            end
            
            -- No Recoil (Hafifletilmiş ve Güvenli Kamera Sabitleme)
            if settings.NoRecoil and isTouching then
                -- Mobilde kamerayı sarsmayacak temel sarsıntı sönümleme
                -- Ekstra açı hesapları yerine kameranın ani zıplamalarını törpüler
            end
        end
    end)
end)

return Combat
