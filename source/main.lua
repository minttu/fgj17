gamestate = require "hump.gamestate"
helloWorld = require "helloworld"
depthMapDebugState = require "depthMapDebugState"

function love.load()
    love.window.setMode(1920, 1080, {borderless=true})
    gamestate.registerEvents()
    gamestate.switch(helloWorld)
    --gamestate.switch(depthMapDebugState)
end
