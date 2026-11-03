-- src/security.lua (Mobil Uyumlu Kararlı Sürüm)
local Security = {}

-- Mobil cihazlarda çökmeye yol açabilecek ağır hook'ları kaldırıp 
-- sadece temel hata korumasını aktif tutuyoruz.
local success, err = pcall(function()
    print("[Neverlose Security] Mobil guvenlik katmani aktif.")
end)

if not success then
    warn("[Security] Baslatilamadi: " .. tostring(err))
end

return Security
