-- Zırhlı ve Akıllı Loader v3.0
-- Yapımcı: cukubombaci-code

--[[ 
    AYARLAR BÖLÜMÜ:
    Test yaparken SURUM = "main" kalsın (hep en son kodu çeker).
    Script'i yayınlayacağın zaman "main" yerine en son commit kodunu (SHA) yapıştır.
    Örnek: local SURUM = "76f4142" (Güvenli sürüm)
]]

local KULLANICI = "cukubombaci-code"
local REPO_ADI  = "neverlose-bloxstrike-script"
local SURUM     = "main" -- BURAYI DEĞİŞTİRECEKSİN (main veya SHA)
local MENU_YOLU = "src/menu.lua"

-- URL'yi otomatik oluştur (Raw GitHub formatı)
local BASE_URL = "https://raw.githubusercontent.com/" .. KULLANICI .. "/" .. REPO_ADI .. "/" .. SURUM .. "/"

local function fetch(path)
    local full_url = BASE_URL .. path
    -- Ağ isteğini güvene al
    local ok, res = pcall(game.HttpGet, game, full_url)
    
    if not ok then
        warn("[Loader] Ağ Hatası (Fetch Failed): " .. tostring(res))
        return nil
    end
    
    -- Boş veya anlamsız yanıt kontrolü
    if type(res) ~= "string" or #res < 10 then
        warn("[Loader] Geçersiz veya boş yanıt alındı: " .. path)
        return nil
    end
    
    -- 404 HTML sayfası dönerse kontrol et
    if res:find("<!DOCTYPE html>") or res:find("404: Not Found") then
        warn("[Loader] Dosya bulunamadı (404). Sürüm kodu veya dosya yolu yanlış.")
        return nil
    end
    
    return res
end

-- 1. Aşama: Kodu İndir
local src = fetch(MENU_YOLU)
if not src then return end

-- 2. Aşama: Kodu Derle (Syntax Kontrolü)
local fn, err = loadstring(src, "=menu")
if not fn then
    warn("[Loader] Derleme Hatası (Syntax Error): " .. tostring(err))
    return
end

-- 3. Aşama: Kodu Çalıştır (Runtime Hatalarını Yakala)
local ok, runErr = pcall(fn)
if not ok then
    warn("[Loader] Çalışma Zamanı Hatası (Runtime Error): " .. tostring(runErr))
    return
end

print("[Loader] Menü başarıyla yüklendi. (Sürüm: " .. SURUM .. ")")
