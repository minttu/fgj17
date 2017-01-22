
local DepthMap = {}

DepthMap.objects = {}

DepthMap.canvas = nil

-- How sharp changes in depth
DepthMap.Sharpiness = 0.005
DepthMap.SharpinessSmooth = 0.002

-- What depth and below is considered as rock/land, in range [0,1]
DepthMap.RockDepth = 0.1

-- Returns depth from range [0, 1]
function DepthMap:getDepth(x, y)
    local layerSharp = love.math.noise(x*DepthMap.Sharpiness, y*DepthMap.Sharpiness)
    --local layerSmooth = love.math.noise(x*DepthMap.SharpinessSmooth, y*DepthMap.SharpinessSmooth)
    --return (layerSmooth + layerSharp) / 2
    --return (layerSharp-0.5) * (layerSmooth) * 2 + 0.5
    return layerSharp
end

-- Returns boolean
function DepthMap:depthIsRock(depth)
    return depth < DepthMap.RockDepth
end

-- Returns boolean
function DepthMap:isRockAt(x, y)
    return DepthMap:getDepth(x, y) < DepthMap.RockDepth
end

function insertRock(x, y)
    -- if x < 0 or y < 0 then
    --     return
    -- end
    found = false
    for i = 1, (#DepthMap.objects) do
        obj = DepthMap.objects[i]
        dx = x - obj[1]
        dy = y - obj[2]
        if dx*dx + dy*dy < 4*(10*10) then
            found = true
            break
        end
    end
    if not found then
        table.insert(DepthMap.objects, {x, y})
    end
end

function DepthMap:update(mapX, mapY, drawWidth, drawHeight, cellSize)
    cellSize = cellSize or 4
    local halfWidth = drawWidth/2
    local halfHeight = drawHeight/2
    for y=1,drawHeight,cellSize do
        for x=1,drawWidth,cellSize do
            if DepthMap:depthIsRock(DepthMap:getDepth(mapX-halfWidth+x,mapY-halfHeight+y)) then
                insertRock(mapX-halfWidth+x, mapY-halfHeight+y)
            end
        end
    end
end

-- Draws the depth map centered in map coordinates (x,y) and width, height in pixels
function DepthMap:debugDrawUpdate(mapX, mapY, drawWidth, drawHeight, cellSize)
    cellSize = cellSize or 16
    local halfWidth = drawWidth/2
    local halfHeight = drawHeight/2
    if (not self.canvas) or (self.canvas:getWidth() ~= drawWidth) or (self.canvas:getHeight() ~= drawHeight) then
        self.canvas = love.graphics.newCanvas(drawWidth, drawHeight)
        self.canvas:setFilter("linear")
    end
    love.graphics.setCanvas(self.canvas)
    love.graphics.scale(1/scx,1/scy) -- this works for whatever reason
    love.graphics.setPointSize(cellSize)
    love.graphics.clear()
    for y=1,drawHeight,cellSize do
        for x=1,drawWidth,cellSize do
            depth = DepthMap:getDepth(mapX-halfWidth+x,mapY-halfHeight+y)
            depthColor = 255 - depth*160
            if DepthMap:depthIsRock(depth) then
                love.graphics.setColor(255,180,0)
            else
                love.graphics.setColor(depthColor*0.4,depthColor*0.6,depthColor)
            end
            love.graphics.points(x, y)
        end
    end
    love.graphics.setCanvas()
end

function DepthMap:debugDraw(x, y, scale)
    local o_r, o_g, o_b = love.graphics.getColor()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.canvas, x or 0, y or 0, 0, scale or 1, scale or 1)
    --love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
    love.graphics.setColor(o_r, o_g, o_b)
end

return DepthMap
