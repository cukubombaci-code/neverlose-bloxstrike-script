-- src/hitsound.lua (Mobil Uyumlu & Çoklu Ses Seçenekli Hitsound)
local HitSound = {}
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer

local settings = {
    Enabled = false,
    Volume = 0.8,
    -- Hazır Ses ID'leri:
    -- 1: Minecraft XP -> "rbxassetid://4655262996"
    -- 2: CS:GO Headshot -> "rbxassetid://9069176046"
    -- 3: Neverlose -> "rbxassetid://5633644030"
    -- 4: Osu! Hit -> "rbxassetid://461232127"
    SoundId = "rbxassetid://4655262996" 
}

local sound = nil
pcall(function()
    sound = Instance.new("Sound")
    sound.SoundId = settings.SoundId
    sound.Volume = settings.Volume
    sound.Parent = SoundService
end)

local lastPlayTime = 0
local cooldown = 0.05

function HitSound.Set(key, value)
    if settings[key] ~= nil then
        settings[key] = value
        pcall(function()
            if key == "SoundId" and sound then
                sound.SoundId = value
            elseif key == "Volume" and sound then
                sound.Volume = value
            end
        end)
    end
end

function HitSound.Toggle(state)
    settings.Enabled = state
end

local function hookPlayer(player)
    if player == LocalPlayer then return end
    
    local function onCharacter(char)
        pcall(function()
            local hum = char:WaitForChild("Humanoid", 5)
            if not hum then return end
            
            local lastHealth = hum.Health
            hum.HealthChanged:Connect(function(newHealth)
                if settings.Enabled and sound and newHealth < lastHealth then
                    if tick() - lastPlayTime > cooldown then
                        lastPlayTime = tick()
                        sound:Play()
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
