Vector = require "hump.vector"
Class = require 'hump.class'

local frame = love.graphics.newImage("assets/graphics/direction_indicator_borders.png")

Compass = Class {
    northRotation = -math.pi/2,
    rotation = 0,
    pos = Vector(0, 0),
    size = 0,
    linesBetween = 1,
    scrollSize = 0,
    speed = 1
}

function Compass:init(x, y, size, scrollSize, linesBetween)
    self.pos.x = x
    self.pos.y = y
    self.size = size
    self.scrollSize = scrollSize
    self.linesBetween = linesBetween
end

function Compass:update(dt, rotation)
    self.rotation = rotation
end

function Compass:drawText(txt, roff)
    local lineSpacing = self.scrollSize / (self.linesBetween*4 + 4)
    local xOffset = (-self.rotation-self.northRotation+roff)/(2*math.pi) * self.scrollSize + 3

    while xOffset > self.scrollSize do
        xOffset = xOffset - self.scrollSize
    end
    while xOffset < 0 do
        xOffset = xOffset + self.scrollSize
    end
    if xOffset < self.size - 10 then
        love.graphics.print(txt, self.pos.x + xOffset, self.pos.y + 8)
    end
end

function Compass:drawLine(x1, y1, x2, y2)
    if x1 < self.pos.x + self.size - 10 then
        if x1 > self.pos.x + 2 then
            love.graphics.line(x1, y1, x2, y2)
        end
    end
end

function Compass:draw()
    local scale = self.size / frame:getWidth()

    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.size,scale * frame:getHeight())
    love.graphics.setColor(255, 255, 255)

    local lineSpacing = self.scrollSize / (self.linesBetween*4+4)

    local xOffset = (-self.rotation)/(2*math.pi) * self.scrollSize

    for i=0, self.linesBetween*4+3, 1 do
        local x = i * lineSpacing + xOffset;

        while x > self.scrollSize do
            x = x - self.scrollSize
        end
        while x < 0 do
            x = x + self.scrollSize
        end

        local x = x + self.pos.x
        local y1 = self.pos.y
        local y2 = y1 + scale * frame:getHeight() - 1
        local y3 = y1 + (scale * frame:getHeight())/2
        self:drawLine(x, y1, x, y2)
        love.graphics.setColor(128, 128, 128)
        self:drawLine(x+lineSpacing/2, y3, x+lineSpacing/2, y2)
        love.graphics.setColor(255, 255, 255)
    end

    self:drawText("N", 0)
    self:drawText("E", math.pi/2)
    self:drawText("S", math.pi)
    self:drawText("W", -math.pi/2)

    love.graphics.draw(frame, self.pos.x, self.pos.y, 0, scale, scale)
end

return Compass
