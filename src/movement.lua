-- src/movement.lua (Bağımsız Bhop & Air Strafe)
local Movement = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local settings = {
    -- Bunnyhop
    BhopEnabled = false,
    BhopSpeed = 50,      
    BhopKey = Enum.KeyCode.Space,
    IsJumping = false,
    
    -- Air Strafe
    AirStrafeEnabled = false,
    AirStrafeSpeed = 50
}

function Movement.Set(key, value)
    if settings[key] ~= nil then settings[key] = value end
end

-- Tuş dinleyicileri (Space tuşu)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == settings.BhopKey then
        settings.IsJumping = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.KeyCode == settings.BhopKey then
        settings.IsJumping = false
    end
end)

RunService.RenderStepped:Connect(function()
    -- Eğer ikisi de kapalıysa hiçbir şey yapma (Optimizasyon)
    if not settings.BhopEnabled and not settings.AirStrafeEnabled then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    
    if hum and root then
        local isAirborne = (hum.FloorMaterial == Enum.Material.Air)
        
        -- 1. BUNNYHOP (Bağımsız)
        if settings.BhopEnabled and settings.IsJumping and not isAirborne then
            hum.Jump = true
            local velocity = root.AssemblyLinearVelocity
            local moveDir = hum.MoveDirection
            if moveDir.Magnitude > 0 then
                root.AssemblyLinearVelocity = Vector3.new(
                    moveDir.X * settings.BhopSpeed, 
                    velocity.Y,
                    moveDir.Z * settings.BhopSpeed
                )
            end
        end
        
        -- 2. AIR STRAFE (Bağımsız)
        if settings.AirStrafeEnabled and isAirborne then
            local moveDir = hum.MoveDirection
            if moveDir.Magnitude > 0 then
                local currentVel = root.AssemblyLinearVelocity
                local targetVel = Vector3.new(
                    moveDir.X * settings.AirStrafeSpeed, 
                    currentVel.Y, 
                    moveDir.Z * settings.AirStrafeSpeed
                )
                root.AssemblyLinearVelocity = currentVel:Lerp(targetVel, 0.15)
            end
        end
    end
end)

return Movement
