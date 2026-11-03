-- src/menu.lua (Mobile Basit Menü)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local NL = getgenv().Neverlose or {}

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "SimpleMenu" ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 240, 0, 380)
MainFrame.Position = UDim2.new(0.5, -120, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(255, 0, 255)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30) Title.BackgroundTransparency = 1
Title.Text = "Basit Menu" Title.TextColor3 = Color3.fromRGB(255, 0, 255) Title.Font = Enum.Font.GothamBold

local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -10, 1, -40) Scroll.Position = UDim2.new(0, 5, 0, 35)
Scroll.BackgroundTransparency = 1 Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y Scroll.CanvasSize = UDim2.new(0,0,0,0) Scroll.ScrollBarThickness = 2
Instance.new("UIListLayout", Scroll).Padding = UDim.new(0, 5)

local function createBtn(text, callback)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(1, 0, 0, 32) btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.Text = text btn.TextColor3 = Color3.new(1,1,1) btn.Font = Enum.Font.GothamMedium btn.TextSize = 12
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " [ON]" or " [OFF]")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(30, 30, 40)
        callback(state)
    end)
end

-- Aimbot
if NL["aimbot"] then
    createBtn("Aimbot", function(s) NL["aimbot"].Toggle(s) end)
    createBtn("Aimbot FOV (200)", function(s) NL["aimbot"].Set("FOV", s and 300 or 200) end)
end

-- ESP
if NL["esp"] then
    createBtn("ESP Box & HP", function(s) NL["esp"].Toggle(s) end)
    createBtn("ESP Tracers", function(s) NL["esp"].Set("Tracers", s) end)
    createBtn("ESP Chams", function(s) NL["esp"].Set("Chams", s) end)
    createBtn("Weapon Chams", function(s) NL["esp"].Set("WeaponChams", s) end)
end

local FAB = Instance.new("TextButton", ScreenGui)
FAB.Size = UDim2.fromOffset(50, 50) FAB.Position = UDim2.new(1, -70, 1, -100)
FAB.BackgroundColor3 = Color3.fromRGB(25, 25, 30) FAB.Text = "NL" FAB.TextColor3 = Color3.new(1,1,1) FAB.Font = Enum.Font.GothamBold
Instance.new("UICorner", FAB).CornerRadius = UDim.new(1, 0)
FAB.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

return { Status = "Loaded" }
