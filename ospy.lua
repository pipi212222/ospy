local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function Notify(Title, Image, Content)
    Rayfield:Notify({
        Title = Title,
        Content = Content,
        Duration = 6.5,
        Image = Image,
    })
end

local function format(template, values)
    return (template:gsub("{(%w+)}", function(key)
        return tostring(values[key] or "{" .. key .. "}")
    end))
end

local Window = Rayfield:CreateWindow({
    Name = "Ospy - Created by ohayo",
    LoadingTitle = "Ospy - Private chat spy",
    LoadingSubtitle = "by ohayo",
    Theme = "Bloom",
    ConfigurationSaving = {
        Enabled = true,
        FileName = "Ospy-config"
    },
    KeySystem = true,
    KeySettings = {
        Title = "Ospy",
        Subtitle = "Key System",
        Note = "Created by ohayo",
        Key = "Ohayo",
        FileName = "Ospykey",
        SaveKey = true,
    }
})

local data = { name = player.DisplayName }
Notify(format("Hi, {name}", data), "info", "Welcome To Ospy")

local Tab = Window:CreateTab("Main")
local Section = Tab:CreateSection("Ospy")

local ScriptTab = Window:CreateTab("Script")
local ScriptSection = ScriptTab:CreateSection("Scripts")

local ItsmeandButton = Tab:CreateButton({
    Name = "Bypass Chat",
    Callback = function()
        saymsg:FireServer("its me and", "All")
    end,
})

local spoofvcsuspentionButton = Tab:CreateButton({
    Name = "Bypass vcban",
    Callback = function()
        game:GetService("VoiceChatService"):joinVoice()
    end,
})

local VHSButton = ScriptTab:CreateButton({
    Name = "VHS premium",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Fling-Things-and-People-FTAP-VHS-FREE-PREMIUM-24411"))()
    end,
})

local CBlitzButton = ScriptTab:CreateButton({
    Name = "Blitz premium",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/chaosscripter/cracks/m/blitz"))()
    end,
})

local BlitzButton = ScriptTab:CreateButton({
    Name = "Blitz free",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/BlizTBr/scripts/main/FTAP.lua"))()
    end,
})

local BlitzButton = ScriptTab:CreateButton({
    Name = "infiniteyield",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end,
})

-- Config
Config = {
    enabled = false,
    spyOnMyself = true,
    public = true,
    publicItalics = false
}

-- Customizing Log Output
PrivateProperties = {
    Color = Color3.fromRGB(0, 255, 255),
    Font = Enum.Font.SourceSansBold,
    TextSize = 18,
}

local StarterGui = game:GetService("StarterGui")
local saymsg = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest")
local getmsg = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("OnMessageDoneFiltering")
local instance = (_G.chatSpyInstance or 0) + 1
_G.chatSpyInstance = instance

local function onChatted(p, msg)
    if _G.chatSpyInstance == instance then
        if p == player and msg:lower():sub(1, 4) == "/spy" then
            Config.enabled = not Config.enabled
            wait(0.3)
            PrivateProperties.Text = "{OSPY " .. (Config.enabled and "EN" or "DIS") .. "ABLED} / made in ohayo"
            StarterGui:SetCore("ChatMakeSystemMessage", PrivateProperties)
        elseif Config.enabled and (Config.spyOnMyself == true or p ~= player) then
            msg = msg:gsub("[\n\r]", ''):gsub("\t", ' '):gsub("[ ]+", ' ')
            local hidden = true
            local conn = getmsg.OnClientEvent:Connect(function(packet, channel)
                if packet.SpeakerUserId == p.UserId and packet.Message == msg:sub(#msg - #packet.Message + 1) and (channel == "All" or (channel == "Team" and Config.public == false and Players[packet.FromSpeaker].Team == player.Team)) then
                    hidden = false
                end
            end)
            wait(1)
            conn:Disconnect()
            if hidden and Config.enabled then
                if Config.public then
                    saymsg:FireServer((Config.publicItalics and "/me " or '') .. "{OSPY} [" .. p.Name .. "]: " .. msg, "All")
                else
                    PrivateProperties.Text = "{OSPY} [" .. p.Name .. "]: " .. msg
                    StarterGui:SetCore("ChatMakeSystemMessage", PrivateProperties)
                end
            end
        end
    end
end

for _, p in ipairs(Players:GetPlayers()) do
    p.Chatted:Connect(function(msg) onChatted(p, msg) end)
end

Players.PlayerAdded:Connect(function(p)
    p.Chatted:Connect(function(msg) onChatted(p, msg) end)
end)

local OspyToggle = Tab:CreateToggle({
    Name = "Chat Spy Toggle",
    CurrentValue = Config.enabled,
    Flag = "Ospy",
    Callback = function(Value)
        Config.enabled = Value
        PrivateProperties.Text = "{OSPY " .. (Config.enabled and "EN" or "DIS") .. "ABLED} / made in ohayo"
        StarterGui:SetCore("ChatMakeSystemMessage", PrivateProperties)
    end,
})

local PublishToggle = Tab:CreateToggle({
    Name = "Publish",
    CurrentValue = Config.public,
    Flag = "Publish",
    Callback = function(Value)
        Config.public = Value
    end,
})

Rayfield:LoadConfiguration()
