local background = {}

background.canvas = nil
background.rain_minlen = 10
background.rain_maxlen = 100
background.raindrops = {}
background.dropcount = 0

function background:update(drawWidth, drawHeight)
    if background.dropcount < 6000 then
        background.dropcount = background.dropcount + 1
    end
    if not self.canvas or self.canvas:getWidth() ~= drawWidth or self.canvas:getHeight() ~= drawHeight then
        self.canvas = love.graphics.newCanvas(drawWidth, drawHeight)
        self.canvas:setFilter("linear")
    end
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear(0, 0, 20)
    while #self.raindrops < background.dropcount do
        local x1 = math.random(-self.rain_maxlen/2,2*drawWidth)
        local y1 = -50
        local dx, dy = math.random(1, 3), math.random(30, 50)
        local len = math.random(self.rain_minlen,self.rain_maxlen)
        table.insert(background.raindrops, {x1, y1, dx, dy, len})
    end
    for i=#self.raindrops,1,-1 do
        drop = self.raindrops[i]
        drop[1] = drop[1] + drop[3]
        drop[2] = drop[2] + drop[4]
        x1 = drop[1]
        y1 = drop[2]
        len = drop[5]
        love.graphics.setColor(len*2,len*2,len*2.55)
        x2 = x1 - drop[3]*4
        y2 = y1 - drop[4]*2
        love.graphics.setLineStyle("rough")
        love.graphics.setLineWidth(4)
        love.graphics.line(x1, y1, x2, y2)
        if drop[2] > 2*drawHeight  then
            table.remove(self.raindrops, i)
        end
    end
    love.graphics.setCanvas()
end

function background:draw(x, y)
    local o_r, o_g, o_b = love.graphics.getColor()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.canvas, x, y)
    love.graphics.setColor(o_r, o_g, o_b)
end

return background
