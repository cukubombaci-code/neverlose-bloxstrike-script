-- src/menu.lua (Lib Bağımlılığı Kaldırıldı - Test Sürümü)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Mobil Buton (FAB) Kodun Aynen Korundu
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local mobileGui = Instance.new("ScreenGui")
mobileGui.Name = "NeverloseMobileBtn"
mobileGui.ResetOnSpawn = false
mobileGui.DisplayOrder = 999
pcall(function() mobileGui.Parent = game:GetService("CoreGui") end)
if not mobileGui.Parent then mobileGui.Parent = PlayerGui end

local FAB = Instance.new("TextButton")
FAB.Size = UDim2.fromOffset(60, 60)
FAB.Position = UDim2.new(1, -80, 1, -100)
FAB.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
FAB.Text = "NL"
FAB.TextColor3 = Color3.fromRGB(255, 255, 255)
FAB.Font = Enum.Font.GothamBold
FAB.TextSize = 22
FAB.BorderSizePixel = 0
FAB.Parent = mobileGui

local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(1, 0); corner.Parent = FAB
local stroke = Instance.new("UIStroke"); stroke.Color = Color3.fromRGB(255, 0, 255); stroke.Thickness = 2; stroke.Parent = FAB

-- Sürükleme Mantığı
local dragging, dragInput, dragStart, startPos
FAB.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = FAB.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
FAB.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        FAB.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Basit Test Menüsü (Eski hile kodları yerine sadece test arayüzü)
local function ToggleTestMenu()
    local existing = PlayerGui:FindFirstChild("TestMenuGui")
    if existing then existing:Destroy() return end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TestMenuGui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 250, 0, 300)
    Frame.Position = UDim2.new(0.5, -125, 0.5, -150)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner"); UICorner.CornerRadius = UDim.new(0, 10); UICorner.Parent = Frame
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = "MENU BASARIYLA YUKLENDI"
    Title.TextColor3 = Color3.fromRGB(255, 0, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.Parent = Frame
    
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 200, 0, 40)
    CloseBtn.Position = UDim2.new(0.5, -100, 1, -60)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    CloseBtn.Text = "KAPAT"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = Frame
    local BtnCorner = Instance.new("UICorner"); BtnCorner.CornerRadius = UDim.new(0, 5); BtnCorner.Parent = CloseBtn
    
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
end

-- FAB Butonuna tıklanınca Test Menüsünü aç
FAB.MouseButton1Click:Connect(function()
    ToggleTestMenu()
    FAB.Size = UDim2.fromOffset(50, 50)
    task.wait(0.1)
    FAB.Size = UDim2.fromOffset(60, 60)
end)

print("[Loader] Menu.lua (Lib'siz) basariyla yuklendi.")
