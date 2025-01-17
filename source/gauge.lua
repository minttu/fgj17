class = require "hump.class"
Vector = require "hump.vector"

Label = require "label"

local bg = love.graphics.newImage("assets/graphics/gauge.png")
local arm = love.graphics.newImage("assets/graphics/gauge_arm.png")


local gauge = class{
    init = function(self, name, pos, radius, val)
        self.val = val or 0
        self.radius = radius or 100
        self.offset = 0
        self.actual = 0
        self.speed = 1
        self.pos = pos or Vector(0, 150)
        self.label = Label(name, pos + Vector(-50, 50))
    end,
    update = function(self, dt)
        self.offset = math.random(0, self.val * 20)/800
        local change = self.val - self.actual;
        if math.abs(change) > self.speed*dt then
            change = change / math.abs(change) * self.speed*dt
        end
        self.actual = self.actual + change
    end,
    draw = function(self)
        local scale = self.radius*2 / bg:getHeight()
        love.graphics.draw(bg, self.pos.x+0, self.pos.y+0, 0, scale, scale, bg:getWidth()/2, bg:getHeight()/2)

        local r = -2.1 + 4.2 * self.actual + self.offset;

        love.graphics.draw(arm, self.pos.x, self.pos.y, r, scale, scale, arm:getWidth()/2, 380 )

        self.label:draw()
    end
}

return gauge
