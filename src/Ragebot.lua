-- src/ragebot.lua (ULTRA PRO GAMESENSE STYLE)
local Rage = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local settings = {
    Enabled = false,
    AlwaysAim = false,      
    AimKey = Enum.UserInputType.MouseButton2, 
    IsAiming = false,
    
    FOV = 360,              
    Smoothing = 0.1,        -- 0.1 = Anında, 1.0 = Yumuşak
    
    TargetMode = "Crosshair", -- "Crosshair", "Lowest HP", "Distance"
    
    -- Ateşleme Ayarları
    AutoFire = true,
    FireRate = 10,          -- Milisaniye (10ms = çok hızlı)
    BurstMode = false,      -- Seri atış açık mı?
    BurstCount = 3,         -- Kaç kurşun sıksın
    BurstDelay = 200,       -- Seriler arası bekleme (ms)
    
    -- Duvarları Delme ve Tahmin
    AutoWall = true,        
    UsePrediction = true,   -- Ping ve hız tahmini (Resolver)
    PredictionAmount = 0.05,-- Saniye (Ping'e göre ayarlanır)
    
    -- Hitbox Önceliği
    Hitboxes = {
        Head = true,
        Chest = true,
        Stomach = true,
        Legs = false,
        Arms = false
    }
}

-- FOV Çemberi
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1.5
fovCircle.NumSides = 60
fovCircle.Transparency = 1
fovCircle.Visible = false
fovCircle.Color = Color3.fromRGB(255, 0, 0)

-- Hedef Çizgisi (Ne kilitlendiğini görmek için)
local targetLine = Drawing.new("Line")
targetLine.Thickness = 1
targetLine.Color = Color3.fromRGB(255, 0, 0)
targetLine.Transparency = 0.5
targetLine.Visible = false

function Rage.Set(key, value)
    if settings[key] ~= nil then settings[key] = value end
end

function Rage.SetHitbox(box, state)
    if settings.Hitboxes[box] ~= nil then settings.Hitboxes[box] = state end
end

function Rage.Toggle(state)
    settings.Enabled = state
    if not state then
        fovCircle.Visible = false
        targetLine.Visible = false
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == settings.AimKey or input.KeyCode == settings.AimKey then settings.IsAiming = true end
end)
UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == settings.AimKey or input.KeyCode == settings.AimKey then settings.IsAiming = false end
end)

local lastShot = 0
local burstShotCount = 0
local lastBurstTime = 0

-- En İyi Hedefi Bulma (Ultra Algoritma)
local function getBestTarget()
    local bestTarget = nil
    local bestScore = math.huge
    local screenCenter = Camera.ViewportSize / 2
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            
            if hum and hum.Health > 0 then
                local isTeammate = (player.Team == LocalPlayer.Team) and LocalPlayer.Team ~= nil
                
                if not isTeammate then
                    -- Hitbox'ları listele
                    local checkParts = {}
                    if settings.Hitboxes.Head then table.insert(checkParts, char:FindFirstChild("Head")) end
                    if settings.Hitboxes.Chest then table.insert(checkParts, char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")) end
                    if settings.Hitboxes.Stomach then table.insert(checkParts, char:FindFirstChild("LowerTorso")) end
                    if settings.Hitboxes.Legs then 
                        table.insert(checkParts, char:FindFirstChild("LeftUpperLeg")); table.insert(checkParts, char:FindFirstChild("RightUpperLeg")) 
                    end
                    
                    for _, part in ipairs(checkParts) do
                        if part then
                            local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                            local dist = onScreen and (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude or 9999
                            
                            if dist <= settings.FOV then
                                local score = dist
                                -- Target Mode Mantığı
                                if settings.TargetMode == "Lowest HP" then score = hum.Health 
                                elseif settings.TargetMode == "Distance" then score = (Camera.CFrame.Position - part.Position).Magnitude end
                                
                                if score < bestScore then
                                    bestScore = score
                                    
                                    -- Prediction (Hareket Tahmini)
                                    local targetPos = part.Position
                                    if settings.UsePrediction then
                                        local vel = part.AssemblyLinearVelocity
                                        targetPos = targetPos + (vel * settings.PredictionAmount)
                                    end
                                    
                                    bestTarget = { part = part, position = targetPos, screenPos = Vector2.new(pos.X, pos.Y) }
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return bestTarget
end

RunService.RenderStepped:Connect(function()
    if not settings.Enabled then 
        fovCircle.Visible = false 
        targetLine.Visible = false
        return 
    end

    fovCircle.Position = Camera.ViewportSize / 2
    fovCircle.Radius = settings.FOV
    fovCircle.Visible = true

    local shouldAim = settings.AlwaysAim or settings.IsAiming
    if not shouldAim then 
        targetLine.Visible = false
        return 
    end

    local target = getBestTarget()
    
    if target then
        -- Auto Wall Kontrolü (Duvarları delme)
        local canShoot = true
        if not settings.AutoWall then
            local rayParams = RaycastParams.new()
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            rayParams.FilterDescendantsInstances = {LocalPlayer.Character, target.part.Parent}
            local hit = workspace:Raycast(Camera.CFrame.Position, (target.position - Camera.CFrame.Position), rayParams)
            if hit then canShoot = false end
        end

        if canShoot then
            -- Hedef Çizgisi Çizimi
            targetLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            targetLine.To = target.screenPos
            targetLine.Visible = true
            
            -- Kamerayı Hedefe Kilitlame (Smoothing Destekli)
            local targetCFrame = CFrame.lookAt(Camera.CFrame.Position, target.position)
            if settings.Smoothing >= 0.99 then
                Camera.CFrame = targetCFrame -- Anında Kilit (Rage)
            else
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, settings.Smoothing) -- Yumuşak Kilit
            end
            
            -- Otomatik Ateş (Auto Fire & Burst Mode)
            if settings.AutoFire then
                local currentTime = tick() * 1000 -- Milisaniye cinsinden zaman
                
                if settings.BurstMode then
                    if burstShotCount < settings.BurstCount then
                        if currentTime - lastShot >= settings.FireRate then
                            lastShot = currentTime
                            burstShotCount = burstShotCount + 1
                            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                            if tool then pcall(function() tool:Activate() end) end
                        end
                    else
                        if currentTime - lastBurstTime >= settings.BurstDelay then
                            lastBurstTime = currentTime
                            burstShotCount = 0
                        end
                    end
                else
                    if currentTime - lastShot >= settings.FireRate then
                        lastShot = currentTime
                        local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if tool then pcall(function() tool:Activate() end) end
                    end
                end
            end
        else
            targetLine.Visible = false
        end
    else
        targetLine.Visible = false
    end
end)

return Rage
