--[[ FULL ARC CONTROLLER SCRIPT WITH DETECTION + FIXED ANIMATION ]]

local Players = game:GetService("Players") local ReplicatedStorage = game:GetService("ReplicatedStorage") local TweenService = game:GetService("TweenService")

-- RemoteEvent local remote = ReplicatedStorage:FindFirstChild("ArcControlEvent") if not remote then remote = Instance.new("RemoteEvent", ReplicatedStorage) remote.Name = "ArcControlEvent" end

local localPlayer = Players.LocalPlayer local playerGui = localPlayer:WaitForChild("PlayerGui") local isMaster = localPlayer.Name == "DYLANcuriae25"

-- MAIN GUI local controllerGui = Instance.new("ScreenGui", playerGui) controllerGui.Name = "ArcController" controllerGui.ResetOnSpawn = false controllerGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local main = Instance.new("Frame", controllerGui) main.Name = "Main" main.Size = UDim2.new(0, 300, 0, 200) main.Position = UDim2.new(0, 50, 0.3, 0) main.BackgroundColor3 = Color3.fromRGB(30, 30, 30) main.BorderSizePixel = 0 main.AnchorPoint = Vector2.new(0, 0.5) main.Active = true main.Draggable = true main.Visible = isMaster Instance.new("UICorner", main).CornerRadius = UDim.new(0, 20)

local title = Instance.new("TextLabel", main) title.Text = "Arc Controller" title.Size = UDim2.new(1, 0, 0, 30) title.BackgroundTransparency = 1 title.TextColor3 = Color3.new(1, 1, 1) title.Font = Enum.Font.GothamBold title.TextSize = 18

local scroll = Instance.new("ScrollingFrame", main) scroll.Size = UDim2.new(1, -10, 1, -40) scroll.Position = UDim2.new(0, 5, 0, 35) scroll.CanvasSize = UDim2.new(0, 0, 0, 300) scroll.ScrollBarThickness = 4 scroll.BackgroundTransparency = 1 scroll.BorderSizePixel = 0

Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 5)

local function createButton(text, callback) local btn = Instance.new("TextButton", scroll) btn.Size = UDim2.new(1, -10, 0, 40) btn.Text = text btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50) btn.TextColor3 = Color3.new(1, 1, 1) btn.Font = Enum.Font.Gotham btn.TextSize = 16 btn.AutoButtonColor = true Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10) btn.MouseButton1Click:Connect(callback) end

if isMaster then createButton("Jump", function()

emote:FireAllClients("Jump", localPlayer) end)

createButton("Follow Master", function()

emote:FireAllClients("Follow", localPlayer) end)

createButton("Detect Controlled", function()
	local detected = nil
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= localPlayer then
			detected = plr
			break
		end
	end

	if detected then
		createButton("\ud83c\udfaf Detected: " .. detected.Name, function() end)
	else
		createButton("\u274c None Detected", function() end)
	end
end)

end

-- Toggle Button local toggleButton = Instance.new("TextButton", controllerGui) toggleButton.Text = "<" toggleButton.Size = UDim2.new(0, 30, 0, 60) toggleButton.Position = UDim2.new(0, 0, 0.5, -30) toggleButton.AnchorPoint = Vector2.new(0, 0.5) toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50) toggleButton.TextColor3 = Color3.new(1, 1, 1) toggleButton.Font = Enum.Font.GothamBlack toggleButton.TextSize = 20 toggleButton.Visible = isMaster Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(1, 0)

local isHidden = false

toggleButton.MouseButton1Click:Connect(function() if not isHidden then isHidden = true toggleButton.Text = ">" local hideTween = TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), { Position = UDim2.new(0, -310, 0.3, 0), Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1 }) hideTween:Play() hideTween.Completed:Connect(function() main.Visible = false end) else main.Visible = true isHidden = false toggleButton.Text = "<" main.Position = UDim2.new(0, -310, 0.3, 0) main.Size = UDim2.new(0, 0, 0, 0) main.BackgroundTransparency = 1 TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), { Position = UDim2.new(0, 50, 0.3, 0), Size = UDim2.new(0, 300, 0, 200), BackgroundTransparency = 0 }):Play() end end)

-- Follower GUI reaction remote.OnClientEvent:Connect(function(command, sender) if sender == localPlayer then return end

if command == "Jump" then
	local char = localPlayer.Character
	if char and char:FindFirstChildOfClass("Humanoid") then
		char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
	end

elseif command == "Follow" then
	coroutine.wrap(function()
		while wait(0.5) do
			if not sender.Character or not sender.Character:FindFirstChild("HumanoidRootPart") then break end
			local myChar = localPlayer.Character
			if myChar and myChar:FindFirstChild("Humanoid") and myChar:FindFirstChild("HumanoidRootPart") then
				myChar:MoveTo(sender.Character.HumanoidRootPart.Position + Vector3.new(2, 0, 2))
			end
		end
	end)()

	-- Show control overlay
	local overlayGui = Instance.new("ScreenGui", playerGui)
	overlayGui.Name = "ControlOverlay"
	overlayGui.IgnoreGuiInset = true
	overlayGui.ResetOnSpawn = false
	overlayGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

	local blackBg = Instance.new("Frame", overlayGui)
	blackBg.BackgroundColor3 = Color3.new(0, 0, 0)
	blackBg.Size = UDim2.new(1, 0, 1, 0)
	blackBg.Position = UDim2.new(0, 0, 0, 0)
	blackBg.ZIndex = 10

	local warning = Instance.new("TextLabel", overlayGui)
	warning.Text = "YOUR ACCOUNT IS BEING CONTROLLED"
	warning.TextColor3 = Color3.fromRGB(255, 0, 0)
	warning.Font = Enum.Font.GothamBlack
	warning.TextSize = 36
	warning.BackgroundTransparency = 1
	warning.Size = UDim2.new(1, 0, 0, 100)
	warning.Position = UDim2.new(0.5, -250, 0.5, -50)
	warning.ZIndex = 11

	-- Profile section
	local profile = Instance.new("Frame", overlayGui)
	profile.Size = UDim2.new(0, 250, 0, 60)
	profile.Position = UDim2.new(0.5, -125, 1, -80)
	profile.BackgroundTransparency = 1
	profile.ZIndex = 11

	local avatar = Instance.new("ImageLabel", profile)
	avatar.Size = UDim2.new(0, 50, 0, 50)
	avatar.Position = UDim2.new(0, 0, 0, 5)
	avatar.BackgroundTransparency = 1
	avatar.Image = Players:GetUserThumbnailAsync(localPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)

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

