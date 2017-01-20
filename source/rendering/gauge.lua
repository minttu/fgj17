class = require "hump.class"

local bg = love.graphics.newImage("assets/graphics/gauge.png")
local arm = love.graphics.newImage("assets/graphics/gauge_arm.png")


local gauge = class{
    init = function(self, val)
        self.val = val
        self.radius = 300
        self.offset = 0
    end,
    update = function(self)
        self.offset = math.random(0, 10)/200
    end,
    draw = function(self)
        local scale = self.radius / bg:getHeight()
        love.graphics.draw(bg, 0, 0, 0, scale, scale)

        local r = -2.1 + 4.2 * self.val + self.offset;

        love.graphics.draw(arm, 150, 150, r, scale, scale, arm:getWidth()/2, 380 )
    end
}

return gauge
