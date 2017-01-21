class = require "hump.class"
Vector = require "hump.Vector"

local bg = love.graphics.newImage("assets/graphics/gauge.png")
local arm = love.graphics.newImage("assets/graphics/gauge_arm.png")


local gauge = class{
    init = function(self, val)
        self.val = val
        self.radius = 300
        self.offset = 0
        self.actual = 0
        self.speed = 0.05
        self.pos = Vector(0, 0)
    end,
    update = function(self, dt)
        self.offset = math.random(0, self.val * 20)/200
        local change = self.val - self.actual;
        if math.abs(change) > self.speed*dt then
            change = change / math.abs(change) * self.speed*dt
        end
        self.actual = self.actual + change
    end,
    draw = function(self)
        local scale = self.radius*2 / bg:getHeight()
        love.graphics.draw(bg, self.pos.x+0, self.pos.y+0, 0, scale, scale)

        local r = -2.1 + 4.2 * self.actual + self.offset;

        love.graphics.draw(arm, self.pos.x+self.radius, self.pos.y+self.radius, r, scale, scale, arm:getWidth()/2, 380 )
    end
}

return gauge
