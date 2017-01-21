cpml = require "cpml"

Sounds = require "sounds"

local Radar = {}
Radar.__index = Radar

Radar.angle = 0
Radar.previousangle = 0
Radar.speed = 2
Radar.size = 300
Radar.x = 900
Radar.y = 700
Radar.seenobjects = {}

function Radar.new()
    local self = setmetatable({}, Radar)
    return self
end

function Radar.update(self, ship, dt)

    objects = {500, 200, 400, 100, 100, 1000}

    self.previousangle = self.angle
    self.angle = (self.angle + self.speed*dt) % (2*math.pi)

    for i = 1, (#objects)/2 do
        x = objects[2*i-1]
        y = objects[2*i]
        dx = x - ship.location.x
        dy = y - ship.location.y
        angle = math.atan2(dy, dx) % (2*math.pi)
        if (self.angle > self.previousangle and angle >= self.previousangle and angle <= self.angle) or
            (self.angle < self.previousangle and (angle >= self.previousangle or angle <= self.angle)) then
            table.insert(self.seenobjects, {dx, dy, 255})
            Sounds.ui:play("radar")
        end
    end
    --    angle = math.atan2(obj.y, obj.x)
    --    if angle >= self.previousangle && angle <= self.angle 
    --      add to seenobjects
end

function Radar.draw(self)
    x = self.size
    y = self.size
    xx = x * math.cos(self.angle) -- - y * math.sin(self.angle)
    yy = x * math.sin(self.angle) -- + y * math.cos(self.angle)

    x = xx + self.x
    y = yy + self.y

    love.graphics.setColor(0, 20, 0)
    love.graphics.circle("fill", self.x, self.y, self.size)

    love.graphics.setColor(0, 200, 0)
    love.graphics.circle("line", self.x, self.y, self.size)
    love.graphics.circle("line", self.x, self.y, self.size/1.5)
    love.graphics.circle("line", self.x, self.y, self.size/3)

    love.graphics.setColor(0, 255, 0)
    love.graphics.line(self.x, self.y, x, y)

    for i = 1, (#self.seenobjects) do
        obj = self.seenobjects[i]
        x = obj[1]
        y = obj[2]
        x = math.tanh(x/100)*100 + self.x
        y = math.tanh(y/100)*100 + self.y
        a = obj[3]
        love.graphics.setColor(255, 255, 255, a)
        love.graphics.circle("fill", x, y, 10)
        -- love.graphics.line(self.x, self.y, x, y)
    end

    for i = #self.seenobjects,1,-1 do
        self.seenobjects[i][3] = self.seenobjects[i][3] - 1.2
        if self.seenobjects[i][3] < 0 then
            table.remove(self.seenobjects, i)
        end
    end

    love.graphics.setColor(255, 255, 255)

end

return Radar
