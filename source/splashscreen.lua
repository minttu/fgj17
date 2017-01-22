gamestate = require "hump.gamestate"
menu = require "menu"
Rendering = require "rendering.rendering"

local splashscreen = {}

splashscreen.entrytime = nil
splashscreen.image = love.graphics.newImage("assets/graphics/GGJ00_GameCredits_SplashScreen.png")
splashscreen.timeout = 3

function enter()
    gamestate.switch(menu)
end

function splashscreen:enter()
    self.entrytime = love.timer.getTime()
end

function splashscreen:draw()
    love.graphics.push()
    Rendering.scale()

    love.graphics.draw(self.image)

    love.graphics.pop()
end

function splashscreen:update(dt)
    if love.timer.getTime() >= self.entrytime + self.timeout then
        enter()
    end
end

function splashscreen:keyreleased(key)
    enter()
end

return splashscreen
