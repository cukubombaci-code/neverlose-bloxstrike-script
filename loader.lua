-- ==============================================================================
-- SADECE MENU TESTI (Moduller ve Bypass Yok)
-- ==============================================================================
local CONFIG = {
    User = "cukubombaci-code",
    Repo = "neverlose-bloxstrike-script",
    Branch = "main",
    Path = "src/"
}

local BASE_URL = string.format("https://cdn.jsdelivr.net/gh/%s/%s@%s/%s", CONFIG.User, CONFIG.Repo, CONFIG.Branch, CONFIG.Path)

local function fetchAndCompile(fileName)
    local targetURL = BASE_URL .. fileName .. ".lua"
    local success, response = pcall(function() return game:HttpGet(targetURL) end)
    
    if not success or not response or response == "" or response:find("404") then
        return nil
    end
    
    local chunk, compileErr = loadstring(response)
    if not chunk then return nil end
    
    local runSuccess, runResult = pcall(chunk)
    if not runSuccess then
        return nil
    end
    return runResult
end

print("[TEST] Sadece Menu Yukleniyor...")
fetchAndCompile("menu")
print("[TEST] Menu Yukleme Komutu Gonderildi.")
