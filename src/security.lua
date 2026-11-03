-- src/security.lua (Mobile Safe Bypass - Hookmetamethod İçermez)
local Security = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local settings = {
    AntiKick = true,
    AntiFling = true,
    AntiVoid = true
}

-- 1. ANTI-KICK (Sunucu seni atmaya çalışırsa engelle)
if settings.AntiKick then
    pcall(function()
        local oldKick = LocalPlayer.Kick
        LocalPlayer.Kick = function(self, message)
            warn("[Security] Kick engellendi: " .. tostring(message))
        end
    end)
end

-- 2. FİZİKSEL KORUMALAR (Anti-Fling & Anti-Void)
RunService.Heartbeat:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            
            -- Başka bir hileci seni fırlatırsa durdur
            if settings.AntiFling and root.AssemblyLinearVelocity.Magnitude > 150 then
                root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end
            
            -- Haritadan aşağı düşersen yukarı çek
            if settings.AntiVoid and root.Position.Y < -500 then
                root.CFrame = CFrame.new(root.Position.X, 50, root.Position.Z)
            end
        end
    end)
end)

function Security.Set(key, value)
    if settings[key] ~= nil then settings[key] = value end
end

return Security
