local background = {}

background.canvas = nil
background.rain_x_offset_per_y = 0.3
background.rain_minlen = 10
background.rain_maxlen = 100

function background:update(drawWidth, drawHeight)
    if not self.canvas or self.canvas:getWidth() ~= drawWidth or self.canvas:getHeight() ~= drawHeight then
        self.canvas = love.graphics.newCanvas(drawWidth, drawHeight)
        self.canvas:setFilter("linear")
    end
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear(0, 0, 60)
    for i=1,1000 do
        local x1, y1 = math.random(-self.rain_maxlen/2,drawWidth), math.random(-self.rain_maxlen/2,drawHeight)
        local len = math.random(self.rain_minlen,self.rain_maxlen)
        love.graphics.setColor(len*2,len*2,len*2.55)
        x2 = x1 + len*self.rain_x_offset_per_y
        y2 = y1 + len
        love.graphics.setLineStyle("rough")
        love.graphics.setLineWidth(4)
        love.graphics.line(x1, y1, x2, y2)
    end
    love.graphics.setCanvas()
end

function background:draw(x, y)
    local o_r, o_g, o_b = love.graphics.getColor()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.canvas, x, y)
    love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
    love.graphics.setColor(o_r, o_g, o_b)
end

return background
