-- src/security.lua (Ultra Pro Bypass & Spoofer - Evcilleştirilmiş Sürüm)
-- Sunucu ağ paketlerine (Remote) müdahale kaldırıldı, sadece yerel korumalar kaldı.

local Security = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local settings = {
    -- Koruma Ayarları
    AntiKick = true,
    AntiFling = true,
    AntiDestroy = true,
    HideUI = true,
    
    -- Fizik & Hız Spoofer
    WalkSpeedSpoof = true,
    JumpPowerSpoof = true,
    VelocitySpoof = true
}

local originalWalkSpeed = 16
local originalJumpPower = 50

-- =====================================================================
-- 1. ANTI-KICK
-- =====================================================================
local oldKick
oldKick = hookfunction(LocalPlayer.Kick, function(self, message)
    if settings.AntiKick then
        warn("[Security] Kick engellendi! Sunucu Sebebi: " .. tostring(message))
        return
    end
    return oldKick(self, message)
end)

-- =====================================================================
-- 2. ANTI-DESTROY
-- =====================================================================
local oldDestroy
oldDestroy = hookfunction(Instance.new("ScreenGui").Destroy, function(self)
    if settings.AntiDestroy then
        if self:FindFirstChild("NeverloseCS2") or self.Name == "NeverloseCS2" or self.Name == "NeverloseMenu" then
            return
        end
    end
    return oldDestroy(self)
end)

-- =====================================================================
-- 3. METAMETHOD HOOK (Hız ve Gizlilik Spoofer'ı)
-- =====================================================================
local oldIndex
oldIndex = hookmetamethod(game, "__index", function(self, key)
    if not checkcaller() then
        local char = LocalPlayer.Character
        if char and self == char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                if key == "WalkSpeed" and settings.WalkSpeedSpoof then
                    return originalWalkSpeed
                elseif key == "JumpPower" and settings.JumpPowerSpoof then
                    return originalJumpPower
                end
            end
        end
        
        if settings.HideUI then
            if self == game:GetService("CoreGui") and (key == "FindFirstChild" or key == "GetChildren" or key == "GetDescendants") then
                return function(_, childName)
                    if childName == "NeverloseCS2" or childName == "NeverloseMenu" then return nil end
                    return oldIndex(self, key)(self, childName)
                end
            end
        end
    end
    return oldIndex(self, key)
end)

-- =====================================================================
-- 4. VELOCITY & FLING SPOOFER
-- =====================================================================
RunService.Heartbeat:Connect(function()
    if not settings.VelocitySpoof then return end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local root = char.HumanoidRootPart
        
        if settings.AntiFling and root.AssemblyLinearVelocity.Magnitude > 120 then
            root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end
        
        if root.AssemblyLinearVelocity.Magnitude > 100 then
            root.AssemblyLinearVelocity = root.AssemblyLinearVelocity.Unit * 50
        end
    end
end)

-- =====================================================================
-- 5. (REMOTE THROTTLER VE SANITIZER KALDIRILDI - OYUNDAN ATMA SEBEBİYDİ)
-- =====================================================================

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        originalWalkSpeed = hum.WalkSpeed
        originalJumpPower = hum.JumpPower or 50
    end
end)

function Security.Set(key, value)
    if settings[key] ~= nil then settings[key] = value end
end

return Security
