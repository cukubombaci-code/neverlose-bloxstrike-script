-- src/anti-aim.lua (Backward, Mevlana, Jitter)
local AntiAim = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local settings = {
    Enabled = false,
    Mode = "Mevlana",   -- "Backward", "Mevlana", "Jitter"
    Speed = 15
}

function AntiAim.Set(key, value)
    if settings[key] ~= nil then settings[key] = value end
end

function AntiAim.Toggle(state)
    settings.Enabled = state
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        if state then
            char.Humanoid.AutoRotate = false
        else
            char.Humanoid.AutoRotate = true -- Kapatınca normale dön
        end
    end
end

RunService.RenderStepped:Connect(function()
    if not settings.Enabled then return end
    
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
        local root = char.HumanoidRootPart
        char.Humanoid.AutoRotate = false
        
        local camLook = Camera.CFrame.LookVector
        
        if settings.Mode == "Backward" then
            -- Kameraya sırtını dön (180 derece ters)
            local targetCFrame = CFrame.lookAt(root.Position, root.Position - camLook)
            root.CFrame = targetCFrame
            
        elseif settings.Mode == "Mevlana" then
            -- Fırıldak gibi sürekli dön
            local spinAngle = (tick() * settings.Speed * 10) % 360
            root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.rad(spinAngle), 0)
            
        elseif settings.Mode == "Jitter" then
            -- Sağa sola hızlıca titret (180 derece farkla)
            local jitterAngle = math.rad(180 * math.sin(tick() * settings.Speed))
            root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, jitterAngle, 0)
        end
    end
end)

-- Karakter öldüğünde veya değiştiğinde AutoRotate'i eski haline getir
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    if not settings.Enabled then
        local hum = char:WaitForChild("Humanoid", 5)
        if hum then hum.AutoRotate = true end
    end
end)

return AntiAim
