-- ==============================================================================
-- ULTIMATE LOADER (Menüyü Başta Yükler, Modülleri Sırayla Çeker)
-- ==============================================================================
local CONFIG = { User = "cukubombaci-code", Repo = "neverlose-bloxstrike-script", Branch = "main", Path = "src/" }
local CDN_URL = string.format("https://cdn.jsdelivr.net/gh/%s/%s@%s/%s", CONFIG.User, CONFIG.Repo, CONFIG.Branch, CONFIG.Path)
local RAW_URL = string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", CONFIG.User, CONFIG.Repo, CONFIG.Branch, CONFIG.Path)

getgenv().Neverlose = {}
local NL = getgenv().Neverlose

local function loadMod(fileName)
    local url = CDN_URL .. fileName .. ".lua"
    local success, response = pcall(function() return game:HttpGet(url) end)
    
    if not success or not response or response == "" or response:find("404") then
        url = RAW_URL .. fileName .. ".lua"
        success, response = pcall(function() return game:HttpGet(url) end)
    end
    
    if not success or not response or response == "" or response:find("404") then
        warn("[Loader] " .. fileName .. " indirilemedi!")
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

-- 1. ADIM: MENÜYÜ İLK YÜKLE
loadMod("menu")

-- 2. ADIM: MODÜLLERİ SIRAYLA YÜKLE
local modules = { "aimbot", "ragebot", "anti-aim", "combat", "esp", "freecam", "hitbox", "hitsound", "movement", "triggerbot", "world" }
for _, modName in ipairs(modules) do
    loadMod(modName)
end

print("[Loader] Her sey hazir! Sag alttaki NL butonuna bas.")
