local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Create GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "FakeBypassGUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

-- Full black background
local bg = Instance.new("Frame", screenGui)
bg.Size = UDim2.new(1, 0, 1, 0)
bg.Position = UDim2.new(0, 0, 0, 0)
bg.BackgroundColor3 = Color3.new(0, 0, 0)
bg.BorderSizePixel = 0

-- Loading bar background
local barBg = Instance.new("Frame", bg)
barBg.Size = UDim2.new(0.6, 0, 0.05, 0)
barBg.Position = UDim2.new(0.2, 0, 0.5, 0)
barBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
barBg.BorderSizePixel = 0
barBg.ClipsDescendants = true

-- Loading bar fill
local barFill = Instance.new("Frame", barBg)
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.Position = UDim2.new(0, 0, 0, 0)
barFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
barFill.BorderSizePixel = 0

-- Bypassing System.. text
local bypassText = Instance.new("TextLabel", barBg)
bypassText.Size = UDim2.new(1, 0, 1, 0)
bypassText.BackgroundTransparency = 1
bypassText.TextColor3 = Color3.new(1, 1, 1)
bypassText.TextScaled = true
bypassText.Font = Enum.Font.SourceSans
bypassText.Text = "Bypassing System.."

-- Percentage text below the bar
local percentText = Instance.new("TextLabel", bg)
percentText.Size = UDim2.new(1, 0, 0, 40)
percentText.Position = UDim2.new(0, 0, 0.5 + 0.07, 0)
percentText.BackgroundTransparency = 1
percentText.TextColor3 = Color3.new(1, 1, 1)
percentText.TextScaled = true
percentText.Font = Enum.Font.SourceSans
percentText.Text = "0%"

-- Animate dots in the text
task.spawn(function()
	local dotCount = 0
	while true do
		dotCount = (dotCount % 3) + 1
		bypassText.Text = "Bypassing System" .. string.rep(".", dotCount)
		task.wait(0.5)
	end
end)

-- Simulate bar progress over 20 seconds
task.spawn(function()
	local totalTime = 20
	for i = 1, totalTime do
		local progress = i / totalTime * 0.99 -- 99%
		barFill.Size = UDim2.new(progress, 0, 1, 0)
		percentText.Text = tostring(math.floor(progress * 100)) .. "%"
		task.wait(1)
	end

	-- Stay at 99%
	barFill.Size = UDim2.new(0.99, 0, 1, 0)
	percentText.Text = "99%"
end)

-- Kick after 60 seconds
task.delay(60, function()
	player:Kick("Bypass Failed")
end)
