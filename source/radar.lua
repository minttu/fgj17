cpml = require "cpml"
rendering = require "rendering.rendering"

local Radar = {}
Radar.__index = Radar

Radar.angle = 0
Radar.previousangle = 0
Radar.speed = 0.5
Radar.size = 300
Radar.x = 900
Radar.y = 700
Radar.seenobjects = {}

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

function Radar.update(self, dt)
    self.previousangle = self.angle
    self.angle = (self.angle + self.speed*dt) % (2*math.pi)
    Radar.seenobjects = {}
    -- for obj in objects
    --    angle = math.atan2(obj.y, obj.x)
    --    if angle >= self.previousangle && angle <= self.angle
    --      add to seenobjects
end

function Radar.draw(self)
    love.graphics.setColor(0, 20, 0)
    love.graphics.circle("fill", self.x, self.y, self.size)
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.prevCanvas, self.x-self.size, self.y-self.size)

end

return Radar
