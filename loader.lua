-- loader.lua (Sadece Security ve ESP Çağıran Kararlı Sürüm)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Önbellek kırıcı (Cache-buster) ile en güncel sürümü çeker
local function LoadScript(fileName)
    local url = "https://raw.githubusercontent.com/cukubombaci-code/neverlose-bloxstrike-script/main/src/" .. fileName .. ".lua?t=" .. tostring(os.time())
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    
    if success then
        print("[Neverlose] Başarıyla yüklendi: " .. fileName)
        return result
    else
        warn("[Neverlose] Yükleme hatası (" .. fileName + "): " + tostring(result))
        return nil
    end
end

-- 1. Önce Güvenlik ve Bypass Modülünü Çalıştır
print("[Neverlose] Güvenlik duvarı devreye sokuluyor...")
LoadScript("security")

-- 2. Ardından ESP Modülünü Çalıştır
task.wait(0.5)
print("[Neverlose] ESP modülü yükleniyor...")
local ESP = LoadScript("esp")

-- Otomatik Master Enabled yap (İsteğe bağlı, direkt başlasın diye)
if ESP and ESP.Toggle then
    ESP.Toggle(true)
    print("[Neverlose] ESP aktif edildi!")
end

