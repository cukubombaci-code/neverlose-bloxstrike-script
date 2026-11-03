-- src/security.lua (Ultra Pro Server-Side Bypass & Spoofer)
local Security = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local settings = {
    -- Koruma Ayarları
    AntiKick = true,
    AntiFling = true,
    AntiDestroy = true,         -- Anti-cheat scriptimizi silmesin
    HideUI = true,              -- Anti-cheat arayüzümüzü görmesin
    
    -- Fizik & Hız Spoofer
    WalkSpeedSpoof = true,
    JumpPowerSpoof = true,
    VelocitySpoof = true,
    GravitySpoof = false,
    
    -- Ağ (Network) Spoofer & Throttler
    RemoteThrottler = true,
    RemoteDelay = 80,           -- Sunucuya giden istekler arası minimum ms
    SanitizeRemotes = true      -- Şüpheli verileri temizle
}

-- Değişkenler
local lastRemoteTime = 0
local originalWalkSpeed = 16
local originalJumpPower = 50
local isCharacterAdded = false

-- =====================================================================
-- 1. ANTI-KICK (Sunucu seni atmaya çalışırsa engelle)
-- =====================================================================
local oldKick
oldKick = hookfunction(LocalPlayer.Kick, function(self, message)
    if settings.AntiKick then
        warn("[Ultra Bypass] Kick engellendi! Sunucu Sebebi: " .. tostring(message))
        return -- Atmayı iptal et
    end
    return oldKick(self, message)
end)

-- =====================================================================
-- 2. ANTI-DESTROY (Anti-cheat senin çizimlerini/UI'ını silmeye çalışırsa)
-- =====================================================================
local oldDestroy
oldDestroy = hookfunction(Instance.new("ScreenGui").Destroy, function(self)
    if settings.AntiDestroy then
        if self:FindFirstChild("NeverloseCS2") or self.Name == "NeverloseCS2" then
            return -- UI'ı silmesini engelle
        end
    end
    return oldDestroy(self)
end)

-- =====================================================================
-- 3. METAMETHOD HOOK (Hız, Zıplama ve Gizlilik Spoofer'ı)
-- =====================================================================
local oldIndex
oldIndex = hookmetamethod(game, "__index", function(self, key)
    -- Eğer sunucu/başkası bu değerleri okumaya çalışıyorsa (checkcaller = false)
    if not checkcaller() then
        local char = LocalPlayer.Character
        if char and self == char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                if key == "WalkSpeed" and settings.WalkSpeedSpoof then
                    return originalWalkSpeed -- Sunucuya her zaman 16 göster
                elseif key == "JumpPower" and settings.JumpPowerSpoof then
                    return originalJumpPower -- Sunucuya her zaman 50 göster
                end
            end
        end
        
        -- UI'ı Gizleme (Anti-cheat "Neverlose" yazısını ararsa bulamasın)
        if settings.HideUI then
            if self == game:GetService("CoreGui") and (key == "FindFirstChild" or key == "GetChildren" or key == "GetDescendants") then
                return function(_, childName)
                    if childName == "NeverloseCS2" then return nil end
                    return oldIndex(self, key)(self, childName)
                end
            end
        end
    end
    return oldIndex(self, key)
end)

-- =====================================================================
-- 4. VELOCITY & FLING SPOOFER (Fizik motorunu sabitle)
-- =====================================================================
RunService.Heartbeat:Connect(function()
    if not settings.VelocitySpoof then return end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local root = char.HumanoidRootPart
        
        -- Sunucu seni fırlatmaya çalışırsa (Velocity > 120 ise) anında sıfırla
        if settings.AntiFling and root.AssemblyLinearVelocity.Magnitude > 120 then
            root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end
        
        -- Sürekli sunucuya normal hızdaymışsın gibi fizik gönder
        if root.AssemblyLinearVelocity.Magnitude > 100 then
            root.AssemblyLinearVelocity = root.AssemblyLinearVelocity.Unit * 50
        end
    end
end)

-- =====================================================================
-- 5. REMOTE SANITIZER & THROTTLER (Ağ Paketlerini Filtreleme)
-- =====================================================================
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    
    -- Eğer bir RemoteEvent tetikleniyorsa ve bu sunucuya gidiyorsa
    if not checkcaller() and (method == "FireServer" or method == "InvokeServer") then
        local args = {...}
        local remoteName = string.lower(self.Name)
        
        -- 5.1. Rapid Fire / Triggerbot Throttler
        -- Eğer silah/hasar ile alakalı bir remote ise ve saniyede 100 kere tetikleniyorsa, sunucuya 80ms'de bir gönder
        if remoteName:find("fire") or remoteName:find("shoot") or remoteName:find("hit") or remoteName:find("damage") then
            if settings.RemoteThrottler then
                local currentTime = tick() * 1000
                if currentTime - lastRemoteTime < settings.RemoteDelay then
                    return -- İsteği iptal et (Sunucu bunu görmez)
                end
                lastRemoteTime = currentTime
            end
        end
        
        -- 5.2. Argument Sanitizer (Şüpheli verileri temizle)
        -- Eğer sunucuya "Kafaya sık" gibi bir argüman gidiyorsa, bunu "Göğse sık"a çevir (Ban yememek için)
        if settings.SanitizeRemotes and remoteName:find("damage") then
            for i, v in pairs(args) do
                if type(v) == "string" and (v == "Head" or v == "HeadHitbox") then
                    args[i] = "UpperTorso" -- Sunucuya göğüs vurmuş gibi gönder
                end
            end
        end
        
        -- Temizlenmiş argümanları gönder
        return oldNamecall(self, unpack(args))
    end
    
    return oldNamecall(self, ...)
end)

-- =====================================================================
-- 6. CHARACTER ADDED KONTROLÜ
-- =====================================================================
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        originalWalkSpeed = hum.WalkSpeed
        originalJumpPower = hum.JumpPower or hum.UseJumpPower and 50 or 50
    end
end)

function Security.Set(key, value)
    if settings[key] ~= nil then settings[key] = value end
end

return Security
