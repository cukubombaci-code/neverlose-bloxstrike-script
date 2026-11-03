-- src/hitsound.lua (Mobil Uyumlu & Ses Üst Üste Binme Koruması)
local HitSound = {}
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer

local settings = {
    Enabled = false,
    Volume = 0.8,
    SoundId = "rbxassetid://4655262996" -- Varsayılan: Minecraft XP
}

-- Ana ses objesini bir kere oluşturuyoruz
local baseSound = nil
pcall(function()
    baseSound = Instance.new("Sound")
    baseSound.SoundId = settings.SoundId
    baseSound.Volume = settings.Volume
    baseSound.Parent = SoundService
end)

local lastPlayTime = 0
local cooldown = 0.05 -- Art arda gelen vuruşlarda kulağı sağır etmemek için

function HitSound.Set(key, value)
    if settings[key] ~= nil then
        settings[key] = value
        pcall(function()
            if key == "SoundId" and baseSound then
                baseSound.SoundId = value
            elseif key == "Volume" and baseSound then
                baseSound.Volume = value
            end
        end)
    end
end

function HitSound.Toggle(state)
    settings.Enabled = state
end

-- Test butonu için fonksiyon
function HitSound.TestSound()
    pcall(function()
        if baseSound then
            local testSnd = baseSound:Clone()
            testSnd.Parent = SoundService
            testSnd:Play()
            task.delay(2, function() if testSnd then testSnd:Destroy() end end)
        end
    end)
end

local function hookPlayer(player)
    if player == LocalPlayer then return end
    
    -- Zaten dinleniyorsa tekrar bağlanmayı engelle
    if player:GetAttribute("NL_HitsoundHooked") then return end
    player:SetAttribute("NL_HitsoundHooked", true)
    
    local function onCharacter(char)
        pcall(function()
            local hum = char:WaitForChild("Humanoid", 5)
            if not hum then return end
            
            local lastHealth = hum.Health
            hum.HealthChanged:Connect(function(newHealth)
                if settings.Enabled and baseSound and newHealth < lastHealth then
                    if tick() - lastPlayTime > cooldown then
                        lastPlayTime = tick()
                        
                        -- SESİ KLONLA (Böylece üst üste binebilir ve diğer sesi kesmez)
                        local hitSnd = baseSound:Clone()
                        hitSnd.Parent = SoundService
                        hitSnd:Play()
                        
                        -- Çaldıktan 2 saniye sonra temizle (bellek sızıntısını önle)
                        task.delay(2, function() 
                            if hitSnd then hitSnd:Destroy() end 
                        end)
                    end
                end
                lastHealth = newHealth
            end)
        end)
    end
    
    player.CharacterAdded:Connect(onCharacter)
    if player.Character then
        onCharacter(player.Character)
    end
end

for _, p in ipairs(Players:GetPlayers()) do
    hookPlayer(p)
end

Players.PlayerAdded:Connect(hookPlayer)

return HitSound
