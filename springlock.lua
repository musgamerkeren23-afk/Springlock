-- 💀 SPRING BONNIE FULL SYSTEM

if not game:IsLoaded() then game.Loaded:Wait() end

local player = game.Players.LocalPlayer
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

--------------------------------------------------
-- 🐰 SUIT SPRING BONNIE
--------------------------------------------------
for _,v in pairs(char:GetDescendants()) do
    if v:IsA("BasePart") then
        v.Color = Color3.fromRGB(255,204,0)
        v.Material = Enum.Material.SmoothPlastic
    end
end

-- hapus face
local head = char:FindFirstChild("Head")
if head and head:FindFirstChild("face") then
    head.face:Destroy()
end

--------------------------------------------------
-- 🌫️ AURA
--------------------------------------------------
local aura = Instance.new("ParticleEmitter", hrp)
aura.Color = ColorSequence.new(Color3.fromRGB(255,204,0))
aura.Rate = 10
aura.Size = NumberSequence.new(0.6)

--------------------------------------------------
-- 🎛️ MODE
--------------------------------------------------
local mode = "KIDS"

--------------------------------------------------
-- 📱 GUI
--------------------------------------------------
local gui = Instance.new("ScreenGui",player.PlayerGui)

local frame = Instance.new("Frame",gui)
frame.Size = UDim2.new(0,260,0,230)
frame.Position = UDim2.new(0.4,0,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(20,0,0)
frame.Active = true

local title = Instance.new("TextLabel",frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "💀 SPRING BONNIE"
title.TextColor3 = Color3.fromRGB(255,0,0)
title.BackgroundTransparency = 1

local status = Instance.new("TextLabel",frame)
status.Size = UDim2.new(1,0,0,40)
status.Position = UDim2.new(0,0,0.3,0)
status.Text = "STABLE"
status.TextColor3 = Color3.fromRGB(255,0,0)
status.BackgroundTransparency = 1

--------------------------------------------------
-- ⚙️ SETTINGS POPUP
--------------------------------------------------
local settings = Instance.new("Frame",gui)
settings.Size = UDim2.new(0,200,0,180)
settings.Position = UDim2.new(0.5,-100,0.5,-90)
settings.BackgroundColor3 = Color3.fromRGB(15,0,0)
settings.Visible = false
settings.Active = true

local function modeBtn(name,y)
    local b = Instance.new("TextButton",settings)
    b.Size = UDim2.new(0.8,0,0,40)
    b.Position = UDim2.new(0.1,0,0,y)
    b.Text = name
    b.TextColor3 = Color3.fromRGB(255,0,0)

    b.MouseButton1Click:Connect(function()
        mode = name
    end)
end

modeBtn("KIDS",0.2)
modeBtn("ADULT",0.5)
modeBtn("MATURE",0.75)

--------------------------------------------------
-- 🎬 ANIMASI SPRINGLOCK
--------------------------------------------------
local active = false
local con

local function animate()
    for i=1,15 do
        hum.WalkSpeed = 0
        task.wait(0.04)
        hum.WalkSpeed = 5
        task.wait(0.04)
    end
end

local function start()
    if active then return end
    active = true

    status.Text = "⚠️ FAILURE"

    animate()

    hum.WalkSpeed = 4
    hum.JumpPower = 0

    if mode == "KIDS" then
        Lighting.Brightness = 1

    elseif mode == "ADULT" then
        Lighting.Brightness = 0.5
        Lighting.ClockTime = 0

    elseif mode == "MATURE" then
        Lighting.Brightness = 0.2
        Lighting.ClockTime = 0

        con = RunService.RenderStepped:Connect(function()
            frame.Position = frame.Position + UDim2.new(0,math.random(-2,2),0,math.random(-2,2))
            if hum.Health > 5 then
                hum.Health -= 0.15
            end
        end)
    end
end

--------------------------------------------------
-- RESET
--------------------------------------------------
local function reset()
    active = false

    hum.WalkSpeed = 16
    hum.JumpPower = 50
    Lighting.Brightness = 1

    if con then con:Disconnect() end

    status.Text = "STABLE"
end

--------------------------------------------------
-- BUTTONS
--------------------------------------------------
local trigger = Instance.new("TextButton",frame)
trigger.Size = UDim2.new(0.9,0,0,40)
trigger.Position = UDim2.new(0.05,0,0.55,0)
trigger.Text = "TRIGGER"

trigger.MouseButton1Click:Connect(start)

local resetBtn = Instance.new("TextButton",frame)
resetBtn.Size = UDim2.new(0.9,0,0,40)
resetBtn.Position = UDim2.new(0.05,0,0.75,0)
resetBtn.Text = "RESET"

resetBtn.MouseButton1Click:Connect(reset)

local setBtn = Instance.new("TextButton",frame)
setBtn.Size = UDim2.new(0,40,0,30)
setBtn.Position = UDim2.new(1,-45,0,0)
setBtn.Text = "⚙"

setBtn.MouseButton1Click:Connect(function()
    settings.Visible = not settings.Visible
end)

--------------------------------------------------
-- 🖱️ DRAG FUNCTION (UNTUK SEMUA GUI)
--------------------------------------------------
local function makeDraggable(obj)
    local dragging, start, pos

    obj.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            start = i.Position
            pos = obj.Position
        end
    end)

    obj.InputChanged:Connect(function(i)
        if dragging then
            local delta = i.Position - start
            obj.Position = UDim2.new(
                pos.X.Scale,
                pos.X.Offset + delta.X,
                pos.Y.Scale,
                pos.Y.Offset + delta.Y
            )
        end
    end)

    obj.InputEnded:Connect(function()
        dragging = false
    end)
end

makeDraggable(frame)
makeDraggable(settings)
