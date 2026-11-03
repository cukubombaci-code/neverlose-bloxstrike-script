-- src/menu.lua (Tam Sürüm - Senin Hile Dosyalarını Çeker)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Hile Modüllerini Yükle
local function LoadModule(name)
    local url = "https://raw.githubusercontent.com/cukubombaci-code/neverlose-bloxstrike-script/main/src/" .. name .. ".lua"
    local success, result = pcall(function() return loadstring(game:HttpGet(url))() end)
    if success then return result else return {} end
end

local ESP = LoadModule("esp")
local Aimbot = LoadModule("aimbot")
local Rage = LoadModule("ragebot")
local Movement = LoadModule("movement")
local Trigger = LoadModule("triggerbot")

-- ANA MENÜ TASARIMI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NeverloseMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 100
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner"); UICorner.CornerRadius = UDim.new(0, 12); UICorner.Parent = MainFrame
local UIStroke = Instance.new("UIStroke"); UIStroke.Color = Color3.fromRGB(255, 0, 255); UIStroke.Thickness = 1.5; UIStroke.Parent = MainFrame

-- Başlık (Sürüklenebilir)
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
Header.BackgroundTransparency = 0.5
Header.Parent = MainFrame
local HeaderCorner = Instance.new("UICorner"); HeaderCorner.CornerRadius = UDim.new(0, 12); HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0); Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1; Title.Text = "Neverlose | BloxStrike"
Title.TextColor3 = Color3.fromRGB(255, 0, 255); Title.Font = Enum.Font.GothamBold
Title.TextSize = 16; Title.TextXAlignment = Enum.TextXAlignment.Left; Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40); CloseBtn.Position = UDim2.new(1, -40, 0, 0)
CloseBtn.BackgroundTransparency = 1; CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50); CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18; CloseBtn.Parent = Header

-- Sekmeler
local TabList = Instance.new("Frame")
TabList.Size = UDim2.new(1, 0, 0, 35); TabList.Position = UDim2.new(0, 0, 0, 40)
TabList.BackgroundTransparency = 1; TabList.Parent = MainFrame

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -20, 1, -85); ContentArea.Position = UDim2.new(0, 10, 0, 80)
ContentArea.BackgroundTransparency = 1; ContentArea.Parent = MainFrame

-- Buton Oluşturucu
local function CreateToggle(parent, text, default, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 35); Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Btn.Text = "  " .. text; Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Font = Enum.Font.Gotham; Btn.TextSize = 14; Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Parent = parent
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = Btn
    
    local enabled = default
    local function UpdateColor()
        if enabled then
            Btn.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Text = "  [AÇIK] " .. text
        else
            Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            Btn.Text = "  [KAPALI] " .. text
        end
    end
    UpdateColor()
    
    Btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        UpdateColor()
        if callback then pcall(callback, enabled) end
    end)
end

local function CreateTab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(0, 80, 1, 0); TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    TabBtn.Text = name; TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabBtn.Font = Enum.Font.GothamBold; TabBtn.TextSize = 12; TabBtn.Parent = TabList
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = TabBtn
    
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false; Page.Parent = ContentArea
    local layout = Instance.new("UIListLayout"); layout.Padding = UDim.new(0, 5); layout.Parent = Page
    return TabBtn, Page
end

-- Hile Menülerini Doldur
local RageBtn, RagePage = CreateTab("RAGE")
CreateToggle(RagePage, "Enable Ragebot", false, function(s) if Rage.Toggle then Rage.Toggle(s) end end)
CreateToggle(RagePage, "Auto Fire", true, function(s) if Rage.Set then Rage.Set("AutoFire", s) end end)

local AimBtn, AimPage = CreateTab("AIMBOT")
CreateToggle(AimPage, "Enable Legitbot", false, function(s) if Aimbot.Toggle then Aimbot.Toggle(s) end end)
CreateToggle(AimPage, "Enable Triggerbot", false, function(s) if Trigger.Toggle then Trigger.Toggle(s) end end)

local VisBtn, VisPage = CreateTab("VISUALS")
CreateToggle(VisPage, "Enable ESP", false, function(s) if ESP.Toggle then ESP.Toggle(s) end end)
CreateToggle(VisPage, "Show Box", true, function(s) if ESP.Set then ESP.Set("BoxEnabled", s) end end)
CreateToggle(VisPage, "Enable Chams", false, function(s) if ESP.Set then ESP.Set("ChamsEnabled", s) end end)

local MovBtn, MovPage = CreateTab("MOVEMENT")
CreateToggle(MovPage, "Enable Bunnyhop", false, function(s) if Movement.Set then Movement.Set("BhopEnabled", s) end end)
CreateToggle(MovPage, "Enable Air Strafe", false, function(s) if Movement.Set then Movement.Set("AirStrafeEnabled", s) end end)

-- Sekme Geçişleri
local tabs = { {Btn=RageBtn, Page=RagePage}, {Btn=AimBtn, Page=AimPage}, {Btn=VisBtn, Page=VisPage}, {Btn=MovBtn, Page=MovPage} }
local function SelectTab(index)
    for i, tab in ipairs(tabs) do
        tab.Page.Visible = (i == index)
        tab.Btn.BackgroundColor3 = (i == index) and Color3.fromRGB(255, 0, 255) or Color3.fromRGB(30, 30, 40)
    end
end
RageBtn.MouseButton1Click:Connect(function() SelectTab(1) end)
AimBtn.MouseButton1Click:Connect(function() SelectTab(2) end)
VisBtn.MouseButton1Click:Connect(function() SelectTab(3) end)
MovBtn.MouseButton1Click:Connect(function() SelectTab(4) end)
SelectTab(1)

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

-- Sürükleme
local dragging, dragInput, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- MOBİL BUTON (FAB)
local mobileGui = Instance.new("ScreenGui")
mobileGui.Name = "NeverloseMobileBtn"
mobileGui.ResetOnSpawn = false
mobileGui.DisplayOrder = 999
pcall(function() mobileGui.Parent = game:GetService("CoreGui") end)
if not mobileGui.Parent then mobileGui.Parent = PlayerGui end

local FAB = Instance.new("TextButton")
FAB.Size = UDim2.fromOffset(60, 60); FAB.Position = UDim2.new(1, -80, 1, -100)
FAB.BackgroundColor3 = Color3.fromRGB(20, 20, 25); FAB.Text = "NL"
FAB.TextColor3 = Color3.fromRGB(255, 255, 255); FAB.Font = Enum.Font.GothamBold
FAB.TextSize = 22; FAB.BorderSizePixel = 0; FAB.Parent = mobileGui
local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(1, 0); corner.Parent = FAB
local stroke = Instance.new("UIStroke"); stroke.Color = Color3.fromRGB(255, 0, 255); stroke.Thickness = 2; stroke.Parent = FAB

local fabDragging, fabDragInput, fabDragStart, fabStartPos
FAB.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        fabDragging = true; fabDragStart = input.Position; fabStartPos = FAB.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then fabDragging = false end end)
    end
end)
FAB.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then fabDragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == fabDragInput and fabDragging then
        local delta = input.Position - fabDragStart
        FAB.Position = UDim2.new(fabStartPos.X.Scale, fabStartPos.X.Offset + delta.X, fabStartPos.Y.Scale, fabStartPos.Y.Offset + delta.Y)
    end
end)

FAB.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    FAB.Size = UDim2.fromOffset(50, 50)
    task.wait(0.1)
    FAB.Size = UDim2.fromOffset(60, 60)
end)
