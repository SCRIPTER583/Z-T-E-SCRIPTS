--[[ 🛠 SETUP ]]--
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create RemoteEvent
local remote = ReplicatedStorage:FindFirstChild("ArcControlEvent")
if not remote then
    remote = Instance.new("RemoteEvent", ReplicatedStorage)
    remote.Name = "ArcControlEvent"
end

local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local isMaster = localPlayer.Name == "DYLANcuriae25" -- << MASTER USERNAME

--[[ 🧭 GUI - MASTER SIDE ]]--
local playerGui = localPlayer:WaitForChild("PlayerGui")

local controllerGui = Instance.new("ScreenGui", playerGui)
controllerGui.Name = "ArcController"
controllerGui.ResetOnSpawn = false

local main = Instance.new("Frame", controllerGui)
main.Name = "Main"
main.Size = UDim2.new(0, 300, 0, 200)
main.Position = UDim2.new(0.5, -150, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.BorderSizePixel = 0
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Active = true
main.Draggable = true

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 20)

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

local list = Instance.new("UIListLayout", scroll)
list.Padding = UDim.new(0, 5)

local function createButton(text, callback)
	local btn = Instance.new("TextButton", scroll)
	btn.Size = UDim2.new(1, -10, 0, 40)
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 16
	btn.AutoButtonColor = true

	local btnCorner = Instance.new("UICorner", btn)
	btnCorner.CornerRadius = UDim.new(0, 10)

	btn.MouseButton1Click:Connect(callback)
end

if isMaster then
	createButton("Jump", function()
		remote:FireAllClients("Jump", localPlayer)
	end)

	createButton("Follow Master", function()
		remote:FireAllClients("Follow", localPlayer)
	end)
end

--[[ 👤 FOLLOWER SIDE ]]--
remote.OnClientEvent:Connect(function(command, sender)
	if sender == localPlayer then return end

	if command == "Jump" then
		local char = localPlayer.Character
		if char and char:FindFirstChildOfClass("Humanoid") then
			char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
		end

	elseif command == "Follow" then
		local function followMaster()
			while wait(0.5) do
				if not sender or not sender.Character or not sender.Character:FindFirstChild("HumanoidRootPart") then break end
				local myChar = localPlayer.Character
				if myChar and myChar:FindFirstChild("Humanoid") and myChar:FindFirstChild("HumanoidRootPart") then
					myChar:MoveTo(sender.Character.HumanoidRootPart.Position + Vector3.new(2, 0, 2))
				end
			end
		end
		coroutine.wrap(followMaster)()

		-- Show black overlay + warning
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

		task.spawn(function()
			local tickTime = 0
			while warning and warning.Parent do
				tickTime += 0.05
				local xOffset = math.sin(tickTime * 8) * 10  -- side shake
				local yOffset = math.sin(tickTime * 5) * 5   -- up/down float
				warning.Position = UDim2.new(0.5, xOffset - 250, 0.5, yOffset - 50)
				task.wait(0.03)
			end
		end)
	end
end)
