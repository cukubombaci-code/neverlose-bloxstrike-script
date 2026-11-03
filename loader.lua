-- ==============================================================================
-- BYPASS'SIZ VE HAFİF LOADER (Sıfır Çökme)
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
        return nil
    end
    
    local chunk = loadstring(response)
    if not chunk then return nil end
    
    local runSuccess, runResult = pcall(chunk)
    if not runSuccess then return nil end
    
    if runResult then NL[fileName] = runResult end
    return runResult
end

-- "security" (Bypass) listeden ÇIKARILDI!
-- Sadece çalışan ve çökme yapmayan modüller yükleniyor.
local modules = {
    "aimbot", 
    "esp", 
    "movement", 
    "menu" 
}

print("[Loader] Baslatiliyor (Bypass'siz Mod)...")

for _, modName in ipairs(modules) do
    fetchAndCompile(modName)
    task.wait(0.1) 
    collectgarbage("collect") -- RAM temizliği
end

print("[Loader] BASARILI! Menu Yuklendi. Sag alttaki NL butonuna bas.")
