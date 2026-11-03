-- src/anti-aim.lua (Mobil Uyumlu & Crash Atmayan Sürüm)
local AntiAim = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local settings = {
    Enabled = false,
    Mode = "Backward",   -- "Backward", "Mevlana" (Mobilde Jitter yerine sade modlar daha kararlıdır)
    Speed = 10
}

function AntiAim.Set(key, value)
    if settings[key] ~= nil then settings[key] = value end
end

function AntiAim.Toggle(state)
    settings.Enabled = state
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        pcall(function()
            char.Humanoid.AutoRotate = not state
        end)
    end
end

RunService.RenderStepped:Connect(function()
    if not settings.Enabled then return end
    
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
        local root = char.HumanoidRootPart
        
        pcall(function()
            char.Humanoid.AutoRotate = false
            local camLook = Camera.CFrame.LookVector
            
            if settings.Mode == "Backward" then
                -- Kameraya sırtını dön (Güvenli CFrame)
                local targetPos = root.Position - Vector3.new(camLook.X, 0, camLook.Z).Unit
                root.CFrame = CFrame.new(root.Position, targetPos)
                
            elseif settings.Mode == "Mevlana" then
                -- Mobilde kasmayacak optimize edilmiş dönüş
                local spinAngle = (tick() * settings.Speed * 5) % 360
                root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.rad(spinAngle), 0)
            end
        end)
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    if not settings.Enabled then
        pcall(function()
            local hum = char:WaitForChild("Humanoid", 5)
            if hum then hum.AutoRotate = true end
        end)
    end
end)

return AntiAim
