DepthMap = require "seaDepthMap"

local depthMapDebugState = {}

function depthMapDebugState.draw()
    -- Draws the map covering the entire window
    DepthMap:debugDraw()
end

return depthMapDebugState
