cpml = require "cpml"

local Radar = {}
Radar.__index = Radar

Radar.angle = 0
Radar.speed = 0.5
Radar.size = 300
Radar.x = 900
Radar.y = 700

function Radar.new()
    local self = setmetatable({}, Radar)
    return self
end

function Radar.update(self, dt)
    self.angle = (self.angle + self.speed*dt) % (2*math.pi)
end

function Radar.draw(self)
    x = self.size
    y = self.size
    xx = x * math.cos(self.angle) -- - y * math.sin(self.angle)
    yy = x * math.sin(self.angle) -- + y * math.cos(self.angle)

    x = xx + self.x
    y = yy + self.y

    love.graphics.line(self.x, self.y, x, y)
end

return Radar
