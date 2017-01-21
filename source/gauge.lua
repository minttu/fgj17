class = require "hump.class"

local bg = love.graphics.newImage("assets/graphics/gauge.png")
local arm = love.graphics.newImage("assets/graphics/gauge_arm.png")


local gauge = class{
    init = function(self, val)
        self.val = val
        self.radius = 300
        self.offset = 0
        self.actual = 0
        self.speed = 0.05
    end,
    update = function(self)
        self.offset = math.random(0, self.val * 20)/200
        local change = self.val - self.actual;
        if math.abs(change) > self.speed then
            change = change / math.abs(change) * self.speed
        end
        self.actual = self.actual + change
    end,
    draw = function(self)
        local scale = self.radius / bg:getHeight()
        love.graphics.draw(bg, 0, 0, 0, scale, scale)

        local r = -2.1 + 4.2 * self.actual + self.offset;

        love.graphics.draw(arm, 150, 150, r, scale, scale, arm:getWidth()/2, 380 )
    end
}

return gauge
