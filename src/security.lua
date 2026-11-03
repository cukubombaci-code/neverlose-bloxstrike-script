-- src/security.lua (Full+Full Mobile Optimized Bypass)
local Security = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local settings = {
    AntiKick = true,
    AntiFling = true,
    AntiVoid = true,
    WalkSpeedSpoof = true,
    JumpPowerSpoof = true,
    RemoteThrottler = true,
    RemoteDelay = 0.04, -- Sunucuya saniyede en fazla 25 istek gider
    SanitizeRemotes = true,
    AntiDestroy = true,
    HideUI = true
}

local lastRemoteTime = 0
local originalWalkSpeed = 16
local originalJumpPower = 50

-- 1. ANTI-KICK (Sunucu seni atmaya çalışırsa engelle)
local oldKick
oldKick = hookfunction(LocalPlayer.Kick, function(self, message)
    if settings.AntiKick and not checkcaller() then
        warn("[Security] Kick girisimi engellendi! Sunucu Sebebi: " .. tostring(message))
        return
    end
    return oldKick(self, message)
end)

-- 2. ANTI-DESTROY (Sunucu menünü silmeye çalışırsa engelle)
local oldDestroy
oldDestroy = hookfunction(Instance.new("ScreenGui").Destroy, function(self)
    if settings.AntiDestroy and not checkcaller() then
        if self.Name == "NeverloseMobileMenu" or self:FindFirstChild("NeverloseMobileMenu") then
            return
        end
    end
    return oldDestroy(self)
end)

-- 3. METAMETHOD HOOKS (Hız, Arayüz ve Ağ Paketleri Zırhı)
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__index = newcclosure(function(self, key)
    if not checkcaller() then
        local char = LocalPlayer.Character
        if char and self == char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                if key == "WalkSpeed" and settings.WalkSpeedSpoof then return originalWalkSpeed
                elseif key == "JumpPower" and settings.JumpPowerSpoof then return originalJumpPower end
            end
        end
        
        -- Hide UI from CoreGui (Sunucu Menüyü görmesin)
        if settings.HideUI and self == game:GetService("CoreGui") then
            if key == "FindFirstChild" or key == "GetChildren" or key == "GetDescendants" then
                return function(_, childName)
                    if childName == "NeverloseMobileMenu" then return nil end
                    return oldIndex(self, key)(self, childName)
                end
            end
        end
    end
    return oldIndex(self, key)
end)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    
    if not checkcaller() and (method == "FireServer" or method == "InvokeServer") then
        local args = {...}
        local remoteName = string.lower(self.Name)
        
        -- Remote Throttler (Rapid Fire / Triggerbot ban koruması)
        if remoteName:find("fire") or remoteName:find("shoot") or remoteName:find("hit") or remoteName:find("damage") then
            if settings.RemoteThrottler then
                local currentTime = tick()
                if currentTime - lastRemoteTime < settings.RemoteDelay then
                    return -- İsteği yut, sunucu görmesin
                end
                lastRemoteTime = currentTime
            end
        end
        
        -- Sanitize Remotes (Kafadan vurduğunu sunucuya gizle, göğüsten vurmuşsun gibi göster)
        if settings.SanitizeRemotes and remoteName:find("damage") then
            for i, v in pairs(args) do
                if type(v) == "string" and (v == "Head" or v == "HeadHitbox") then
                    args[i] = "UpperTorso"
                end
            end
        end
        
        return oldNamecall(self, unpack(args))
    end
    
    return oldNamecall(self, ...)
end)

setreadonly(mt, true)

-- 4. VELOCITY (Anti-Fling) ve VOID (Harita Altı) Koruması
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local root = char.HumanoidRootPart
        
        -- Başka bir hileci seni fırlatırsa anında durdur
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

-- Karakter yenilendiğinde orijinal hızı hafızaya al
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        originalWalkSpeed = hum.WalkSpeed
        originalJumpPower = hum.JumpPower or 50
    end
end)

-- Menüden ayar değiştirmek için
function Security.Set(key, value)
    if settings[key] ~= nil then settings[key] = value end
end

return Security
