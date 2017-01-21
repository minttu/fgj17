vector = require "hump.vector"
DepthMap = require "seaDepthMap"
Rudder = require "rudder"
Ship = require "ship"
Radar = require "radar"
Sounds = require "sounds"
Gauge = require "gauge"
Rendering = require "rendering.rendering"
Compass = require "compass"
fonts = require "fonts"

Background = require "background"
Wiper = require "wiper"
Switch = require "switch"

-- Map to visualize the locations, ship movement and depth
local debugMapState = {}

local windowFrame = love.graphics.newImage("assets/graphics/frame_grey.png")
local console = love.graphics.newImage("assets/graphics/console.png")
local fishFinderFrame = love.graphics.newImage("assets/graphics/fish_finder.png")

local ship = Ship(100, 100)

local radar = Radar(vector((1920 / 2) + 550, 800), 200)

local rollGauge = Gauge("roll", vector((1920 / 4) - 240, 660), 100)
local pitchGauge = Gauge("pitch", vector((1920 / 4), 660), 100)

local rudderGauge = Gauge("rudder", vector((1920 / 4) - 240, 890), 100, 0.5)
local fuelGauge = Gauge("fuel", vector((1920 / 4), 890), 100)

local rudder = Rudder(vector(1920 / 2, 1000), 0.5)

local compass = Compass((1920 / 2) - 300, (1080 / 2) + 4, 600, 600, 3)

local leftwiper = Wiper(580, 4, math.pi-0.02, 0.08, 0.5, 1.15)
local rightwiper = Wiper(1340, 4, 0.05, math.pi-0.05, 0, 1.15)
local wiperswitch = Switch(1920/2+500, 800)

local isDebugging = false

local windowtranslation = {0, 0}
local consoletranslation = {0, 0}
local roll = 0

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
    love.graphics.translate(1920/2, 1080/2)
    love.graphics.rotate(roll)
    love.graphics.translate(-1920/2, -1080/2)
    love.graphics.translate(windowtranslation[1], windowtranslation[2])

    leftwiper:draw()
    rightwiper:draw()
    w, h = windowFrame:getDimensions()
    love.graphics.draw(windowFrame, -w/2 + 1920/2, -h/2 + 1080/2, 0, 1, 1.05)

    love.graphics.push()
    love.graphics.translate(consoletranslation[1], consoletranslation[2])

    love.graphics.draw(console, 72, 512, 0, 1.1, 1)

    wiperswitch:draw()
    rudderGauge:draw()
    rollGauge:draw()
    pitchGauge:draw()
    fuelGauge:draw()
    rudder:draw()

    love.graphics.setFont(fonts.small)

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
local draws = 0

function debugMapState.update(self, dt)
    accumulator = accumulator + dt

    radar:update(dt, ship)
    rudder:update(dt)
    ship.turnspeed = ship.maxturnspeed * (rudder.angle / rudder.maxangle)
    ship:update(dt)

    multiplier = 12
    windowtranslation = {math.sin(2*accumulator), multiplier*ship.orientation.y}
    consoletranslation = {3*math.sin(2*accumulator), 5*multiplier*ship.orientation.y}
    roll = ship.orientation.x / 4

    draws = draws + 1
    if (isDebugging) then
        DepthMap:debugDrawUpdate(ship.location.x, ship.location.y, 400, 400)
    elseif draws > 30 then
        DepthMap:update(ship.location.x, ship.location.y, 700, 700)
        draws = 0
    end

    rollGauge.val = ship:getRoll()/(2*math.pi) + 0.5
    pitchGauge.val = ship:getPitch()/(2*math.pi) + 0.5

    rollGauge:update(dt)
    pitchGauge:update(dt)

    rudderGauge.val = (ship.turnspeed * 25) + 0.5
    rudderGauge:update(dt)

    compass:update(dt, ship:angle())

    fuelGauge.val = ship.fuel
    fuelGauge:update(dt)

    local playedRandomSound = Sounds.misc:update(dt)
    if playedRandomSound == "thunder_01.ogg" then
        Background:flash(180)
    end
    if playedRandomSound == "thunder_02.ogg" then
        Background:flash(255)
    end
    Background:update(canvas_w, canvas_h)
    leftwiper:update(dt)
    rightwiper:update(dt)
end

function debugMapState:mousereleased(x,y, mouse_btn)
    if mouse_btn == 1 then
        rudder:mouseReleased(x,y)
        wiperswitch:mouseReleased(x,y)
    end
end

function debugMapState:keyreleased(key)
    if key == "f3" then
        isDebugging = not isDebugging
    end
end

return debugMapState
