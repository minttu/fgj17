gamestate = require "hump.gamestate"
helloWorld = require "helloworld"

renderingSandbox = require "rendering.sandbox"
--depthMapDebugState = require "depthMapDebugState"
debugMapState = require "debugMapState"

--local scx, scy
canvas_w, canvas_h = 1920, 1080

function love.load()
    local desktop_w, desktop_h = love.window.getDesktopDimensions()
    gamestate.registerEvents()
    --gamestate.switch(renderingSandbox)

    love.window.setMode(desktop_w, desktop_h, {borderless=true,msaa=4})
    gamestate.registerEvents()
    --gamestate.switch(helloWorld)
    gamestate.switch(debugMapState)
end
