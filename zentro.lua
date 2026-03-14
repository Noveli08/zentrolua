------------------------------------------------
-- SERVICES
------------------------------------------------
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

------------------------------------------------
-- BLACKLIST (ID 10485993734 ist entfernt)
------------------------------------------------
local Blacklist = { 5122905406 }

local logWebhook = "https://webhook.lewisakura.moe/api/webhooks/1480630162109235240/NJG14-EhXUo-4DzeiwZ0sJW2mYpFXn_L4aHTYvUyEDa1t5z0w5I6vd3Ze9DFqGHHtYTV"

local function sendSauberLog(aktion)
    local embed = {
        username = "Zentro Security System",
        embeds = {{
            title = "⚠️ ZENTRO ACTIVITY LOG",
            color = 16753920,
            fields = {
                {name = "USER", value = player.Name, inline = true},
                {name = "USER ID", value = tostring(player.UserId), inline = true},
                {name = "ACTION", value = aktion, inline = false}
            },
            footer = {text = "Zentro Security System • heute um " .. os.date("%H:%M") .. " Uhr"}
        }}
    }
    pcall(function()
        local req = syn and syn.request or http_request or request or (HttpService and HttpService.PostAsync)
        if req == HttpService.PostAsync then
            HttpService:PostAsync(logWebhook, HttpService:JSONEncode(embed))
        else
            req({Url = logWebhook, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(embed)})
        end
    end)
end

for _, id in pairs(Blacklist) do
    if player.UserId == id then
        player:Kick("ZENTRO SECURITY: Blacklisted.")
        return 
    end
end

------------------------------------------------
-- UI BASE
------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "ZentroFinal_WithX"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local function makeDraggable(f)
    local dragging, inputPos, startPos
    f.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true inputPos = i.Position startPos = f.Position end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - inputPos
            f.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
end

------------------------------------------------
-- KEY SYSTEM
------------------------------------------------
local keyFrame = Instance.new("Frame", gui)
keyFrame.Size = UDim2.new(0, 400, 0, 220)
keyFrame.Position = UDim2.new(0.5, -200, 0.5, -110)
keyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", keyFrame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", keyFrame).Color = Color3.fromRGB(255, 255, 255)

local kt = Instance.new("TextLabel", keyFrame)
kt.Size = UDim2.new(1, 0, 0, 50)
kt.Text = "ZENTRO KEY SYSTEM"
kt.TextColor3 = Color3.fromRGB(255, 255, 255)
kt.Font = Enum.Font.GothamBold
kt.TextSize = 20
kt.BackgroundTransparency = 1

local kb = Instance.new("TextBox", keyFrame)
kb.Size = UDim2.new(0.8, 0, 0, 45)
kb.Position = UDim2.new(0.1, 0, 0.4, 0)
kb.PlaceholderText = "KEY"
kb.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
kb.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", kb)

local eb = Instance.new("TextButton", keyFrame)
eb.Size = UDim2.new(0.8, 0, 0, 40)
eb.Position = UDim2.new(0.1, 0, 0.7, 0)
eb.Text = "LOGIN"
eb.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
eb.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", eb)

------------------------------------------------
-- MAIN PANEL
------------------------------------------------
local shadow = Instance.new("Frame", gui)
shadow.Size = UDim2.new(0, 454, 0, 324)
shadow.Position = UDim2.new(0.5, -227, 0.5, -162)
shadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
shadow.Visible = false
Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 16)

local grad = Instance.new("UIGradient", shadow)
grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 212)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})

local main = Instance.new("Frame", shadow)
main.Size = UDim2.new(0, 450, 0, 320)
main.Position = UDim2.new(0, 2, 0, 2)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "ZENTRO PANEL"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255, 255, 255)

-- DER X BUTTON
local closeBtn = Instance.new("TextButton", main)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 10)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
closeBtn.MouseButton1Click:Connect(function()
    shadow.Visible = false
end)

task.spawn(function() while true do grad.Rotation += 2 task.wait(0.02) end end)

local holder = Instance.new("Frame", main)
holder.Size = UDim2.new(1, -40, 1, -70)
holder.Position = UDim2.new(0, 20, 0, 55)
holder.BackgroundTransparency = 1
Instance.new("UIListLayout", holder).Padding = UDim.new(0, 10)

local function addBtn(txt, callback)
    local b = Instance.new("TextButton", holder)
    b.Size = UDim2.new(1, 0, 0, 45)
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    b.Text = txt
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 16
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() 
        callback() 
        sendSauberLog("Button benutzt: " .. txt) 
    end)
end

addBtn("Remove Sky", function() for _,v in pairs(Lighting:GetChildren()) do if v:IsA("Sky") then v:Destroy() end end end)
addBtn("FPS BOOST 🚀", function()
    Lighting.GlobalShadows = false
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    for _,v in pairs(game:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Enabled = false end
        if v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
    end
end)
addBtn("Weather Clear", function() Lighting.ClockTime = 12 end)
addBtn("Join Discord", function() if setclipboard then setclipboard("https://discord.gg/zentro") end end)

eb.MouseButton1Click:Connect(function()
    if kb.Text == "fuckgoofy12" then
        keyFrame.Visible = false
        shadow.Visible = true
        sendSauberLog("Key erfolgreich eingegeben")
    else
        kb.Text = "WRONG KEY"
        task.wait(1)
        kb.Text = ""
    end
end)

makeDraggable(keyFrame)
makeDraggable(shadow)
