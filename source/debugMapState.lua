vector = require "hump.vector"
DepthMap = require "seaDepthMap"
Rudder = require "rudder"
Ship = require "ship"
Radar = require "radar"
Sounds = require "sounds"
Gauge = require "gauge"
Rendering = require "rendering.rendering"
Compass = require "compass"

Background = require "background"

-- Map to visualize the locations, ship movement and depth
local debugMapState = {}

local windowFrame = love.graphics.newImage("assets/graphics/frame_grey.png")
local console = love.graphics.newImage("assets/graphics/console.png")
local fishFinderFrame = love.graphics.newImage("assets/graphics/fish_finder.png")

local ship = Ship(100, 100)

local radar = Radar(vector((1920 / 2) + 550, 800), 200)

local rollGauge = Gauge(vector((1920 / 4) - 240, 660), 100)
local pitchGauge = Gauge(vector((1920 / 4), 660), 100)

local rudderGauge = Gauge(vector((1920 / 4) - 240, 890), 100, 0.5)
local fuelGauge = Gauge(vector((1920 / 4), 890), 100)

local rudder = Rudder(vector(1920 / 2, 1000), 0.5)

local compass = Compass((1920 / 2) - 200, (1080 / 2), 400, 400, 3)

local isDebugging = false

local windowtranslation = {0, 0}
local consoletranslation = {0, 0}

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

    love.graphics.push()
    love.graphics.translate(windowtranslation[1], windowtranslation[2])

    love.graphics.draw(windowFrame, 0, 0)

    love.graphics.push()
    love.graphics.translate(consoletranslation[1], consoletranslation[2])

    love.graphics.draw(console, 72, 512, 0, 1.1, 1)

    rudderGauge:draw()
    rollGauge:draw()
    pitchGauge:draw()
    fuelGauge:draw()
    rudder:draw()
    compass:draw()



    if isDebugging == false then
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.rectangle("fill", radar.x - radar.size - 5, radar.y - radar.size - 5, (radar.size * 2) + 5, (radar.size * 2) + 5)
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.draw(fishFinderFrame, radar.x - radar.size - 14, radar.y - radar.size - 14, 0, 0.43, 0.43)
        radar:draw()
    else
        love.graphics.push()
        love.graphics.translate(radar.x - radar.size - 14, radar.y - radar.size - 14)

        DepthMap:debugDraw()
        ship:draw()

        love.graphics.pop()
    end

    love.graphics.pop() -- console
    love.graphics.pop() -- window
end

local accumulator = 0

function debugMapState.update(self, dt)
    accumulator = accumulator + dt
    windowtranslation = {0, 5 * math.sin(accumulator)}
    consoletranslation = {0, 30*math.sin(accumulator)}

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

    compass:update(dt, ship:angle())

    fuelGauge.val = ship.fuel
    fuelGauge:update(dt)

    Sounds.misc:update(dt)
    Background:update(canvas_w, canvas_h)
end

function debugMapState:mousereleased(x,y, mouse_btn)
    if mouse_btn == 1 then
        rudder:mouseReleased(x,y)
    end
end

function debugMapState:keyreleased(key)
    if key == "f3" then
        isDebugging = not isDebugging
    end
end

return debugMapState
