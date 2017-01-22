gamestate = require "hump.gamestate"
Rendering = require "rendering.rendering"

fonts = require "fonts"

local gameover = {}

function gameover:shipCrashed()
    self.message = "You shipped over a rock"
    gamestate.switch(gameover)
end

function gameover:noFuel()
    self.message = "You shipped out of fuel"
    gamestate.switch(gameover)
end
function gameover:shipCapsized()
    self.message = "You shipped upside down"
    gamestate.switch(gameover)
end

function gameover:enter()
    love.graphics.setFont(fonts.menu)
end

function gameover:draw()
    love.graphics.push()
    Rendering.scale()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print(self.message, 100, 200)
    love.graphics.pop()
end

function gameover:keyreleased(key)
    if key == "space" or key == "return" then
        love.event.quit("restart")
    end
end

return gameover
