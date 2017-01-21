gamestate = require "hump.gamestate"

local gameover = {}

function gameover:shipCrashed()
    self.message = "You shipped over a rock"
    gamestate.switch(gameover)
end

function gameover:draw()
    love.graphics.print(self.message, 100, 200)
end

function gameover:keyreleased(key)
    if key == "space" or key == "return" then
        gamestate.switch(menu)
    end
end

return gameover
