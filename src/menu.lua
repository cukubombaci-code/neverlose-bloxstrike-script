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
-- 1. RAGEBOT SEKMESİ
-- ==========================================
Win:AddTabLabel("Rage")
local RageTab = Win:AddTab("Rage", "crosshair")

local RageMain = RageTab:AddSection("Main", "left")
RageMain:AddToggle("Enable Ragebot", false, function(state) Rage.Toggle(state) end)
RageMain:AddToggle("Always Aim", false, function(state) Rage.Set("AlwaysAim", state) end)
RageMain:AddDropdown("Aim Key", {"Right Click", "Left Click", "E", "Q"}, "Right Click", function(val)
    if val == "Right Click" then Rage.Set("AimKey", Enum.UserInputType.MouseButton2)
    elseif val == "Left Click" then Rage.Set("AimKey", Enum.UserInputType.MouseButton1)
    elseif val == "E" then Rage.Set("AimKey", Enum.KeyCode.E)
    elseif val == "Q" then Rage.Set("AimKey", Enum.KeyCode.Q) end
end)
RageMain:AddSlider("Field of View", 10, 360, 360, function(val) Rage.Set("FOV", val) end, "°")
RageMain:AddSlider("Smoothing", 0.1, 1.0, 0.1, function(val) Rage.Set("Smoothing", val) end)
RageMain:AddDropdown("Target Mode", {"Crosshair", "Lowest HP", "Distance"}, "Crosshair", function(val) Rage.Set("TargetMode", val) end)

local RageAcc = RageTab:AddSection("Accuracy", "right")
RageAcc:AddToggle("Auto Fire", true, function(state) Rage.Set("AutoFire", state) end)
RageAcc:AddSlider("Fire Rate (ms)", 1, 500, 10, function(val) Rage.Set("FireRate", val) end, "ms")
RageAcc:AddToggle("Burst Mode", false, function(state) Rage.Set("BurstMode", state) end)
RageAcc:AddSlider("Burst Count", 1, 10, 3, function(val) Rage.Set("BurstCount", val) end)
RageAcc:AddToggle("Auto Wall", true, function(state) Rage.Set("AutoWall", state) end)

local RageAA = RageTab:AddSection("Anti-Aim", "right")
RageAA:AddToggle("Enable Anti-Aim", false, function(state) AntiAim.Toggle(state) end)
RageAA:AddDropdown("Mode", {"Backward", "Mevlana (Spin)", "Jitter"}, "Mevlana (Spin)", function(val) 
    if val == "Mevlana (Spin)" then val = "Mevlana" end
    AntiAim.Set("Mode", val) 
end)
RageAA:AddSlider("Speed", 1, 50, 15, function(val) AntiAim.Set("Speed", val) end)

-- ==========================================
-- 2. LEGITBOT & TRIGGERBOT SEKMESİ
-- ==========================================
Win:AddTabLabel("Aimbot")
local AimTab = Win:AddTab("Legit", "mouse")

local LegitMain = AimTab:AddSection("Legitbot", "left")
LegitMain:AddToggle("Enable Legitbot", false, function(state) Aimbot.Toggle(state) end)
LegitMain:AddSlider("Field of View", 10, 360, 150, function(val) Aimbot.Set("FOV", val) end, "°")
LegitMain:AddSlider("Smoothness", 1, 20, 1.5, function(val) Aimbot.Set("Smoothness", val) end)
LegitMain:AddDropdown("Hitbox", {"Head", "Chest", "Nearest"}, "Head", function(val) Aimbot.Set("Hitbox", val) end)
LegitMain:AddToggle("Wall Check", true, function(state) Aimbot.Set("WallCheck", state) end)

local TrigSec = AimTab:AddSection("Triggerbot", "left")
TrigSec:AddToggle("Enable Triggerbot", false, function(state) Trigger.Toggle(state) end)
TrigSec:AddSlider("Trigger Delay (ms)", 0, 500, 50, function(val) Trigger.Set("Delay", val) end, "ms")
TrigSec:AddDropdown("Trigger Hitbox", {"Head", "Chest", "Any"}, "Head", function(val) Trigger.Set("Hitbox", val) end)

-- ==========================================
-- 3. VISUALS (ESP & CHAMS) SEKMESİ
-- ==========================================
Win:AddTabLabel("Visuals")
local VisTab = Win:AddTab("Visuals", "image")

local EspSub = VisTab:AddSubTab("ESP", "user")
local EspSec = EspSub:AddSection("Player ESP", "left")
EspSec:AddToggle("Master ESP", false, function(state) ESP.Toggle(state) end)
EspSec:AddToggle("Team Check", true, function(state) ESP.Set("TeamCheck", state) end)
EspSec:AddToggle("Show Box", true, function(state) ESP.Set("BoxEnabled", state) end)
EspSec:AddDropdown("Box Style", {"Normal", "Corner"}, "Normal", function(val) ESP.Set("BoxStyle", val) end)
EspSec:AddColorpicker("Box Color", Color3.fromRGB(255, 50, 50), function(color) ESP.Set("BoxColor", color) end)
EspSec:AddToggle("Show Name", true, function(state) ESP.Set("NameEnabled", state) end)
EspSec:AddToggle("Show Distance", true, function(state) ESP.Set("DistanceEnabled", state) end)
EspSec:AddToggle("Show Skeleton", true, function(state) ESP.Set("SkeletonEnabled", state) end)
EspSec:AddToggle("Show Health", true, function(state) ESP.Set("HealthEnabled", state) end)

local EspExtra = EspSub:AddSection("Extra ESP", "right")
EspExtra:AddToggle("Off-screen Arrows", true, function(state) ESP.Set("OffScreenArrows", state) end)
EspExtra:AddToggle("Enable Tracers", false, function(state) ESP.Set("TracerEnabled", state) end)

local ChamsSub = VisTab:AddSubTab("Chams", "layers")
local ChamsSec = ChamsSub:AddSection("Player Chams", "left")
ChamsSec:AddToggle("Enable Player Chams", false, function(state) ESP.Set("ChamsEnabled", state) end)
ChamsSec:AddColorpicker("Visible Color", Color3.fromRGB(255, 0, 255), function(color) ESP.Set("ChamsVisibleColor", color) end)

local LocalWpnSec = ChamsSub:AddSection("Local Weapon Chams", "right")
LocalWpnSec:AddToggle("Enable My Weapon Chams", false, function(state) ESP.Set("LocalWeaponChamsEnabled", state) end)
LocalWpnSec:AddColorpicker("My Weapon Color", Color3.fromRGB(0, 255, 255), function(color) ESP.Set("LocalWeaponChamsColor", color) end)

-- ==========================================
-- 4. COMBAT (SİLAH)
-- ==========================================
Win:AddTabLabel("Combat")
local CombatTab = Win:AddTab("Combat", "gear")

local CombatMain = CombatTab:AddSection("Weapon", "left")
CombatMain:AddToggle("Enable Combat", false, function(state) Combat.Toggle(state) end)
CombatMain:AddToggle("No Recoil", false, function(state) Combat.Set("NoRecoil", state) end)
CombatMain:AddToggle("Rapid Fire", false, function(state) Combat.Set("RapidFire", state) end)
CombatMain:AddSlider("Rapid Fire Speed (ms)", 1, 500, 10, function(val) Combat.Set("FireRate", val) end, "ms")
CombatMain:AddToggle("Auto Reload", false, function(state) Combat.Set("AutoReload", state) end)

local HitSec = CombatTab:AddSection("Hit Sounds", "right")
HitSec:AddToggle("Enable Hit Sound", false, function(state) HitSound.Toggle(state) end)
local soundNames = { ["Minecraft XP"] = "rbxassetid://4655262996", ["Mario Coin"] = "rbxassetid://3312870665", ["CS:GO Hitmarker"] = "rbxassetid://4627983311" }
HitSec:AddDropdown("Select Sound", {"Minecraft XP", "Mario Coin", "CS:GO Hitmarker"}, "Minecraft XP", function(val) HitSound.Set("SoundId", soundNames[val]) end)

-- ==========================================
-- 5. WORLD (DÜNYА)
-- ==========================================
Win:AddTabLabel("World")
local WorldTab = Win:AddTab("World", "earth")

local WorldVis = WorldTab:AddSection("Visuals", "left")
WorldVis:AddToggle("Fullbright", false, function(state) World.Set("Fullbright", state) end)
WorldVis:AddSlider("Fullbright Brightness", 1, 10, 3, function(val) World.Set("FullbrightValue", val) end)
WorldVis:AddToggle("Custom FOV", false, function(state) World.Set("FOVEnabled", state) end)
WorldVis:AddSlider("FOV Value", 50, 140, 90, function(val) World.Set("FOVValue", val) end, "°")

-- ==========================================
-- 6. MOVEMENT (HAREKET)
-- ==========================================
Win:AddTabLabel("Movement")
local MoveTab = Win:AddTab("Movement", "run")

local BhopSec = MoveTab:AddSection("Bunnyhop", "left")
BhopSec:AddToggle("Enable Bunnyhop", false, function(state) Movement.Set("BhopEnabled", state) end)
BhopSec:AddSlider("Bhop Speed", 16, 200, 50, function(val) Movement.Set("BhopSpeed", val) end)

local AirSec = MoveTab:AddSection("Air Strafe", "right")
AirSec:AddToggle("Enable Air Strafe", false, function(state) Movement.Set("AirStrafeEnabled", state) end)
AirSec:AddSlider("Air Speed / Power", 16, 200, 50, function(val) Movement.Set("AirStrafeSpeed", val) end)

-- ==========================================
-- 7. SECURITY (BYPASS)
-- ==========================================
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
pcall(function() mobileGui.Parent = game:GetService("CoreGui") end)
if not mobileGui.Parent then mobileGui.Parent = PlayerGui end

local FAB = Instance.new("TextButton")
FAB.Name = "ToggleMenuBtn"
FAB.Size = UDim2.fromOffset(60, 60)
FAB.Position = UDim2.new(1, -80, 1, -100)
FAB.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
FAB.Text = "NL"
FAB.TextColor3 = Color3.fromRGB(255, 255, 255)
FAB.Font = Enum.Font.GothamBold
FAB.TextSize = 22
FAB.BorderSizePixel = 0
FAB.Parent = mobileGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = FAB

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 0, 255)
stroke.Thickness = 2
stroke.Transparency = 0.2
stroke.Parent = FAB

local dragging = false
local dragInput, dragStart, startPos

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

FAB.MouseButton1Click:Connect(function()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Insert, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Insert, false, game)
    FAB.Size = UDim2.fromOffset(50, 50)
    task.wait(0.1)
    FAB.Size = UDim2.fromOffset(60, 60)
end)
