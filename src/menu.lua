-- ==============================================================================
-- NEVERLOSE MOBILE MENÜ (Sadece Arayüz - Sıfır Kütüphane)
-- ==============================================================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Modülleri güvenli çağırma (Modül yoksa çökmez)
local function SafeCall(moduleName, methodName, ...)
    local NL = getgenv().Neverlose
    if NL and NL[moduleName] and type(NL[moduleName][methodName]) == "function" then
        pcall(NL[moduleName][methodName], NL[moduleName], ...)
    end
end

-- Arayüz
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NeverloseMenuUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Ana Çerçeve
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 420)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(255, 0, 255)

-- Başlık
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Title.Text = "Neverlose | Mobile"
Title.TextColor3 = Color3.fromRGB(255, 0, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = MainFrame
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 10)

-- Kapat Butonu
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 15
CloseBtn.Parent = MainFrame
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

-- Sekmeler (Tabs)
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -10, 0, 30)
TabBar.Position = UDim2.new(0, 5, 0, 42)
TabBar.BackgroundTransparency = 1
TabBar.Parent = MainFrame
Instance.new("UIListLayout", TabBar).FillDirection = Enum.FillDirection.Horizontal
Instance.new("UIListLayout", TabBar).Padding = UDim.new(0, 4)

-- İçerik Alanı
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -10, 1, -80)
Content.Position = UDim2.new(0, 5, 0, 78)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- Sayfa Oluşturucu
local Pages = {}
local function CreatePage(name)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ScrollBarThickness = 3
    scroll.Visible = false
    scroll.Parent = Content
    Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 6)
    Pages[name] = scroll
    return scroll
end

-- UI Elemanları
local function CreateHeader(parent, text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 24)
    lbl.BackgroundTransparency = 1
    lbl.Text = "--- " .. text .. " ---"
    lbl.TextColor3 = Color3.fromRGB(255, 0, 255)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13
    lbl.Parent = parent
end

local function CreateToggle(parent, name, default, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    local enabled = default
    btn.Text = (enabled and "  [ON] " or "  [OFF] ") .. name
    btn.TextColor3 = enabled and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = (enabled and "  [ON] " or "  [OFF] ") .. name
        btn.TextColor3 = enabled and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(200, 200, 200)
        if callback then pcall(callback, enabled) end
    end)
end

local function CreateSlider(parent, name, min, max, default, step, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    btn.Text = "  " .. name .. " : " .. tostring(default)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local currentVal = default
    btn.MouseButton1Click:Connect(function()
        currentVal = currentVal + step
        if currentVal > max then currentVal = min end
        btn.Text = "  " .. name .. " : " .. tostring(currentVal)
        if callback then pcall(callback, currentVal) end
    end)
end

local function CreateDropdown(parent, name, options, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    btn.Text = "  " .. name .. " : " .. options[1]
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local currentIndex = 1
    btn.MouseButton1Click:Connect(function()
        currentIndex = currentIndex + 1
        if currentIndex > #options then currentIndex = 1 end
        btn.Text = "  " .. name .. " : " .. options[currentIndex]
        if callback then pcall(callback, options[currentIndex]) end
    end)
end

local function CreateColorPicker(parent, name, callback)
    local colors = {
        ["Kirmizi"] = Color3.fromRGB(255, 50, 50), 
        ["Yesil"] = Color3.fromRGB(0, 255, 128), 
        ["Mavi"] = Color3.fromRGB(50, 150, 255), 
        ["Sari"] = Color3.fromRGB(255, 255, 0), 
        ["Mor"] = Color3.fromRGB(255, 0, 255), 
        ["Beyaz"] = Color3.fromRGB(255, 255, 255)
    }
    local names = {"Kirmizi", "Yesil", "Mavi", "Sari", "Mor", "Beyaz"}
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    btn.Text = "  " .. name .. " : " .. names[1]
    btn.TextColor3 = colors[names[1]]
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local currentIndex = 1
    btn.MouseButton1Click:Connect(function()
        currentIndex = currentIndex + 1
        if currentIndex > #names then currentIndex = 1 end
        btn.Text = "  " .. name .. " : " .. names[currentIndex]
        btn.TextColor3 = colors[names[currentIndex]]
        if callback then pcall(callback, colors[names[currentIndex]]) end
    end)
end

-- ==============================================================================
-- SAYFA İÇERİKLERİ
-- ==============================================================================

-- 1. RAGE
local RagePage = CreatePage("Rage")
CreateHeader(RagePage, "RAGEBOT")
CreateToggle(RagePage, "Enable Ragebot", false, function(s) SafeCall("ragebot", "Toggle", s) end)
CreateSlider(RagePage, "FOV", 10, 360, 360, 10, function(v) SafeCall("ragebot", "Set", "FOV", v) end)
CreateDropdown(RagePage, "Hitbox", {"Head", "Chest"}, function(v) SafeCall("ragebot", "Set", "Hitbox", v) end)
CreateToggle(RagePage, "Auto Fire", true, function(s) SafeCall("ragebot", "Set", "AutoFire", s) end)
CreateHeader(RagePage, "ANTI-AIM")
CreateToggle(RagePage, "Enable Anti-Aim", false, function(s) SafeCall("anti-aim", "Toggle", s) end)
CreateDropdown(RagePage, "AA Mode", {"Mevlana", "Backward"}, function(v) SafeCall("anti-aim", "Set", "Mode", v) end)

-- 2. LEGIT
local LegitPage = CreatePage("Legit")
CreateHeader(LegitPage, "LEGITBOT")
CreateToggle(LegitPage, "Enable Aimbot", false, function(s) SafeCall("aimbot", "Toggle", s) end)
CreateSlider(LegitPage, "Aimbot FOV", 10, 360, 150, 10, function(v) SafeCall("aimbot", "Set", "FOV", v) end)
CreateSlider(LegitPage, "Smoothness", 1, 20, 2, 1, function(v) SafeCall("aimbot", "Set", "Smoothness", v) end)
CreateDropdown(LegitPage, "Aimbot Hitbox", {"Head", "Chest"}, function(v) SafeCall("aimbot", "Set", "Hitbox", v) end)
CreateToggle(LegitPage, "Wall Check", true, function(s) SafeCall("aimbot", "Set", "WallCheck", s) end)
CreateHeader(LegitPage, "TRIGGERBOT")
CreateToggle(LegitPage, "Enable Triggerbot", false, function(s) SafeCall("triggerbot", "Toggle", s) end)
CreateSlider(LegitPage, "Trigger Delay (ms)", 10, 500, 50, 10, function(v) SafeCall("triggerbot", "Set", "Delay", v) end)

-- 3. VISUALS
local VisPage = CreatePage("Visuals")
CreateHeader(VisPage, "ESP")
CreateToggle(VisPage, "Enable ESP", false, function(s) SafeCall("esp", "Toggle", s) end)
CreateToggle(VisPage, "Show Box", true, function(s) SafeCall("esp", "Set", "BoxEnabled", s) end)
CreateColorPicker(VisPage, "Box Color", function(c) SafeCall("esp", "Set", "BoxColor", c) end)
CreateToggle(VisPage, "Show Name", true, function(s) SafeCall("esp", "Set", "NameEnabled", s) end)
CreateToggle(VisPage, "Show Health", true, function(s) SafeCall("esp", "Set", "HealthEnabled", s) end)
CreateToggle(VisPage, "Show Tracers", false, function(s) SafeCall("esp", "Set", "TracerEnabled", s) end)
CreateHeader(VisPage, "CHAMS")
CreateToggle(VisPage, "Enable Player Chams", false, function(s) SafeCall("esp", "Set", "ChamsEnabled", s) end)
CreateColorPicker(VisPage, "Chams Color", function(c) SafeCall("esp", "Set", "ChamsVisibleColor", c) end)
CreateToggle(VisPage, "Enable Weapon Chams", false, function(s) SafeCall("esp", "Set", "LocalWeaponChamsEnabled", s) end)

-- 4. MOVEMENT
local MovePage = CreatePage("Move")
CreateHeader(MovePage, "BUNNYHOP")
CreateToggle(MovePage, "Enable Bhop", false, function(s) SafeCall("movement", "Set", "BhopEnabled", s) end)
CreateSlider(MovePage, "Bhop Speed", 16, 200, 50, 10, function(v) SafeCall("movement", "Set", "BhopSpeed", v) end)
CreateHeader(MovePage, "AIR STRAFE")
CreateToggle(MovePage, "Enable Air Strafe", false, function(s) SafeCall("movement", "Set", "AirStrafeEnabled", s) end)
CreateSlider(MovePage, "Air Power", 16, 200, 50, 10, function(v) SafeCall("movement", "Set", "AirStrafeSpeed", v) end)

-- Sekme Geçiş Mantığı
local function SwitchTab(tabName)
    for name, page in pairs(Pages) do
        page.Visible = (name == tabName)
    end
end

for tabName, _ in pairs(Pages) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.24, 0, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    btn.Text = tabName
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.Parent = TabBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function() SwitchTab(tabName) end)
end

SwitchTab("Rage")

-- Sağ Alt Yuvarlak Buton
local FAB = Instance.new("TextButton")
FAB.Size = UDim2.fromOffset(55, 55)
FAB.Position = UDim2.new(1, -75, 1, -110)
FAB.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
FAB.Text = "NL"
FAB.TextColor3 = Color3.fromRGB(255, 255, 255)
FAB.Font = Enum.Font.GothamBold
FAB.TextSize = 18
FAB.Parent = ScreenGui
Instance.new("UICorner", FAB).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", FAB).Color = Color3.fromRGB(255, 0, 255)

FAB.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
