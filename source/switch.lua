Class = require 'hump.class'

local base = love.graphics.newImage("assets/graphics/switch_base.png")
local stick_on = love.graphics.newImage("assets/graphics/switch_know_up.png")
local stick_off = love.graphics.newImage("assets/graphics/switch_know_down.png")

Switch = Class {
    enabled = false,
    x = 0,
    y = 0,
    scale = 0.1
}

function Switch:init(x, y, on)
    self.x = x
    self.y = y
    self.enabled = on or false
end

function Switch:mouseReleased(x, y)
    if x>self.x and x<self.x+base:getWidth()/self.scale and y > self.y and y < self.y+base:getHeight()/self.scale then
        self.enabled = not self.enabled
    end
end

function Switch:draw(x, y)
    love.graphics.draw(base, self.x, self.y, 0, self.scale, self.scale)
    love.graphics.draw(self.enabled and stick_on or stick_off, self.x, self.y, 0, self.scale, self.scale)
end

return Switch
