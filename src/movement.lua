-- src/movement.lua (Mobil Uyumlu & Güvenli Bunnyhop & Air Strafe)
local Movement = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local settings = {
    -- Bunnyhop
    BhopEnabled = false,
    BhopSpeed = 40,      -- Mobilde savrulmayı önlemek için dengeli hız
    
    -- Air Strafe
    AirStrafeEnabled = false,
    AirStrafeSpeed = 40
}

function Movement.Set(key, value)
    if settings[key] ~= nil then settings[key] = value end
end

RunService.RenderStepped:Connect(function()
    if not settings.BhopEnabled and not settings.AirStrafeEnabled then return end
    
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        
        if hum and root then
            local isAirborne = (hum.FloorMaterial == Enum.Material.Air)
            
            -- 1. BUNNYHOP (Dokunmatik ve Mobil Uyumlu Otomatik Zıplama)
            if settings.BhopEnabled then
                if hum.JumpPower > 0 or hum.JumpHeight > 0 then
                    if not isAirborne then
                        hum.Jump = true
                    end
                end
            end
            
            -- 2. AIR STRAFE (Havada Kontrol ve Hızlanma)
            if settings.AirStrafeEnabled and isAirborne then
                local moveDir = hum.MoveDirection
                if moveDir.Magnitude > 0 then
                    local currentVel = root.AssemblyLinearVelocity
                    local targetVel = Vector3.new(
                        moveDir.X * settings.AirStrafeSpeed, 
                        currentVel.Y, 
                        moveDir.Z * settings.AirStrafeSpeed
                    )
                    root.AssemblyLinearVelocity = currentVel:Lerp(targetVel, 0.1)
                end
            end
        end
    end)
end)

return Movement
