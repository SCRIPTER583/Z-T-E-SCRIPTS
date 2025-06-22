-- 🔒 CONTROLLED USER SCRIPT
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- 🔧 Remote Events
local controlEvent = ReplicatedStorage:FindFirstChild("MultiMasterControlEvent")
if not controlEvent then
    controlEvent = Instance.new("RemoteEvent", ReplicatedStorage)
    controlEvent.Name = "MultiMasterControlEvent"
    controlEvent.Parent = ReplicatedStorage
end

local announceEvent = ReplicatedStorage:FindFirstChild("MultiMasterAnnounceEvent")
if not announceEvent then
    announceEvent = Instance.new("RemoteEvent", ReplicatedStorage)
    announceEvent.Name = "MultiMasterAnnounceEvent"
    announceEvent.Parent = ReplicatedStorage
end

-- ⚠️ GUI Warning
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "ControlledGUI"
gui.ResetOnSpawn = false

local warning = Instance.new("TextLabel", gui)
warning.Size = UDim2.new(0.6, 0, 0.1, 0)
warning.Position = UDim2.new(0.2, 0, 0.45, 0)
warning.Text = "ACCOUNT IS BEING CONTROLLED"
warning.TextColor3 = Color3.new(1, 0, 0)
warning.BackgroundTransparency = 1
warning.TextScaled = true
warning.Font = Enum.Font.GothamBold

task.spawn(function()
	while true do
		local x = math.random(-5, 5)
		local y = math.random(-5, 5)
		local pos = UDim2.new(0.2, x, 0.45, y)
		TweenService:Create(warning, TweenInfo.new(0.1), {Position = pos}):Play()
		task.wait(0.1)
	end
end)

-- 🔐 Control Logic
local assignedMaster = nil
local latestMaster = nil
local isFollowing = false

-- Receive master login announcement
announceEvent.OnClientEvent:Connect(function(masterName)
    latestMaster = masterName
end)

-- Detect if user types "-LOG"
LocalPlayer.Chatted:Connect(function(msg)
	if msg:lower():match("^%-log$") and latestMaster then
		assignedMaster = latestMaster
		game.StarterGui:SetCore("ChatMakeSystemMessage", {
			Text = "🔐 Master assigned: " .. assignedMaster,
			Color = Color3.fromRGB(255, 100, 100),
			Font = Enum.Font.GothamBold,
			FontSize = Enum.FontSize.Size24
		})
	end
end)

-- Receive commands
controlEvent.OnClientEvent:Connect(function(data)
	if data.To ~= LocalPlayer.Name then return end
	if data.From ~= assignedMaster then return end

	if data.Command == "follow" then
		isFollowing = data.State
	elseif data.Command == "chat" then
		game.StarterGui:SetCore("ChatMakeSystemMessage", {
			Text = "[CONTROLLED] " .. data.Text,
			Color = Color3.fromRGB(255, 50, 50),
			Font = Enum.Font.GothamBold,
			FontSize = Enum.FontSize.Size24
		})
	end
end)

-- 👣 Follow loop
task.spawn(function()
	while true do
		if isFollowing and assignedMaster then
			local master = Players:FindFirstChild(assignedMaster)
			if master and master.Character and LocalPlayer.Character then
				local mh = master.Character:FindFirstChild("HumanoidRootPart")
				local ch = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				if mh and ch then
					ch.CFrame = mh.CFrame * CFrame.new(2, 0, 2)
				end
			end
		end
		task.wait(0.3)
	end
end)
