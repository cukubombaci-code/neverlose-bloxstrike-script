-- ==============================================================================
-- Neverlose Ultimate Loader v5.0 (jsDelivr CDN + Anti-Crash + RAM Cleaner)
-- ==============================================================================

local CONFIG = {
    User = "cukubombaci-code",
    Repo = "neverlose-bloxstrike-script",
    Branch = "main",
    Path = "src/"
}

-- DİKKAT: GitHub yerine jsDelivr CDN kullanıyoruz (Mobilde çok daha hızlı ve güvenli)
local BASE_URL = string.format("https://cdn.jsdelivr.net/gh/%s/%s@%s/%s", CONFIG.User, CONFIG.Repo, CONFIG.Branch, CONFIG.Path)
getgenv().Neverlose = getgenv().Neverlose or {}
local NL = getgenv().Neverlose

print("[Loader] Baslatiliyor (jsDelivr Modu)...")

local function fetchAndCompile(fileName)
    -- Önbelleği önlemek için sonuna rastgele sayı ekle (jsDelivr için)
    local targetURL = BASE_URL .. fileName .. ".lua?v=" .. tostring(math.random(1, 99999))
    
    local success, response = pcall(function()
        return game:HttpGet(targetURL)
    end)
    
    if not success or not response or response == "" or response:find("404: Not Found") or response:find("<!DOCTYPE html>") then
        -- jsDelivr çökerse GitHub'a geri dön (Yedek plan)
        targetURL = string.format("https://raw.githubusercontent.com/%s/%s/%s/%s%s.lua", CONFIG.User, CONFIG.Repo, CONFIG.Branch, CONFIG.Path, fileName)
        local backupSuccess, backupRes = pcall(function() return game:HttpGet(targetURL) end)
        if not backupSuccess or not backupRes or backupRes:find("404") then
            warn("[Loader] Hata (" .. fileName .. "): Dosya yuklenemedi.")
            return nil
        end
        response = backupRes
    end
    
    local chunk, compileErr = loadstring(response)
    if not chunk then
        warn("[Loader] Derleme Hatasi (" .. fileName .. "): " .. tostring(compileErr))
        return nil
    end
    
    local runSuccess, runResult = pcall(chunk)
    if not runSuccess then
        warn("[Loader] Calisma Hatasi (" .. fileName .. "): " .. tostring(runResult))
        return nil
    end
    
    if runResult then NL[fileName] = runResult end
    return runResult
end

-- ==============================================================================
-- YÜKLEME SIRALAMASI (RAM DOSTU)
-- ==============================================================================

print("[Loader] 1. Adim: Bypass Yukleniyor...")
fetchAndCompile("security")
task.wait(0.3)
collectgarbage("collect") -- RAM Temizle

print("[Loader] 2. Adim: Moduller Yukleniyor...")
local modules = {
    "aimbot", "ragebot", "anti-aim", "combat", 
    "esp", "freecam", "hitbox", "hitsound", 
    "movement", "triggerbot", "world"
}

for _, modName in ipairs(modules) do
    fetchAndCompile(modName)
    task.wait(0.1) -- Telefonun nefes alması için bekle
    collectgarbage("collect") -- Her modülden sonra RAM'i temizle (Çökme Engelleme)
end

task.wait(0.3)
print("[Loader] 3. Adim: Menu Yukleniyor...")
fetchAndCompile("menu")

print("[Loader] TAMAMLANDI! Sistem hazir. Sag alttaki NL butonuna bas.")
