-- src/triggerbot.lua (Ayarlanabilir Gecikmeli Triggerbot)
local Trigger = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local settings = {
    Enabled = false,
    Delay = 50,             -- Milisaniye cinsinden gecikme (0 = Anında)
    Hitbox = "Head",        -- "Head", "Chest" veya "Any"
    TeamCheck = true,
    WallCheck = false       -- Duvarların arkasındakine sıkmasın mı?
}

local targetStartTime = 0
local currentTarget = nil

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

-- Crosshair'in (Ekranın tam ortası) baktığı yeri bulma
local function getTargetUnderCrosshair()
    local ray = Camera:ViewportPointToRay(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
    
    -- Eğer WallCheck açıksa, dünyayı da tarar ve duvar varsa iptal eder
    if not settings.WallCheck then
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        -- Sadece karakterleri taramak için daha spesifik filtre yapılabilir ama şimdilik genel bırakalım
    end

    local result = workspace:Raycast(ray.Origin, ray.Direction * 1000, rayParams)
    
    if result and result.Instance then
        local part = result.Instance
        local model = part:FindFirstAncestorOfClass("Model")
        
        if model then
            local player = Players:GetPlayerFromCharacter(model)
            if player and player ~= LocalPlayer then
                if settings.TeamCheck and player.Team == LocalPlayer.Team and LocalPlayer.Team ~= nil then
                    return nil
                end
                
                -- Hitbox Kontrolü
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
end

RunService.RenderStepped:Connect(function()
    if not settings.Enabled then return end
    
    local target = getTargetUnderCrosshair()
    local currentTime = tick() * 1000 -- Milisaniye
    
    if target then
        -- Eğer yeni bir hedefe kilitlendiysek zamanlayıcıyı sıfırla
        if currentTarget ~= target then
            currentTarget = target
            targetStartTime = currentTime
        end
        
        -- Gecikme süresi dolduysa ateş et
        if currentTime - targetStartTime >= settings.Delay then
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                pcall(function() tool:Activate() end)
                -- Ateş ettikten sonra zamanlayıcıyı sıfırla ki spam yapmasın (Auto-fire a dönmesin)
                targetStartTime = currentTime + 200 -- 200ms cooldown (silah atış hızına göre)
            end
        end
    else
        currentTarget = nil
    end
end)

return Trigger
