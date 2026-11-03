-- src/aimbot.lua (Orijinal Mantık + Güvenli FOV Çemberi)
local Aimbot = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local settings = {
    Enabled = false,
    Mode = "Legit",
    FOV = 150,
    Smoothness = 1.5,
    Hitbox = "Head",
    AimKey = Enum.UserInputType.MouseButton2,
    ShowFOV = true,
    FOVColor = Color3.fromRGB(255, 255, 255),
    FOVThickness = 1.5,
    WallCheck = true,
    IsAiming = false,
}

-- Mobilde çökmeyi önleyen güvenli FOV çemberi
local fovCircle = nil
pcall(function()
    fovCircle = Drawing.new("Circle")
    fovCircle.Thickness = settings.FOVThickness
    fovCircle.NumSides = 40
    fovCircle.Transparency = 1
    fovCircle.Visible = false
end)

function Aimbot.Set(key, value)
    if settings[key] ~= nil then
        settings[key] = value
    end
end

function Aimbot.Toggle(state)
    settings.Enabled = state
    if not state and fovCircle then fovCircle.Visible = false end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == settings.AimKey or input.KeyCode == settings.AimKey then
        settings.IsAiming = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == settings.AimKey or input.KeyCode == settings.AimKey then
        settings.IsAiming = false
    end
end)

local function isVisible(targetPart)
    if not settings.WallCheck then return true end
    
    local rayOrigin = Camera.CFrame.Position
    local rayDirection = (targetPart.Position - rayOrigin).Unit * (targetPart.Position - rayOrigin).Magnitude
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, targetPart.Parent}
    
    local rayResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    return rayResult == nil
end

local function getClosestTarget()
    local closestPart = nil
    local shortestDist = math.huge
    local screenCenter = Camera.ViewportSize / 2
    local localChar = LocalPlayer.Character
    
    if not localChar or not localChar:FindFirstChild("HumanoidRootPart") then return nil end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local head = char:FindFirstChild("Head")
            local chest = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
            local hum = char:FindFirstChildOfClass("Humanoid")
            
            if hum and hum.Health > 0 then
                local isTeammate = (player.Team == LocalPlayer.Team) and LocalPlayer.Team ~= nil
                
                if not isTeammate then
                    local targetPart = head
                    if settings.Hitbox == "Chest" and chest then targetPart = chest
                    elseif settings.Hitbox == "Nearest" then
                        local distHead = head and (Camera.CFrame.Position - head.Position).Magnitude or math.huge
                        local distChest = chest and (Camera.CFrame.Position - chest.Position).Magnitude or math.huge
                        targetPart = (distHead < distChest) and head or chest
                    end
                    
                    if targetPart then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                        
                        if onScreen then
                            local distToCenter = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                            
                            if distToCenter <= settings.FOV then
                                if distToCenter < shortestDist then
                                    if isVisible(targetPart) then
                                        shortestDist = distToCenter
                                        closestPart = targetPart
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return closestPart
end

RunService.RenderStepped:Connect(function()
    if fovCircle then
        if not settings.Enabled or not settings.ShowFOV then
            fovCircle.Visible = false
        else
            fovCircle.Position = Camera.ViewportSize / 2
            fovCircle.Radius = settings.FOV
            fovCircle.Color = settings.FOVColor
            fovCircle.Thickness = settings.FOVThickness
            fovCircle.Visible = true
        end
    end
    
    if not settings.Enabled or not settings.IsAiming then return end
    
    local target = getClosestTarget()
    if target then
        local targetPos = target.Position
        local currentCFrame = Camera.CFrame
        local targetCFrame = CFrame.lookAt(currentCFrame.Position, targetPos)
        
        if settings.Mode == "Rage" then
            Camera.CFrame = targetCFrame
        else
            local smoothFactor = 1 / (settings.Smoothness * 10)
            Camera.CFrame = currentCFrame:Lerp(targetCFrame, math.clamp(smoothFactor, 0.01, 1))
        end
    end
end)

return Aimbot
