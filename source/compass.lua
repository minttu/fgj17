Vector = require "hump.vector"
Class = require 'hump.class'

local frame = love.graphics.newImage("assets/graphics/gauge.png")

Compass = Class {
    northRotation = -math.pi/2,
    angle = 0,
    pos = Vector(0, 0),
    size = 0
}

function Compass:init(x, y, size)
    self.pos.x = x
    self.pos.y = y
    self.pos.size = size
end

function Compass:update(dt, angle)
end

function Compass:draw()
    local scale = self.size / frame:getWidth()
    love.graphics.draw(frame, x, y, scale, scale)
end

return Compass
