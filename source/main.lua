gamestate = require "hump.gamestate"
helloWorld = require "helloworld"

renderingSandbox = require "rendering.sandbox"
--depthMapDebugState = require "depthMapDebugState"
debugMapState = require "debugMapState"

local scx, scy
canvas_w, canvas_h = 1920, 1080

function love.load()
    local desktop_w, desktop_h = love.window.getDesktopDimensions()
    scx = desktop_w / canvas_w
    scy = desktop_h / canvas_h
    gamestate.registerEvents()
    --gamestate.switch(renderingSandbox)

    love.window.setMode(desktop_w, desktop_h, {borderless=true,msaa=4})
    gamestate.registerEvents()
    --gamestate.switch(helloWorld)
    gamestate.switch(debugMapState)

end

function love.draw()
    love.graphics.scale(scx,scy)
end
