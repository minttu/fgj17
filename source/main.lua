gamestate = require "hump.gamestate"
helloWorld = require "helloworld"
debugMapState = require "debugMapState"

--local scx, scy
canvas_w, canvas_h = 1920, 1080

function love.load()
    local desktop_w, desktop_h = love.window.getDesktopDimensions()

    scx = desktop_w / canvas_w
    scy = desktop_h / canvas_h
    love.window.setMode(desktop_w, desktop_h, {fullscreen=true,fullscreentype="exclusive",msaa=4})
    gamestate.registerEvents()
    --gamestate.switch(helloWorld)
    gamestate.switch(debugMapState)

end
