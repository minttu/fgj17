Class = require "hump.class"
vector = require "hump.vector"


local ledBase = love.graphics.newImage("assets/graphics/led.png")
local ledLight = love.graphics.newImage("assets/graphics/led_effect.png")


Led = Class{
    init = function(self, pos)
        self.enabled = false
        self.pos = pos + vector(-13, 25)
    end,
    draw = function(self)
        love.graphics.draw(ledBase, self.pos.x, self.pos.y, 0, 0.05, 0.05)
        if self.enabled then
            love.graphics.draw(ledLight, self.pos.x, self.pos.y, 0, 0.05, 0.05)
        end
    end,
}

return Led
