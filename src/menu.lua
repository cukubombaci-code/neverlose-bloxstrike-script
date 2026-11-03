-- src/menu.lua (Tam Donanımlı & Full Ayarlanabilir Mobil Menü)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Tüm Modülleri Güvenli Şekilde Çağırma
local Aimbot = pcall(function() return require(script.Parent.aimbot) end) and require(script.Parent.aimbot) or nil
local Rage = pcall(function() return require(script.Parent.ragebot) end) and require(script.Parent.ragebot) or nil
local AntiAim = pcall(function() return require(script.Parent.anti-aim) end) and require(script.Parent.anti-aim) or nil
local Combat = pcall(function() return require(script.Parent.combat) end) and require(script.Parent.combat) or nil
local ESP = pcall(function() return require(script.Parent.esp) end) and require(script.Parent.esp) or nil
local Freecam = pcall(function() return require(script.Parent.freecam) end) and require(script.Parent.freecam) or nil
local Hitbox = pcall(function() return require(script.Parent.hitbox) end) and require(script.Parent.hitbox) or nil
local HitSound = pcall(function() return require(script.Parent.hitsound) end) and require(script.Parent.hitsound) or nil
local Movement = pcall(function() return require(script.Parent.movement) end) and require(script.Parent.movement) or nil
local Trigger = pcall(function() return require(script.Parent.triggerbot) end) and require(script.Parent.triggerbot) or nil
local World = pcall(function() return require(script.Parent.world) end) and require(script.Parent.world) or nil

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NeverloseMasterMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = PlayerGui

-- Ana Çerçeve
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 390, 0, 340)
MainFrame.Position = UDim2.new(0.5, -195, 0.5, -170)
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
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Neverlose | Ultimate Edition"
Title.TextColor3 = Color3.fromRGB(255, 0, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 15
CloseBtn.Parent = Header

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Kaydırılabilir İçerik Alanı
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -50)
Scroll.Position = UDim2.new(0, 10, 0, 42)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 950)
Scroll.ScrollBarThickness = 4
Scroll.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 8)
UIList.Parent = Scroll

-- Menü Yardımcı Oluşturucuları
local function createHeader(text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 25)
    lbl.BackgroundTransparency = 1
    lbl.Text = "--- " .. text .. " ---"
    lbl.TextColor3 = Color3.fromRGB(255, 0, 255)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13
    lbl.Parent = Scroll
end

local function createToggle(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    btn.Text = "  [OFF] " .. name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = Scroll
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            btn.Text = "  [ON] " .. name
            btn.TextColor3 = Color3.fromRGB(0, 255, 128)
        else
            btn.Text = "  [OFF] " .. name
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        callback(enabled)
    end)
end

-- ==========================================
-- MENÜ KONTROL BAĞLANTILARI
-- ==========================================

createHeader("AIMBOT & RAGE")
if Aimbot then
    createToggle("Aimbot Master Toggle", function(state) Aimbot.Toggle(state) end)
end
if Rage then
    createToggle("Ragebot (Auto-Fire)", function(state) Rage.Toggle(state) end)
end
if Trigger then
    createToggle("Triggerbot (Tetikleyici)", function(state) Trigger.Toggle(state) end)
end

createHeader("VISUALS (ESP)")
if ESP then
    createToggle("ESP Master Toggle", function(state) ESP.Toggle(state) end)
    createToggle("ESP Box (Kutu)", function(state) ESP.Set("BoxEnabled", state) end)
    createToggle("ESP Name (İsim)", function(state) ESP.Set("NameEnabled", state) end)
    createToggle("ESP Health (Can Barı)", function(state) ESP.Set("HealthEnabled", state) end)
    createToggle("ESP Tracer (Çizgiler)", function(state) ESP.Set("TracerEnabled", state) end)
    createToggle("ESP Chams (Parlama)", function(state) ESP.Set("ChamsEnabled", state) end)
end

createHeader("COMBAT & ADVANCED")
if Combat then
    createToggle("Rapid Fire (Hızlı Ateş)", function(state) Combat.Set("RapidFire", state) end)
    createToggle("No Recoil (Tepmeme)", function(state) Combat.Set("NoRecoil", state) end)
end
if Hitbox then
    createToggle("Hitbox Expander (Kafa Büyüt)", function(state) Hitbox.Toggle(state) end)
end
if AntiAim then
    createToggle("Anti-Aim (Mevlana / Spin)", function(state) AntiAim.Toggle(state) end)
end

createHeader("MOVEMENT & MISC")
if Movement then
    createToggle("Bunnyhop (Otomatik Zıplama)", function(state) Movement.Set("BhopEnabled", state) end)
    createToggle("Air Strafe (Havada Kontrol)", function(state) Movement.Set("AirStrafeEnabled", state) end)
end
if Freecam then
    createToggle("Freecam (Serbest Kamera)", function(state) Freecam.Toggle(state) end)
end
if HitSound then
    createToggle("Hitsound (Vuruş Sesi)", function(state) HitSound.Toggle(state) end)
end

createHeader("WORLD & ENVIRONMENT")
if World then
    createToggle("Fullbright (Geceyi Aydınlat)", function(state) World.Set("Fullbright", state) end)
    createToggle("Remove Fog (Sisi Kaldır)", function(state) World.Set("RemoveFog", state) end)
    createToggle("Custom FOV (Geniş Görüş)", function(state) World.Set("FOVEnabled", state) end)
end

-- Sağ Alt Sürüklenebilir NL Butonu (FAB)
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

-- Dokunmatik Sürükleme (Draggable) Desteği
local dragging, dragStart, startPos
FAB.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = FAB.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        FAB.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

FAB.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

return { Status = "Fully Loaded & Configurable" }
