gamestate = require "hump.gamestate"
debugMapState = require "debugMapState"

local menu = {}

function menu:draw()
    love.graphics.print("Press enter to play", 20, 400)
end

function menu:keyreleased(key)
    if key == "space" or key == "return" then
        gamestate.switch(debugMapState)
    end
end

return menu
