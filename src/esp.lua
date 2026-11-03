-- ==============================================================================
-- NEVERLOSE ULTIMATE ESP (Kutu, Tracer, Chams, Weapon Chams, HP, İsim, Mesafe)
-- ==============================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Ayarlar (Menüden değiştirilebilir)
local settings = {
    ESP = true,
    Tracers = true,
    Chams = true,
    WeaponChams = true
}

-- Çizim Objeleri Havuzu
local espDrawings = {}
local enemyHighlights = {}
local weaponHighlights = {}

-- ==============================================================================
-- MENÜ (Mobil Uyumlu)
-- ==============================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NeverloseUltimateESP"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 180)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.Visible = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(255, 0, 255)

local FAB = Instance.new("TextButton")
FAB.Size = UDim2.fromOffset(50, 50)
FAB.Position = UDim2.new(1, -70, 1, -100)
FAB.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
FAB.Text = "ESP"
FAB.TextColor3 = Color3.fromRGB(255, 255, 255)
FAB.Font = Enum.Font.GothamBold
FAB.TextSize = 14
FAB.Parent = ScreenGui
Instance.new("UICorner", FAB).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", FAB).Color = Color3.fromRGB(255, 0, 255)

local function createBtn(text, yPos, defaultState, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 32)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(30, 30, 40)
    btn.Text = text .. (defaultState and ": ON" or ": OFF")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Parent = MainFrame
    
    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and ": ON" or ": OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(30, 30, 40)
        callback(state)
    end)
end

createBtn("Player ESP", 10, settings.ESP, function(s) settings.ESP = s end)
createBtn("Tracers", 50, settings.Tracers, function(s) settings.Tracers = s end)
createBtn("Enemy Chams", 90, settings.Chams, function(s) settings.Chams = s end)
createBtn("Weapon Chams", 130, settings.WeaponChams, function(s) settings.WeaponChams = s end)

FAB.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- ==============================================================================
-- TEMİZLİK FONKSİYONU (Bellek Sızıntısını Engeller)
-- ==============================================================================
local function cleanupESP(player)
    if espDrawings[player] then
        for _, obj in pairs(espDrawings[player]) do
            if obj and obj.Remove then obj:Remove() end
        end
        espDrawings[player] = nil
    end
    if enemyHighlights[player] then
        pcall(function() enemyHighlights[player]:Destroy() end)
        enemyHighlights[player] = nil
    end
end

-- ==============================================================================
-- ANA DÖNGÜ
-- ==============================================================================
RunService.RenderStepped:Connect(function()
    pcall(function()
        local localChar = LocalPlayer.Character
        if not localChar or not localChar:FindFirstChild("HumanoidRootPart") then return end
        
        -- 1. WEAPON CHAMS (Kendi Silahımız)
        local myTool = localChar:FindFirstChildOfClass("Tool")
        if settings.WeaponChams and myTool then
            if not weaponHighlights[LocalPlayer] then weaponHighlights[LocalPlayer] = {} end
            for _, part in ipairs(myTool:GetDescendants()) do
                if part:IsA("BasePart") then
                    if not weaponHighlights[LocalPlayer][part] then
                        local hl = Instance.new("Highlight")
                        hl.Adornee = part
                        hl.FillColor = Color3.fromRGB(0, 255, 255)
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        hl.Parent = part
                        weaponHighlights[LocalPlayer][part] = hl
                    end
                end
            end
        elseif weaponHighlights[LocalPlayer] then
            for _, hl in pairs(weaponHighlights[LocalPlayer]) do
                pcall(function() hl:Destroy() end)
            end
            weaponHighlights[LocalPlayer] = nil
        end

        -- 2. DÜŞMANLAR (ESP, Tracer, Chams)
        local activePlayers = {}
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local char = player.Character
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local head = char:FindFirstChild("Head")
                local hum = char:FindFirstChildOfClass("Humanoid")
                
                -- Takım kontrolü
                local isTeammate = player.Team == LocalPlayer.Team and LocalPlayer.Team ~= nil
                
                if hrp and head and hum and hum.Health > 0 and not isTeammate then
                    
                    -- CHAMS (Vücut)
                    if settings.Chams then
                        if not enemyHighlights[player] then
                            local hl = Instance.new("Highlight")
                            hl.Adornee = char
                            hl.FillColor = Color3.fromRGB(255, 0, 255)
                            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                            hl.FillTransparency = 0.4
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            hl.Parent = char
                            enemyHighlights[player] = hl
                        end
                    elseif enemyHighlights[player] then
                        pcall(function() enemyHighlights[player]:Destroy() end)
                        enemyHighlights[player] = nil
                    end

                    -- ESP (Kutu, İsim, Can, Tracer)
                    if settings.ESP then
                        -- WorldToScreenPoint: Çentik/İnset sorununu %100 çözer
                        local pos, onScreen = Camera:WorldToScreenPoint(hrp.Position)
                        
                        if onScreen then
                            activePlayers[player] = true
                            
                            if not espDrawings[player] then
                                espDrawings[player] = {
                                    Box = Drawing.new("Square"),
                                    Name = Drawing.new("Text"),
                                    Dist = Drawing.new("Text"),
                                    HPBg = Drawing.new("Square"),
                                    HP = Drawing.new("Square"),
                                    Tracer = Drawing.new("Line")
                                }
                                local d = espDrawings[player]
                                d.Box.Color = Color3.fromRGB(255, 0, 255)
                                d.Box.Thickness = 1
                                d.Box.Filled = false
                                
                                d.Name.Color = Color3.fromRGB(255, 255, 255)
                                d.Name.Size = 13
                                d.Name.Center = true
                                d.Name.Outline = true
                                
                                d.Dist.Color = Color3.fromRGB(200, 200, 200)
                                d.Dist.Size = 11
                                d.Dist.Center = true
                                d.Dist.Outline = true
                                
                                d.HPBg.Color = Color3.fromRGB(0, 0, 0)
                                d.HPBg.Filled = true
                                
                                d.HP.Color = Color3.fromRGB(0, 255, 0)
                                d.HP.Filled = true
                                
                                d.Tracer.Color = Color3.fromRGB(255, 255, 0)
                                d.Tracer.Thickness = 1
                                d.Tracer.Transparency = 0.6
                            end
                            
                            local d = espDrawings[player]
                            
                            -- Boyut Hesaplama
                            local headPos = Camera:WorldToScreenPoint(head.Position + Vector3.new(0, 0.5, 0))
                            local legPos = Camera:WorldToScreenPoint(hrp.Position - Vector3.new(0, 3, 0))
                            
                            local height = math.abs(headPos.Y - legPos.Y)
                            local width = height / 2
                            local x = pos.X - (width / 2)
                            local y = headPos.Y
                            
                            -- Kutu
                            d.Box.Position = Vector2.new(x, y)
                            d.Box.Size = Vector2.new(width, height)
                            d.Box.Visible = true
                            
                            -- İsim
                            d.Name.Position = Vector2.new(pos.X, y - 16)
                            d.Name.Text = player.Name
                            d.Name.Visible = true
                            
                            -- Mesafe
                            local distance = math.floor((localChar.HumanoidRootPart.Position - hrp.Position).Magnitude)
                            d.Dist.Position = Vector2.new(pos.X, y + height + 2)
                            d.Dist.Text = distance .. "m"
                            d.Dist.Visible = true
                            
                            -- Can Barı
                            local hpRatio = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                            d.HPBg.Position = Vector2.new(x - 6, y)
                            d.HPBg.Size = Vector2.new(2, height)
                            d.HPBg.Visible = true
                            
                            d.HP.Position = Vector2.new(x - 6, y + height - (height * hpRatio))
                            d.HP.Size = Vector2.new(2, height * hpRatio)
                            d.HP.Visible = true
                            
                            if hpRatio > 0.6 then d.HP.Color = Color3.fromRGB(0, 255, 0)
                            elseif hpRatio > 0.3 then d.HP.Color = Color3.fromRGB(255, 255, 0)
                            else d.HP.Color = Color3.fromRGB(255, 0, 0) end
                            
                            -- Tracer (Çizgi)
                            if settings.Tracers then
                                d.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                                d.Tracer.To = Vector2.new(pos.X, y + (height / 2))
                                d.Tracer.Visible = true
                            else
                                d.Tracer.Visible = false
                            end
                            
                        else
                            -- Ekranda değilse gizle
                            if espDrawings[player] then
                                local d = espDrawings[player]
                                d.Box.Visible = false
                                d.Name.Visible = false
                                d.Dist.Visible = false
                                d.HPBg.Visible = false
                                d.HP.Visible = false
                                d.Tracer.Visible = false
                            end
                        end
                    elseif espDrawings[player] then
                        -- ESP kapalıysa çizimleri gizle
                        local d = espDrawings[player]
                        d.Box.Visible = false
                        d.Name.Visible = false
                        d.Dist.Visible = false
                        d.HPBg.Visible = false
                        d.HP.Visible = false
                        d.Tracer.Visible = false
                    end
                end
            end
        end
        
        -- Ölen/Çıkan oyuncuların çizimlerini temizle
        for player, _ in pairs(espDrawings) do
            if not activePlayers[player] then
                if not player.Parent or not player.Character or not player.Character:FindFirstChild("Humanoid") or player.Character.Humanoid.Health <= 0 then
                    cleanupESP(player)
                end
            end
        end
    end)
end)

-- Oyundan çıkan oyuncuları temizle
Players.PlayerRemoving:Connect(function(player)
    cleanupESP(player)
end)
