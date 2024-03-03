local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Tạo tọa độ của map 79
local map79Coordinates = Vector3.new(9.495932579040527, -2.681464910507202, 0.14139124751091003)

-- Khoảng cách tối đa cho phép người chơi đến trước khi bị kick ra (đo lường bằng Euclidean distance)
local maxDistance = 10

-- Tạo sự kiện khi người chơi đến một vị trí mới
local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(character)
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        humanoidRootPart:GetPropertyChangedSignal("Position"):Connect(function()
            -- Tính khoảng cách giữa tọa độ của người chơi và tọa độ của map 79
            local distance = (humanoidRootPart.Position - map79Coordinates).Magnitude
            -- Kiểm tra nếu khoảng cách nhỏ hơn hoặc bằng maxDistance, đá người chơi ra
            if distance <= maxDistance then
                player:Kick("Bạn đã bị đá ra khỏi trò chơi vì đã đến map 79.")
            end
        end)
    end)
end

-- Khi một người chơi tham gia trò chơi, gọi hàm onPlayerAdded
Players.PlayerAdded:Connect(onPlayerAdded)

-- Kiểm tra người chơi hiện tại
for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end
