
local DepthMap = {}

-- How sharp changes in depth
DepthMap.Sharpiness = 0.01

-- What depth and below is considered as rock/land, in range [0,1]
DepthMap.RockDepth = 0.05

-- Returns depth from range [0, 1]
function DepthMap:getDepth(x, y)
    return love.math.noise(x*DepthMap.Sharpiness, y*DepthMap.Sharpiness)
end

-- Returns boolean
function DepthMap:depthIsRock(depth)
    return depth < DepthMap.RockDepth
end

-- Returns boolean
function DepthMap:isRockAt(x, y)
    return DepthMap:getDepth(x, y) < DepthMap.RockDepth
end

-- Draws the depth map centered in map coordinates (x,y) and width, height in pixels 
function DepthMap:debugDraw(mapX, mapY, drawWidth, drawHeight)
    cellSize = 5
    halfWidth = drawWidth/2
    halfHeight = drawHeight/2
    for y=mapY-halfHeight,drawHeight,cellSize do
        for x=mapX-halfWidth,drawWidth,cellSize do
            depth = DepthMap:getDepth(x+cellSize/2,y+cellSize/2)
            depthColor = 255 - depth*255
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
