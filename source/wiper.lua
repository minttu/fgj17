Class = require 'hump.class'

local img = love.graphics.newImage("assets/graphics/crap_wiper.png")

Wiper = Class {
      speed = 2
    , start_angle = 0
    , end_angle = math.pi
    , timer = 0
    , start_time = 0
    , angle = 0
    , enabled = false
    , x = 0
    , y = 0
}

function Wiper:init(x, y, min_ang, max_ang, start_time, speed)
    self.start_angle = min_ang or 0
    self.end_angle = max_ang or math.pi
    self.timer = start_time or 0
    self.start_time = start_time or 0
    self.speed = speed or 2
    self.x = x
    self.y = y
end

function Wiper:update(dt)
    if self.enabled or (self.timer > 0 and self.timer < 2) then
        self.timer = (self.timer + self.speed*dt) % 4
        local t = math.min(2, self.timer)
        self.angle = self.start_angle + (self.end_angle - self.start_angle) * (t>1 and 2-t or t)
    end
end

function Wiper:draw()
    love.graphics.draw(img, self.x, self.y, self.angle, 1, 1, 14, img:getHeight()/2)
end

function Wiper:enable(state)
    self.enabled = state
    if self.enabled then
        self.timer = 2 + self.start_time
    end
end

return Wiper
