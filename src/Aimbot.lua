-- src/aimbot.lua (Mobil Uyumlu & Crash Atmayan Sürüm)
local Aimbot = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local settings = {
    Enabled = false,
    FOV = 120,
    Smoothness = 2,
    Hitbox = "Head",
    WallCheck = false, -- Mobilde raycast performans yükünü azaltmak için kapalı başlatıyoruz
    IsAiming = true,   -- Mobilde direkt aktif olsun diye true yaptık
}

function Aimbot.Set(key, value)
    if settings[key] ~= nil then
        settings[key] = value
    end
end

function Aimbot.Toggle(state)
    settings.Enabled = state
end

-- Mobilde en yakın hedefi bulan optimize edilmiş fonksiyon
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
            local hum = char:FindFirstChildOfClass("Humanoid")
            
            if hum and hum.Health > 0 then
                local isTeammate = (player.Team == LocalPlayer.Team) and LocalPlayer.Team ~= nil
                
                if not isTeammate and head then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    
                    if onScreen then
                        local distToCenter = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        
                        if distToCenter <= settings.FOV then
                            if distToCenter < shortestDist then
                                shortestDist = distToCenter
                                closestPart = head
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
    if not settings.Enabled or not settings.IsAiming then return end
    
    local target = getClosestTarget()
    if target then
        local targetPos = target.Position
        local currentCFrame = Camera.CFrame
        local targetCFrame = CFrame.lookAt(currentCFrame.Position, targetPos)
        
        -- Mobili sarsmayacak pürüzsüz geçiş (Lerp)
        local smoothFactor = math.clamp(1 / (settings.Smoothness * 5), 0.05, 1)
        Camera.CFrame = currentCFrame:Lerp(targetCFrame, smoothFactor)
    end
end)

return Aimbot
