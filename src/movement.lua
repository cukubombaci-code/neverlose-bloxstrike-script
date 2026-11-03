-- src/movement.lua (Mobil Uyumlu & Full Hız Destekli)
local Movement = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local settings = {
    -- Bunnyhop
    BhopEnabled = false,
    BhopSpeed = 60,      -- Zıplarken ulaşılacak hız (Varsayılan 16'dır, 60 uçurur)
    
    -- Air Strafe
    AirStrafeEnabled = false,
    AirStrafeSpeed = 60  -- Havadaki hız
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
            local moveDir = hum.MoveDirection
            
            -- 1. BUNNYHOP (Otomatik Zıplama + Hız Kazandırma)
            if settings.BhopEnabled then
                if not isAirborne then
                    hum.Jump = true
                    -- Eğer hareket ediyorsak (W,A,S,D veya joystick), Bhop hızını uygula
                    if moveDir.Magnitude > 0 then
                        local currentVel = root.AssemblyLinearVelocity
                        root.AssemblyLinearVelocity = Vector3.new(
                            moveDir.X * settings.BhopSpeed, 
                            currentVel.Y, -- Zıplama gücünü koru
                            moveDir.Z * settings.BhopSpeed
                        )
                    end
                end
            end
            
            -- 2. AIR STRAFE (Havada Yönlendirme ve Hızlanma)
            if settings.AirStrafeEnabled and isAirborne then
                if moveDir.Magnitude > 0 then
                    local currentVel = root.AssemblyLinearVelocity
                    local targetVel = Vector3.new(
                        moveDir.X * settings.AirStrafeSpeed, 
                        currentVel.Y, 
                        moveDir.Z * settings.AirStrafeSpeed
                    )
                    -- 0.15 Lerp değeri havada daha akıcı dönüş sağlar
                    root.AssemblyLinearVelocity = currentVel:Lerp(targetVel, 0.15)
                end
            end
        end
    end)
end)

return Movement
