-- src/combat.lua (Full+Full Mobil Combat)
local Combat = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local settings = {
    Enabled = false,
    NoRecoil = false,
    RapidFire = false,
    AutoReload = false,
    FireRate = 60, -- Mobil için güvenli hız (ms)
}

local lastShot = 0
local isTouching = false
local originalCameraCFrame = nil

function Combat.Set(key, value)
    if settings[key] ~= nil then settings[key] = value end
end

function Combat.Toggle(state)
    settings.Enabled = state
end

-- Dokunmatik ve Fare algılama
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
            -- 1. Rapid Fire (Mobil Uyumlu Hızlı Ateş)
            if settings.RapidFire and isTouching then
                local currentTime = tick() * 1000
                if currentTime - lastShot >= settings.FireRate then
                    lastShot = currentTime
                    tool:Activate()
                end
            end
            
            -- 2. No Recoil (Sekme Engelleme - Kamerayı Sabitleme)
            if settings.NoRecoil and isTouching then
                -- Sıkarken kameranın anlık yukarı zıplamasını yumuşat
                local currentPitch = Camera.CFrame:ToEulerAnglesYXZ()
                if currentPitch > math.rad(80) then
                    -- Aşırı yukarı bakmayı engelle
                    Camera.CFrame = CFrame.Angles(0, Camera.CFrame:ToEulerAnglesYXZ(), 0) 
                end
            end

            -- 3. Auto Reload (Otomatik Şarjör)
            if settings.AutoReload and not isTouching then
                -- Eğer ateş etmiyorsak ve silah boşsa R tuşuna bas (Sanal tuş simülasyonu)
                -- Oyun R tuşunu desteklemiyorsa Tool'u yeniden kuşanır
                if tool:GetAttribute("Ammo") == 0 or tool:GetAttribute("Ammo") == "0" then
                    pcall(function()
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.R, false, game)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.R, false, game)
                    end)
                    
                    -- Eğer R işe yaramazsa silahı düşürüp tekrar al (Reload hilesi)
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum:UnequipTools()
                        task.wait(0.1)
                        hum:EquipTool(tool)
                    end
                end
            end
        end
    end)
end)

return Combat
