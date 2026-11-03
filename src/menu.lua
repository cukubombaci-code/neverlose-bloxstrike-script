-- src/menu.lua (Ultra Hafif Test Menüsü - Crash Sebebi Aranıyor)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Sadece PlayerGui kullanıyoruz, CoreGui'ye dokunmuyoruz!
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NL_HafifMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Btn = Instance.new("TextButton")
Btn.Size = UDim2.new(0, 100, 0, 50)
Btn.Position = UDim2.new(0, 20, 0, 100)
Btn.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
Btn.Text = "NL TEST"
Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn.Parent = ScreenGui

Btn.MouseButton1Click:Connect(function()
    Btn.Text = "CALISIYOR!"
end)

print("[Test Menu] Basariyla yuklendi.")
return { Status = "Test Menu Loaded" }
