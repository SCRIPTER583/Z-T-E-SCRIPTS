local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- GUI Setup
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "TomatoTeleporter"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 130)
mainFrame.Position = UDim2.new(0.5, -110, 0.4, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.ZIndex = 2
mainFrame.Parent = gui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 20)

-- Background Image
local bg = Instance.new("ImageLabel", mainFrame)
bg.Size = UDim2.new(1, 0, 1, 0)
bg.Position = UDim2.new(0, 0, 0, 0)
bg.Image = "rbxassetid://85834680621895"
bg.ImageTransparency = 0.7
bg.BackgroundTransparency = 1
bg.ZIndex = 1

-- Title
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, -40, 0, 30)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.Text = "Tomato Auto Clicker"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 3

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
Instance.new("UICorner", minimize).CornerRadius = UDim.new(1, 0)

-- Teleport Button
local tpButton = Instance.new("TextButton", mainFrame)
tpButton.Size = UDim2.new(0.8, 0, 0, 30)
tpButton.Position = UDim2.new(0.1, 0, 0.35, 0)
tpButton.BackgroundColor3 = Color3.fromRGB(70, 140, 255)
tpButton.Text = "Teleport & Auto Use Tomato"
tpButton.TextColor3 = Color3.new(1, 1, 1)
tpButton.Font = Enum.Font.Gotham
tpButton.TextScaled = true
tpButton.ZIndex = 3
Instance.new("UICorner", tpButton).CornerRadius = UDim.new(0, 15)

-- Auto Collector Button
local autoCollector = Instance.new("TextButton", mainFrame)
autoCollector.Size = UDim2.new(0.8, 0, 0, 30)
autoCollector.Position = UDim2.new(0.1, 0, 0.65, 0)
autoCollector.BackgroundColor3 = Color3.fromRGB(70, 140, 255)
autoCollector.Text = "Auto Collector"
autoCollector.TextColor3 = Color3.new(1, 1, 1)
autoCollector.Font = Enum.Font.Gotham
autoCollector.TextScaled = true
autoCollector.ZIndex = 3
Instance.new("UICorner", autoCollector).CornerRadius = UDim.new(0, 15)

-- Drag Line
local dragLine = Instance.new("Frame", mainFrame)
dragLine.Size = UDim2.new(1, 0, 0, 5)
dragLine.Position = UDim2.new(0, 0, 1, -5)
dragLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
dragLine.BackgroundTransparency = 0.25
Instance.new("UICorner", dragLine).CornerRadius = UDim.new(1, 0)

-- Dragging Logic
local dragging = false
local dragInput, dragStart, startPos

local function enableDrag(handle)
	handle.InputBegan:Connect(function(input)
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

	handle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)
end

enableDrag(title)
enableDrag(dragLine)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		miniButton.Position = mainFrame.Position
	end
end)

-- Minimized Button
local miniButton = Instance.new("TextButton", gui)
miniButton.Size = UDim2.new(0, 40, 0, 40)
miniButton.Position = mainFrame.Position
miniButton.AnchorPoint = Vector2.new(0.5, 0)
miniButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
miniButton.BackgroundTransparency = 0.7
miniButton.Text = "Arc"
miniButton.TextColor3 = Color3.new(1, 1, 1)
miniButton.TextScaled = true
miniButton.Font = Enum.Font.GothamBold
miniButton.Visible = false
Instance.new("UICorner", miniButton).CornerRadius = UDim.new(1, 0)

-- Morphing Animation
local function morphTo(minimized)
	local info = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	if minimized then
		local hideTween = TweenService:Create(mainFrame, info, {
			Size = UDim2.new(0, 0, 0, 0),
			Transparency = 1
		})
		hideTween:Play()
		hideTween.Completed:Wait()
		mainFrame.Visible = false
		miniButton.Position = mainFrame.Position
		miniButton.Visible = true
	else
		mainFrame.Position = miniButton.Position
		mainFrame.Visible = true
		TweenService:Create(mainFrame, info, {
			Size = UDim2.new(0, 220, 0, 130),
			Transparency = 0
		}):Play()
		miniButton.Visible = false
	end
end

minimize.MouseButton1Click:Connect(function()
	morphTo(true)
end)
miniButton.MouseButton1Click:Connect(function()
	morphTo(false)
end)

-- Dragging Mini Button
local draggingMini = false
local miniDragInput, miniDragStart, miniStartPos

miniButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingMini = true
		miniDragStart = input.Position
		miniStartPos = miniButton.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				draggingMini = false
			end
		end)
	end
end)

miniButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		miniDragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if draggingMini and input == miniDragInput then
		local delta = input.Position - miniDragStart
		miniButton.Position = UDim2.new(miniStartPos.X.Scale, miniStartPos.X.Offset + delta.X, miniStartPos.Y.Scale, miniStartPos.Y.Offset + delta.Y)
	end
end)

-- Action Button
tpButton.MouseButton1Click:Connect(function()
	local char = player.Character or player.CharacterAdded:Wait()
	if char and char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(-104.8, 8.4, -17.1))
	end

	task.wait(0.5)

	for _, tool in ipairs(player.Backpack:GetChildren()) do
		if tool:IsA("Tool") and tool.Name:lower():find("tomato") then
			tool.Parent = player.Character
			task.wait(0.1)
		end
	end

	for _, v in ipairs(workspace:GetDescendants()) do
		if v:IsA("ProximityPrompt") and (v.Parent.Position - char.HumanoidRootPart.Position).Magnitude < 10 then
			coroutine.wrap(function()
				for i = 1, 20 do
					pcall(function()
						fireproximityprompt(v)
					end)
					task.wait(0.1)
				end
			end)()
		end
	end
end)

-- Auto Collector Toggle
local autoCollecting = false
autoCollector.MouseButton1Click:Connect(function()
	autoCollecting = not autoCollecting
	autoCollector.BackgroundColor3 = autoCollecting and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(70, 140, 255)

	if autoCollecting then
		coroutine.wrap(function()
			while autoCollecting do
				for _, v in ipairs(workspace:GetDescendants()) do
					if v:IsA("ProximityPrompt") and (v.Parent.Position - player.Character.HumanoidRootPart.Position).Magnitude <= 10 then
						pcall(function()
							fireproximityprompt(v)
						end)
					end
				end
				task.wait(0.1)
			end
		end)()
	end
end)
