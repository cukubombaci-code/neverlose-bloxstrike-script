-- ==============================================================================
-- SIRALI VE TEMİZ LOADER (Önce Bypass, Sonra Modüller, En Son Menü)
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
    local targetURL = BASE_URL .. fileName .. ".lua"
    local success, response = pcall(function() return game:HttpGet(targetURL) end)
    
    if not success or not response or response == "" or response:find("404") then
        warn("[Loader] Indirilemedi: " .. fileName)
        return nil
    end
    
    local chunk, compileErr = loadstring(response)
    if not chunk then return nil end
    
    local runSuccess, runResult = pcall(chunk)
    if not runSuccess then
        warn("[Loader] Calisma Hatasi: " .. fileName)
        return nil
    end
    
    if runResult then NL[fileName] = runResult end
    return runResult
end

-- 1. ADIM: BYPASS (GÜVENLİK KORUMASI)
print("[Loader] 1. Adim: Bypass Yukleniyor...")
fetchAndCompile("security")
task.wait(0.5) -- Telefonun nefes alması için bekle
collectgarbage("collect")

-- 2. ADIM: MODÜLLER (ESP, AIMBOT VS)
print("[Loader] 2. Adim: Moduller Yukleniyor...")
local modules = {"aimbot", "ragebot", "anti-aim", "combat", "esp", "hitbox", "hitsound", "movement", "triggerbot", "world"}
for _, modName in ipairs(modules) do
    fetchAndCompile(modName)
    task.wait(0.15) -- Kasma yapmaması için araya süre koyuyoruz
    collectgarbage("collect")
end

-- 3. ADIM: MENÜ (ARAYÜZ)
print("[Loader] 3. Adim: Menu Yukleniyor...")
fetchAndCompile("menu")

print("[Loader] BASARILI! Sistem hazir.")
