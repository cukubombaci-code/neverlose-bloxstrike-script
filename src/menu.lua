-- src/menu.lua (İzole ve Saf Test Menüsü)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Ana Ekran Çerçevesi
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NeverloseIsolatedMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 100
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 300)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -150)
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

-- Başlık Çubuğu
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Neverlose | Saf Mod"
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

-- İçerik Alanı
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -60)
Content.Position = UDim2.new(0, 10, 0, 50)
Content.BackgroundTransparency = 1
Content.CanvasSize = UDim2.new(0, 0, 0, 150)
Content.ScrollBarThickness = 3
Content.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = Content

-- Test Toggle Düğmesi Oluşturucu
local function CreateButton(text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 36)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 13
    Btn.Parent = Content
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = Btn
    
    local active = false
    Btn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            Btn.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Text = "[AÇIK] " .. text
        else
            Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
            Btn.TextColor3 = Color3.fromRGB(220, 220, 220)
            Btn.Text = text
        end
        if callback then pcall(callback, active) end
    end)
end

-- Örnek Test Butonları
CreateButton("Test Özellik 1", function(state)
    print("Özellik 1 durumu:", state)
end)

CreateButton("Test Özellik 2", function(state)
    print("Özellik 2 durumu:", state)
end)

-- Menüyü Kapatma İşlevi
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Mobil Sağ Alt Köşe Sürüklenebilir Aç/Kapat Butonu (NL)
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

-- Dokunmatik Sürükleme Mantığı
local dragging, dragStart, startPos
FAB.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = FAB.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        FAB.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Butona Basınca Menüyü Aç/Kapat
FAB.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

return { Status = "IsolatedMenuLoaded" }
