if game.CoreGui:FindFirstChild("TomatoTeleporter") then
	game.CoreGui:FindFirstChild("TomatoTeleporter"):Destroy()
end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "TomatoTeleporter"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 220, 0, 210)
mainFrame.Position = UDim2.new(0.5, -110, 0.4, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.ZIndex = 2
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 20)

local bg = Instance.new("ImageLabel", mainFrame)
bg.Size = UDim2.new(1, 0, 1, 0)
bg.Image = "rbxassetid://8583468062"
bg.ImageTransparency = 0.7
bg.BackgroundTransparency = 1
bg.ZIndex = 1

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

local tpButton = Instance.new("TextButton", mainFrame)
tpButton.Size = UDim2.new(0.8, 0, 0, 30)
tpButton.Position = UDim2.new(0.1, 0, 0.25, 0)
tpButton.BackgroundColor3 = Color3.fromRGB(70, 140, 255)
tpButton.Text = "Teleport & Use Tomato"
tpButton.TextColor3 = Color3.new(1, 1, 1)
tpButton.Font = Enum.Font.Gotham
tpButton.TextScaled = true
tpButton.ZIndex = 3
Instance.new("UICorner", tpButton).CornerRadius = UDim.new(0, 15)

local collectorBtn = Instance.new("TextButton", mainFrame)
collectorBtn.Size = UDim2.new(0.8, 0, 0, 30)
collectorBtn.Position = UDim2.new(0.1, 0, 0.48, 0)
collectorBtn.BackgroundColor3 = Color3.fromRGB(70, 140, 255)
collectorBtn.Text = "Auto Collector"
collectorBtn.TextColor3 = Color3.new(1, 1, 1)
collectorBtn.Font = Enum.Font.Gotham
collectorBtn.TextScaled = true
collectorBtn.ZIndex = 3
Instance.new("UICorner", collectorBtn).CornerRadius = UDim.new(0, 15)

local spamEBtn = Instance.new("TextButton", mainFrame)
spamEBtn.Size = UDim2.new(0.8, 0, 0, 30)
spamEBtn.Position = UDim2.new(0.1, 0, 0.71, 0)
spamEBtn.BackgroundColor3 = Color3.fromRGB(70, 140, 255)
spamEBtn.Text = "Auto Submit"
spamEBtn.TextColor3 = Color3.new(1, 1, 1)
spamEBtn.Font = Enum.Font.Gotham
spamEBtn.TextScaled = true
spamEBtn.ZIndex = 3
Instance.new("UICorner", spamEBtn).CornerRadius = UDim.new(0, 15)

-- Badge
local badgeFrame = Instance.new("Frame", mainFrame)
badgeFrame.Size = UDim2.new(0, 60, 0, 60)
badgeFrame.Position = UDim2.new(1, -65, 1, -65)
badgeFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
badgeFrame.BackgroundTransparency = 0.2
Instance.new("UICorner", badgeFrame).CornerRadius = UDim.new(1, 0)

local badgeImg = Instance.new("ImageLabel", badgeFrame)
badgeImg.Size = UDim2.new(1, 0, 1, -15)
badgeImg.Position = UDim2.new(0, 0, 0, 0)
badgeImg.Image = "rbxassetid://8583468062"
badgeImg.BackgroundTransparency = 1

local badgeText = Instance.new("TextLabel", badgeFrame)
badgeText.Size = UDim2.new(1, 0, 0, 15)
badgeText.Position = UDim2.new(0, 0, 1, -15)
badgeText.BackgroundTransparency = 1
badgeText.Text = "🏅 Made By Arc"
badgeText.Font = Enum.Font.GothamBold
badgeText.TextScaled = true
badgeText.TextColor3 = Color3.new(1, 1, 1)

-- Dragging
local dragging, dragInput, dragStart, startPos
local function enableDrag(handle)
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = mainFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
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

UserInputService.InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Minimize toggle
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
			Size = UDim2.new(0, 220, 0, 210),
			Transparency = 0
		}):Play()
		miniButton.Visible = false
	end
end

minimize.MouseButton1Click:Connect(function() morphTo(true) end)
miniButton.MouseButton1Click:Connect(function() morphTo(false) end)

-- Buttons
local tomatoLooping = false
tpButton.MouseButton1Click:Connect(function()
	tomatoLooping = not tomatoLooping
	tpButton.BackgroundColor3 = tomatoLooping and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(70, 140, 255)
	if tomatoLooping then
		coroutine.wrap(function()
			while tomatoLooping do
				local char = player.Character or player.CharacterAdded:Wait()
				if char:FindFirstChild("HumanoidRootPart") then
					char.HumanoidRootPart.CFrame = CFrame.new(-104.8, 8.4, -17.1)
				end
				local tomatoCount = 0
				for _, tool in ipairs(player.Backpack:GetChildren()) do
					if tool:IsA("Tool") and tool.Name:lower():find("tomato") then
						tool.Parent = player.Character
						tomatoCount += 1
						task.wait(0.05)
					end
				end
				for i = 1, tomatoCount do
					for _, v in ipairs(workspace:GetDescendants()) do
						if v:IsA("ProximityPrompt") and (v.Parent.Position - player.Character.HumanoidRootPart.Position).Magnitude <= 10 then
							pcall(function() fireproximityprompt(v) end)
						end
					end
					task.wait(0.1)
				end
				task.wait(0.2)
			end
		end)()
	end
end)

local collecting = false
collectorBtn.MouseButton1Click:Connect(function()
	collecting = not collecting
	collectorBtn.BackgroundColor3 = collecting and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(70, 140, 255)
	if collecting then
		coroutine.wrap(function()
			while collecting do
				for _, v in ipairs(workspace:GetDescendants()) do
					if v:IsA("ProximityPrompt") and (v.Parent.Position - player.Character.HumanoidRootPart.Position).Magnitude <= 10 then
						pcall(function() fireproximityprompt(v) end)
					end
				end
				task.wait(0.1)
			end
		end)()
	end
end)

local krLoop = false
spamEBtn.MouseButton1Click:Connect(function()
	krLoop = not krLoop
	spamEBtn.BackgroundColor3 = krLoop and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(70, 140, 255)
	if krLoop then
		coroutine.wrap(function()
			local char = player.Character or player.CharacterAdded:Wait()
			if char:FindFirstChild("HumanoidRootPart") then
				char.HumanoidRootPart.CFrame = CFrame.new(-104.8, 8.4, -17.1)
			end
			while krLoop do
				local pos = player.Character.HumanoidRootPart.Position
				local closestPrompt, closestDist = nil, math.huge
				for _, v in ipairs(workspace:GetDescendants()) do
					if v:IsA("ProximityPrompt") and v.Parent:IsA("BasePart") then
						local dist = (v.Parent.Position - pos).Magnitude
						if dist < closestDist then
							closestPrompt = v
							closestDist = dist
						end
					end
				end
				if closestPrompt and closestDist <= 10 then
					pcall(function() fireproximityprompt(closestPrompt) end)
				end
				task.wait(0.3)
			end
		end)()
	end
end)
