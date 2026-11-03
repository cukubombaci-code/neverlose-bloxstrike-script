-- ==============================================================================
-- FINAL LOADER (Önce Menü, Sonra Tüm Modüller)
-- ==============================================================================
local CONFIG = {
    User = "cukubombaci-code",
    Repo = "neverlose-bloxstrike-script",
    Branch = "main",
    Path = "src/"
}

local CDN_URL = string.format("https://cdn.jsdelivr.net/gh/%s/%s@%s/%s", CONFIG.User, CONFIG.Repo, CONFIG.Branch, CONFIG.Path)
local RAW_URL = string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", CONFIG.User, CONFIG.Repo, CONFIG.Branch, CONFIG.Path)

getgenv().Neverlose = {}
local NL = getgenv().Neverlose

local function loadMod(fileName)
    local url = CDN_URL .. fileName .. ".lua"
    local success, response = pcall(function() return game:HttpGet(url) end)
    
    -- 1. Sunucu çökerse 2. sunucuyu dene
    if not success or not response or response == "" or response:find("404") then
        url = RAW_URL .. fileName .. ".lua"
        success, response = pcall(function() return game:HttpGet(url) end)
    end
    
    if not success or not response or response == "" or response:find("404") then
        warn("[Loader] Indirilemedi: " .. fileName)
        return
    end
    
    local chunk = loadstring(response)
    if chunk then
        local runSuccess, res = pcall(chunk)
        if runSuccess and res then NL[fileName] = res end
    end
    task.wait(0.1)
    collectgarbage("collect")
end

print("[Loader] Baslatiliyor...")

-- 1. ADIM: ÖNCE MENÜYÜ YÜKLE (Ekrana hemen gelsin diye)
print("[Loader] 1. Adim: Menu Yukleniyor...")
loadMod("menu")

-- 2. ADIM: SONRA BÜTÜN MODÜLLERİ SIRAYLA YÜKLE
print("[Loader] 2. Adim: Tum Moduller Yukleniyor...")
local allModules = {
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
    "world"
}

for _, modName in ipairs(allModules) do
    loadMod(modName)
end

print("[Loader] BASARILI! Butonlar birkac saniye icinde aktiflesecek.")
