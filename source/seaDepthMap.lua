
local DepthMap = {}

DepthMap.canvas = nil

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

function DepthMap:debugDrawUpdate(mapX, mapY, drawWidth, drawHeight)
    local cellSize = 10
    local halfWidth = drawWidth/2
    local halfHeight = drawHeight/2
    if not self.canvas or self.canvas:getWidth() ~= drawWidth or self.canvas:getHeight() ~= drawHeight then
        self.canvas = love.graphics.newCanvas(drawWidth, drawHeight)
        self.canvas:setFilter("nearest")
    end
    love.graphics.setCanvas(self.canvas)
    love.graphics.setPointSize(cellSize)
    love.graphics.clear()
    for y=mapY-halfHeight,drawHeight,cellSize do
        for x=mapX-halfWidth,drawWidth,cellSize do
            depth = DepthMap:getDepth(x,y)
            depthColor = 255 - depth*255
            if DepthMap:depthIsRock(depth) then
                love.graphics.setColor(255,0,0)
            else
                love.graphics.setColor(depthColor,depthColor,depthColor)
            end
            love.graphics.points(x, y)
        end
    end
    love.graphics.setCanvas()
end

-- Draws the depth map centered in map coordinates (x,y) and width, height in pixels
function DepthMap:debugDraw()
    local o_r, o_g, o_b = love.graphics.getColor()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.canvas)
    love.graphics.setColor(o_r, o_g, o_b)
end

return DepthMap
