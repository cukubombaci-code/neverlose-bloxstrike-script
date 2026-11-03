-- src/menu.lua
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/cukubombaci-code/neverlose-bloxstrike-script/main/src/esp.lua"))()
local Aimbot = loadstring(game:HttpGet("https://raw.githubusercontent.com/cukubombaci-code/neverlose-bloxstrike-script/main/src/aimbot.lua"))()
local Rage = loadstring(game:HttpGet("https://raw.githubusercontent.com/cukubombaci-code/neverlose-bloxstrike-script/main/src/ragebot.lua"))()
local AntiAim = loadstring(game:HttpGet("https://raw.githubusercontent.com/cukubombaci-code/neverlose-bloxstrike-script/main/src/anti-aim.lua"))()
local Movement = loadstring(game:HttpGet("https://raw.githubusercontent.com/cukubombaci-code/neverlose-bloxstrike-script/main/src/movement.lua"))()
local Combat = loadstring(game:HttpGet("https://raw.githubusercontent.com/cukubombaci-code/neverlose-bloxstrike-script/main/src/combat.lua"))()
local World = loadstring(game:HttpGet("https://raw.githubusercontent.com/cukubombaci-code/neverlose-bloxstrike-script/main/src/world.lua"))()
local HitSound = loadstring(game:HttpGet("https://raw.githubusercontent.com/cukubombaci-code/neverlose-bloxstrike-script/main/src/hitsound.lua"))()
local Trigger = loadstring(game:HttpGet("https://raw.githubusercontent.com/cukubombaci-code/neverlose-bloxstrike-script/main/src/triggerbot.lua"))()
local Security = loadstring(game:HttpGet("https://raw.githubusercontent.com/cukubombaci-code/neverlose-bloxstrike-script/main/src/security.lua"))()
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/cukubombaci-code/neverlose-bloxstrike-script/main/lib/nl-menu.lua"))()

Library.ShowLoader = false

local Win = Library:AddWindow("Neverlose", "", "BloxStrike")
Win:SetScale("Auto")

-- ==========================================
-- MENÜ SEKMELERİ
-- ==========================================
Win:AddTabLabel("Rage")
local RageTab = Win:AddTab("Rage", "crosshair")

local RageMain = RageTab:AddSection("Main", "left")
RageMain:AddToggle("Enable Ragebot", false, function(state) Rage.Toggle(state) end)
RageMain:AddSlider("Field of View", 10, 360, 360, function(val) Rage.Set("FOV", val) end, "°")
RageMain:AddSlider("Smoothing", 0.1, 1.0, 0.1, function(val) Rage.Set("Smoothing", val) end)
RageMain:AddToggle("Auto Fire", true, function(state) Rage.Set("AutoFire", state) end)

local RageAA = RageTab:AddSection("Anti-Aim", "right")
RageAA:AddToggle("Enable Anti-Aim", false, function(state) AntiAim.Toggle(state) end)
RageAA:AddDropdown("Mode", {"Backward", "Mevlana (Spin)", "Jitter"}, "Mevlana (Spin)", function(val) 
    if val == "Mevlana (Spin)" then val = "Mevlana" end
    AntiAim.Set("Mode", val) 
end)
RageAA:AddSlider("Spin Speed", 1, 50, 15, function(val) AntiAim.Set("Speed", val) end)

Win:AddTabLabel("Aimbot")
local AimTab = Win:AddTab("Legit", "mouse")
local LegitMain = AimTab:AddSection("Legitbot", "left")
LegitMain:AddToggle("Enable Legitbot", false, function(state) Aimbot.Toggle(state) end)
LegitMain:AddSlider("Field of View", 10, 360, 150, function(val) Aimbot.Set("FOV", val) end, "°")
LegitMain:AddSlider("Smoothness", 1, 20, 1.5, function(val) Aimbot.Set("Smoothness", val) end)

local TrigSec = AimTab:AddSection("Triggerbot", "right")
TrigSec:AddToggle("Enable Triggerbot", false, function(state) Trigger.Toggle(state) end)
TrigSec:AddSlider("Trigger Delay (ms)", 0, 500, 50, function(val) Trigger.Set("Delay", val) end, "ms")

Win:AddTabLabel("Visuals")
local VisTab = Win:AddTab("Visuals", "image")
local EspSub = VisTab:AddSubTab("ESP", "user")
local EspSec = EspSub:AddSection("Player ESP", "left")
EspSec:AddToggle("Master ESP", false, function(state) ESP.Toggle(state) end)
EspSec:AddToggle("Show Box", true, function(state) ESP.Set("BoxEnabled", state) end)
EspSec:AddColorpicker("Box Color", Color3.fromRGB(255, 50, 50), function(color) ESP.Set("BoxColor", color) end)

local ChamsSub = VisTab:AddSubTab("Chams", "layers")
local ChamsSec = ChamsSub:AddSection("Player Chams", "left")
ChamsSec:AddToggle("Enable Player Chams", false, function(state) ESP.Set("ChamsEnabled", state) end)
ChamsSec:AddColorpicker("Visible Color", Color3.fromRGB(255, 0, 255), function(color) ESP.Set("ChamsVisibleColor", color) end)

Win:AddTabLabel("Movement")
local MoveTab = Win:AddTab("Movement", "run")
local BhopSec = MoveTab:AddSection("Bunnyhop", "left")
BhopSec:AddToggle("Enable Bunnyhop", false, function(state) Movement.Set("BhopEnabled", state) end)
BhopSec:AddSlider("Bhop Speed", 16, 200, 50, function(val) Movement.Set("BhopSpeed", val) end)

local AirSec = MoveTab:AddSection("Air Strafe", "right")
AirSec:AddToggle("Enable Air Strafe", false, function(state) Movement.Set("AirStrafeEnabled", state) end)
AirSec:AddSlider("Air Speed / Power", 16, 200, 50, function(val) Movement.Set("AirStrafeSpeed", val) end)

Win:AddTabLabel("Security")
local SecTab = Win:AddTab("Security", "locked")
local BypassSec = SecTab:AddSection("Server Bypass", "left")
BypassSec:AddToggle("Anti-Kick", true, function(state) Security.Set("AntiKick", state) end)
BypassSec:AddToggle("Speed Spoof", true, function(state) Security.Set("WalkSpeedSpoof", state) end)
BypassSec:AddToggle("Remote Throttler", true, function(state) Security.Set("RemoteThrottler", state) end)

-- Klavye Kısayolu (PC için)
Win:SetMenuBind(Enum.KeyCode.Insert)


-- ==========================================
-- MOBİL BUTON (FLOATING ACTION BUTTON)
-- ==========================================
local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local mobileGui = Instance.new("ScreenGui")
mobileGui.Name = "NeverloseMobileBtn"
mobileGui.ResetOnSpawn = false
mobileGui.DisplayOrder = 999
-- Executor'ların çoğu CoreGui'ye atmayı destekler, desteklemiyorsa PlayerGui'ye atar
pcall(function() mobileGui.Parent = game:GetService("CoreGui") end)
if not mobileGui.Parent then mobileGui.Parent = PlayerGui end

local FAB = Instance.new("TextButton")
FAB.Name = "ToggleMenuBtn"
FAB.Size = UDim2.fromOffset(60, 60)
FAB.Position = UDim2.new(1, -80, 1, -100) -- Sağ alt köşe
FAB.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
FAB.Text = "NL"
FAB.TextColor3 = Color3.fromRGB(255, 255, 255)
FAB.Font = Enum.Font.GothamBold
FAB.TextSize = 22
FAB.BorderSizePixel = 0
FAB.Parent = mobileGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0) -- Tam yuvarlak
corner.Parent = FAB

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 0, 255) -- Neon Pembe Çizgi
stroke.Thickness = 2
stroke.Transparency = 0.2
stroke.Parent = FAB

-- Butonu Sürüklenebilir Yapma
local dragging = false
local dragInput, dragStart, startPos

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

FAB.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        FAB.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Butona Tıklayınca Menüyü Aç/Kapat (Insert tuşuna basılmış gibi simüle eder)
FAB.MouseButton1Click:Connect(function()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Insert, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Insert, false, game)
    
    -- Butona tıklanınca ufak bir animasyon (Küçülüp büyüme)
    FAB.Size = UDim2.fromOffset(50, 50)
    task.wait(0.1)
    FAB.Size = UDim2.fromOffset(60, 60)
end)
