gamestate = require "hump.gamestate"
helloWorld = require "helloworld"

function love.load()
    gamestate.registerEvents()
    gamestate.switch(helloWorld)
end
