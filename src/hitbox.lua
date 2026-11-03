-- src/hitbox.lua (Vuruş Alanı Büyütme)
local Hitbox = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local settings = {
    Enabled = false,
    Size = 2, -- Varsayılan çarpan
}

local expandedParts = {}

function Hitbox.Set(key, value)
    if settings[key] ~= nil then settings[key] = value end
end

function Hitbox.Toggle(state)
    settings.Enabled = state
    if not state then
        for part, originalSize in pairs(expandedParts) do
            if part and part.Parent then part.Size = originalSize end
        end
        expandedParts = {}
    end
end

RunService.Heartbeat:Connect(function()
    if not settings.Enabled then return end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local head = char:FindFirstChild("Head")
            
            if head and head:IsA("BasePart") then
                if not expandedParts[head] then
                    expandedParts[head] = head.Size -- Orijinal boyutu kaydet
                end
                -- Kafayı belirlenen çarpan kadar büyüt
                local original = expandedParts[head]
                head.Size = Vector3.new(original.X * settings.Size, original.Y * settings.Size, original.Z * settings.Size)
            end
        end
    end
end)

return Hitbox
