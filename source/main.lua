gamestate = require "hump.gamestate"
helloWorld = require "helloworld"
renderingSandbox = require "rendering.sandbox"

function love.load()
    gamestate.registerEvents()
    gamestate.switch(renderingSandbox)
end
