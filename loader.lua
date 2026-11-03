-- Test Loader (Bypass Devre Dışı)
-- Yapımcı: cukubombaci-code

local KULLANICI = "cukubombaci-code"
local REPO_ADI  = "neverlose-bloxstrike-script"
local SURUM     = "main" 
local MENU_YOLU = "src/menu.lua"

-- URL'yi otomatik oluştur
local BASE_URL = "https://raw.githubusercontent.com/" .. KULLANICI .. "/" .. REPO_ADI .. "/" .. SURUM .. "/"

local function AddCacheBuster(url)
    local separator = url:find("?") and "&" or "?"
    return url .. separator .. "t=" .. tostring(os.time()) .. math.random(1000, 9999)
end

local function fetch(path)
    local full_url = AddCacheBuster(BASE_URL .. path)
    local ok, res = pcall(function()
        return game:HttpGet(full_url)
    end)

    if not ok then
        warn("[Loader] Ağ Hatası: " .. tostring(res))
        return nil
    end

    if type(res) ~= "string" or #res < 10 then
        warn("[Loader] Geçersiz yanıt: " .. path)
        return nil
    end

    return res
end

-- ==========================================
-- (BYPASS KISMI DEVRE DIŞI BIRAKILDI)
-- ==========================================

-- 1. AŞAMA: MENÜYÜ İNDİR
local src = fetch(MENU_YOLU)
if not src then return end

-- 2. Aşama: Kodu Derle
local fn, err = loadstring(src, "=menu")
if not fn then
    warn("[Loader] Derleme Hatası: " .. tostring(err))
    return
end

-- 3. Aşama: Kodu Çalıştır
local ok, runErr = pcall(fn)
if not ok then
    warn("[Loader] Çalışma Zamanı Hatası: " .. tostring(runErr))
    return
end

print("[Loader] Menü başarıyla yüklendi (Bypass'sız Test).")
