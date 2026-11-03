-- src/esp.lua (Full ESP + Chams)
local ESP = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local settings = {
    Enabled = false, Tracers = false, Chams = false, WeaponChams = false,
    Color = Color3.fromRGB(255, 0, 255)
}

local drawings = {}
local highlights = {}

function ESP.Set(key, val) if settings[key] ~= nil then settings[key] = val end end
function ESP.Toggle(state) settings.Enabled = state end

RunService.RenderStepped:Connect(function()
    pcall(function()
        if not settings.Enabled and not settings.Chams and not settings.WeaponChams then 
            for p, d in pairs(drawings) do for _, o in pairs(d) do o:Remove() end end
            drawings = {}
            for p, h in pairs(highlights) do h:Destroy() end
            highlights = {}
            return 
        end

        -- Weapon Chams
        local myTool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if settings.WeaponChams and myTool and not highlights[myTool] then
            local h = Instance.new("Highlight", myTool)
            h.FillColor = Color3.fromRGB(0, 255, 255)
            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlights[myTool] = h
        end

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local char, hrp, head, hum = p.Character, p.Character:FindFirstChild("HumanoidRootPart"), p.Character:FindFirstChild("Head"), p.Character:FindFirstChildOfClass("Humanoid")
                
                if hrp and head and hum and hum.Health > 0 then
                    -- Chams
                    if settings.Chams and not highlights[p] then
                        local h = Instance.new("Highlight", char)
                        h.FillColor = settings.Color
                        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        highlights[p] = h
                    elseif not settings.Chams and highlights[p] then
                        highlights[p]:Destroy() highlights[p] = nil
                    end

                    -- 2D ESP (WorldToScreenPoint ile kaymaz)
                    if settings.Enabled then
                        local pos, onScreen = Camera:WorldToScreenPoint(hrp.Position)
                        if onScreen then
                            if not drawings[p] then
                                drawings[p] = {
                                    Box = Drawing.new("Square"), Name = Drawing.new("Text"),
                                    HP = Drawing.new("Square"), HPBg = Drawing.new("Square"),
                                    Tracer = Drawing.new("Line")
                                }
                                drawings[p].Box.Thickness = 1 drawings[p].Name.Size = 12
                                drawings[p].Name.Center = true drawings[p].Name.Outline = true
                            end
                            
                            local d = drawings[p]
                            local headPos = Camera:WorldToScreenPoint(head.Position + Vector3.new(0, 0.5, 0))
                            local legPos = Camera:WorldToScreenPoint(hrp.Position - Vector3.new(0, 3, 0))
                            local h, w = math.abs(headPos.Y - legPos.Y), math.abs(headPos.Y - legPos.Y) / 2
                            local x, y = pos.X - w/2, headPos.Y

                            d.Box.Color = settings.Color
                            d.Box.Position = Vector2.new(x, y)
                            d.Box.Size = Vector2.new(w, h)
                            d.Box.Visible = true
                            
                            d.Name.Color = Color3.new(1,1,1)
                            d.Name.Position = Vector2.new(pos.X, y - 16)
                            d.Name.Text = p.Name .. " (" .. math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude) .. "m)"
                            d.Name.Visible = true
                            
                            local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                            d.HPBg.Color = Color3.new(0,0,0)
                            d.HPBg.Position = Vector2.new(x - 5, y)
                            d.HPBg.Size = Vector2.new(2, h)
                            d.HPBg.Visible = true
                            
                            d.HP.Color = Color3.fromRGB(0, 255, 0)
                            d.HP.Position = Vector2.new(x - 5, y + h - (h * hp))
                            d.HP.Size = Vector2.new(2, h * hp)
                            d.HP.Visible = true
                            
                            if settings.Tracers then
                                d.Tracer.Color = settings.Color
                                d.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                                d.Tracer.To = Vector2.new(pos.X, y + h/2)
                                d.Tracer.Visible = true
                            else d.Tracer.Visible = false end
                        else
                            for _, o in pairs(drawings[p]) do o.Visible = false end
                        end
                    end
                end
            end
        end
    end)
end)

return ESP
