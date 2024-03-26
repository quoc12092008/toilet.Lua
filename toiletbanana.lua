local player = game.Players.LocalPlayer
local postOfficePosition = Vector3.new(-457, 250, -67)

player.Character:SetPrimaryPartCFrame(CFrame.new(postOfficePosition))
print("Bạn đã đến post office!")
local Config = getgenv().config

function autoMail()
    while Config.sendMail do
        local playerGui = player.PlayerGui
        local sendPackages = playerGui.Lobby.PostOffice.Menus.SendPackages

        sendPackages.SendingFrame.Username.Text = Config.userToMail
        sendPackages.SendingFrame.MessageBox.Text = Config.message

        sendPackages.YourGems.GemAmount.GemAmount:CaptureFocus()
        sendPackages.YourGems.GemAmount.GemAmount.Text = tostring(Config.gemAmount)

        local args = {
            [1] = {
                [1] = {
                    [1] = "3035333364313331633135613432396538343536643366316231376634663538",
                    [2] = 2891179472,
                    [3] = "Troops",
                    [4] = "0ebec1186c134ceda392",
                    [5] = 0,
                    [6] = "cccccccc"
                },
                [2] = "mL"
            }
        }
        
        game:GetService("ReplicatedStorage"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
        
        wait(2)
    end
end

autoMail()
