-- src/freecam.lua (Gerçek Mobil Uyumlu Serbest Kamera)
local Freecam = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local settings = {
    Enabled = false,
    Speed = 50
}

local cameraCFrame = CFrame.new()
local isRotating = false
local lastMousePos = Vector2.new(0, 0)

function Freecam.Set(key, value)
    if settings[key] ~= nil then settings[key] = value end
end

function Freecam.Toggle(state)
    settings.Enabled = state
    pcall(function()
        if state then
            cameraCFrame = Camera.CFrame
            Camera.CameraType = Enum.CameraType.Scriptable
        else
            Camera.CameraType = Enum.CameraType.Custom
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                Camera.CameraSubject = LocalPlayer.Character.Humanoid
            end
        end
    end)
end

-- Mobilde ekranı kaydırınca kamerayı döndürme
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not settings.Enabled then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.Touch then
        isRotating = true
        lastMousePos = Vector2.new(input.Position.X, input.Position.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.Touch then
        isRotating = false
    end
end)

UserInputService.InputChanged:Connect(function(input, gameProcessed)
    if not settings.Enabled or not isRotating then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - lastMousePos
        lastMousePos = Vector2.new(input.Position.X, input.Position.Y)
        
        -- Kamerayı fare/parmak hareketine göre döndür
        cameraCFrame = cameraCFrame * CFrame.Angles(0, -delta.X * 0.005, 0) * CFrame.Angles(-delta.Y * 0.005, 0, 0)
    end
end)

RunService.RenderStepped:Connect(function(dt)
    if not settings.Enabled then return end
    
    pcall(function()
        Camera.CameraType = Enum.CameraType.Scriptable
        
        local moveVector = Vector3.new(0, 0, 0)
        local speed = settings.Speed
        
        -- Klavye varsa WASD ile hareket et
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + cameraCFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - cameraCFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - cameraCFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + cameraCFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVector = moveVector + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveVector = moveVector - Vector3.new(0, 1, 0) end

        -- Eğer hareket ediliyorsa kamerayı o yöne kaydır
        if moveVector.Magnitude > 0 then
            cameraCFrame = cameraCFrame + (moveVector.Unit * speed * dt)
        end
        
        Camera.CFrame = cameraCFrame
    end)
end)

return Freecam
