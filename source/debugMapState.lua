DepthMap = require "seaDepthMap"
Ship = require "ship"
Radar = require "radar"
Sounds = require "sounds"

-- Map to visualize the locations, ship movement and depth
local debugMapState = {}

ship = Ship.new()
radar = Radar.new()

function debugMapState:enter()
    Sounds.ambient:play()
    DepthMap:debugDrawUpdate(0,0,canvas_w,canvas_h)
end

function debugMapState.draw()
    -- Draws the map covering the entire window
    DepthMap:debugDraw()

    -- draw Ship location
    ship:draw()

    -- draw the radar
    radar:draw()

    -- draw Goal location
end

function debugMapState.update(self, dt)
    -- Draws the map covering the entire window
    ship:update(dt)
    radar:update(dt)
    Sounds.misc:update(dt)
end

return debugMapState
