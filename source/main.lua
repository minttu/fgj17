gamestate = require "hump.gamestate"
helloWorld = require "helloworld"
depthMapDebugState = require "depthMapDebugState"

local scx, scy
local canvas_w, canvas_h = 1920, 1080

function love.load()
    local desktop_w, desktop_h = love.window.getDesktopDimensions()
    scx = desktop_w / canvas_w
    scy = desktop_h / canvas_h
    love.window.setMode(desktop_w, desktop_h, {borderless=true})
    gamestate.registerEvents()
    gamestate.switch(helloWorld)
    --gamestate.switch(depthMapDebugState)

end

function love.draw()
    love.graphics.scale(scx,scy)

end
