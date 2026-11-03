-- Neverlose Bloxstrike Korumalı Loader
local HttpService = game:GetService("HttpService")

-- 1. Aşama: Temel Ortam Kontrolü
local function verifyEnvironment()
    if not game.HttpGet then
        warn("[Loader] Desteklenmeyen executor!")
        return false
    end
    return true
end

if not verifyEnvironment() then return end

print("[Loader] Güvenlik duvarı ve Bypass başlatılıyor...")

-- Önbellek kırıcı (GitHub'ın eski kodu göstermesini engeller)
local function GetUrl(path)
    return "https://raw.githubusercontent.com/cukubombaci-code/neverlose-bloxstrike-script/main/src/" .. path .. "?t=" .. tostring(os.time())
end

-- 2. Aşama: Bypass Kontrolü (src/security.lua)
local securitySuccess, securityErr = pcall(function()
    local code = game:HttpGet(GetUrl("security.lua"))
    
    if not code or #code < 10 then
        error("Security dosyası boş veya çekilemedi!")
    end
    
    loadstring(code)()
end)

if not securitySuccess then
    warn("[Loader] Kritik Hata: Bypass yüklenemedi! " .. tostring(securityErr))
    return -- Hata alırsa akışı tamamen keser
end

print("[Loader] Bypass başarıyla uygulandı. Menü yükleniyor...")

-- 3. Aşama: Menüyü Yükleme (src/menu.lua)
local menuSuccess, menuErr = pcall(function()
    local code = game:HttpGet(GetUrl("menu.lua"))
    
    if not code or #code < 10 then
        error("Menu dosyası boş veya çekilemedi!")
    end
    
    loadstring(code)()
end)

if menuSuccess then
    print("[Loader] Sistem başarıyla başlatıldı. İyi oyunlar!")
else
    warn("[Loader] Menü yüklenirken hata oluştu: " .. tostring(menuErr))
end
