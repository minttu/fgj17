Class = require "hump.class"
vector = require "hump.vector"
Rendering = require "rendering.rendering"


local ledBase = love.graphics.newImage("assets/graphics/led.png")
local ledLight = love.graphics.newImage("assets/graphics/led_effect.png")
local imgLight = love.graphics.newImage("assets/graphics/imglightred.png")


Led = Class{
    init = function(self, pos)
        self.blinkGap = 0.2
        self.blinkTime = self.blinkGap
        self.enabled = false
        self.blinking = false
        self.pos = pos + vector(-13, 25)
    end,
    draw = function(self)
        love.graphics.draw(ledBase, self.pos.x, self.pos.y, 0, 0.05, 0.05)
        if self.enabled then
            love.graphics.draw(ledLight, self.pos.x, self.pos.y, 0, 0.05, 0.05)
            Rendering.light(true)
            love.graphics.draw(imgLight, self.pos.x+ledLight:getWidth()*0.025, self.pos.y+ledLight:getHeight()*0.025, 0, 1, 1, 250, 250)
            Rendering.light(false)
        end
    end,
    update = function(self, dt)
        if self.blinking then
            if self.blinkTime < 0 then
                self.blinkTime = self.blinkGap
                self.enabled = not self.enabled
            else
                self.blinkTime = self.blinkTime - dt
            end
        end
    end,
}

return Led
