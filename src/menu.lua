-- src/menu.lua (Mobil Dostu & Tam Uyumlu Menü)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- v3.2 Loader'dan Modülleri Çek (require yerine Global Tablo)
local NL = getgenv().Neverlose or {}
local Aimbot = NL["aimbot"]
local Rage = NL["ragebot"]
local AntiAim = NL["anti-aim"]
local Combat = NL["combat"]
local ESP = NL["esp"]
local Freecam = NL["freecam"]
local Hitbox = NL["hitbox"]
local HitSound = NL["hitsound"]
local Movement = NL["movement"]
local Trigger = NL["triggerbot"]
local World = NL["world"]

-- Arayüz (Telefonlarda CoreGui daha iyi çalışır)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NeverloseMobileMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = PlayerGui end

-- Ana Çerçeve
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 420) -- Telefon ekranına daha uygun boyut
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
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
Title.Text = "Neverlose | Mobile"
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
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y -- Butonlar eklendikçe otomatik uzar
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0) 
Scroll.ScrollBarThickness = 4
Scroll.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 8)
UIList.Parent = Scroll

-- Menü Elemanı Oluşturucuları
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
    btn.Size = UDim2.new(1, 0, 0, 36) -- Parmakla basması kolay olsun diye biraz büyüttük
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
        if callback then callback(enabled) end
    end)
end

-- ==========================================
-- MENÜ KONTROL BAĞLANTILARI (Hata Korumalı)
-- ==========================================

createHeader("AIMBOT & RAGE")
if Aimbot then createToggle("Aimbot Master", function(s) Aimbot.Toggle(s) end) end
if Rage then createToggle("Ragebot (Auto-Fire)", function(s) Rage.Toggle(s) end) end
if Trigger then createToggle("Triggerbot", function(s) Trigger.Toggle(s) end) end

createHeader("VISUALS (ESP)")
if ESP then
    createToggle("ESP Master", function(s) ESP.Toggle(s) end)
    createToggle("ESP Box", function(s) ESP.Set("BoxEnabled", s) end)
    createToggle("ESP Name", function(s) ESP.Set("NameEnabled", s) end)
    createToggle("ESP Health", function(s) ESP.Set("HealthEnabled", s) end)
    createToggle("ESP Tracer", function(s) ESP.Set("TracerEnabled", s) end)
    createToggle("ESP Chams", function(s) ESP.Set("ChamsEnabled", s) end)
    createToggle("Local Weapon Chams", function(s) ESP.Set("LocalWeaponChamsEnabled", s) end)
end

createHeader("COMBAT")
if Combat then
    createToggle("Rapid Fire", function(s) Combat.Set("RapidFire", s) end)
    createToggle("No Recoil", function(s) Combat.Set("NoRecoil", s) end)
end
if Hitbox then createToggle("Hitbox Expander", function(s) Hitbox.Toggle(s) end) end
if AntiAim then createToggle("Anti-Aim (Spin)", function(s) AntiAim.Toggle(s) end) end

createHeader("MOVEMENT")
if Movement then
    createToggle("Bunnyhop", function(s) Movement.Set("BhopEnabled", s) end)
    createToggle("Air Strafe", function(s) Movement.Set("AirStrafeEnabled", s) end)
end
if Freecam then createToggle("Freecam", function(s) Freecam.Toggle(s) end) end

createHeader("WORLD")
if World then
    createToggle("Fullbright", function(s) World.Set("Fullbright", s) end)
    createToggle("Remove Fog", function(s) World.Set("RemoveFog", s) end)
end

-- ==========================================
-- SAĞ ALT SÜRÜKLENEBİLİR "NL" BUTONU (FAB)
-- ==========================================
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

local dragging, dragStart, startPos
FAB.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = FAB.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
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

return { Status = "Mobile UI Loaded Successfully" }
