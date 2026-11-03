-- ==============================================================================
-- Neverlose Temiz ve Stabil Loader (Mobile Ready)
-- ==============================================================================

local BASE_URL = "https://raw.githubusercontent.com/cukubombaci-code/neverlose-bloxstrike-script/main/src/"
getgenv().Neverlose = {} 
local NL = getgenv().Neverlose

-- İndirme ve Çalıştırma Fonksiyonu
local function LoadModule(name)
    local ok, code = pcall(function() return game:HttpGet(BASE_URL .. name .. ".lua") end)
    if not ok or not code or code == "" or code:find("404: Not Found") then
        warn("[Loader] " .. name .. " indirilemedi!")
        return nil
    end
    
    local func, err = loadstring(code)
    if func then
        local success, result = pcall(func)
        if success and result then
            NL[name] = result
            print("[Loader] " .. name .. " basariyla yuklendi.")
        else
            warn("[Loader] " .. name .. " calisirken hata verdi: " .. tostring(result))
        end
    else
        warn("[Loader] " .. name .. " kod hatasi: " .. tostring(err))
    end
end

-- Modülleri Sırayla Yükle
print("[Loader] Baslatiliyor...")
LoadModule("security")
LoadModule("aimbot")
LoadModule("ragebot")
LoadModule("anti-aim")
LoadModule("combat")
LoadModule("esp")
LoadModule("freecam")
LoadModule("hitbox")
LoadModule("hitsound")
LoadModule("movement")
LoadModule("triggerbot")
LoadModule("world")

-- En Son Menüyü Yükle (Çünkü menü diğerlerini kullanıyor)
LoadModule("menu")

print("[Loader] Islem Tamamlandi!")
