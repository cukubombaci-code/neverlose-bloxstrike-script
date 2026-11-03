-- src/hitbox.lua (Mobil Uyumlu & Güvenli Hitbox Büyütücü)
local Hitbox = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local settings = {
    Enabled = false,
    Size = 2, -- Çarpan (Mobilde aşırı büyük yapmak oyuncuyu buga sokabilir, 2-3 idealdir)
}

local expandedParts = {}

function Hitbox.Set(key, value)
    if settings[key] ~= nil then settings[key] = value end
end

function Hitbox.Toggle(state)
    settings.Enabled = state
    if not state then
        pcall(function()
            for part, originalSize in pairs(expandedParts) do
                if part and part.Parent then part.Size = originalSize end
            end
            expandedParts = {}
        end)
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
                            expandedParts[head] = head.Size -- Orijinal boyutu güvenle kaydet
                        end
                        
                        local original = expandedParts[head]
                        -- Boyutu güvenli sınırlarda büyüt
                        local targetSize = Vector3.new(original.X * settings.Size, original.Y * settings.Size, original.Z * settings.Size)
                        if head.Size ~= targetSize then
                            head.Size = targetSize
                            head.Transparency = 0.5 -- İsteğe bağlı: büyüyen kafayı yarı şeffaf yapar
                            head.CanCollide = false
                        end
                    end
                end
            end
        end
    end)
end)

return Hitbox
