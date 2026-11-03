-- src/menu.lua (Crash-Proof Mobile Menu)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Loader'dan Modülleri Çek (Hata Korumalı)
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

-- Menünün tamamını hata korumasına al (Oyun çökmesini engeller)
local success, err = pcall(function()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NeverloseMobileMenu"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 999
    -- Önce CoreGui'ye atmayı dene, hata verirse PlayerGui'ye at
    local coreSuccess = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
    if not coreSuccess or not ScreenGui.Parent then 
        ScreenGui.Parent = PlayerGui 
    end

    -- Ana Çerçeve
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 340, 0, 460)
    MainFrame.Position = UDim2.new(0.5, -170, 0.5, -230)
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

    -- Başlık
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
    CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

    -- SEKME BUTONLARI (Tabs)
    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(1, -10, 0, 30)
    TabBar.Position = UDim2.new(0, 5, 0, 38)
    TabBar.BackgroundTransparency = 1
    TabBar.Parent = MainFrame

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.Padding = UDim.new(0, 4)
    TabLayout.Parent = TabBar

    local TabContents = Instance.new("Frame")
    TabContents.Size = UDim2.new(1, -20, 1, -78)
    TabContents.Position = UDim2.new(0, 10, 0, 72)
    TabContents.BackgroundTransparency = 1
    TabContents.Parent = MainFrame

    -- Sayfa Oluşturucu
    local Pages = {}
    local function createPage(name)
        local scroll = Instance.new("ScrollingFrame")
        scroll.Size = UDim2.new(1, 0, 1, 0)
        scroll.BackgroundTransparency = 1
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        scroll.ScrollBarThickness = 4
        scroll.Visible = false
        scroll.Parent = TabContents
        
        local list = Instance.new("UIListLayout")
        list.SortOrder = Enum.SortOrder.LayoutOrder
        list.Padding = UDim.new(0, 6)
        list.Parent = scroll
        
        Pages[name] = scroll
        return scroll
    end

    -- UI ELEMAN OLUŞTURUCULAR (Fonksiyonları pcall ile koru)
    local function createHeader(parent, text)
        pcall(function()
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 24)
            lbl.BackgroundTransparency = 1
            lbl.Text = "--- " .. text .. " ---"
            lbl.TextColor3 = Color3.fromRGB(255, 0, 255)
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 13
            lbl.Parent = parent
        end)
    end

    local function createToggle(parent, name, default, callback)
        pcall(function()
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 34)
            btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            local enabled = default or false
            btn.Text = (enabled and "  [ON] " or "  [OFF] ") .. name
            btn.TextColor3 = enabled and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(200, 200, 200)
            btn.Font = Enum.Font.GothamMedium
            btn.TextSize = 13
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.Parent = parent
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                enabled = not enabled
                btn.Text = (enabled and "  [ON] " or "  [OFF] ") .. name
                btn.TextColor3 = enabled and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(200, 200, 200)
                if callback then pcall(callback, enabled) end -- Callback'i güvene al
            end)
        end)
    end

    local function createSlider(parent, name, min, max, default, step, callback)
        pcall(function()
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 34)
            btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            btn.Text = "  " .. name .. " : " .. tostring(default)
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            btn.Font = Enum.Font.GothamMedium
            btn.TextSize = 13
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.Parent = parent
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = btn
            
            local currentVal = default
            btn.MouseButton1Click:Connect(function()
                currentVal = currentVal + step
                if currentVal > max then currentVal = min end
                btn.Text = "  " .. name .. " : " .. tostring(currentVal)
                if callback then pcall(callback, currentVal) end
            end)
        end)
    end

    local function createDropdown(parent, name, options, callback)
        pcall(function()
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 34)
            btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            btn.Text = "  " .. name .. " : " .. options[1]
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            btn.Font = Enum.Font.GothamMedium
            btn.TextSize = 13
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.Parent = parent
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = btn
            
            local currentIndex = 1
            btn.MouseButton1Click:Connect(function()
                currentIndex = currentIndex + 1
                if currentIndex > #options then currentIndex = 1 end
                btn.Text = "  " .. name .. " : " .. options[currentIndex]
                if callback then pcall(callback, options[currentIndex]) end
            end)
        end)
    end

    local function createColorPicker(parent, name, callback)
        pcall(function()
            local colors = {["Kirmizi"] = Color3.fromRGB(255, 50, 50), ["Yesil"] = Color3.fromRGB(0, 255, 128), ["Mavi"] = Color3.fromRGB(50, 150, 255), ["Sari"] = Color3.fromRGB(255, 255, 0), ["Mor"] = Color3.fromRGB(255, 0, 255), ["Beyaz"] = Color3.fromRGB(255, 255, 255)}
            local colorNames = {"Kirmizi", "Yesil", "Mavi", "Sari", "Mor", "Beyaz"}
            
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 34)
            btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            btn.Text = "  " .. name .. " : " .. colorNames[1]
            btn.TextColor3 = colors[colorNames[1]]
            btn.Font = Enum.Font.GothamMedium
            btn.TextSize = 13
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.Parent = parent
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = btn
            
            local currentIndex = 1
            btn.MouseButton1Click:Connect(function()
                currentIndex = currentIndex + 1
                if currentIndex > #colorNames then currentIndex = 1 end
                local colName = colorNames[currentIndex]
                btn.Text = "  " .. name .. " : " .. colName
                btn.TextColor3 = colors[colName]
                if callback then pcall(callback, colors[colName]) end
            end)
        end)
    end

    -- SAYFA İÇERİKLERİ
    local ragePage = createPage("Rage")
    createHeader(ragePage, "RAGEBOT")
    if Rage then
        createToggle(ragePage, "Enable Ragebot", false, function(s) Rage.Toggle(s) end)
        createSlider(ragePage, "FOV", 10, 360, 360, 10, function(v) Rage.Set("FOV", v) end)
        createDropdown(ragePage, "Hitbox", {"Head", "Chest"}, function(v) Rage.Set("Hitbox", v) end)
        createToggle(ragePage, "Auto Fire", true, function(s) Rage.Set("AutoFire", s) end)
    end
    createHeader(ragePage, "ANTI-AIM")
    if AntiAim then
        createToggle(ragePage, "Enable Anti-Aim", false, function(s) AntiAim.Toggle(s) end)
        createDropdown(ragePage, "AA Mode", {"Mevlana", "Backward"}, function(v) AntiAim.Set("Mode", v) end)
        createSlider(ragePage, "AA Speed", 1, 50, 15, 1, function(v) AntiAim.Set("Speed", v) end)
    end

    local legitPage = createPage("Legit")
    createHeader(legitPage, "LEGITBOT")
    if Aimbot then
        createToggle(legitPage, "Enable Legitbot", false, function(s) Aimbot.Toggle(s) end)
        createSlider(legitPage, "FOV", 10, 360, 150, 10, function(v) Aimbot.Set("FOV", v) end)
        createSlider(legitPage, "Smoothness", 1, 20, 2, 1, function(v) Aimbot.Set("Smoothness", v) end)
        createDropdown(legitPage, "Hitbox", {"Head", "Chest"}, function(v) Aimbot.Set("Hitbox", v) end)
        createToggle(legitPage, "Wall Check", true, function(s) Aimbot.Set("WallCheck", s) end)
    end
    createHeader(legitPage, "TRIGGERBOT")
    if Trigger then
        createToggle(legitPage, "Enable Triggerbot", false, function(s) Trigger.Toggle(s) end)
        createSlider(legitPage, "Trigger Delay (ms)", 10, 500, 50, 10, function(v) Trigger.Set("Delay", v) end)
        createDropdown(legitPage, "Trigger Hitbox", {"Head", "Chest", "Any"}, function(v) Trigger.Set("Hitbox", v) end)
    end

    local visPage = createPage("Visuals")
    createHeader(visPage, "ESP")
    if ESP then
        createToggle(visPage, "Enable ESP", false, function(s) ESP.Toggle(s) end)
        createToggle(visPage, "Box", true, function(s) ESP.Set("BoxEnabled", s) end)
        createDropdown(visPage, "Box Style", {"Normal", "Corner"}, function(v) ESP.Set("BoxStyle", v) end)
        createColorPicker(visPage, "Box Color", function(c) ESP.Set("BoxColor", c) end)
        createToggle(visPage, "Name", true, function(s) ESP.Set("NameEnabled", s) end)
        createToggle(visPage, "Health", true, function(s) ESP.Set("HealthEnabled", s) end)
        createToggle(visPage, "Skeleton", false, function(s) ESP.Set("SkeletonEnabled", s) end)
        createHeader(visPage, "CHAMS")
        createToggle(visPage, "Enable Chams", false, function(s) ESP.Set("ChamsEnabled", s) end)
        createColorPicker(visPage, "Chams Color", function(c) ESP.Set("ChamsColor", c) end)
        createHeader(visPage, "WEAPON CHAMS")
        createToggle(visPage, "Enable My Weapon Chams", false, function(s) ESP.Set("LocalWeaponChamsEnabled", s) end)
        createColorPicker(visPage, "Weapon Color", function(c) ESP.Set("LocalWeaponChamsColor", c) end)
    end

    local movePage = createPage("Movement")
    createHeader(movePage, "BUNNYHOP")
    if Movement then
        createToggle(movePage, "Enable Bhop", false, function(s) Movement.Set("BhopEnabled", s) end)
        createSlider(movePage, "Bhop Speed", 16, 200, 50, 10, function(v) Movement.Set("BhopSpeed", v) end)
        createHeader(movePage, "AIR STRAFE")
        createToggle(movePage, "Enable Air Strafe", false, function(s) Movement.Set("AirStrafeEnabled", s) end)
        createSlider(movePage, "Strafe Power", 16, 200, 50, 10, function(v) Movement.Set("AirStrafeSpeed", v) end)
    end

    local combatPage = createPage("Combat")
    createHeader(combatPage, "WEAPON MODS")
    if Combat then
        createToggle(combatPage, "Enable Combat", false, function(s) Combat.Toggle(s) end)
        createToggle(combatPage, "Rapid Fire", false, function(s) Combat.Set("RapidFire", s) end)
        createSlider(combatPage, "Fire Rate (ms)", 10, 500, 60, 10, function(v) Combat.Set("FireRate", v) end)
        createToggle(combatPage, "No Recoil", false, function(s) Combat.Set("NoRecoil", s) end)
        createToggle(combatPage, "No Spread", false, function(s) Combat.Set("NoSpread", s) end)
    end
    createHeader(combatPage, "EXTRA")
    if Hitbox then
        createToggle(combatPage, "Hitbox Expander", false, function(s) Hitbox.Toggle(s) end)
        createSlider(combatPage, "Hitbox Size", 1, 5, 2, 1, function(v) Hitbox.Set("Size", v) end)
    end
    if HitSound then
        createToggle(combatPage, "Hit Sound", false, function(s) HitSound.Toggle(s) end)
    end

    -- Sekme Mantığı
    local tabs = {
        ["Rage"] = ragePage,
        ["Legit"] = legitPage,
        ["Visuals"] = visPage,
        ["Movement"] = movePage,
        ["Combat"] = combatPage
    }

    local function switchTab(name)
        pcall(function()
            for tabName, page in pairs(Pages) do
                page.Visible = (tabName == name)
            end
        end)
    end

    for tabName, _ in pairs(tabs) do
        pcall(function()
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0.19, 0, 1, 0)
            btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            btn.Text = tabName
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 11
            btn.Parent = TabBar
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = btn
            
            btn.MouseButton1Click:Connect(function() switchTab(tabName) end)
        end)
    end

    switchTab("Rage")

    -- FAB (Yuvarlak Buton)
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
            pcall(function()
                local delta = input.Position - dragStart
                FAB.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end)
        end
    end)

    FAB.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)
end)

if not success then
    warn("[Menu] UI Yuklenirken hata olustu (Crash engellendi): " .. tostring(err))
else
    print("[Menu] Mobil Arayuz basariyla yuklendi.")
end

return { Status = "Crash-Proof Mobile Menu Loaded" }
