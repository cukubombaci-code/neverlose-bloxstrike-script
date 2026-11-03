-- src/menu.lua (Saf ve Kararlı Mobil Menü)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NeverlosePureMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 100
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 280)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 0, 255)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

-- Başlık
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Neverlose | Calisiyor"
Title.TextColor3 = Color3.fromRGB(255, 0, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -40, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.Parent = Header

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Sağ Alt Sürüklenebilir NL Butonu
local FAB = Instance.new("TextButton")
FAB.Size = UDim2.fromOffset(55, 55)
FAB.Position = UDim2.new(1, -75, 1, -120)
FAB.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
FAB.Text = "NL"
FAB.TextColor3 = Color3.fromRGB(255, 255, 255)
FAB.Font = Enum.Font.GothamBold
FAB.TextSize = 20
FAB.Parent = ScreenGui

local fabCorner = Instance.new("UICorner")
fabCorner.CornerRadius = UDim.new(1, 0)
fabCorner.Parent = FAB

local fabStroke = Instance.new("UIStroke")
fabStroke.Color = Color3.fromRGB(255, 0, 255)
fabStroke.Thickness = 2
fabStroke.Parent = FAB

FAB.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

return { Status = "Loaded" }
