-- 💀 SPRINGLOCK V3 + KEY SYSTEM

if not game:IsLoaded() then game.Loaded:Wait() end

local player = game.Players.LocalPlayer
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local correctKey = "Springlock_Fails"
local savedKey = "SPRINGLOCK_KEY_SAVE"

--------------------------------------------------
-- 🔐 CHECK SAVE
--------------------------------------------------
local hasKey = false

pcall(function()
    if readfile and isfile and isfile(savedKey..".txt") then
        if readfile(savedKey..".txt") == correctKey then
            hasKey = true
        end
    end
end)

--------------------------------------------------
-- 📱 GUI KEY
--------------------------------------------------
local gui = Instance.new("ScreenGui",player.PlayerGui)

local keyFrame = Instance.new("Frame",gui)
keyFrame.Size = UDim2.new(0,260,0,180)
keyFrame.Position = UDim2.new(0.4,0,0.3,0)
keyFrame.BackgroundColor3 = Color3.fromRGB(20,0,0)

local title = Instance.new("TextLabel",keyFrame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "🔐 ENTER KEY"
title.TextColor3 = Color3.fromRGB(255,0,0)
title.BackgroundTransparency = 1

local box = Instance.new("TextBox",keyFrame)
box.Size = UDim2.new(0.8,0,0,40)
box.Position = UDim2.new(0.1,0,0.4,0)
box.PlaceholderText = "ENTER KEY..."

local status = Instance.new("TextLabel",keyFrame)
status.Size = UDim2.new(1,0,0,30)
status.Position = UDim2.new(0,0,0.7,0)
status.Text = ""
status.TextColor3 = Color3.fromRGB(255,0,0)
status.BackgroundTransparency = 1

local enter = Instance.new("TextButton",keyFrame)
enter.Size = UDim2.new(0.8,0,0,40)
enter.Position = UDim2.new(0.1,0,0.55,0)
enter.Text = "ENTER"

--------------------------------------------------
-- 💀 MAIN GUI FUNCTION
--------------------------------------------------
local function loadMain()

    keyFrame:Destroy()

    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    local hrp = char:WaitForChild("HumanoidRootPart")

    --------------------------------------------------
    -- GUI MAIN
    --------------------------------------------------
    local frame = Instance.new("Frame",gui)
    frame.Size = UDim2.new(0,260,0,220)
    frame.Position = UDim2.new(0.4,0,0.3,0)
    frame.BackgroundColor3 = Color3.fromRGB(20,0,0)
    frame.Active = true

    local title = Instance.new("TextLabel",frame)
    title.Size = UDim2.new(1,0,0,30)
    title.Text = "💀 SPRINGLOCK"
    title.TextColor3 = Color3.fromRGB(255,0,0)
    title.BackgroundTransparency = 1

    local statusText = Instance.new("TextLabel",frame)
    statusText.Size = UDim2.new(1,0,0,40)
    statusText.Position = UDim2.new(0,0,0.3,0)
    statusText.Text = "STABLE"
    statusText.TextColor3 = Color3.fromRGB(255,0,0)
    statusText.BackgroundTransparency = 1

    --------------------------------------------------
    -- ANIMASI
    --------------------------------------------------
    local active = false
    local camCon
    local dmgCon

    local function animate()
        for i=1,25 do
            hrp.CFrame = hrp.CFrame * CFrame.Angles(
                math.rad(math.random(-8,8)),
                math.rad(math.random(-8,8)),
                0
            )
            hum.WalkSpeed = 0
            task.wait(0.03)
            hum.WalkSpeed = 6
            task.wait(0.03)
        end
    end

    local function cameraShake()
        camCon = RunService.RenderStepped:Connect(function()
            local cam = workspace.CurrentCamera
            cam.CFrame *= CFrame.new(
                math.random(-1,1)/40,
                math.random(-1,1)/40,
                0
            )
        end)
    end

    local function start()
        if active then return end
        active = true

        statusText.Text = "⚠️ FAILURE"

        animate()
        hum.WalkSpeed = 4
        hum.JumpPower = 0

        Lighting.Brightness = 0.2
        Lighting.ClockTime = 0

        cameraShake()

        dmgCon = RunService.RenderStepped:Connect(function()
            if hum.Health > 5 then
                hum.Health -= 0.15
            end
        end)
    end

    local function reset()
        active = false

        hum.WalkSpeed = 16
        hum.JumpPower = 50
        Lighting.Brightness = 1

        if camCon then camCon:Disconnect() end
        if dmgCon then dmgCon:Disconnect() end

        statusText.Text = "STABLE"
    end

    --------------------------------------------------
    -- BUTTON
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

    --------------------------------------------------
    -- DRAG
    --------------------------------------------------
    local dragging, dragStart, startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    frame.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

--------------------------------------------------
-- 🔐 ENTER BUTTON
--------------------------------------------------
enter.MouseButton1Click:Connect(function()
    if box.Text == correctKey then
        status.Text = "ACCESS GRANTED"

        pcall(function()
            if writefile then
                writefile(savedKey..".txt", correctKey)
            end
        end)

        task.wait(1)
        loadMain()
    else
        status.Text = "WRONG KEY"
    end
end)

--------------------------------------------------
-- AUTO LOGIN
--------------------------------------------------
if hasKey then
    loadMain()
end
