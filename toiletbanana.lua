-- Hàm kiểm tra và kick người chơi ra khi ở gần tọa độ cần kiểm tra
local function checkDistanceAndKick(player)
    local character = player.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local playerPosition = humanoidRootPart.Position
            local distance = calculateDistance(playerPosition, targetPosition)
            if distance <= maxDistance then
                player:Kick("Bạn đã bị đá ra khỏi trò chơi vì ở quá gần với tọa độ cần kiểm tra.")
            end
        else
            warn("Không tìm thấy HumanoidRootPart cho " .. player.Name)
        end
    else
        warn(player.Name .. " chưa tham gia trò chơi")
    end
end

-- Sự kiện khi một người chơi tham gia trò chơi
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        character:WaitForChild("HumanoidRootPart").Changed:Connect(function()
            checkDistanceAndKick(player)
        end)
    end)
end)
