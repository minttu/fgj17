cpml = require "cpml"
rendering = require "rendering.rendering"

Sounds = require "sounds"

local Radar = {}
Radar.__index = Radar

Radar.angle = 0
Radar.previousangle = 0
Radar.speed = 2
Radar.size = 300
Radar.x = 1500
Radar.y = 700
Radar.seenobjects = {}
Radar.objects = {500, 200, 400, 100, 100, 1000, 50, 1000, 50, 900, 50, 800, 50, 700, 50, 600, 50, 500, 50, 400, 50, 300,
1000, 1000, 500, 1000, 1000, 0}

function Radar.new()
    local self = setmetatable({}, Radar)

    self.canvas = love.graphics.newCanvas(self.size*2, self.size*2, "rgba32f")
    self.prevCanvas = love.graphics.newCanvas(self.size*2, self.size*2, "rgba32f")

    love.graphics.setCanvas(self.prevCanvas)
    love.graphics.clear()
    love.graphics.setCanvas()

    return self
end

function Radar.prerender(self)
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()

    love.graphics.setShader(rendering.fader)
    love.graphics.draw(self.prevCanvas)
    love.graphics.setShader()

    local xx = self.size + self.size * math.cos(self.angle) -- - y * math.sin(self.angle)
    local yy = self.size + self.size * math.sin(self.angle) -- + y * math.cos(self.angle)

    love.graphics.setColor(0, 200, 0)
    love.graphics.circle("line", self.size, self.size, self.size)
    love.graphics.circle("line", self.size, self.size, self.size/1.5)
    love.graphics.circle("line", self.size, self.size, self.size/3)

    -- for obj in seenobjects, draw obj --

    love.graphics.setColor(0, 255, 0)
    love.graphics.line(self.size, self.size, xx, yy)

    love.graphics.setColor(255, 255, 255)

    love.graphics.setCanvas()

    local tmp = self.prevCanvas
    self.prevCanvas = self.canvas
    self.canvas = tmp
end

function Radar.update(self, dt, ship)

    self.previousangle = self.angle
    self.angle = (self.angle + self.speed*dt) % (2*math.pi)

    for i = 1, (#self.objects)/2 do
        xx = self.objects[2*i-1]
        yy = self.objects[2*i]
        sa = -ship:angle() - math.pi/2
        sin = math.sin(sa)
        cos = math.cos(sa)
        x = (xx - ship.location.x) * cos - (yy - ship.location.y) * sin + ship.location.x
        y = (xx - ship.location.x) * sin + (yy - ship.location.y) * cos + ship.location.y
        dx = x - ship.location.x
        dy = y - ship.location.y
        angle = math.atan2(dy, dx) % (2*math.pi)
        if (self.angle > self.previousangle and angle >= self.previousangle and angle <= self.angle) or
            (self.angle < self.previousangle and (angle >= self.previousangle or angle <= self.angle)) then
            len = math.sqrt(dx*dx + dy*dy)/3
            if len < self.size/1.05 then
                table.insert(self.seenobjects, {dx, dy, 255})
                Sounds.ui:play("radar", 0.25 + (0.75 - (len / (self.size/1.05))))
            end
        end
    end
end

function Radar.draw(self)
    love.graphics.setColor(0, 20, 0)
    love.graphics.circle("fill", self.x, self.y, self.size)

    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.prevCanvas, self.x-self.size, self.y-self.size)

    for i = 1, (#self.objects)/2 do
        x = self.objects[2*i-1]
        y = self.objects[2*i]
        love.graphics.circle("fill", x, y, 10)
    end

    for i = 1, (#self.seenobjects) do
        obj = self.seenobjects[i]
        x = obj[1]/3 + self.x
        y = obj[2]/3 + self.y
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
