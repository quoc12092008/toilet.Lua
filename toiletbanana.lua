local Players = game:GetService("Players")

-- Tọa độ cần kiểm tra khoảng cách
local targetPosition = Vector3.new(1026.103759765625, -33.44594955444336, 3740.22998046875)

-- Khoảng cách tối đa cho phép người chơi đến trước khi bị kick ra (đo lường bằng khoảng cách Euclidean)
local maxDistance = 5

-- Hàm tính khoảng cách giữa hai điểm
local function calculateDistance(point1, point2)
    return (point1 - point2).magnitude
end

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

-- Lặp qua tất cả người chơi trong trò chơi và kiểm tra khoảng cách
for _, player in ipairs(Players:GetPlayers()) do
    checkDistanceAndKick(player)
end

-- Sự kiện khi một người chơi tham gia trò chơi
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        character:WaitForChild("HumanoidRootPart").Changed:Connect(function()
            checkDistanceAndKick(player)
        end)
    end)
end)
