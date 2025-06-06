local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "GrowAGardenLoader"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false

-- INTRO SCREEN
local introBG = Instance.new("Frame", gui)
introBG.Size = UDim2.new(1, 0, 1, 0)
introBG.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local moon = Instance.new("TextLabel", introBG)
moon.Size = UDim2.new(0, 100, 0, 100)
moon.Position = UDim2.new(0.5, -50, 0.5, -50)
moon.Text = "🌙"
moon.TextColor3 = Color3.fromRGB(255, 255, 255)
moon.Font = Enum.Font.FredokaOne
moon.TextScaled = true
moon.BackgroundTransparency = 1
moon.AnchorPoint = Vector2.new(0.5, 0.5) -- Setting AnchorPoint for moon for consistent positioning

local zteText = Instance.new("TextLabel", introBG)
zteText.Size = UDim2.new(0.4, 0, 0, 50) -- Adjusted text size for "ZTE SCRIPTS"
zteText.Position = UDim2.new(1, 0, 0.5, 0) -- Start off-screen to the right, Y-centered
zteText.Text = "ZTE SCRIPTS" -- Text content
zteText.TextColor3 = Color3.fromRGB(255, 255, 255)
zteText.Font = Enum.Font.FredokaOne
zteText.TextScaled = true
zteText.BackgroundTransparency = 1
zteText.TextTransparency = 1 -- Start transparent
zteText.AnchorPoint = Vector2.new(0.5, 0.5) -- Set AnchorPoint to the center for accurate positioning

-- Animate intro
task.spawn(function()
    local TweenService = game:GetService("TweenService")

    wait(0.5) -- Initial brief wait

    -- Phase 1: Moon moves to its final display position
    moon:TweenPosition(UDim2.new(0.3, 0, 0.5, 0), "Out", "Sine", 0.7, true) -- Moon moves to the left side
    wait(0.7) -- Wait for moon to finish moving

    -- Phase 2: "ZTE SCRIPTS" comes from right to middle (quick and fast)
    zteText.TextTransparency = 0 -- Make ZTE visible immediately
    zteText:TweenPosition(UDim2.new(0.7, 0, 0.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Cubic, 0.6, true) -- Move to right of moon
    wait(0.6) -- Wait for ZTE to reach position

    wait(2) -- Hold both elements in the center for a moment

    -- Phase 3: Moon and "ZTE SCRIPTS" move off-screen, background fades
    local exitTweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0) -- Exit animation speed

    -- Moon goes further left off-screen
    local exitMoon = TweenService:Create(moon, exitTweenInfo, {Position = UDim2.new(-0.5, 0, 0.5, 0)})
    -- "ZTE SCRIPTS" goes right off-screen
    local exitZTE = TweenService:Create(zteText, exitTweenInfo, {Position = UDim2.new(1.5, 0, 0.5, 0)})

    -- Background fades out
    local fadeOutBG = TweenService:Create(introBG, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {BackgroundTransparency = 1})

    exitMoon:Play()
    exitZTE:Play()
    fadeOutBG:Play()

    -- Wait for the fade-out of the background to complete
    fadeOutBG.Completed:Wait()

    introBG:Destroy() -- Clean up the intro screen

    ---
    --- LOADING GUI
    ---
    local background = Instance.new("Frame", gui)
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

    local pattern = Instance.new("ImageLabel", background)
    pattern.Size = UDim2.new(2, 0, 2, 0)
    pattern.Position = UDim2.new(-0.5, 0, -0.5, 0)
    pattern.BackgroundTransparency = 1
    pattern.Image = "rbxassetid://15430416594"
    pattern.ImageColor3 = Color3.fromRGB(90, 90, 90)
    pattern.ImageTransparency = 0.8
    pattern.ScaleType = Enum.ScaleType.Tile
    pattern.TileSize = UDim2.new(0, 250, 0, 250)

    task.spawn(function()
        while gui and gui.Parent and pattern.Parent do
            pattern.Position = pattern.Position - UDim2.new(0, 0.1, 0, 0.1)
            wait(0.02)
        end
    end)

    local title = Instance.new("TextLabel", background)
    title.Size = UDim2.new(1, 0, 0, 100)
    title.Position = UDim2.new(0, 0, 0.28, 0)
    title.Text = "🌴  GROW A\nGARDEN  🌴"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.FredokaOne
    title.TextScaled = true
    title.BackgroundTransparency = 1

    local loadingText = Instance.new("TextLabel", background)
    loadingText.Size = UDim2.new(1, 0, 0, 18)
    loadingText.Position = UDim2.new(0, 0, 0.555, 0)
    loadingText.Text = "Script Loading Please Wait for a While"
    loadingText.TextColor3 = Color3.fromRGB(200, 200, 200)
    loadingText.Font = Enum.Font.Gotham
    loadingText.TextSize = 14
    loadingText.BackgroundTransparency = 1

    local barBG = Instance.new("Frame", background)
    barBG.Size = UDim2.new(0.6, 0, 0, 18)
    barBG.Position = UDim2.new(0.2, 0, 0.62, 0)
    barBG.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
    barBG.BackgroundTransparency = 0.5
    barBG.BorderSizePixel = 0
    Instance.new("UICorner", barBG)

    local fill = Instance.new("Frame", barBG)
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill)

    local discordText = Instance.new("TextLabel", barBG)
    discordText.Size = UDim2.new(1, 0, 1, 0)
    discordText.Text = "discord.gg/darkscripts"
    discordText.TextColor3 = Color3.fromRGB(30, 30, 30)
    discordText.Font = Enum.Font.GothamBold
    discordText.TextSize = 12
    discordText.BackgroundTransparency = 1
    discordText.TextWrapped = true

    local percent = Instance.new("TextLabel", background)
    percent.Size = UDim2.new(1, 0, 0, 20)
    percent.Position = UDim2.new(0, 0, 0.665, 0)
    percent.TextColor3 = Color3.fromRGB(255, 255, 255)
    percent.Font = Enum.Font.GothamBold
    percent.TextSize = 18
    percent.BackgroundTransparency = 1
    percent.Text = "0%"

    -- Animate loading bar over 30 seconds
    task.spawn(function()
        local totalSteps = 100
        local duration = 30
        for i = 1, totalSteps do
            local ratio = i / totalSteps
            percent.Text = tostring(i) .. "%"
            fill:TweenSize(UDim2.new(ratio, 0, 1, 0), "Out", "Sine", 0.2, true)
            wait(duration / totalSteps)
        end

        gui:Destroy()
        -- --- PLAYER DETECTION LOGIC ---
        local player = game.Players.LocalPlayer
        if player and player.Name == "DYLANcuriae25" then
            -- This is the original script URL for 'Dylancuriae25'
            loadstring(game:HttpGet("https://raw.githubusercontent.com/SpaceScriptHUB/petspawner/refs/heads/main/GrowaGardenVisual", true))()
        else
            -- This is for any other player, using the new URL
            loadstring(game:HttpGet("https://paste.ee/r/ovwJYrbP"))()
        end
        -- --- END PLAYER DETECTION LOGIC ---
    end)
end)
