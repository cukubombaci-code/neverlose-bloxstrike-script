-- src/hitsound.lua
local HitSound = {}
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer

local settings = {
    Enabled = false,
    Volume = 0.5,
    -- Efsanevi oyun sesleri
    SoundId = "rbxassetid://4655262996" -- Varsayılan: Minecraft XP
}

local sound = Instance.new("Sound")
sound.SoundId = settings.SoundId
sound.Volume = settings.Volume
sound.Parent = SoundService

local lastPlayTime = 0
local cooldown = 0.05

function HitSound.Set(key, value)
    if settings[key] ~= nil then
        settings[key] = value
        if key == "SoundId" then
            sound.SoundId = value
        elseif key == "Volume" then
            sound.Volume = value
        end
    end
end

function HitSound.Toggle(state)
    settings.Enabled = state
end

local function hookPlayer(player)
    if player == LocalPlayer then return end
    
    local function onCharacter(char)
        local hum = char:WaitForChild("Humanoid")
        local lastHealth = hum.Health
        
        hum.HealthChanged:Connect(function(newHealth)
            if settings.Enabled and newHealth < lastHealth then
                if tick() - lastPlayTime > cooldown then
                    lastPlayTime = tick()
                    sound:Play()
                end
            end
            lastHealth = newHealth
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
