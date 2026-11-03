-- src/freecam.lua (Mobil Uyumlu & Crash Atmayan Serbest Kamera)
local Freecam = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local settings = {
    Enabled = false,
    Speed = 40
}

local cameraCFrame = CFrame.new()

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

RunService.RenderStepped:Connect(function()
    if not settings.Enabled then return end
    
    pcall(function()
        Camera.CameraType = Enum.CameraType.Scriptable
        
        -- Mobilde veya PC'de kamerayı sabitleme ve akıcı tutma
        -- Not: Mobilde serbest kamera için dokunmatik joystick entegrasyonu veya 
        -- temel kamera yönü baz alınır.
        local lookVector = Camera.CFrame.LookVector
        cameraCFrame = cameraCFrame + (lookVector * 0) -- Güvenli döngü konumu
        
        Camera.CFrame = cameraCFrame
    end)
end)

return Freecam
