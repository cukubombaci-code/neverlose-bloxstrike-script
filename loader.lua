-- ==============================================================================
-- SIRA TESTİ: MENU -> BYPASS -> MODULLER
-- ==============================================================================
local CONFIG = {
    User = "cukubombaci-code",
    Repo = "neverlose-bloxstrike-script",
    Branch = "main",
    Path = "src/"
}

local BASE_URL = string.format("https://cdn.jsdelivr.net/gh/%s/%s@%s/%s", CONFIG.User, CONFIG.Repo, CONFIG.Branch, CONFIG.Path)
getgenv().Neverlose = {}
local NL = getgenv().Neverlose

local function fetchAndCompile(fileName)
    warn("[TEST] Yukleniyor: " .. fileName) 
    local targetURL = BASE_URL .. fileName .. ".lua"
    local success, response = pcall(function() return game:HttpGet(targetURL) end)
    
    if not success or not response or response == "" or response:find("404") then
        warn("[TEST] HATA: " .. fileName .. " indirilemedi!")
        return nil
    end
    
    local chunk, compileErr = loadstring(response)
    if not chunk then
        warn("[TEST] HATA (Derleme): " .. fileName .. " | " .. tostring(compileErr))
        return nil
    end
    
    local runSuccess, runResult = pcall(chunk)
    if not runSuccess then
        warn("[TEST] HATA (Calisma): " .. fileName .. " | " .. tostring(runResult))
        return nil
    end
    
    if runResult then NL[fileName] = runResult end
    warn("[TEST] BASARILI: " .. fileName)
    return runResult
end

-- ==========================================
-- 1. ADIM: MENÜYÜ YÜKLE
-- ==========================================
warn("[TEST] 1. ADIM: MENU YUKLENIYOR...")
fetchAndCompile("menu")
warn("[TEST] MENU YUKLENDI. EKRANDA NL BUTONU VAR MI?")
task.wait(3) -- Menünün oturması için bekle

-- ==========================================
-- 2. ADIM: BYPASS'I YÜKLE
-- ==========================================
warn("[TEST] 2. ADIM: BYPASS (SECURITY) YUKLENIYOR...")
fetchAndCompile("security")
warn("[TEST] BYPASS YUKLENDI. OYUN COKTU MU?")
task.wait(3)

-- ==========================================
-- 3. ADIM: DİĞER MODÜLLERİ YÜKLE
-- ==========================================
warn("[TEST] 3. ADIM: DIGER MODULLER YUKLENIYOR...")
local modules = {
    "aimbot", "ragebot", "anti-aim", "combat", 
    "esp", "hitbox", "hitsound", "movement", "triggerbot", "world"
}

for _, modName in ipairs(modules) do
    fetchAndCompile(modName)
    task.wait(0.2)
    collectgarbage("collect")
end

warn("[TEST] TUM TESTLER BITTI. OYUN HALA AYAKTA!")
