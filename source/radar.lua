Class = require "hump.class"
cpml = require "cpml"
rendering = require "rendering.rendering"
Sounds = require "sounds"
DepthMap = require "seaDepthMap"
Rendering = require "rendering.rendering"

Radar = Class
    { angle = 0
    , previousangle = 0
    , speed = 3
    , size = 200
    , x = 1500
    , y = 800
    , range = 100
    , seenobjects = {}
    , beepvolume = 0.6
    }

function Radar:init(pos, size)

    self.x = pos.x
    self.y = pos.y
    self.size = size

    self.canvas = love.graphics.newCanvas(self.size*2, self.size*2, "rgba32f")
    self.prevCanvas = love.graphics.newCanvas(self.size*2, self.size*2, "rgba32f")

    love.graphics.setCanvas(self.prevCanvas)
    love.graphics.clear()
    love.graphics.setCanvas()
end

function Radar:prerender()
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()

    love.graphics.setShader(rendering.fader)
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.prevCanvas)
    love.graphics.setShader()

    for i = 1, (#self.seenobjects) do
        obj = self.seenobjects[i]
        x = obj[1]/3
        y = obj[2]/3
        len = math.sqrt(x*x + y*y)
        if len < self.range/1.05 then
            a = obj[3]
            love.graphics.setColor(0, 255, 0)
            scale = self.size / self.range
            love.graphics.circle("fill", scale * x + self.size, scale * y + self.size, 4)
            -- love.graphics.line(self.x, self.y, x, y)
        end
    end

    local xx = self.size + self.size * math.cos(self.angle) -- - y * math.sin(self.angle)
    local yy = self.size + self.size * math.sin(self.angle) -- + y * math.cos(self.angle)
    local oxx = self.size + self.size * math.cos(self.previousangle) -- - y * math.sin(self.angle)
    local oyy = self.size + self.size * math.sin(self.previousangle) -- + y * math.cos(self.angle)

    love.graphics.setLineWidth(2)
    love.graphics.setColor(0, 200, 0)
    love.graphics.circle("line", self.size, self.size, self.size)
    love.graphics.circle("line", self.size, self.size, self.size/1.5)
    love.graphics.circle("line", self.size, self.size, self.size/3)

    love.graphics.setColor(0, 255, 0)
    love.graphics.polygon("fill", self.size, self.size, oxx, oyy, xx, yy)

    love.graphics.setColor(255, 255, 255)
    love.graphics.setCanvas()

    local tmp = self.prevCanvas
    self.prevCanvas = self.canvas
    self.canvas = tmp
end

function Radar:update(dt, ship, soundsEnabled)

    self.previousangle = self.angle
    self.angle = (self.angle + self.speed*dt) % (2*math.pi)

    for i = 1, (#DepthMap.objects) do
        obj = DepthMap.objects[i]
        xx = obj[1]
        yy = obj[2]
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
            if len < self.size/2 then
                table.insert(self.seenobjects, {dx, dy, 255})
                if soundsEnabled then
                    Sounds.ui:play("radar", 0.1 + (self.beepvolume-0.1)*(1 - (len / (self.size/2))))
                end
            end
        end
    end

    for i = #self.seenobjects,1,-1 do
        self.seenobjects[i][3] = self.seenobjects[i][3] - 300*self.speed*dt/(math.pi*2)
        if self.seenobjects[i][3] < 0 then
            table.remove(self.seenobjects, i)
        end
    end
end

function Radar:draw()
    love.graphics.setColor(0, 20, 0)
    love.graphics.circle("fill", self.x, self.y, self.size)

    love.graphics.setColor(255, 255, 255)
    Rendering.light(true)
    love.graphics.draw(self.prevCanvas, self.x-self.size, self.y-self.size)
    Rendering.light(false)

end

return Radar
