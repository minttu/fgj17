gamestate = require "hump.gamestate"
Rendering = require "rendering.rendering"

local gameover = {}

function gameover:shipCrashed()
    self.message = "You shipped over a rock"
    gamestate.switch(gameover)
end

function gameover:draw()
    love.graphics.push()
    Rendering.scale()
    love.graphics.print(self.message, 100, 200)
    love.graphics.pop()
end

function gameover:keyreleased(key)
    if key == "space" or key == "return" then
        love.event.quit("restart")
    end
end

return gameover
