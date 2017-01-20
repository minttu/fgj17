gamestate = require "hump.gamestate"
helloWorld = require "helloworld"

function love.load()
    love.window.setMode(1280, 720, {})
    gamestate.registerEvents()
    gamestate.switch(helloWorld)
end
