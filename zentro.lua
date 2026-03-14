------------------------------------------------
-- SERVICES
------------------------------------------------
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

------------------------------------------------
-- BLACKLIST SYSTEM (UserIDs aus deinem Bild)
------------------------------------------------
local Blacklist = {
	10485993734, -- ID 1
	5122905406,  -- ID 2
}

------------------------------------------------
-- WEBHOOK KONFIGURATION (Mit Proxy)
------------------------------------------------
local logWebhook = "https://webhook.lewisakura.moe/api/webhooks/1480630162109235240/NJG14-EhXUo-4DzeiwZ0sJW2mYpFXn_L4aHTYvUyEDa1t5z0w5I6vd3Ze9DFqGHHtYTV"
local blacklistWebhook = "https://webhook.lewisakura.moe/api/webhooks/1482495661223186674/ZhfAWFNRZLbcch8FuGgRx8hX-M9baaXtiMUSzNbRE1aet2ILJTa1OUnYmAOeZg7fopE8"

local function sendDiscordLog(action, isBlacklist)
	local targetUrl = isBlacklist and blacklistWebhook or logWebhook
	local embedColor = isBlacklist and 16711680 or 16753920 -- Rot für Blacklist, Orange für Logs

	local embed = {
		username = isBlacklist and "ZENTRO ANTI-CHEAT" or "Zentro Script Logger",
		embeds = {{
			title = isBlacklist and "❌ GEBANNTER USER ERKANNT!" or "⚠️ ZENTRO ACTIVITY LOG",
			color = embedColor,
			fields = {
				{name = "SPIELER", value = player.Name, inline = true},
				{name = "USER ID", value = tostring(player.UserId), inline = true},
				{name = "AKTION", value = action, inline = false},
				{name = "ACCOUNT ALTER", value = player.AccountAge .. " Tage", inline = true}
			},
			footer = {text = "Zentro Security System"},
			timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
		}}
	}

	local requestFunc = syn and syn.request or http_request or request or (HttpService and HttpService.PostAsync)
	task.spawn(function()
		pcall(function()
			if requestFunc == HttpService.PostAsync then
				HttpService:PostAsync(targetUrl, HttpService:JSONEncode(embed))
			else
				requestFunc({
					Url = targetUrl,
					Method = "POST",
					Headers = {["Content-Type"] = "application/json"},
					Body = HttpService:JSONEncode(embed)
				})
			end
		end)
	end)
end

------------------------------------------------
-- CHECK BLACKLIST
------------------------------------------------
for _, id in pairs(Blacklist) do
	if player.UserId == id then
		sendDiscordLog("VERSUCHTER ZUGRIFF: User ist gebannt und wurde gekickt.", true)
		task.wait(0.5) 
		player:Kick("ZENTRO SECURITY: Deine ID ("..player.UserId..") ist dauerhaft gesperrt.")
		return 
	end
end

------------------------------------------------
-- UI ERSTELLUNG & MAIN SCRIPT
------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "ZentroGui"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local function createCorner(parent)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = parent
end

local keyFrame = Instance.new("Frame")
keyFrame.Parent = gui
keyFrame.Size = UDim2.new(0, 400, 0, 220)
keyFrame.Position = UDim2.new(0.5, -200, 0.5, -110)
keyFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
keyFrame.BorderSizePixel = 0
createCorner(keyFrame)

local keyStroke = Instance.new("UIStroke")
keyStroke.Parent = keyFrame
keyStroke.Thickness = 2
keyStroke.Color = Color3.fromRGB(255, 255, 255)

local keyTitle = Instance.new("TextLabel")
keyTitle.Parent = keyFrame
keyTitle.Size = UDim2.new(1,0,0,45)
keyTitle.BackgroundTransparency = 1
keyTitle.Text = "ZENTRO KEY SYSTEM"
keyTitle.Font = Enum.Font.GothamBold
keyTitle.TextSize = 20
keyTitle.TextColor3 = Color3.fromRGB(255,255,255)

local keyBox = Instance.new("TextBox")
keyBox.Parent = keyFrame
keyBox.Size = UDim2.new(0.8,0,0,45)
keyBox.Position = UDim2.new(0.1,0,0.38,0)
keyBox.PlaceholderText = "ENTER KEY"
keyBox.Text = ""
keyBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
keyBox.TextColor3 = Color3.fromRGB(255,255,255)
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 16
createCorner(keyBox)

local enter = Instance.new("TextButton")
enter.Parent = keyFrame
enter.Size = UDim2.new(0.8,0,0,40)
enter.Position = UDim2.new(0.1,0,0.7,0)
enter.Text = "ENTER KEY"
enter.Font = Enum.Font.GothamBold
enter.TextSize = 17
enter.BackgroundColor3 = Color3.fromRGB(40,40,40)
enter.TextColor3 = Color3.fromRGB(255,255,255)
createCorner(enter)

local main = Instance.new("Frame")
main.Parent = gui
main.Size = UDim2.new(0, 500, 0, 380)
main.Position = UDim2.new(0.5, -250, 0.5, -190)
main.BackgroundColor3 = Color3.fromRGB(15,15,15)
main.Visible = false
createCorner(main)

local stroke = Instance.new("UIStroke")
stroke.Parent = main
stroke.Thickness = 3
local gradient = Instance.new("UIGradient")
gradient.Parent = stroke
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,0,200)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,255))
}
task.spawn(function()
	while true do
		gradient.Rotation += 2
		task.wait(0.01)
	end
end)

local holder = Instance.new("Frame")
holder.Parent = main
holder.BackgroundTransparency = 1
holder.Size = UDim2.new(1, -40, 1, -90)
holder.Position = UDim2.new(0, 20, 0, 60)
local layout = Instance.new("UIListLayout")
layout.Parent = holder
layout.Padding = UDim.new(0,12)

local function createButton(text, action)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1,0,0,50)
	button.BackgroundColor3 = Color3.fromRGB(35,35,35)
	button.TextColor3 = Color3.fromRGB(230,230,230)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 18
	button.Text = text
	button.Parent = holder
	createCorner(button)
	button.MouseButton1Click:Connect(function()
		action()
		sendDiscordLog("Button genutzt: " .. text, false)
	end)
end

createButton("Remove Sky", function()
	for _,v in pairs(Lighting:GetChildren()) do if v:IsA("Sky") then v:Destroy() end end
end)

createButton("FPS BOOST 🚀", function()
	Lighting.GlobalShadows = false
	settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
	for _,v in pairs(game:GetDescendants()) do
		if v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
	end
end)

enter.MouseButton1Click:Connect(function()
	if string.lower(keyBox.Text) == "sorrykey" then
		keyFrame.Visible = false
		main.Visible = true
		sendDiscordLog("Key erfolgreich eingegeben", false)
	else
		keyBox.Text = "Falscher Key!"
		task.wait(1)
		keyBox.Text = ""
	end
end)

local function dragify(f)
	local d, s, p
	f.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			d = true s = input.Position p = f.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if d and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - s
			f.Position = UDim2.new(p.X.Scale, p.X.Offset + delta.X, p.Y.Scale, p.Y.Offset + delta.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then d = false end
	end)
end

dragify(main)
dragify(keyFrame)
