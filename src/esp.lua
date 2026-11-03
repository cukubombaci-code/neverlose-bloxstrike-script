-- src/esp.lua (ULTRA SÜRÜM - Kendi Silahın Parlıyor)
local ESP = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- TÜM AYARLAR
-- ==========================================
local settings = {
    MasterEnabled = false,
    TeamCheck = true,
    
    -- Kutu Ayarları
    BoxEnabled = true,
    BoxStyle = "Normal", -- "Normal" veya "Corner"
    BoxFilled = false,
    BoxColor = Color3.fromRGB(255, 50, 50),
    
    -- Yazı Ayarları
    NameEnabled = true,
    NameColor = Color3.fromRGB(255, 255, 255),
    DistanceEnabled = true,
    DistanceColor = Color3.fromRGB(200, 200, 200),
    
    -- Sağlık Ayarları
    HealthEnabled = true,
    HealthTextEnabled = true,
    
    -- Düşman Silah Ayarları (Yazı ve Kutu)
    WeaponTextEnabled = true,
    WeaponTextColor = Color3.fromRGB(255, 255, 100),
    WeaponBoxEnabled = true,
    WeaponBoxColor = Color3.fromRGB(255, 150, 0),
    
    -- BİZİM SİLAHIMIZ (Local Weapon Chams)
    LocalWeaponChamsEnabled = false,
    LocalWeaponChamsColor = Color3.fromRGB(0, 255, 255), -- Varsayılan Mavi
    
    -- Gelişmiş Görseller
    SkeletonEnabled = true,
    SkeletonColor = Color3.fromRGB(255, 255, 255),
    HeadDotEnabled = true,
    HeadDotColor = Color3.fromRGB(255, 255, 255),
    ViewDirectionEnabled = true,
    ViewDirectionColor = Color3.fromRGB(255, 100, 100),
    OffScreenArrows = true,
    ArrowColor = Color3.fromRGB(255, 0, 0),
    
    -- Tracers
    TracerEnabled = false,
    TracerOrigin = "Bottom", -- "Top", "Bottom", "Mouse"
    TracerColor = Color3.fromRGB(255, 255, 0),
    
    -- Chams (Düşman Vücudu)
    ChamsEnabled = false,
    ChamsVisibleColor = Color3.fromRGB(255, 0, 255),
    ChamsOccludedColor = Color3.fromRGB(255, 255, 255),
    ChamsTransparency = 0.5,
}

local drawings = {}
local highlights = {}
local weaponHighlights = {} -- Kendi silahımız için

local skeletonConnections = {
    {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"}, {"LowerTorso", "HumanoidRootPart"},
    {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
    {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"LowerTorso", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"},
    {"Head", "Torso"}, {"Torso", "HumanoidRootPart"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"}, {"Torso", "Left Leg"}, {"Torso", "Right Leg"}
}

local function createDrawing(class, props)
    local ok, obj = pcall(Drawing.new, class)
    if not ok then return nil end
    for k, v in pairs(props) do pcall(function() obj[k] = v end) end
    return obj
end

local function createCornerBox(color)
    local lines = {}
    for i = 1, 8 do
        table.insert(lines, createDrawing("Line", { Color = color, Thickness = 1, Visible = false }))
    end
    return lines
end

local function updateCornerBox(lines, x, y, w, h)
    local lenW = w * 0.2
    local lenH = h * 0.2
    lines[1].From = Vector2.new(x, y); lines[1].To = Vector2.new(x + lenW, y)
    lines[2].From = Vector2.new(x, y); lines[2].To = Vector2.new(x, y + lenH)
    lines[3].From = Vector2.new(x + w, y); lines[3].To = Vector2.new(x + w - lenW, y)
    lines[4].From = Vector2.new(x + w, y); lines[4].To = Vector2.new(x + w, y + lenH)
    lines[5].From = Vector2.new(x, y + h); lines[5].To = Vector2.new(x + lenW, y + h)
    lines[6].From = Vector2.new(x, y + h); lines[6].To = Vector2.new(x, y + h - lenH)
    lines[7].From = Vector2.new(x + w, y + h); lines[7].To = Vector2.new(x + w - lenW, y + h)
    lines[8].From = Vector2.new(x + w, y + h); lines[8].To = Vector2.new(x + w, y + h - lenH)
    for _, line in ipairs(lines) do line.Visible = true end
end

local function clearPlayerDrawings(player)
    if drawings[player] then
        for k, d in pairs(drawings[player]) do
            if type(d) == "table" then
                if d[1] and d[1].Remove then 
                    for _, sub in ipairs(d) do if sub and sub.Remove then pcall(function() sub:Remove() end) end end
                else
                    for _, sub in pairs(d) do if sub and sub.Remove then pcall(function() sub:Remove() end) end end
                end
            elseif d and d.Remove then pcall(function() d:Remove() end) end
        end
        drawings[player] = nil
    end
    if highlights[player] then
        if highlights[player].Parent then pcall(function() highlights[player]:Destroy() end) end
        highlights[player] = nil
    end
end

local function clearAll()
    for player, _ in pairs(drawings) do clearPlayerDrawings(player) end
    if weaponHighlights[LocalPlayer] then
        for _, hl in pairs(weaponHighlights[LocalPlayer]) do
            if hl and hl.Parent then pcall(function() hl:Destroy() end) end
        end
        weaponHighlights[LocalPlayer] = nil
    end
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
    local camViewport = Camera.ViewportSize
    local screenCenter = Vector2.new(camViewport.X / 2, camViewport.Y / 2)
    local mousePos = UserInputService:GetMouseLocation()
    local activePlayers = {}

    -- ==========================================
    -- 1. BİZİM SİLAHIMIZ (LOCAL WEAPON CHAMS)
    -- ==========================================
    local myTool = localChar:FindFirstChildOfClass("Tool")
    if myTool then
        if settings.LocalWeaponChamsEnabled then
            if not weaponHighlights[LocalPlayer] then weaponHighlights[LocalPlayer] = {} end
            for _, part in ipairs(myTool:GetDescendants()) do
                if part:IsA("BasePart") then
                    if not weaponHighlights[LocalPlayer][part] then
                        local hl = Instance.new("Highlight")
                        hl.Adornee = part
                        hl.Parent = part
                        weaponHighlights[LocalPlayer][part] = hl
                    end
                    local hl = weaponHighlights[LocalPlayer][part]
                    hl.FillColor = settings.LocalWeaponChamsColor
                    hl.OutlineColor = settings.LocalWeaponChamsColor
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                end
            end
        elseif weaponHighlights[LocalPlayer] then
            for _, hl in pairs(weaponHighlights[LocalPlayer]) do
                if hl and hl.Parent then hl:Destroy() end
            end
            weaponHighlights[LocalPlayer] = nil
        end
    elseif weaponHighlights[LocalPlayer] then
        for _, hl in pairs(weaponHighlights[LocalPlayer]) do
            if hl and hl.Parent then hl:Destroy() end
        end
        weaponHighlights[LocalPlayer] = nil
    end


    -- ==========================================
    -- 2. DÜŞMANLAR (ESP & CHAMS)
    -- ==========================================
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head")
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local isTeammate = settings.TeamCheck and (player.Team == myTeam) and myTeam ~= nil

            if hrp and head and humanoid and humanoid.Health > 0 and not isTeammate then
                activePlayers[player] = true
                
                -- Düşman Chams
                if settings.ChamsEnabled then
                    if not highlights[player] then
                        local hl = Instance.new("Highlight")
                        hl.Adornee = char
                        hl.Parent = char
                        highlights[player] = hl
                    end
                    local hl = highlights[player]
                    hl.FillColor = settings.ChamsVisibleColor
                    hl.OutlineColor = settings.ChamsOccludedColor
                    hl.FillTransparency = settings.ChamsTransparency
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                elseif highlights[player] then
                    pcall(function() highlights[player]:Destroy() end)
                    highlights[player] = nil
                end

                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                local tool = char:FindFirstChildOfClass("Tool")
                
                -- Ekran Dışı Okları
                if not onScreen and settings.OffScreenArrows then
                    local dir = (hrp.Position - Camera.CFrame.Position).Unit
                    local arrowX, arrowY
                    if math.abs(dir.X) > math.abs(dir.Z) then
                        arrowX = dir.X > 0 and camViewport.X - 50 or 50
                        arrowY = screenCenter.Y + (dir.Z * (camViewport.Y / 2))
                    else
                        arrowY = dir.Z > 0 and camViewport.Y - 50 or 50
                        arrowX = screenCenter.X + (dir.X * (camViewport.X / 2))
                    end
                    
                    if not drawings[player] then drawings[player] = {} end
                    if not drawings[player].oofArrow then
                        drawings[player].oofArrow = createDrawing("Text", { Size = 24, Center = true, Outline = true, Text = ">" })
                    end
                    local arrow = drawings[player].oofArrow
                    arrow.Color = settings.ArrowColor
                    arrow.Visible = true
                    arrow.Position = Vector2.new(arrowX, arrowY)
                    arrow.Text = dir.X > 0 and ">>" or "<<" 
                elseif drawings[player] and drawings[player].oofArrow then
                    drawings[player].oofArrow.Visible = false
                end
                
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
                        d.cornerBox = createCornerBox(settings.BoxColor)
                        d.fill = createDrawing("Square", { Color = settings.BoxColor, Thickness = 0, Filled = true, Transparency = 0.6 })
                    end
                    
                    if settings.BoxStyle == "Corner" then
                        d.box.Visible = false
                        updateCornerBox(d.cornerBox, x, y, width, height)
                        for _, line in ipairs(d.cornerBox) do line.Color = settings.BoxColor end
                    else
                        d.box.Color = settings.BoxColor
                        d.box.Visible = settings.BoxEnabled
                        d.box.Position = Vector2.new(x, y)
                        d.box.Size = Vector2.new(width, height)
                        for _, line in ipairs(d.cornerBox) do line.Visible = false end
                    end
                    
                    if d.fill then
                        d.fill.Color = settings.BoxColor
                        d.fill.Visible = settings.BoxFilled
                        d.fill.Position = Vector2.new(x, y)
                        d.fill.Size = Vector2.new(width, height)
                    end
                    
                    -- Kafa Noktası
                    if not d.headDot then d.headDot = createDrawing("Circle", { Color = settings.HeadDotColor, Thickness = 1, Filled = true, Radius = 4 }) end
                    d.headDot.Color = settings.HeadDotColor
                    d.headDot.Visible = settings.HeadDotEnabled
                    d.headDot.Position = Vector2.new(pos.X, y)
                    
                    -- İsim ve Mesafe
                    if not d.name then
                        d.name = createDrawing("Text", { Color = settings.NameColor, Size = 14, Center = true, Outline = true })
                        d.dist = createDrawing("Text", { Color = settings.DistanceColor, Size = 12, Center = true, Outline = true })
                    end
                    d.name.Color = settings.NameColor
                    d.name.Visible = settings.NameEnabled
                    d.name.Position = Vector2.new(pos.X, y - 16)
                    d.name.Text = player.Name
                    
                    d.dist.Color = settings.DistanceColor
                    d.dist.Visible = settings.DistanceEnabled
                    d.dist.Position = Vector2.new(pos.X, y + height + 4)
                    d.dist.Text = math.floor((localPos - hrp.Position).Magnitude) .. "m"
                    
                    -- SİLAH 2D KUTU VE YAZI (Düşman için)
                    if not d.weaponText then
                        d.weaponText = createDrawing("Text", { Size = 12, Center = true, Outline = true })
                        d.weaponBox = createDrawing("Square", { Thickness = 1, Filled = false })
                    end
                    
                    if tool then
                        local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
                        if handle then
                            local wPos, wOnScreen = Camera:WorldToViewportPoint(handle.Position)
                            if wOnScreen then
                                d.weaponBox.Color = settings.WeaponBoxColor
                                d.weaponBox.Visible = settings.WeaponBoxEnabled
                                d.weaponBox.Position = Vector2.new(wPos.X - 10, wPos.Y - 10)
                                d.weaponBox.Size = Vector2.new(20, 20)
                            else
                                d.weaponBox.Visible = false
                            end
                        end
                        d.weaponText.Color = settings.WeaponTextColor
                        d.weaponText.Visible = settings.WeaponTextEnabled
                        d.weaponText.Position = Vector2.new(pos.X, y + height + 18)
                        d.weaponText.Text = "[" .. tool.Name .. "]"
                    else
                        d.weaponText.Visible = false
                        d.weaponBox.Visible = false
                    end
                    
                    -- Can Barı
                    if not d.healthBar then
                        d.healthBg = createDrawing("Square", { Color = Color3.fromRGB(20, 20, 20), Thickness = 0, Filled = true })
                        d.healthBar = createDrawing("Square", { Color = Color3.fromRGB(0, 255, 0), Thickness = 0, Filled = true })
                        d.hpText = createDrawing("Text", { Size = 11, Center = false, Outline = true })
                    end
                    
                    d.healthBg.Visible = settings.HealthEnabled
                    d.healthBar.Visible = settings.HealthEnabled
                    if settings.HealthEnabled then
                        local hp = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                        d.healthBg.Position = Vector2.new(x - 6, y)
                        d.healthBg.Size = Vector2.new(3, height)
                        d.healthBar.Position = Vector2.new(x - 6, y + height - (height * hp))
                        d.healthBar.Size = Vector2.new(3, height * hp)
                        if hp > 0.6 then d.healthBar.Color = Color3.fromRGB(0, 255, 0)
                        elseif hp > 0.3 then d.healthBar.Color = Color3.fromRGB(255, 255, 0)
                        else d.healthBar.Color = Color3.fromRGB(255, 0, 0) end
                        
                        d.hpText.Visible = settings.HealthTextEnabled
                        d.hpText.Position = Vector2.new(x - 16, y + height - (height * hp) - 6)
                        d.hpText.Text = tostring(math.floor(humanoid.Health))
                        d.hpText.Color = d.healthBar.Color
                    else
                        d.hpText.Visible = false
                    end
                    
                    -- Bakış Yönü
                    if not d.viewLine then d.viewLine = createDrawing("Line", { Thickness = 1 }) end
                    d.viewLine.Visible = settings.ViewDirectionEnabled
                    if settings.ViewDirectionEnabled then
                        local lookVec = head.CFrame.LookVector * 8
                        local vEndPos = Camera:WorldToViewportPoint(head.Position + lookVec)
                        d.viewLine.Color = settings.ViewDirectionColor
                        d.viewLine.From = Vector2.new(pos.X, y)
                        d.viewLine.To = Vector2.new(vEndPos.X, vEndPos.Y)
                    end
                    
                    -- Tracer
                    if not d.tracer then d.tracer = createDrawing("Line", { Color = settings.TracerColor, Thickness = 1, Transparency = 0.5 }) end
                    d.tracer.Visible = settings.TracerEnabled
                    d.tracer.Color = settings.TracerColor
                    local fromPos = Vector2.new(camViewport.X / 2, camViewport.Y)
                    if settings.TracerOrigin == "Top" then fromPos = Vector2.new(camViewport.X / 2, 0)
                    elseif settings.TracerOrigin == "Mouse" then fromPos = Vector2.new(mousePos.X, mousePos.Y) end
                    d.tracer.From = fromPos
                    d.tracer.To = Vector2.new(pos.X, y + (height / 2))
                    
                    -- İskelet
                    if not d.skeleton then d.skeleton = {} end
                    if settings.SkeletonEnabled then
                        local lineIdx = 1
                        for _, conn in ipairs(skeletonConnections) do
                            local part1 = char:FindFirstChild(conn[1])
                            local part2 = char:FindFirstChild(conn[2])
                            if part1 and part2 then
                                local p1, on1 = Camera:WorldToViewportPoint(part1.Position)
                                local p2, on2 = Camera:WorldToViewportPoint(part2.Position)
                                if on1 or on2 then
                                    if not d.skeleton[lineIdx] then d.skeleton[lineIdx] = createDrawing("Line", { Thickness = 1, Transparency = 0.4 }) end
                                    local line = d.skeleton[lineIdx]
                                    line.Color = settings.SkeletonColor
                                    line.From = Vector2.new(p1.X, p1.Y)
                                    line.To = Vector2.new(p2.X, p2.Y)
                                    line.Visible = true
                                    lineIdx = lineIdx + 1
                                end
                            end
                        end
                        for i = lineIdx, #d.skeleton do if d.skeleton[i] then d.skeleton[i].Visible = false end end
                    else
                        for _, line in ipairs(d.skeleton) do if line then line.Visible = false end end
                    end
                    
                else
                    -- Ekranda değilse gizle
                    if drawings[player] then
                        for k, drawing in pairs(drawings[player]) do
                            if k ~= "oofArrow" then
                                if type(drawing) == "table" then
                                    if drawing[1] and drawing[1].Remove then 
                                        for _, sub in ipairs(drawing) do if sub then sub.Visible = false end end
                                    else
                                        for _, sub in pairs(drawing) do if sub and sub.Visible then sub.Visible = false end end
                                    end
                                elseif drawing and drawing.Visible then drawing.Visible = false end
                            end
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
