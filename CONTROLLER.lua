--[[ 🛠 SETUP ]]--
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- Create RemoteEvents
local controlEvent = ReplicatedStorage:FindFirstChild("ArcControlEvent")
if not controlEvent then
    controlEvent = Instance.new("RemoteEvent", ReplicatedStorage)
    controlEvent.Name = "ArcControlEvent"
end

local detectionEvent = ReplicatedStorage:FindFirstChild("ArcDetectionEvent")
if not detectionEvent then
    detectionEvent = Instance.new("RemoteEvent", ReplicatedStorage)
    detectionEvent.Name = "ArcDetectionEvent"
end

local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local isMaster = localPlayer.Name == "DYLANcuriae25"

-- Store currently controlled player (on the server, if you want this persistent across sessions/rejoins)
-- For this client-side example, we'll track it locally for the master.
local controlledPlayerUserId = nil

--[[ 🧭 MASTER GUI ]]--
local playerGui = localPlayer:WaitForChild("PlayerGui")

local controllerGui = Instance.new("ScreenGui", playerGui)
controllerGui.Name = "ArcController"
controllerGui.ResetOnSpawn = false
controllerGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local main = Instance.new("Frame", controllerGui)
main.Name = "Main"
main.Size = UDim2.new(0, 300, 0, 200)
main.Position = UDim2.new(0, 50, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.BorderSizePixel = 0
main.AnchorPoint = Vector2.new(0, 0.5)
main.Active = true
main.Draggable = true
main.Visible = isMaster -- Initially visible for master, hidden otherwise

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 20)

local title = Instance.new("TextLabel", main)
title.Text = "Arc Controller"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -10, 1, -40)
scroll.Position = UDim2.new(0, 5, 0, 35)
scroll.CanvasSize = UDim2.new(0, 0, 0, 300)
scroll.ScrollBarThickness = 4
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0

Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 5)

local function createButton(text, callback)
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.AutoButtonColor = true
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    btn.MouseButton1Click:Connect(callback)
    return btn -- Return the button for potential updates
end

if isMaster then
    createButton("Jump", function()
        controlEvent:FireAllClients("Jump", localPlayer)
    end)

    createButton("Follow Master", function()
        controlEvent:FireAllClients("Follow", localPlayer)
    end)

    local detectButton = createButton("Detect Controlled", function()
        if controlledPlayerUserId then
            local controlledPlayer = Players:GetPlayerByUserId(controlledPlayerUserId)
            if controlledPlayer then
                detectButton.Text = "Controlled: " .. controlledPlayer.Name
            else
                detectButton.Text = "None Detected"
                controlledPlayerUserId = nil -- Reset if player left
            end
        else
            detectButton.Text = "None Detected"
        end
    end)

    -- Listen for detection events from clients
    detectionEvent.OnClientEvent:Connect(function(command, userId)
        if command == "Controlled" then
            controlledPlayerUserId = userId
            local controlledPlayer = Players:GetPlayerByUserId(controlledPlayerUserId)
            if controlledPlayer then
                detectButton.Text = "Controlled: " .. controlledPlayer.Name
            end
        end
    end)
end

-- Toggle Button
local toggleButton = Instance.new("TextButton", controllerGui)
toggleButton.Text = "<"
toggleButton.Size = UDim2.new(0, 30, 0, 60)
toggleButton.Position = UDim2.new(0, 0, 0.5, -30)
toggleButton.AnchorPoint = Vector2.new(0, 0.5)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.GothamBlack
toggleButton.TextSize = 20
toggleButton.Visible = isMaster
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(1, 0)

local isHidden = false

toggleButton.MouseButton1Click:Connect(function()
    if isHidden == false then
        toggleButton.Text = ">"
        isHidden = true
        -- Close animation (no bounce)
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, -310, 0.3, 0),
            BackgroundTransparency = 1
        }):Play()
        task.wait(0.3) -- Wait for the tween to finish before hiding
        main.Visible = false
    else
        toggleButton.Text = "<"
        isHidden = false
        main.Visible = true
        -- Open animation (bounce back)
        local initialPosition = UDim2.new(0, 50, 0.3, 0)
        local bounceOffset = UDim2.new(0, 20, 0, 0) -- Adjust this for more/less bounce

        main.Position = UDim2.new(0, -310, 0.3, 0) -- Start off-screen
        main.BackgroundTransparency = 1 -- Start transparent

        -- Tween to bounce position
        local bounceTween = TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            Position = initialPosition + bounceOffset,
            BackgroundTransparency = 0
        })
        bounceTween:Play()

        bounceTween.Completed:Wait() -- Wait for the bounce to complete

        -- Tween back to final position
        TweenService:Create(main, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = initialPosition
        }):Play()
    end
end)

--[[ 👤 FOLLOWER SIDE ]]--
controlEvent.OnClientEvent:Connect(function(command, sender)
    if sender == localPlayer then return end

    if command == "Jump" then
        local char = localPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
            -- Notify master that this player is being controlled
            detectionEvent:FireClient(sender, "Controlled", localPlayer.UserId)
        end

    elseif command == "Follow" then
        -- Notify master that this player is being controlled
        detectionEvent:FireClient(sender, "Controlled", localPlayer.UserId)

        -- Follow
        local function followMaster()
            -- Check for existing overlay and remove if present to prevent multiple overlays
            local existingOverlay = playerGui:FindFirstChild("ControlOverlay")
            if existingOverlay then
                existingOverlay:Destroy()
            end

            while true do
                task.wait(0.5)
                if not sender or not sender.Character or not sender.Character:FindFirstChild("HumanoidRootPart") then
                    -- If master leaves or character is gone, clean up overlay and break loop
                    local overlayToRemove = playerGui:FindFirstChild("ControlOverlay")
                    if overlayToRemove then
                        overlayToRemove:Destroy()
                    end
                    break
                end
                local myChar = localPlayer.Character
                if myChar and myChar:FindFirstChildOfClass("Humanoid") and myChar:FindFirstChild("HumanoidRootPart") then
                    myChar:FindFirstChildOfClass("Humanoid"):MoveTo(sender.Character.HumanoidRootPart.Position + Vector3.new(2, 0, 2))
                end
            end
        end
        coroutine.wrap(followMaster)()

        -- Overlay UI
        local overlayGui = Instance.new("ScreenGui", playerGui)
        overlayGui.Name = "ControlOverlay"
        overlayGui.IgnoreGuiInset = true
        overlayGui.ResetOnSpawn = false
        overlayGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

        local blackBg = Instance.new("Frame", overlayGui)
        blackBg.BackgroundColor3 = Color3.new(0, 0, 0)
        blackBg.Size = UDim2.new(1, 0, 1, 0)
        blackBg.Position = UDim2.new(0, 0, 0, 0)
        blackBg.BorderSizePixel = 0
        blackBg.ZIndex = 10
        blackBg.BackgroundTransparency = 0.5 -- Make it slightly transparent

        local warning = Instance.new("TextLabel", overlayGui)
        warning.Text = "YOUR ACCOUNT IS BEING CONTROLLED"
        warning.TextColor3 = Color3.fromRGB(255, 0, 0)
        warning.Font = Enum.Font.GothamBlack
        warning.TextSize = 36
        warning.BackgroundTransparency = 1
        warning.Size = UDim2.new(1, 0, 0, 100)
        warning.Position = UDim2.new(0.5, -250, 0.5, -50)
        warning.TextStrokeTransparency = 0.8
        warning.TextStrokeColor3 = Color3.new(0, 0, 0)
        warning.ZIndex = 11

        -- Profile Panel
        local profile = Instance.new("Frame", overlayGui)
        profile.Size = UDim2.new(0, 250, 0, 60)
        profile.Position = UDim2.new(0.5, -125, 1, -80)
        profile.BackgroundTransparency = 1
        profile.ZIndex = 11

        local avatar = Instance.new("ImageLabel", profile)
        avatar.Size = UDim2.new(0, 50, 0, 50)
        avatar.Position = UDim2.new(0, 0, 0, 5)
        avatar.BackgroundTransparency = 1
        -- Fetching thumbnail might fail if user ID is not valid or service is slow.
        -- Consider a default image or error handling if this is critical.
        pcall(function()
            avatar.Image = Players:GetUserThumbnailAsync(localPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        end)


        local nameLabel = Instance.new("TextLabel", profile)
        nameLabel.Size = UDim2.new(1, -60, 1, 0)
        nameLabel.Position = UDim2.new(0, 60, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = localPlayer.Name
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextColor3 = Color3.new(1, 1, 1)
        nameLabel.TextSize = 20
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left

        task.spawn(function()
            local tickTime = 0
            while warning and warning.Parent do
                tickTime += 0.05
                local xOffset = math.sin(tickTime * 8) * 10
                local yOffset = math.sin(tickTime * 5) * 5
                warning.Position = UDim2.new(0.5, xOffset - 250, 0.5, yOffset - 50)
                task.wait(0.03)
            end
        end)
    end
end)

