-- 👑 MASTER SCRIPT
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
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

-- 📝 Chat Commands
LocalPlayer.Chatted:Connect(function(msg)
	if msg:lower():sub(1, 7) == "-login" then
		announceEvent:FireAllClients(LocalPlayer.Name)

	elseif msg:lower():sub(1, 7) == "-follow" then
		local target = msg:sub(9):lower()
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr.Name:lower():find(target) then
				controlEvent:FireClient(plr, {
					Command = "follow",
					From = LocalPlayer.Name,
					To = plr.Name,
					State = true
				})
			end
		end

	elseif msg:lower():sub(1, 5) == "-chat" then
		local args = msg:split(" ")
		local target = args[2]
		local message = msg:sub(8 + #target)
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr.Name:lower():find(target:lower()) then
				controlEvent:FireClient(plr, {
					Command = "chat",
					From = LocalPlayer.Name,
					To = plr.Name,
					Text = message
				})
			end
		end
	end
end)
