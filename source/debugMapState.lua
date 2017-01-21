DepthMap = require "seaDepthMap"
Ship = require "ship"
Sounds = require "sounds"

-- Map to visualize the locations, ship movement and depth
local debugMapState = {}

ship = Ship.new()

function debugMapState:enter()
    Sounds.ambient:play()
end

function debugMapState.draw()
    -- Draws the map covering the entire window
    DepthMap:debugDraw(0,0,canvas_w,canvas_h)

    -- draw Ship location
    ship:draw()

    -- draw Goal location
end

function debugMapState:update()
    -- Draws the map covering the entire window
    ship:update()
end

return debugMapState
