local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- GUI container
local gui = Instance.new("ScreenGui")
gui.Name = "ArcTeleporterGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame (squircle)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 130)
mainFrame.Position = UDim2.new(0.5, -110, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0.5, 0)
mainFrame.ZIndex = 2
mainFrame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 20)
corner.Parent = mainFrame

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
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0, 25, 0, 25)
minimize.Position = UDim2.new(1, -30, 0, 5)
minimize.Text = "-"
minimize.TextScaled = true
minimize.Font = Enum.Font.GothamBold
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minimize.ZIndex = 3
minimize.Parent = mainFrame

local minCorner = Instance.new("UICorner", minimize)
minCorner.CornerRadius = UDim.new(1, 0)

-- Button
local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(0.8, 0, 0, 30)
copyButton.Position = UDim2.new(0.1, 0, 0.42, 0)
copyButton.BackgroundColor3 = Color3.fromRGB(50, 120, 255)
copyButton.Text = "Copy Coordinates"
copyButton.TextColor3 = Color3.new(1, 1, 1)
copyButton.Font = Enum.Font.Gotham
copyButton.TextScaled = true
copyButton.ZIndex = 3
copyButton.Parent = mainFrame

local bCorner = Instance.new("UICorner", copyButton)
bCorner.CornerRadius = UDim.new(0, 15)

-- Label
local coordLabel = Instance.new("TextLabel")
coordLabel.Size = UDim2.new(0.9, 0, 0, 24)
coordLabel.Position = UDim2.new(0.05, 0, 0.75, 0)
coordLabel.BackgroundTransparency = 1
coordLabel.TextColor3 = Color3.new(1, 1, 1)
coordLabel.Font = Enum.Font.Code
coordLabel.TextScaled = true
coordLabel.Text = "X: 0 Y: 0 Z: 0"
coordLabel.ZIndex = 3
coordLabel.Parent = mainFrame

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
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

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

-- Copy Button Logic
copyButton.MouseButton1Click:Connect(function()
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		local pos = char.HumanoidRootPart.Position
		local coords = ("X: %.1f Y: %.1f Z: %.1f"):format(pos.X, pos.Y, pos.Z)
		coordLabel.Text = coords
		if setclipboard then setclipboard(coords) end
	end
end)

-- Minimize/Restore
minimize.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	miniButton.Visible = true
end)
miniButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = true
	miniButton.Visible = false
end)
