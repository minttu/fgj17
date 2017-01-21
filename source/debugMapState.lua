DepthMap = require "seaDepthMap"
Rudder = require "rudder"
Ship = require "ship"
Radar = require "radar"
Sounds = require "sounds"
Gauge = require "gauge"

-- Map to visualize the locations, ship movement and depth
local debugMapState = {}

ship = Ship.new()
radar = Radar.new()
local gauge = Gauge(0)
local rudder = Rudder(0,0)

function debugMapState:enter()
    Sounds.ambient:play()
    DepthMap:debugDrawUpdate(0,0,canvas_w,canvas_h)
    rudder:init(canvas_w/2, canvas_h*0.82)
end

function debugMapState.draw()
    -- Draws the map covering the entire window
    DepthMap:debugDraw()

    -- draw Ship location
    ship:draw()

    -- draw the radar
    radar:prerender()
    radar:draw()
    gauge:draw()
    rudder:draw()

    -- draw Goal location
end

function debugMapState.update(self, dt)
    -- Draws the map covering the entire window
    radar:update(dt, ship)
    gauge:update(dt)
    rudder:update(dt)
    ship.turnspeed = rudder.angle*0.0001
    ship:update(dt)
    Sounds.misc:update(dt)
end

function debugMapState:mousereleased(x,y, mouse_btn)
    if mouse_btn == 1 then
        rudder:mouseReleased(x,y)
    end
end

return debugMapState
