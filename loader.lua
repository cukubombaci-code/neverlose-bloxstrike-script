-- ==============================================================================
-- Neverlose Ultimate Zırhlı & Akıllı Loader v4.0 (Mobile / Crash-Proof)
-- ==============================================================================

local CONFIG = {
    User = "cukubombaci-code",
    Repo = "neverlose-bloxstrike-script",
    Branch = "main",
    Path = "src/"
}

local BASE_URL = string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", CONFIG.User, CONFIG.Repo, CONFIG.Branch, CONFIG.Path)
getgenv().Neverlose = getgenv().Neverlose or {}
local NL = getgenv().Neverlose

print(string.format("[Loader] Baslatiliyor... | Hedef: %s/%s", CONFIG.User, CONFIG.Repo))

local function fetchAndCompile(fileName)
    local targetURL = BASE_URL .. fileName .. ".lua"
    
    -- 1. İndirme (Ağ Koruması)
    local success, response = pcall(function()
        return game:HttpGet(targetURL)
    end)
    
    if not success then
        warn("[Loader] Ağ Hatası (" .. fileName .. "): Bağlantı kurulamadı.")
        return nil
    end
    
    -- 2. İçerik Kontrolü (404 ve HTML sayfası koruması)
    if not response or response == "" or response:find("404: Not Found") or response:find("<!DOCTYPE html>") then
        warn("[Loader] Geçersiz İçerik (" .. fileName .. "): Dosya bulunamadı!")
        return nil
    end
    
    if #response < 10 then
        warn("[Loader] Kritik Hata (" .. fileName .. "): İndirilen veri çok kısa veya boş!")
        return nil
    end
    
    -- 3. Derleme (Syntax Koruması)
    local chunk, compileErr = loadstring(response)
    if not chunk then
        warn("[Loader] Derleme Hatası (" .. fileName .. "): " .. tostring(compileErr))
        return nil
    end
    
    -- 4. Çalıştırma (Runtime Koruması - Çökme Engelleme)
    local runSuccess, runResult = pcall(chunk)
    if not runSuccess then
        warn("[Loader] Çalışma Zamanı Hatası (" .. fileName .. "): " .. tostring(runResult))
        return nil
    end
    
    -- 5. Başarılıysa Global Havuza Kaydet
    if runResult then
        NL[fileName] = runResult
    end
    
    return runResult
end

-- ==============================================================================
-- 1. ADIM: BYPASS (GÜVENLİK KATMANI)
-- ==============================================================================
-- Güvenlik her zaman en önce yüklenmelidir ki diğer modüller koruma altında çalışsın.
print("\n[Loader] 1. Adim: Guvenlik Duvari (Bypass) Devrede...")
local sec = fetchAndCompile("security")
if sec then
    print("[Loader] Guvenlik Katmani Aktif. (Anti-Kick, Anti-Void, Throttler)")
else
    warn("[Loader] Uyari: Guvenlik katmani yuklenemedi, devam ediliyor...")
end

task.wait(0.5) -- Telefonun ağ isteklerini sindirmesi için kısa bir mola

-- ==============================================================================
-- 2. ADIM: OYUN MODÜLLERİ
-- ==============================================================================
print("\n[Loader] 2. Adim: Oyun Modulleri Yukleniyor...")
local modules = {
    "aimbot", "ragebot", "anti-aim", "combat", 
    "esp", "freecam", "hitbox", "hitsound", 
    "movement", "triggerbot", "world"
}

for _, modName in ipairs(modules) do
    fetchAndCompile(modName)
    task.wait(0.1) -- Her modül arasında bekle (Mobil kasmasını/çökmesini engeller)
end

task.wait(0.3)

-- ==============================================================================
-- 3. ADIM: MENÜ (ARAYÜZ)
-- ==============================================================================
print("\n[Loader] 3. Adim: Arayuz (Menu) Yukleniyor...")
local menu = fetchAndCompile("menu")
if menu then
    print("\n[Loader] BASARILI! Menu hazir. Sag alttaki 'NL' butonuna tiklayarak acabilirsin.")
else
    warn("\n[Loader] KRITIK HATA: Menu yuklenemedi!")
end
