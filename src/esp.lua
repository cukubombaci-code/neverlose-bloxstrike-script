-- src/esp.lua (Mobil Uyumlu & Güvenli Ultra Sürüm)
local ESP = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local settings = {
    MasterEnabled = false,
    TeamCheck = true,
    BoxEnabled = true,
    BoxStyle = "Normal",
    BoxFilled = false,
    BoxColor = Color3.fromRGB(255, 50, 50),
    NameEnabled = true,
    NameColor = Color3.fromRGB(255, 255, 255),
    DistanceEnabled = true,
    DistanceColor = Color3.fromRGB(200, 200, 200),
    HealthEnabled = true,
    HealthTextEnabled = true,
    WeaponTextEnabled = true,
    WeaponTextColor = Color3.fromRGB(255, 255, 100),
    SkeletonEnabled = false, -- Mobilde kasma yapmaması için varsayılan kapalı (menüden açılabilir)
    SkeletonColor = Color3.fromRGB(255, 255, 255),
    HeadDotEnabled = true,
    HeadDotColor = Color3.fromRGB(255, 255, 255),
    TracerEnabled = false,
    TracerColor = Color3.fromRGB(255, 255, 0),
    ChamsEnabled = false,
    ChamsColor = Color3.fromRGB(255, 0, 255),
}

local drawings = {}
local highlights = {}

local function createDrawing(class, props)
    local ok, obj = pcall(Drawing.new, class)
    if not ok then return nil end
    for k, v in pairs(props) do pcall(function() obj[k] = v end) end
    return obj
end

local function clearPlayerDrawings(player)
    if drawings[player] then
        for _, d in pairs(drawings[player]) do
            if type(d) == "table" then
                for _, sub in pairs(d) do pcall(function() if sub.Remove then sub:Remove() end end) end
            else
                pcall(function() if d.Remove then d:Remove() end end)
            end
        end
        drawings[player] = nil
    end
    if highlights[player] then
        pcall(function() highlights[player]:Destroy() end)
        highlights[player] = nil
    end
end

local function clearAll()
    for player, _ in pairs(drawings) do clearPlayerDrawings(player) end
    drawings = {}; highlights = {}
end

function ESP.Set(key, value)
    if settings[key] ~= nil then settings[key] = value end
end

function ESP.Toggle(state)
    settings.MasterEnabled = state
    if not state then clearAll() end
end

RunService.RenderStepped:Connect(function()
    if not settings.MasterEnabled then return end
    local localChar = LocalPlayer.Character
    local localHRP = localChar and localChar:FindFirstChild("HumanoidRootPart")
    if not localHRP then return end
    
    local localPos = localHRP.Position
    local myTeam = LocalPlayer.Team
    local activePlayers = {}

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head")
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local isTeammate = settings.TeamCheck and (player.Team == myTeam) and myTeam ~= nil

            if hrp and head and humanoid and humanoid.Health > 0 and not isTeammate then
                activePlayers[player] = true
                
                -- Güvenli Chams
                if settings.ChamsEnabled then
                    if not highlights[player] then
                        pcall(function()
                            local hl = Instance.new("Highlight")
                            hl.Adornee = char
                            hl.FillColor = settings.ChamsColor
                            hl.OutlineColor = settings.ChamsColor
                            hl.Parent = char
                            highlights[player] = hl
                        end)
                    end
                elseif highlights[player] then
                    pcall(function() highlights[player]:Destroy() end)
                    highlights[player] = nil
                end

                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                
                if onScreen then
                    local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                    local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                    
                    local height = math.abs(headPos.Y - legPos.Y)
                    local width = height / 2
                    local x = pos.X - width / 2
                    local y = headPos.Y
                    
                    if not drawings[player] then drawings[player] = {} end
                    local d = drawings[player]
                    
                    -- Kutu
                    if not d.box then
                        d.box = createDrawing("Square", { Color = settings.BoxColor, Thickness = 1, Filled = false })
                    end
                    if d.box then
                        d.box.Color = settings.BoxColor
                        d.box.Visible = settings.BoxEnabled
                        d.box.Position = Vector2.new(x, y)
                        d.box.Size = Vector2.new(width, height)
                    end
                    
                    -- Kafa Noktası
                    if not d.headDot then d.headDot = createDrawing("Circle", { Color = settings.HeadDotColor, Thickness = 1, Filled = true, Radius = 3 }) end
                    if d.headDot then
                        d.headDot.Color = settings.HeadDotColor
                        d.headDot.Visible = settings.HeadDotEnabled
                        d.headDot.Position = Vector2.new(pos.X, y)
                    end
                    
                    -- İsim ve Mesafe
                    if not d.name then
                        d.name = createDrawing("Text", { Color = settings.NameColor, Size = 13, Center = true, Outline = true })
                        d.dist = createDrawing("Text", { Color = settings.DistanceColor, Size = 11, Center = true, Outline = true })
                    end
                    if d.name then
                        d.name.Visible = settings.NameEnabled
                        d.name.Position = Vector2.new(pos.X, y - 15)
                        d.name.Text = player.Name
                    end
                    if d.dist then
                        d.dist.Visible = settings.DistanceEnabled
                        d.dist.Position = Vector2.new(pos.X, y + height + 2)
                        d.dist.Text = math.floor((localPos - hrp.Position).Magnitude) .. "m"
                    end
                    
                    -- Can Barı
                    if not d.healthBar then
                        d.healthBg = createDrawing("Square", { Color = Color3.fromRGB(20, 20, 20), Filled = true })
                        d.healthBar = createDrawing("Square", { Color = Color3.fromRGB(0, 255, 0), Filled = true })
                    end
                    if d.healthBar and d.healthBg then
                        d.healthBg.Visible = settings.HealthEnabled
                        d.healthBar.Visible = settings.HealthEnabled
                        if settings.HealthEnabled then
                            local hp = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                            d.healthBg.Position = Vector2.new(x - 6, y)
                            d.healthBg.Size = Vector2.new(3, height)
                            d.healthBar.Position = Vector2.new(x - 6, y + height - (height * hp))
                            d.healthBar.Size = Vector2.new(3, height * hp)
                        end
                    end
                    
                    -- Tracer
                    if not d.tracer then d.tracer = createDrawing("Line", { Thickness = 1, Transparency = 0.5 }) end
                    if d.tracer then
                        d.tracer.Visible = settings.TracerEnabled
                        d.tracer.Color = settings.TracerColor
                        d.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        d.tracer.To = Vector2.new(pos.X, y + (height / 2))
                    end
                    
                else
                    if drawings[player] then
                        for _, drawing in pairs(drawings[player]) do
                            if type(drawing) ~= "table" and drawing.Visible then drawing.Visible = false end
                        end
                    end
                end
            end
        end
    end

    for player, _ in pairs(drawings) do
        if not activePlayers[player] then clearPlayerDrawings(player) end
    end
end)

return ESP
