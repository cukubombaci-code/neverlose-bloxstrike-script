-- ==============================================================================
-- ULTIMATE SIRALI LOADER (Tüm Modüller + RAM Koruması)
-- ==============================================================================
local CONFIG = {
    User = "cukubombaci-code",
    Repo = "neverlose-bloxstrike-script",
    Branch = "main",
    Path = "src/"
}

-- Hızlı indirme için jsDelivr CDN kullanıyoruz
local BASE_URL = string.format("https://cdn.jsdelivr.net/gh/%s/%s@%s/%s", CONFIG.User, CONFIG.Repo, CONFIG.Branch, CONFIG.Path)
getgenv().Neverlose = {}
local NL = getgenv().Neverlose

local function fetchAndCompile(fileName)
    local targetURL = BASE_URL .. fileName .. ".lua"
    
    -- Ağ isteğini güvene al
    local success, response = pcall(game.HttpGet, game, targetURL)

    if not success or not response or response == "" or response:find("404") or response:find("<!DOCTYPE html>") then
        warn("[Loader] Hata (" .. fileName .. "): İndirilemedi.")
        return nil
    end

    -- Derleme koruması
    local chunk, compileErr = loadstring(response)
    if not chunk then
        warn("[Loader] Derleme Hatası (" .. fileName .. "): " .. tostring(compileErr))
        return nil
    end

    -- Çalıştırma koruması
    local runSuccess, runResult = pcall(chunk)
    if not runSuccess then
        warn("[Loader] Çalışma Hatası (" .. fileName .. "): " .. tostring(runResult))
        return nil
    end

    -- Başarılı olursa Global Havuza kaydet
    if runResult then
        NL[fileName] = runResult
    end
    
    return runResult
end

-- ==============================================================================
-- MODÜL YÜKLEME SIRASI (Sırayla, Nefes Alarak)
-- ==============================================================================
-- Önce Bypass ve Modüller, En Son Menü (Çünkü Menü diğerlerini okur)
local modules = {
    "security", 
    "aimbot", 
    "ragebot", 
    "anti-aim", 
    "combat", 
    "esp", 
    "freecam", 
    "hitbox", 
    "hitsound", 
    "movement", 
    "triggerbot", 
    "world", 
    "menu" -- Menü her zaman EN SON
}

print("[Loader] Baslatiliyor...")

for _, modName in ipairs(modules) do
    fetchAndCompile(modName)
    
    -- Telefonun işlemcisini boğmamak için kısa bir bekleme süresi
    task.wait(0.15) 
    
    -- Her modülden sonra RAM'i temizle (Çökmeleri önler)
    collectgarbage("collect")
end

print("[Loader] TÜM MODÜLLER YÜKLENDİ! Sağ alttaki NL butonuna basarak menüyü açabilirsin.")
