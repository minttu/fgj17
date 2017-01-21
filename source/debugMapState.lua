DepthMap = require "seaDepthMap"
Ship = require "ship"
Radar = require "radar"
Sounds = require "sounds"
Gauge = require "gauge"

-- Map to visualize the locations, ship movement and depth
local debugMapState = {}

ship = Ship.new()
radar = Radar.new()
local gauge = Gauge()

function debugMapState:enter()
    Sounds.ambient:play()
end

function debugMapState.draw()
    -- Draws the map covering the entire window
    DepthMap:debugDraw(0,0,canvas_w,canvas_h)

    -- draw Ship location
    ship:draw()

    -- draw the radar
    radar:draw()
    gauge:draw()

    -- draw Goal location
end

function debugMapState.update(self, dt)
    -- Draws the map covering the entire window
    ship:update(dt)
    radar:update(dt)
    Sounds.misc:update(dt)
end

return debugMapState
