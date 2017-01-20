
local DepthMap = {}

-- How sharp changes in depth
DepthMap.Sharpiness = 0.01

-- What depth and above is considered as rock/land, in range [0,1]
DepthMap.RockDepth = 0.95

-- Returns depth from range [0, 1]
function DepthMap:getDepth(x, y)
    return love.math.noise(x*DepthMap.Sharpiness, y*DepthMap.Sharpiness)
end

-- Returns boolean
function DepthMap:depthIsRock(depth)
    return depth > DepthMap.RockDepth
end

-- Returns boolean
function DepthMap:isRockAt(x, y)
    return DepthMap:getDepth(x, y) > DepthMap.RockDepth
end

-- Draws the map covering the entire window
function DepthMap:debugDraw()
    cellSize = 5
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
    for y=0,height,cellSize do
        for x=0,width,cellSize do
            depth = DepthMap:getDepth(x+cellSize/2,y+cellSize/2)
            depthColor = depth*255
            if DepthMap:depthIsRock(depth) then
                love.graphics.setColor(255,0,0)
            else
                love.graphics.setColor(depthColor,depthColor,depthColor)
            end
            love.graphics.rectangle("fill", x, y, cellSize, cellSize)
        end
    end
end

return DepthMap
