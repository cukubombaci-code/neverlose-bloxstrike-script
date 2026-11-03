-- src/triggerbot.lua (Full+Full Çökme Korumalı Triggerbot)
local Trigger = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local settings = {
    Enabled = false,
    Delay = 40,             -- Hedefe kilitlendikten sonra ateş etme gecikmesi (ms)
    Hitbox = "Head",        -- "Head", "Chest" veya "Any"
    TeamCheck = true,
    ShotCooldown = 150      -- Art arda sıkma koruması (Sunucudan atmaması için)
}

local currentTarget = nil
local targetStartTime = 0
local lastShotTime = 0

function Trigger.Set(key, value)
    if settings[key] ~= nil then
        settings[key] = value
    end
end

function Trigger.Toggle(state)
    settings.Enabled = state
    if not state then
        currentTarget = nil
    end
end

-- Çapraz nişangah altındaki hedefi güvenle bulan fonksiyon
local function getTargetUnderCrosshair()
    local success, resultTarget = pcall(function()
        local viewportSize = Camera.ViewportSize
        local ray = Camera:ViewportPointToRay(viewportSize.X / 2, viewportSize.Y / 2)
        
        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        rayParams.FilterDescendantsInstances = {LocalPlayer.Character}

        local result = workspace:Raycast(ray.Origin, ray.Direction * 800, rayParams)
        
        if result and result.Instance then
            local part = result.Instance
            local model = part:FindFirstAncestorOfClass("Model")
            
            if model then
                local player = Players:GetPlayerFromCharacter(model)
                if player and player ~= LocalPlayer then
                    -- Takım kontrolü
                    if settings.TeamCheck and player.Team == LocalPlayer.Team and LocalPlayer.Team ~= nil then
                        return nil
                    end
                    
                    -- Hitbox Filtresi (Kafa veya Göğüs)
                    if settings.Hitbox == "Head" and part.Name == "Head" then
                        return player
                    elseif settings.Hitbox == "Chest" and (part.Name == "UpperTorso" or part.Name == "Torso") then
                        return player
                    elseif settings.Hitbox == "Any" then
                        return player
                    end
                end
            end
        end
        return nil
    end)
    
    if success then
        return resultTarget
    end
    return nil
end

RunService.RenderStepped:Connect(function()
    if not settings.Enabled then return end
    
    pcall(function()
        local target = getTargetUnderCrosshair()
        local currentTime = tick() * 1000 -- Milisaniye
        
        if target then
            if currentTarget ~= target then
                currentTarget = target
                targetStartTime = currentTime
            end
            
            -- 1. Gecikme süresi doldu mu?
            if currentTime - targetStartTime >= settings.Delay then
                -- 2. Sıkma koruması (Cooldown) doldu mu?
                if currentTime - lastShotTime >= settings.ShotCooldown then
                    local char = LocalPlayer.Character
                    local tool = char and char:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                        lastShotTime = currentTime -- Süreyi güncelle
                    end
                end
            end
        else
            currentTarget = nil
        end
    end)
end)

return Trigger
