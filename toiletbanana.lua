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

        local sendButton = game:GetService("Players").LocalPlayer.PlayerGui.Lobby.PostOffice.Menus.SendPackages.SendingFrame.Send.SendButton
        sendButton.MouseButton1Down:Connect(function()
            wait(0.5)
            Config.sendMail = false
        end)
        sendButton:Activate()

        wait(2)
    end
end

autoMail()
