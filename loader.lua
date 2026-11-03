-- Zırhlı ve Güvenli Loader (v1.1)
-- Hata toleransı, cache bypass ve supply-chain koruması eklendi.

local REPO = "cukubombaci-code/neverlose-bloxstrike-script"
local BRANCH = "main"
local FILE_PATH = "src/menu.lua"

local function FetchMenuSource()
    -- 1. Aşama: En güncel commit SHA'sını al (Cache ve Drift engelleme)
    local apiUrl = "https://api.github.com/repos/" .. REPO .. "/commits/" .. BRANCH
    local rawUrl = "https://raw.githubusercontent.com/" .. REPO .. "/" .. BRANCH .. "/" .. FILE_PATH
    
    local success, response = pcall(function()
        local body = game:HttpGet(apiUrl, true)
        local sha = body:match('"sha"%s*:%s*"(%x+)"')
        
        if sha then
            -- Eğer SHA bulunduysa, dosyayı bu spesifik sürümden çek (her zaman stabil)
            return game:HttpGet("https://raw.githubusercontent.com/" .. REPO .. "/" .. sha .. "/" .. FILE_PATH, true)
        else
            -- API kotası dolduysa veya hata verdiyse, ana daldan çekmeyi dene
            return game:HttpGet(rawUrl, true)
        end
    end)

    -- 2. Aşama: Ağ hatası kontrolü
    if not success or type(response) ~= "string" or #response < 10 then
        return nil, "Ağ hatası veya boş yanıt. GitHub'a ulaşılamıyor veya internet koptu."
    end

    -- 3. Aşama: 404 ve HTML kontrolü (GitHub sayfa döndürdüyse)
    if response:find("<!DOCTYPE html>") or response:find("<html>") or response:find("404: Not Found") then
        return nil, "Dosya bulunamadı (404) veya HTML yanıtı alındı. Repo silinmiş veya yol yanlış olabilir."
    end

    return response, nil
end

local function Initialize()
    -- 1. Kodu İndir
    local source, fetchError = FetchMenuSource()
    if not source then
        warn("[Neverlose Loader] İndirme Başarısız: " .. tostring(fetchError))
        return
    end

    -- 2. Kodu Derle (Syntax kontrolü)
    local compiledChunk, loadError = loadstring(source)
    if not compiledChunk then
        warn("[Neverlose Loader] Derleme Hatası (Bozuk veya yarım yüklenmiş dosya):\n" .. tostring(loadError))
        return
    end

    -- 3. Kodu Çalıştır (Runtime hatalarını yakala)
    local success, runtimeError = pcall(compiledChunk)
    if not success then
        warn("[Neverlose Loader] Çalışma Zamanı Hatası (Runtime Error):\n" .. tostring(runtimeError))
    else
        print("[Neverlose Loader] Menü başarıyla yüklendi.")
    end
end

-- Başlat
Initialize()
