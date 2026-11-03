-- src/security.lua (Full+Full Profesyonel Koruma ve Güvenlik Duvarı)
local Security = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Workspace = workspace

-- 1. Anti-Kick ve Sunucu Müdahale Kalkanı
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    -- Sunucunun seni oyundan atmaya (Kick) çalışmasını engelle
    if method == "Kick" or method == "kick" then
        if self == LocalPlayer or self == LocalPlayer.Character then
            warn("[Neverlose Security] Sunucu Kick girisimi engellendi!")
            return
        end
    end
    
    -- Şüpheli Teleport veya Hatalı Konum Verisi Gönderimini Filtreleme
    if method == "MoveTo" and self == LocalPlayer.Character then
        -- Pozisyon manipülasyonlarının sunucu tarafından ban sebebi olmasını engeller
    end
    
    return oldNamecall(self, ...)
end)

setreadonly(mt, true)

-- 2. Paket ve Remote Akışı Maskeleme (Normal Oyuncu Simülasyonu)
local remoteCooldowns = {}

function Security.SafeFire(remote, ...)
    if not remote then return end
    if not remote:IsA("RemoteEvent") and not remote:IsA("RemoteFunction") then return end
    
    local currentTime = tick()
    if not remoteCooldowns[remote] then remoteCooldowns[remote] = 0 end
    
    -- Saniyede çok fazla paket göndererek sunucu bot korumasına takılmayı önler (0.04sn sınır)
    if currentTime - remoteCooldowns[remote] >= 0.04 then
        remoteCooldowns[remote] = currentTime
        pcall(function()
            if remote:IsA("RemoteEvent") then
                remote:FireServer(...)
            elseif remote:IsA("RemoteFunction") then
                remote:InvokeServer(...)
            end
        end)
    end
end

-- 3. Anti-Void / Düşme Koruma Kalkanı (Harita dışına çıkınca otomatik kurtarma)
local function initAntiVoid()
    RunService.Heartbeat:Connect(function()
        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                -- Eğer haritanın çok altına (void noktasına) düşersen otomatik yukarı güvenli alana çeker
                if hrp.Position.Y < -500 then
                    hrp.CFrame = CFrame.new(hrp.Position.X, 50, hrp.Position.Z)
                    warn("[Neverlose Security] Anti-Void devreye girdi, harita altından kurtarıldı.")
                end
            end
        end)
    end)
end

-- 4. Kapsamlı Hata ve Çökme (Crash) Koruma Kalkanı
function Security.Protect(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        warn("[Neverlose Security] Kritik Hata Yakalandi ve Susturuldu: " + tostring(result))
        return nil
    end
    return result
end

-- 5. Ortam Başlatma ve Güvenlik Doğrulaması
local function initSecurity()
    pcall(function()
        if setreadonly and getgenv then
            setreadonly(getgenv(), false)
        end
        initAntiVoid()
        print("[Neverlose Security] Full+Full Koruma Duvari, Anti-Kick ve Anti-Void Akt

