local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- GUI container
local gui = Instance.new("ScreenGui")
gui.Name = "ArcTeleporterGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 100)
mainFrame.Position = UDim2.new(0.5, -110, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0.5, 0)
mainFrame.ZIndex = 2
mainFrame.Parent = gui

local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 20)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 30)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.Text = "Arc Teleporter"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 3
title.Parent = mainFrame

-- Minimize Button
local minimize = Instance.new("TextButton", mainFrame)
minimize.Size = UDim2.new(0, 25, 0, 25)
minimize.Position = UDim2.new(1, -30, 0, 5)
minimize.Text = "-"
minimize.TextScaled = true
minimize.Font = Enum.Font.GothamBold
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minimize.ZIndex = 3

local minCorner = Instance.new("UICorner", minimize)
minCorner.CornerRadius = UDim.new(1, 0)

-- Teleport Button
local tpButton = Instance.new("TextButton")
tpButton.Size = UDim2.new(0.8, 0, 0, 30)
tpButton.Position = UDim2.new(0.1, 0, 0.5, 0)
tpButton.BackgroundColor3 = Color3.fromRGB(50, 120, 255)
tpButton.Text = "Teleport to Spot"
tpButton.TextColor3 = Color3.new(1, 1, 1)
tpButton.Font = Enum.Font.Gotham
tpButton.TextScaled = true
tpButton.ZIndex = 3
tpButton.Parent = mainFrame

local bCorner = Instance.new("UICorner", tpButton)
bCorner.CornerRadius = UDim.new(0, 15)

-- Minimized Button
local miniButton = Instance.new("TextButton")
miniButton.Size = UDim2.new(0, 60, 0, 25)
miniButton.Position = UDim2.new(0.5, -30, 0, 5)
miniButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
miniButton.BackgroundTransparency = 0.7
miniButton.Text = "Arc"
miniButton.TextColor3 = Color3.new(1, 1, 1)
miniButton.TextScaled = true
miniButton.Font = Enum.Font.GothamBold
miniButton.Visible = false
miniButton.ZIndex = 4
miniButton.Parent = gui

local miniCorner = Instance.new("UICorner", miniButton)
miniCorner.CornerRadius = UDim.new(0, 20)

-- Drag Title
local dragging, dragInput, dragStart, startPos
title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)
title.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Drag Minimized
local draggingMini, dragInputMini, dragStartMini, startPosMini
miniButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingMini = true
		dragStartMini = input.Position
		startPosMini = miniButton.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				draggingMini = false
			end
		end)
	end
end)
miniButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInputMini = input
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if draggingMini and input == dragInputMini then
		local delta = input.Position - dragStartMini
		miniButton.Position = UDim2.new(startPosMini.X.Scale, startPosMini.X.Offset + delta.X, startPosMini.Y.Scale, startPosMini.Y.Offset + delta.Y)
	end
end)

-- Minimize/Restore Logic
minimize.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	miniButton.Visible = true
end)
miniButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = true
	miniButton.Visible = false
end)

-- 🌀 Teleport Logic
tpButton.MouseButton1Click:Connect(function()
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(-117.0, 4.5, -15.0))
	end
end)
