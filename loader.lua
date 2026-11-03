-- ==============================================================================
-- Neverlose Ultimate Zırhlı & Akıllı Loader v3.1 (Mobile Edition)
-- ==============================================================================

-- 1. MERKEZİ DEĞİŞKENLER (Konfigürasyon ve Sürüm Pinleme)
local CONFIG = {
    User = "KULLANICI_ADIN",       -- GitHub Kullanıcı Adın
    Repo = "REPO_ADIN",           -- Depo (Repository) Adın
    Branch = "main",              -- Branch veya Güvenlik için Commit SHA'sı
    Path = "src/"                 -- Dosyaların Durduğu Klasör
}

local BASE_URL = string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", CONFIG.User, CONFIG.Repo, CONFIG.Branch, CONFIG.Path)

-- Bilgilendirici Başlangıç Çıktısı
print(string.format("[Loader] Baslatiliyor... | Hedef Depo: %s/%s (%s)", CONFIG.User, CONFIG.Repo, CONFIG.Branch))

-- 2, 3, 4. GÜVENLİ İNDİRME, AĞ TAMPONU VE İÇERİK KONTROLÜ
local function fetchAndCompile(fileName)
    local targetURL = BASE_URL .. fileName .. ".lua"
    print("[Loader] İndiriliyor -> " .. fileName .. ".lua")
    
    -- Ağ Hatalarına Karşı Koruma (pcall)
    local success, response = pcall(function()
        return game:HttpGet(targetURL)
    end)
    
    if not success then
        warn("[Loader] Ağ Hatası (" .. fileName .. "): Bağlantı kurulamadı veya DNS çözülemedi.")
        return nil
    end
    
    -- 404 ve HTML Sayfası Kontrolü (GitHub yanlış link / silinen dosya koruması)
    if not response or response == "" or response:find("404: Not Found") or response:find("<!DOCTYPE html>") then
        warn("[Loader] Geçersiz İçerik (" .. fileName .. "): Dosya bulunamadı veya HTML sayfası döndü!")
        return nil
    end
    
    -- Boş Yanıt Kontrolü (10 karakterden az veya yarım push edilmiş dosyalar)
    if #response < 10 then
        warn("[Loader] Kritik Hata (" .. fileName .. "): İndirilen veri çok kısa veya boş!")
        return nil
    end
    
    -- 5. DERLEME KONTROLÜ (Syntax Error Yakalama)
    local chunk, compileErr = loadstring(response)
    if not chunk then
        warn("[Loader] Derleme Hatası (" .. fileName .. "): " .. tostring(compileErr))
        return nil
    end
    
    print("[Loader] Derleme Başarılı -> " .. fileName)
    
    -- 6. ÇALIŞMA ZAMANI KORUMASI (Runtime Tamponu / pcall ile çalıştırma)
    local runSuccess, runResult = pcall(chunk)
    if not runSuccess then
        warn("[Loader] Çalışma Zamanı Hatası (" .. fileName .. "): " .. tostring(runResult))
        return nil
    end
    
    return runResult
end

-- ==============================================================================
-- ÇALIŞTIRMA SIRALAMASI (Önce Bypass, Sonra Modüller ve En Son Menü)
-- ==============================================================================

-- 1. ADIM: Önce Bypass ve Güvenlik Katmanı (Zırhlandırma)
print("\n[Neverlose] 1. Adım: Güvenlik Duvarı ve Bypass Devreye Alınıyor...")
local Security = fetchAndCompile("security")

if Security then
    print("[Neverlose] Güvenlik katmanı başarıyla oturtuldu.")
else
    warn("[Neverlose] Uyarı: Güvenlik katmanı yüklenemedi ancak devam ediliyor.")
end

-- Kısa bir güvenlik gecikmesi
task.wait(0.4)

-- 2. ADIM: Diğer Tüm Oyun Modülleri Arka Planda Yüklenir
print("\n[Neverlose] 2. Adım: Oyun Modülleri Yükleniyor...")
local modules = {
    "aimbot", "ragebot", "anti-aim", "combat", 
    "esp", "freecam", "hitbox", "hitsound", 
    "movement", "triggerbot", "world"
}

for _, modName in ipairs(modules) do
    fetchAndCompile(modName)
end

task.wait(0.3)

-- 3. ADIM: En Son Kullanıcı Arayüzü (Menü) Yüklenir ve Ekrana Gelir
print("\n[Neverlose] 3. Adım: Kullanıcı Arayüzü (Menü) Yükleniyor...")
local Menu = fetchAndCompile("menu")

if Menu then
    print("\n[Neverlose] TAMAMLANDI! Sistem kararlı, zırhlı ve tam performans çalışıyor. İyi oyunlar!")
else
    warn("\n[Neverlose] Kritik Uyarı: Menü yüklenemedi!")
end
