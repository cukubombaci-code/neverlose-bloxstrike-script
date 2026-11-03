-- src/security.lua (Stabil Sürüm - Crash Korumalı)
local Security = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local settings = {
    AntiKick = true,
    WalkSpeedSpoof = true,
    JumpPowerSpoof = true,
}

local originalWalkSpeed = 16
local originalJumpPower = 50

-- 1. GÜVENLİ NAME('&CALL) HOOK İLE KICK ENGELLEME
-- Doğrudan hookfunction yerine namecall kullanarak oyunu çökertmeden kick'leri yakalarız.
if getgenv().FireConnection or hookmetamethod then
    local oldNameCall
    oldNameCall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" and self == LocalPlayer and settings.AntiKick then
            warn("[Security] Kick denemesi engellendi!")
            return nil -- Oyundan atılmayı sessizce iptal eder
        end
        return oldNameCall(self, ...)
    end)
end

-- 2. GÜVENLİ METAMETHOD __INDEX (Hız ve Zıplama Maskeleme)
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
    end
    return oldIndex(self, key)
end)

-- Karakter yenilendiğinde orijinal hızları güvenli şekilde güncelle
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1.5)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        originalWalkSpeed = hum.WalkSpeed
        originalJumpPower = hum.JumpPower or 50
    end
end)

function Security.Set(key, value)
    if settings[key] ~= nil then 
        settings[key] = value 
    end
end

print("[Security] Güvenlik modülü başarıyla yüklendi.")
return Security
