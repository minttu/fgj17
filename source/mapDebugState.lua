DepthMap = require "seaDepthMap"

-- Map to visualize the locations, ship movement and depth
local debugMapState = {}

function debugMapState.draw()
    -- Draws the map covering the entire window
    DepthMap:debugDraw(0,0,canvas_w,canvas_h)

    -- draw Ship location
    -- draw Goal location
end

return debugMapState
