-- src/security.lua (Temiz ve Güvenli Bypass - Fizik Kodları Silindi)
local Security = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local settings = {
    AntiKick = true,
    WalkSpeedSpoof = true,
    JumpPowerSpoof = true,
    HideUI = true
}

local originalWalkSpeed = 16
local originalJumpPower = 50

-- 1. ANTI-KICK (Seni atmaya çalışırlarsa engeller)
local oldKick
oldKick = hookfunction(LocalPlayer.Kick, function(self, message)
    if settings.AntiKick then
        warn("[Security] Kick engellendi!")
        return
    end
    return oldKick(self, message)
end)

-- 2. SADECE HIZ VE ZIPLAMA GİZLEME (Sunucu seni 16 hızında sansın)
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
        
        -- Arayüzü Gizleme
        if settings.HideUI then
            if self == game:GetService("CoreGui") and (key == "FindFirstChild" or key == "GetChildren") then
                return function(_, childName)
                    if childName == "NeverloseMenu" or childName == "NeverloseMobileBtn" then return nil end
                    return oldIndex(self, key)(self, childName)
                end
            end
        end
    end
    return oldIndex(self, key)
end)

-- Karakter yenilendiğinde orijinal hızı kaydet
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
