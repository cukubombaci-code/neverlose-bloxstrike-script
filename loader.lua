-- loader.lua (Sadece Security ve Menu Çağıran Test Sürümü)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Önbellek kırıcı ile en güncel sürümü çeken fonksiyon
local function LoadScript(fileName)
    local url = "https://raw.githubusercontent.com/cukubombaci-code/neverlose-bloxstrike-script/main/src/" .. fileName .. ".lua?t=" .. tostring(os.time())
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    
    if success then
        print("[Neverlose] Başarıyla yüklendi: " .. fileName)
        return result
    else
        warn("[Neverlose] Yükleme hatası (" .. fileName .. "): " .. tostring(result))
        return nil
    end
end

-- 1. Önce Güvenlik ve Bypass Modülünü Çalıştır
print("[Neverlose] Güvenlik duvarı devreye sokuluyor...")
LoadScript("security")

-- 2. Ardından Menü Modülünü Çalıştır (ESP harici diğer modüller menü içinde yüklenir)
task.wait(0.5)
print("[Neverlose] Menü yükleniyor...")
LoadScript("menu")
