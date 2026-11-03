-- ==============================================================================
-- SAF BYPASS (Anti-Kick + Paket Maskeleme)
-- Sadece arka planda çalışır, hiçbir arayüz çizmez.
-- ==============================================================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

print("[Bypass] Koruma kalkanı aktif ediliyor...")

-- 1. ANTI-KICK (Sunucunun seni oyundan atmasını engeller)
pcall(function()
    local oldKick = LocalPlayer.Kick
    LocalPlayer.Kick = function(self, message)
        warn("[Bypass] Sunucu atma girisimi engellendi! Sebep: " .. tostring(message))
        -- Oyun seni atmaya çalışsa bile bu fonksiyon boş döner ve oyunda kalırsın.
    end
end)

-- 2. PAKET MASKELEME (Remote Throttler)
-- Rapid Fire veya hızlı tıklama yaptığında sunucuya spam paket gitmesini engeller,
-- böylece sunucu anti-cheat'i seni hileci olarak algılamaz.
local lastRemoteTime = 0
local remoteDelay = 0.05 -- Saniyede en fazla 20 istek (İnsan hızı)

pcall(function()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        
        -- Eğer sunucuya giden bir paket varsa ve bu senin scriptinden gelmiyorsa
        if not checkcaller() and (method == "FireServer" or method == "InvokeServer") then
            local remoteName = string.lower(self.Name)
            
            -- Silah, ateş etme, hasar verme ile ilgili paketleri tespit et
            if remoteName:find("fire") or remoteName:find("shoot") or remoteName:find("hit") or remoteName:find("damage") then
                local currentTime = tick()
                
                -- Eğer son paketten bu yana 50ms (0.05s) geçmediyse paketi YUT (gönderme)
                if currentTime - lastRemoteTime < remoteDelay then
                    return 
                end
                
                lastRemoteTime = currentTime
            end
        end
        
        return oldNamecall(self, ...)
    end)
    
    setreadonly(mt, true)
end)

print("[Bypass] Anti-Kick ve Paket Maskeleme basariyla aktif edildi. Hilelerinizi guvenle kullanabilirsiniz.")
