if game.CoreGui:FindFirstChild("SafetyExecutor") then
    game.CoreGui.SafetyExecutor:Destroy()
end

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Main GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "SafetyExecutor"
gui.ResetOnSpawn = false

-- Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleBtn"
toggleBtn.Parent = gui
toggleBtn.Size = UDim2.new(0, 100, 0, 40)
toggleBtn.Position = UDim2.new(0.5, -50, 0, 20)
toggleBtn.AnchorPoint = Vector2.new(0.5, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleBtn.Text = "Open"
toggleBtn.Draggable = true
toggleBtn.Active = true
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamSemibold
toggleBtn.TextSize = 18
toggleBtn.BackgroundTransparency = 0.2
toggleBtn.BorderSizePixel = 0
toggleBtn.AutoButtonColor = true
toggleBtn.ZIndex = 2

-- RGB Aura Effect
local aura = Instance.new("UIStroke", toggleBtn)
aura.Thickness = 2
aura.Transparency = 0.5
aura.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local hue = 0
local running = false

task.spawn(function()
	while task.wait() do
		hue += 0.01
		if hue > 1 then hue = 0 end
		aura.Color = ColorSequence.new(Color3.fromHSV(hue, 1, 1))
	end
end)

-- Main Frame
local main = Instance.new("Frame", gui)
main.Name = "MainFrame"
main.Size = UDim2.new(0, 400, 0, 250)
main.Position = UDim2.new(0.5, -200, 0.5, -125)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
main.Visible = false
main.Active = true
main.Draggable = true
main.BackgroundTransparency = 0.1
main.BorderSizePixel = 0
main.ClipsDescendants = true

-- UICorner
local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 20)

-- Title
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Safety Executor"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 20

-- TextBox
local box = Instance.new("TextBox", main)
box.Size = UDim2.new(0.65, -10, 0, 140)
box.Position = UDim2.new(0, 10, 0, 40)
box.Text = ""
box.PlaceholderText = "Paste script here"
box.MultiLine = true
box.ClearTextOnFocus = false
box.TextXAlignment = Enum.TextXAlignment.Left
box.TextYAlignment = Enum.TextYAlignment.Top
box.Font = Enum.Font.Code
box.TextSize = 14
box.TextColor3 = Color3.new(1, 1, 1)
box.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
box.BorderSizePixel = 0
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 12)

-- Execute Button
local execBtn = Instance.new("TextButton", main)
execBtn.Size = UDim2.new(0.65, -10, 0, 30)
execBtn.Position = UDim2.new(0, 10, 0, 190)
execBtn.Text = "Execute"
execBtn.TextColor3 = Color3.new(1, 1, 1)
execBtn.Font = Enum.Font.GothamBold
execBtn.TextSize = 16
execBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
execBtn.BorderSizePixel = 0
Instance.new("UICorner", execBtn).CornerRadius = UDim.new(0, 12)

-- Side Menu
local modFrame = Instance.new("Frame", main)
modFrame.Size = UDim2.new(0.3, -10, 1, -50)
modFrame.Position = UDim2.new(0.7, 0, 0, 40)
modFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
modFrame.BorderSizePixel = 0
Instance.new("UICorner", modFrame).CornerRadius = UDim.new(0, 14)

local function createModButton(name, callback)
	local btn = Instance.new("TextButton", modFrame)
	btn.Size = UDim2.new(1, -10, 0, 30)
	btn.Position = UDim2.new(0, 5, 0, #modFrame:GetChildren() * 35)
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.Text = name
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.BorderSizePixel = 0
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
	btn.MouseButton1Click:Connect(callback)
end

createModButton("Inf Jump", function()
	local jp = game:GetService("UserInputService")
	jp.JumpRequest:Connect(function()
		Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
	end)
end)

createModButton("Kill Roblox", function()
	while task.wait(0.1) do
		while true do end
	end
end)

-- Confirm GUI
local confirm = Instance.new("Frame", gui)
confirm.Size = UDim2.new(0, 250, 0, 100)
confirm.Position = UDim2.new(0.5, -125, 0.5, -50)
confirm.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
confirm.Visible = false
confirm.AnchorPoint = Vector2.new(0.5, 0.5)
confirm.ZIndex = 5
Instance.new("UICorner", confirm).CornerRadius = UDim.new(0, 15)

local confirmText = Instance.new("TextLabel", confirm)
confirmText.Size = UDim2.new(1, 0, 0.5, 0)
confirmText.Position = UDim2.new(0, 0, 0, 0)
confirmText.Text = "Run name.lua? Are you sure?"
confirmText.TextColor3 = Color3.new(1, 1, 1)
confirmText.Font = Enum.Font.Gotham
confirmText.TextSize = 14
confirmText.BackgroundTransparency = 1

local yesBtn = Instance.new("TextButton", confirm)
yesBtn.Size = UDim2.new(0.45, 0, 0.3, 0)
yesBtn.Position = UDim2.new(0.05, 0, 0.6, 0)
yesBtn.Text = "Yes"
yesBtn.TextColor3 = Color3.new(1, 1, 1)
yesBtn.Font = Enum.Font.GothamBold
yesBtn.TextSize = 14
yesBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
Instance.new("UICorner", yesBtn).CornerRadius = UDim.new(0, 10)

local noBtn = yesBtn:Clone()
noBtn.Text = "No"
noBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
noBtn.Position = UDim2.new(0.5, 0, 0.6, 0)
noBtn.Parent = confirm

yesBtn.MouseButton1Click:Connect(function()
	confirm.Visible = false
	pcall(function()
		loadstring(box.Text)()
	end)
end)

noBtn.MouseButton1Click:Connect(function()
	confirm.Visible = false
end)

-- Execution logic
execBtn.MouseButton1Click:Connect(function()
	local name = box.Text:match("%-%-/ ?(.-)%.lua")
	if name then
		confirmText.Text = "Run " .. name .. ".lua? Are you sure?"
		confirm.Visible = true
	else
		pcall(function()
			loadstring(box.Text)()
		end)
	end
end)

-- Toggle Open/Close
local isOpen = false

local function toggleMain()
	isOpen = not isOpen
	toggleBtn.Text = isOpen and "Close" or "Open"
	if isOpen then
		main.Visible = true
		main.BackgroundTransparency = 1
		TweenService:Create(main, TweenInfo.new(0.4), {BackgroundTransparency = 0.1}):Play()
	else
		local tween = TweenService:Create(main, TweenInfo.new(0.3), {BackgroundTransparency = 1})
		tween:Play()
		tween.Completed:Wait()
		main.Visible = false
	end
end

toggleBtn.MouseButton1Click:Connect(toggleMain)
