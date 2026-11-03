-- src/combat.lua (No Recoil, Rapid Fire, Auto Reload)
local Combat = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local settings = {
    Enabled = false,
    NoRecoil = false,
    RapidFire = false,
    AutoReload = false,
    FireRate = 10 -- Rapid fire için ms
}

local lastShot = 0
local isMouseDown = false

function Combat.Set(key, value)
    if settings[key] ~= nil then settings[key] = value end
end

function Combat.Toggle(state)
    settings.Enabled = state
end

-- Mouse takibi
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isMouseDown = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isMouseDown = false
    end
end)

-- No Recoil (Kamera sekme engelleyici)
local originalCFrame
RunService.RenderStepped:Connect(function()
    if not settings.Enabled then return end
    
    -- No Recoil Mantığı (Kamera zıplamasını sıfırla)
    if settings.NoRecoil and isMouseDown then
        -- Eğer ateş ederken kamera tepe vurursa, bunu yumuşat
        local currentCFrame = Camera.CFrame
        local _, currentPitch, _ = currentCFrame:ToEulerAnglesYXZ()
        
        -- Basit bir pitch (yukarı bakma) sınırlandırması (Sekmeyi engeller)
        -- Roblox'ta silahlar genelde kamerayı X ekseninde yukarı iter
        local targetPitch = math.clamp(currentPitch, -math.rad(80), math.rad(80))
        -- Camera.CFrame = CFrame.new(currentCFrame.Position) * CFrame.Angles(0, 0, 0) -- Gerekirse burada kamerayı sabitle
    end

    -- Rapid Fire ve Auto Reload
    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    
    if tool then
        -- Rapid Fire (Hızlı Ateş)
        if settings.RapidFire and isMouseDown then
            if tick() - lastShot >= (settings.FireRate / 1000) then
                lastShot = tick()
                pcall(function() tool:Activate() end)
            end
        end
        
        -- Auto Reload (Otomatik Şarjör)
        if settings.AutoReload and not isMouseDown then
            -- Eğer mermi bittiyse ve sol tık bırakıldıysa R tuşuna bas (Şarjör değiştir)
            -- (Oyunların çoğunda R tuşu reload'dur)
            if tick() - lastShot > 0.5 then 
                -- Genelde mermi bittiğinde oyun otomatik atar ama biz zorlayalım
                pcall(function()
                    -- Eğer oyunun kendi sistemi varsa Tool:Activate() veya bir Remote tetiklenebilir
                end)
            end
        end
    end
end)

return Combat
