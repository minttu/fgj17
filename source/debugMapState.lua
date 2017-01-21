vector = require "hump.vector"
DepthMap = require "seaDepthMap"
Rudder = require "rudder"
Ship = require "ship"
Radar = require "radar"
Sounds = require "sounds"
Gauge = require "gauge"
Rendering = require "rendering.rendering"

Background = require "background"

-- Map to visualize the locations, ship movement and depth
local debugMapState = {}

local windowFrame = love.graphics.newImage("assets/graphics/frame_grey.png")
local console = love.graphics.newImage("assets/graphics/console.png")
local fishFinderFrame = love.graphics.newImage("assets/graphics/fish_finder.png")

local ship = Ship(100, 100)
local radar = Radar(vector(304, 352), 164)

local rollGauge = Gauge(vector((1920 / 4) - 240, 660), 100)
local pitchGauge = Gauge(vector((1920 / 4), 660), 100)

local rudderGauge = Gauge(vector((1920 / 4) - 240, 890), 100, 0.5)
local idkGauge = Gauge(vector((1920 / 4), 890), 100)

local rudder = Rudder(vector(1920 / 2, 1080))

function debugMapState:enter()
    Sounds.ambient:play()
    DepthMap:debugDrawUpdate(0, 0, 400, 400)
end

function debugMapState.draw()
    love.graphics.scale(1, 1)

    radar:prerender()

    Rendering.scale()

    -- Draws the map covering the entire window
    -- DepthMap:debugDraw()
    Background:draw(0, 0)
    -- draw Ship location
    -- ship:draw()
    love.graphics.draw(windowFrame, 0, 0)
    love.graphics.draw(console, 72, 512, 0, 1.1, 1)
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.rectangle("fill", 133, 181, 340, 340)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(fishFinderFrame, 128, 176, 0, 0.35, 0.35)

    -- draw the radar
    radar:draw()
    rudderGauge:draw()
    rollGauge:draw()
    pitchGauge:draw()
    idkGauge:draw()
    rudder:draw()

    love.graphics.push()
    love.graphics.translate((1920 / 2) + 400, 600)

    DepthMap:debugDraw()
    ship:draw()

    love.graphics.pop()

    -- draw Goal location
end

function debugMapState.update(self, dt)
    -- Draws the map covering the entire window
    radar:update(dt, ship)
    rudder:update(dt)
    ship.turnspeed = ship.maxturnspeed * (rudder.angle / rudder.maxangle)
    ship:update(dt)
    DepthMap:debugDrawUpdate(ship.location.x, ship.location.y, 400, 400)

    rollGauge.val = ship:getRoll()/(2*math.pi) + 0.5
    pitchGauge.val = ship:getPitch()/(2*math.pi) + 0.5

    rollGauge:update(dt)
    pitchGauge:update(dt)

    rudderGauge.val = (ship.turnspeed * 25) + 0.5
    rudderGauge:update(dt)

    idkGauge:update(dt)

    Sounds.misc:update(dt)
    Background:update(canvas_w, canvas_h)
end

function debugMapState:mousereleased(x,y, mouse_btn)
    if mouse_btn == 1 then
        rudder:mouseReleased(x,y)
    end
end

return debugMapState
