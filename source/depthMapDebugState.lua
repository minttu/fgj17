DepthMap = require "seaDepthMap"
Ship = require "ship"
Sounds = require "sounds"

local depthMapDebugState = {}

ship = Ship.new()

function depthMapDebugState:enter()
    Sounds.ambient:play()
end

function depthMapDebugState:draw()
    -- Draws the map covering the entire window
    DepthMap:debugDraw()
    ship:draw()
end

function depthMapDebugState:update()
    -- Draws the map covering the entire window
    ship:update()
end

return depthMapDebugState
