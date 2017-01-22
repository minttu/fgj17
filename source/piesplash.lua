gamestate = require "hump.gamestate"
menu = require "menu"
Rendering = require "rendering.rendering"

local piesplash = {}

piesplash.entrytime = nil
piesplash.image = love.graphics.newImage("assets/graphics/piesome.png")
piesplash.timeout = 3
piesplash.brightness = 0
piesplash.fadeOutTime = 0.2
piesplash.fadeInTime = 0.2

local function enter()
    gamestate.switch(menu)
end

function piesplash:enter()
    self.entrytime = love.timer.getTime()
end

function piesplash:draw()
    love.graphics.push()
    Rendering.scale()

    love.graphics.setColor(self.brightness, self.brightness, self.brightness)
    love.graphics.draw(self.image)

    love.graphics.pop()
end

function piesplash:update(dt)
    if love.timer.getTime() >= self.entrytime + self.timeout then
        if self.brightness <= 0 then
            enter()
        else
            self.brightness = self.brightness - dt * 255/self.fadeOutTime
        end
    else
        if self.brightness < 255 then
            self.brightness = self.brightness + dt * 255/self.fadeInTime
        end
    end
end

function piesplash:keyreleased(key)
    self.timeout = 0
end

return piesplash
