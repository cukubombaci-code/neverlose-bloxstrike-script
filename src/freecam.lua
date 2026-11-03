-- src/freecam.lua (Serbest Kamera)
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

local isFreecam = false
local cameraCFrame = CFrame.new()

function Freecam.Set(key, value)
    if settings[key] ~= nil then settings[key] = value end
end

function Freecam.Toggle(state)
    settings.Enabled = state
    if state then
        cameraCFrame = Camera.CFrame
        isFreecam = true
    else
        isFreecam = false
        -- Kamerayı karaktere geri bağla
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            Camera.CameraSubject = LocalPlayer.Character.Humanoid
        end
    end
end

RunService.RenderStepped:Connect(function()
    if not isFreecam then return end
    
    -- Kamerayı oyuncudan ayır
    Camera.CameraSubject = nil
    Camera.CameraType = Enum.CameraType.Scriptable

    local moveVector = Vector3.new(0, 0, 0)
    local speed = settings.Speed
    
    -- Hareket Mantığı (WASD ve Space/Ctrl)
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + Camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - Camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - Camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + Camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVector = moveVector + Vector3.new(0, 1, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveVector = moveVector - Vector3.new(0, 1, 0) end

    if moveVector.Magnitude > 0 then
        cameraCFrame = cameraCFrame + (moveVector.Unit * speed * (1/60))
    end
    
    -- Farenin baktığı yöne doğru döndür
    local mousePos = UserInputService:GetMouseDelta()
    cameraCFrame = cameraCFrame * CFrame.Angles(0, -mousePos.X * 0.005, 0) * CFrame.Angles(-mousePos.Y * 0.005, 0, 0)

    Camera.CFrame = cameraCFrame
end)

return Freecam
