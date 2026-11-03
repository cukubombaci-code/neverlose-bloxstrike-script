-- src/ragebot.lua (Full+Full Mobil Çökme Korumalı Ragebot)
local Rage = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local settings = {
    Enabled = false,
    FOV = 360,
    Smoothing = 0.2,
    Hitbox = "Head",      -- Menüden değiştirilebilir
    AutoWall = true,      -- Duvarları delip geçme
    AutoFire = true,
    FireRate = 50,
    Prediction = true,    -- Hareket tahmini (Resolver)
}

-- Çember (Çökme korumalı)
local fovCircle = nil
pcall(function()
    fovCircle = Drawing.new("Circle")
    fovCircle.Thickness = 1.5
    fovCircle.NumSides = 30
    fovCircle.Transparency = 1
    fovCircle.Visible = false
    fovCircle.Color = Color3.fromRGB(255, 0, 0)
end)

function Rage.Set(key, value)
    if settings[key] ~= nil then settings[key] = value end
end

function Rage.Toggle(state)
    settings.Enabled = state
    if not state and fovCircle then fovCircle.Visible = false end
end

local lastShot = 0

-- Duvar kontrolü için
local function isVisible(targetPart)
    if settings.AutoWall then return true end
    
    local rayOrigin = Camera.CFrame.Position
    local rayDirection = (targetPart.Position - rayOrigin).Unit * (targetPart.Position - rayOrigin).Magnitude
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, targetPart.Parent}
    
    local rayResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    return rayResult == nil
end

local function getBestTarget()
    local bestTarget = nil
    local bestScore = math.huge
    local screenCenter = Camera.ViewportSize / 2
    local localChar = LocalPlayer.Character
    
    if not localChar or not localChar:FindFirstChild("HumanoidRootPart") then return nil end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            
            if hum and hum.Health > 0 then
                local isTeammate = (player.Team == LocalPlayer.Team) and LocalPlayer.Team ~= nil
                
                if not isTeammate then
                    -- Hitbox Seçimi (Menüden gelen)
                    local head = char:FindFirstChild("Head")
                    local chest = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
                    
                    local targetPart = head
                    if settings.Hitbox == "Chest" and chest then targetPart = chest end
                    
                    if targetPart and isVisible(targetPart) then
                        local pos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                        if onScreen then
                            local dist = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                            if dist <= settings.FOV and dist < bestScore then
                                bestScore = dist
                                
                                -- Prediction (Hareket tahmini)
                                local targetPos = targetPart.Position
                                if settings.Prediction then
                                    local vel = targetPart.AssemblyLinearVelocity
                                    targetPos = targetPos + (vel * 0.05) -- 50ms gecikme tahmini
                                end
                                
                                bestTarget = { part = targetPart, pos = targetPos }
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
    -- Ana döngüyü pcall içine al (Çökme koruması)
    pcall(function()
        if fovCircle then
            if settings.Enabled then
                fovCircle.Position = Camera.ViewportSize / 2
                fovCircle.Radius = settings.FOV
                fovCircle.Visible = true
            else
                fovCircle.Visible = false
            end
        end

        if not settings.Enabled then return end

        local target = getBestTarget()
        if target then
            local targetCFrame = CFrame.lookAt(Camera.CFrame.Position, target.pos)
            if settings.Smoothing >= 0.99 then
                Camera.CFrame = targetCFrame
            else
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, settings.Smoothing)
            end
            
            if settings.AutoFire then
                local currentTime = tick() * 1000
                if currentTime - lastShot >= settings.FireRate then
                    lastShot = currentTime
                    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then pcall(function() tool:Activate() end) end
                end
            end
        end
    end)
end)

return Rage
