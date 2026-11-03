-- ==============================================================================
-- Neverlose Ultimate Zırhlı & Global Modül Kayıtlı Loader v3.2
-- ==============================================================================

local CONFIG = {
    User = "cukubombaci-code",       -- GitHub Kullanıcı Adın
    Repo = "neverlose-bloxstrike-script", -- Depo Adın
    Branch = "main",              -- Branch
    Path = "src/"                 -- Klasör
}

local BASE_URL = string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", CONFIG.User, CONFIG.Repo, CONFIG.Branch, CONFIG.Path)

-- Global Modül Havuzu (Çakışmaları önlemek için)
getgenv().Neverlose = getgenv().Neverlose or {}
local NL = getgenv().Neverlose

print(string.format("[Loader] Baslatiliyor... | Depo: %s/%s", CONFIG.User, CONFIG.Repo))

local function fetchAndCompile(fileName, moduleKey)
    local targetURL = BASE_URL .. fileName .. ".lua"
    print("[Loader] İndiriliyor -> " .. fileName .. ".lua")
    
    local success, response = pcall(function()
        return game:HttpGet(targetURL)
    end)
    
    if not success then
        warn("[Loader] Ağ Hatası (" .. fileName .. "): Bağlantı kurulamadı.")
        return nil
    end
    
    if not response or response == "" or response:find("404: Not Found") or response:find("<!DOCTYPE html>") then
        warn("[Loader] Geçersiz İçerik (" .. fileName .. "): Dosya bulunamadı!")
        return nil
    end
    
    if #response < 10 then
        warn("[Loader] Kritik Hata (" .. fileName .. "): İndirilen veri çok kısa veya boş!")
        return nil
    end
    
    local chunk, compileErr = loadstring(response)
    if not chunk then
        warn("[Loader] Derleme Hatası (" .. fileName .. "): " .. tostring(compileErr))
        return nil
    end
    
    local runSuccess, runResult = pcall(chunk)
    if not runSuccess then
        warn("[Loader] Çalışma Zamanı Hatası (" .. fileName .. "): " .. tostring(runResult))
        return nil
    end
    
    -- Başarılı olursa Global Havuza kaydet
    if runResult then
        NL[moduleKey or fileName] = runResult
    end
    
    return runResult
end

-- ==============================================================================
-- ÇALIŞTIRMA SIRALAMASI
-- ==============================================================================

-- 1. ADIM: Bypass ve Güvenlik
print("\n[Neverlose] 1. Adım: Güvenlik Katmanı Yükleniyor...")
local Security = fetchAndCompile("security", "Security")

if Security then
    print("[Neverlose] Güvenlik katmanı aktif.")
else
    warn("[Neverlose] Uyarı: Güvenlik katmanı yüklenemedi.")
end

task.wait(0.4)

-- 2. ADIM: Oyun Modülleri
print("\n[Neverlose] 2. Adım: Oyun Modülleri Yükleniyor...")
local modules = {
    "aimbot", "ragebot", "anti-aim", "combat", 
    "esp", "freecam", "hitbox", "hitsound", 
    "movement", "triggerbot", "world"
}

for _, modName in ipairs(modules) do
    fetchAndCompile(modName, modName)
    task.wait(0.05) 
end

task.wait(0.3)

-- 3. ADIM: Kullanıcı Arayüzü (Menü)
print("\n[Neverlose] 3. Adım: Kullanıcı Arayüzü (Menü) Yükleniyor...")
local Menu = fetchAndCompile("menu", "Menu")

if Menu then
    print("\n[Neverlose] TAMAMLANDI! Sistem kararlı, zırhlı ve tam performans çalışıyor. İyi oyunlar!")
else
    warn("\n[Neverlose] Kritik Uyarı: Menü yüklenemedi!")
end
