Class = require 'hump.class'

local img = love.graphics.newImage("assets/graphics/crap_wiper.png")

Wiper = Class {
      speed = 2
    , start_angle = 0
    , end_angle = math.pi
    , timer = 0
    , angle = 0
}

function Wiper:init(start_ang, end_ang, speed)
    self.start_angle = start_ang
    self.end_angle = end_ang
    self.speed = speed
end

function Wiper:update(dt)
    self.timer = (self.timer + self.speed*dt) % 2
    self.angle = self.start_angle + (self.end_angle - self.start_angle) * (self.timer>1 and 2-self.timer or self.timer)
end

function Wiper:draw(x, y)
    love.graphics.draw(img, x, y, self.angle, 1, 1, 14, img:getHeight()/2)
end

return Wiper
