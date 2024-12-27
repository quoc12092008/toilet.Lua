repeat wait() until game:IsLoaded()
repeat wait() until game.Players.LocalPlayer
local Plr = game.Players.LocalPlayer
repeat wait() until Plr.Character
repeat wait() until Plr.Character:FindFirstChild("HumanoidRootPart")
repeat wait() until Plr.Character:FindFirstChild("Humanoid")
local Plrgui = game:GetService("Players").LocalPlayer.PlayerGui
local vim = game:GetService("VirtualInputManager")
local StarterGui = game:GetService("StarterGui")

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)

function ClickButton(a)
    game:GetService("VirtualInputManager"):SendMouseButtonEvent(a.AbsolutePosition.X + a.AbsoluteSize.X / 2, a.AbsolutePosition.Y + 65, 0, true, a, 1)
    game:GetService("VirtualInputManager"):SendMouseButtonEvent(a.AbsolutePosition.X + a.AbsoluteSize.X / 2, a.AbsolutePosition.Y + 65, 0, false, a, 1)
end

local function ClickButton1(a)
    game:GetService("GuiService").SelectedObject = a
    game:GetService("VirtualInputManager"):SendKeyEvent(true, "Return", false, game)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, "Return", false, game)
end

local listCrate = {
    ["Golden Gladiator"] = "rbxassetid://129368477907107",
    ["Christmas"] = "rbxassetid://77647395502645"
}

local function CheckRarity(rarity)
    if rarity == "Ultimate" then 
        return true 
    end
    return false 
end

local movementRadius = 10
local speed = 16
local origin = Plr.Character.HumanoidRootPart.Position

local function moveRandomly()
    local randomX = math.random(-movementRadius, movementRadius)
    local randomZ = math.random(-movementRadius, movementRadius)
    local targetPosition = Vector3.new(origin.X + randomX, origin.Y, origin.Z + randomZ)
    Plr.Character.Humanoid:MoveTo(targetPosition)
    Plr.Character.Humanoid.MoveToFinished:Wait()
end

local function isCrate(crate)
    for i, v in pairs(listCrate) do 
        if v == crate.TroopsFrame.TroopIcon.Image then 
            return true 
        end 
    end
    return false 
end

local function getNotEnoughSpaceGui()
    for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.MainFrames.NotificationFrame:GetChildren()) do 
        if v.Name == "BigNotification" and v.Parent.Visible then 
            if string.find(v.NotificationMessage.Text, "enough space") then 
                return v 
            end 
        end 
    end
    return 
end

local function SendWebHook(v)
    local msg = {
        ['content'] = '@everyone',
        ["embeds"] = {{
            ["title"] = "Toilet Tower Defense",
            ["description"] = "Crate Opened",
            ["type"] = "rich",
            ["color"] = tonumber(0xbdce44),
            ["fields"] = {
                {
                    ["name"] = "User",
                    ["value"] = game.Players.LocalPlayer.Name,
                    ["inline"] = false
                },
                {
                    ["name"] = "Name",
                    ["value"] = v.Holder.UnitName.Text,
                    ["inline"] = true
                },
                {
                    ["name"] = "Rarity",
                    ["value"] = v.Holder.RarityFrame.Rarity.Text,
                    ["inline"] = true
                },
            }
        }}
    }

    local webhookUrl = "https://discord.com/api/webhooks/1321908862831296582/1Ah7lx471loUAQJIwvTFB86tiF0-MdI6qoE_3A42vGhG7Yt6eSPRS2FFxG2gUUR1D2RV"
    
    local httpService = game:GetService("HttpService")
    local success, response = pcall(function()
        return request({
            Url = webhookUrl,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = httpService:JSONEncode(msg)
        })
    end)

    if success and response and response.StatusCode == 200 then
        print("Webhook sent successfully!")
    else
        warn("Failed to send webhook. StatusCode:", response and response.StatusCode or "Unknown", "Error:", not success and response or "None")
    end
end


local function getOpenGui()
    for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.MainFrames.NotificationFrame:GetChildren()) do 
        if v.Name == "BigNotification" and v.Parent.Visible then 
            if v.NotificationMessage.Text == "Are you sure you want to open this crate?" then 
                return v 
            end 
        end 
    end
    return 
end

local function getOpenButton(frame)
    if frame:FindFirstChild("Button3") and frame.Button3.Visible and frame.Button3.Btn.Text == "Open 8" then 
        return frame.Button3 
    else 
        return frame.Button1 
    end 
end

local function getCrate() 
    for i, v in pairs(Plrgui.Lobby.UnitFrame.UnitHolder.UnitList:GetChildren()) do 
        if v:IsA("Frame") and isCrate(v) then
            return v 
        end  
    end
    return 
end

if Plrgui.Lobby.UpdateLog.Visible then 
    repeat wait()
        ClickButton1(Plrgui.Lobby.UpdateLog.LogHolder.Frame.CloseButton)
    until not Plrgui.Lobby.UpdateLog.Visible
end

_G.farm = true 

spawn(function()
    while _G.farm do wait()
        local NotEnoughSpaceGui = getNotEnoughSpaceGui()
        if NotEnoughSpaceGui then 
            repeat wait()
                ClickButton1(NotEnoughSpaceGui.Buttons.OkButton.Btn)
                wait(.5)
            until getNotEnoughSpaceGui() == nil or not _G.farm 
        else 
            if not Plrgui.Lobby.UnitFrame.Visible then 
                repeat wait()
                    ClickButton1(Plrgui.Lobby.LeftSideFrame.Units.Button)
                    wait(.5)
                until Plrgui.Lobby.UnitFrame.Visible or not _G.farm or getNotEnoughSpaceGui()
            else 
                local OpenGui = getOpenGui()
                if OpenGui then 
                    repeat wait()
                        ClickButton1(getOpenButton(OpenGui.Buttons).Btn)
                        wait(.5)
                    until not _G.farm or getOpenGui() == nil or getNotEnoughSpaceGui() or not Plrgui.Lobby.UnitFrame.Visible
                else 
                    local crate = getCrate()
                    if crate then 
                        ClickButton1(crate.TroopsFrame.InteractiveButton)
                    end 
                end 
            end 
        end 
    end
end)

spawn(function()
    while _G.farm do wait()
        moveRandomly()
        wait(.5)
    end
end)

Plrgui.ResultsGui.TroopResultsFrame.SummonResults.ChildAdded:connect(function(Unit)
    if Unit:IsA("Frame") then 
        if CheckRarity(Unit.Holder.RarityFrame.Rarity.Text) then 
            SendWebHook(Unit)
        end 
    end 
end)
