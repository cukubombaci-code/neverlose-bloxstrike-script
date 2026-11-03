-- Zırhlı Loader v2.0 (Statik Hash & Tam Hata Kontrolü)
local BASE_URL = "https://raw.githubusercontent.com/cukubombaci-code/neverlose-bloxstrike-script/main/"
local MENU_PATH = "src/menu.lua"

local function fetch(path)
    -- Ağ isteğini güvene al
    local ok, res = pcall(game.HttpGet, game, BASE_URL .. path)
    
    -- Ağ koptuysa veya executor HttpGet desteklemiyorsa
    if not ok then
        warn("[Loader] Ağ Hatası (Fetch Failed): " .. path .. " | " .. tostring(res))
        return nil
    end
    
    -- Boş veya anlamsız yanıt kontrolü (404 HTML sayfası dönerse)
    if type(res) ~= "string" or #res < 10 then
        warn("[Loader] Geçersiz veya boş yanıt alındı: " .. path)
        return nil
    end
    
    if res:find("<!DOCTYPE html>") or res:find("404: Not Found") then
        warn("[Loader] Dosya bulunamadı (404). Repo silinmiş veya yol yanlış.")
        return nil
    end
    
    return res
end

-- 1. Aşama: Kodu İndir
local src = fetch(MENU_PATH)
if not src then return end -- İndirme başarısızsa burada dur, scripti çökertme

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

print("[Loader] Menü başarıyla yüklendi.")
