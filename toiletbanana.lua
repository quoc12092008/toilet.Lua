local targetX = 1026.103759765625
local targetY = -33.44594955444336
local targetZ = 3740.22998046875


local maxDistance = 5 
local function distance(x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

local function isPlayerNearTarget(playerX, playerY, playerZ)
    local d = distance(playerX, playerY, playerZ, targetX, targetY, targetZ)
    return d <= maxDistance
end

local function getPlayerCoordinates()
    local playerX, playerY, playerZ = GetPlayerCoordinates()
    return playerX, playerY, playerZ
end

while true do
    local playerX, playerY, playerZ = getPlayerCoordinates()

    if isPlayerNearTarget(playerX, playerY, playerZ) then
        KickPlayerOutOfGame()
        break 
    end

    Wait(1000)
end
