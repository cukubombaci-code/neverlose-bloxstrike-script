-- src/hitbox.lua (Kasmayan & Bellek Sızıntısı Giderilmiş)
local Hitbox = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local settings = {
    Enabled = false,
    Size = 2, 
    Transparency = false -- Kafayı yarı saydam yap (Görsel)
}

local expandedParts = {}

function Hitbox.Set(key, value)
    if settings[key] ~= nil then settings[key] = value end
end

function Hitbox.Toggle(state)
    settings.Enabled = state
    if not state then
        pcall(function()
            for part, data in pairs(expandedParts) do
                if part and part.Parent then 
                    part.Size = data.Size 
                    part.Transparency = data.Transparency
                end
            end
            expandedParts = {}
        end)
    end
end

-- Ölen veya çıkan oyuncuların eski kafa referanslarını temizle (Memory Leak Fix)
local function cleanupDeadParts()
    for part, _ in pairs(expandedParts) do
        if not part or not part.Parent then
            expandedParts[part] = nil
        end
    end
end

RunService.Heartbeat:Connect(function()
    if not settings.Enabled then return end
    
    pcall(function()
        local myTeam = LocalPlayer.Team
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local char = player.Character
                local isTeammate = (player.Team == myTeam) and myTeam ~= nil
                
                if not isTeammate then
                    local head = char:FindFirstChild("Head")
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    
                    if head and head:IsA("BasePart") and hum and hum.Health > 0 then
                        if not expandedParts[head] then
                            -- Orijinal boyut ve şeffaflığı kaydet
                            expandedParts[head] = {
                                Size = head.Size,
                                Transparency = head.Transparency
                            }
                        end
                        
                        local data = expandedParts[head]
                        local targetSize = Vector3.new(data.Size.X * settings.Size, data.Size.Y * settings.Size, data.Size.Z * settings.Size)
                        
                        if head.Size ~= targetSize then
                            head.Size = targetSize
                            head.CanCollide = false
                            
                            if settings.Transparency then
                                head.Transparency = 0.5
                            else
                                head.Transparency = data.Transparency
                            end
                        end
                    end
                end
            end
        end
        
        -- Her 1 saniyede bir (yaklaşık) ölü parçaları temizle
        if tick() % 1 < 0.02 then
            cleanupDeadParts()
        end
    end)
end)

return Hitbox
