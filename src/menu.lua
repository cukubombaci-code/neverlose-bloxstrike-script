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
RageMain:AddSlider("Field of View", 10, 360, 360, function(val) Rage.Set("FOV", val) end, "°")
RageMain:AddSlider("Smoothing", 0.1, 1.0, 0.1, function(val) Rage.Set("Smoothing", val) end)

local RageAcc = RageTab:AddSection("Accuracy", "right")
RageAcc:AddToggle("Auto Fire", true, function(state) Rage.Set("AutoFire", state) end)
RageAcc:AddSlider("Fire Rate (ms)", 1, 500, 10, function(val) Rage.Set("FireRate", val) end, "ms")
RageAcc:AddToggle("Auto Wall", true, function(state) Rage.Set("AutoWall", state) end)

local RageAA = RageTab:AddSection("Anti-Aim", "right")
RageAA:AddToggle("Enable Anti-Aim", false, function(state) AntiAim.Toggle(state) end)
RageAA:AddDropdown("Mode", {"Backward", "Mevlana (Spin)", "Jitter"}, "Mevlana (Spin)", function(val) 
    if val == "Mevlana (Spin)" then val = "Mevlana" end
    AntiAim.Set("Mode", val) 
end)

-- ==========================================
-- 2. LEGITBOT & TRIGGERBOT
-- ==========================================
Win:AddTabLabel("Aimbot")
local AimTab = Win:AddTab("Legit", "mouse")

local LegitMain = AimTab:AddSection("Legitbot", "left")
LegitMain:AddToggle("Enable Legitbot", false, function(state) Aimbot.Toggle(state) end)
LegitMain:AddSlider("Field of View", 10, 360, 150, function(val) Aimbot.Set("FOV", val) end, "°")
LegitMain:AddSlider("Smoothness", 1, 20, 1.5, function(val) Aimbot.Set("Smoothness", val) end)
LegitMain:AddToggle("Wall Check", true, function(state) Aimbot.Set("WallCheck", state) end)

local TrigSec = AimTab:AddSection("Triggerbot", "left")
TrigSec:AddToggle("Enable Triggerbot", false, function(state) Trigger.Toggle(state) end)
TrigSec:AddSlider("Trigger Delay (ms)", 0, 500, 50, function(val) Trigger.Set("Delay", val) end, "ms")
TrigSec:AddDropdown("Trigger Hitbox", {"Head", "Chest", "Any"}, "Head", function(val) Trigger.Set("Hitbox", val) end)

-- ==========================================
-- 3. VISUALS
-- ==========================================
Win:AddTabLabel("Visuals")
local VisTab = Win:AddTab("Visuals", "image")

local EspSub = VisTab:AddSubTab("ESP", "user")
local EspSec = EspSub:AddSection("Player ESP", "left")
EspSec:AddToggle("Master ESP", false, function(state) ESP.Toggle(state) end)
EspSec:AddToggle("Show Box", true, function(state) ESP.Set("BoxEnabled", state) end)
EspSec:AddColorpicker("Box Color", Color3.fromRGB(255, 50, 50), function(color) ESP.Set("BoxColor", color) end)
EspSec:AddToggle("Show Name", true, function(state) ESP.Set("NameEnabled", state) end)

local ChamsSub = VisTab:AddSubTab("Chams", "layers")
local ChamsSec = ChamsSub:AddSection("Player Chams", "left")
ChamsSec:AddToggle("Enable Player Chams", false, function(state) ESP.Set("ChamsEnabled", state) end)
ChamsSec:AddColorpicker("Visible Color", Color3.fromRGB(255, 0, 255), function(color) ESP.Set("ChamsVisibleColor", color) end)

-- ==========================================
-- 4. COMBAT
-- ==========================================
Win:AddTabLabel("Combat")
local CombatTab = Win:AddTab("Combat", "gear")

local CombatMain = CombatTab:AddSection("Weapon", "left")
CombatMain:AddToggle("Enable Combat", false, function(state) Combat.Toggle(state) end)
CombatMain:AddToggle("No Recoil", false, function(state) Combat.Set("NoRecoil", state) end)
CombatMain:AddToggle("Rapid Fire", false, function(state) Combat.Set("RapidFire", state) end)
CombatMain:AddSlider("Rapid Fire Speed (ms)", 1, 500, 10, function(val) Combat.Set("FireRate", val) end, "ms")

local HitSec = CombatTab:AddSection("Hit Sounds", "right")
HitSec:AddToggle("Enable Hit Sound", false, function(state) HitSound.Toggle(state) end)
local soundNames = { ["Minecraft XP"] = "rbxassetid://4655262996", ["Mario Coin"] = "rbxassetid://3312870665", ["CS:GO Hitmarker"] = "rbxassetid://4627983311" }
HitSec:AddDropdown("Select Sound", {"Minecraft XP", "Mario Coin", "CS:GO Hitmarker"}, "Minecraft XP", function(val) HitSound.Set("SoundId", soundNames[val]) end)

-- ==========================================
-- 5. WORLD
-- ==========================================
Win:AddTabLabel("World")
local WorldTab = Win:AddTab("World", "earth")
local WorldVis = WorldTab:AddSection("Visuals", "left")
WorldVis:AddToggle("Fullbright", false, function(state) World.Set("Fullbright", state) end)
WorldVis:AddToggle("Custom FOV", false, function(state) World.Set("FOVEnabled", state) end)
WorldVis:AddSlider("FOV Value", 50, 140, 90, function(val) World.Set("FOVValue", val) end, "°")

-- ==========================================
-- 6. MOVEMENT
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
-- 7. SECURITY (ULTRA SERVER BYPASS)
-- ==========================================
Win:AddTabLabel("Security")
local SecTab = Win:AddTab("Security", "locked")

local BypassSec = SecTab:AddSection("Anti-Cheat", "left")
BypassSec:AddToggle("Anti-Kick", true, function(state) Security.Set("AntiKick", state) end)
BypassSec:AddToggle("Anti-Fling", true, function(state) Security.Set("AntiFling", state) end)
BypassSec:AddToggle("Anti-Destroy (Protect UI)", true, function(state) Security.Set("AntiDestroy", state) end)
BypassSec:AddToggle("Hide UI from AC", true, function(state) Security.Set("HideUI", state) end)

local SpoofSec = SecTab:AddSection("Spoofers", "right")
SpoofSec:AddToggle("WalkSpeed Spoof", true, function(state) Security.Set("WalkSpeedSpoof", state) end)
SpoofSec:AddToggle("JumpPower Spoof", true, function(state) Security.Set("JumpPowerSpoof", state) end)
SpoofSec:AddToggle("Velocity Spoof", true, function(state) Security.Set("VelocitySpoof", state) end)

local RemoteSec = SecTab:AddSection("Network", "left")
RemoteSec:AddToggle("Remote Throttler", true, function(state) Security.Set("RemoteThrottler", state) end)
RemoteSec:AddSlider("Max Fire Rate (ms)", 10, 500, 80, function(val) Security.Set("RemoteDelay", val) end, "ms")
RemoteSec:AddToggle("Sanitize Remotes", true, function(state) Security.Set("SanitizeRemotes", state) end)

Win:SetMenuBind(Enum.KeyCode.Insert)
