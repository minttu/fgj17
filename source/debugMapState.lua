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
Checkpoints = require "checkpoint"
require "util"

Background = require "background"
Wiper = require "wiper"
Switch = require "switch"
Led = require "led"
Label = require "label"

-- Map to visualize the locations, ship movement and depth
local debugMapState = {}

local windowFrame = love.graphics.newImage("assets/graphics/frame_grey.png")
local console = love.graphics.newImage("assets/graphics/console2.png")
local fishFinderFrame = love.graphics.newImage("assets/graphics/fish_finder.png")
local imgLightBig = love.graphics.newImage("assets/graphics/imglightbig.png")

local ship = Ship(100, 100)

local radar = Radar(vector((1920 / 2) + 550, 800), 200)

local rollGauge = Gauge("roll", vector((1920 / 4) - 240, 660), 100)
local pitchGauge = Gauge("pitch", vector((1920 / 4), 660), 100)
local rollLed = Led(vector((1920 / 4 -240), 660))
local pitchLed = Led(vector((1920 / 4), 660))

local rudderGauge = Gauge("rudder", vector((1920 / 4) - 240, 890), 100, 0.5)
local fuelGauge = Gauge("fuel", vector((1920 / 4), 890), 100)
local fuelLed = Led(vector((1920 / 4), 890))

local depthLed = Led(vector((1920 / 2) + 216, 616))
local depthLabel = Label("depth\nwarning", vector((1920 / 2) + 200 - 32, 675), true)

local rudder = Rudder(vector(1920 / 2, 1000), 0.5)

local compass = Compass((1920 / 2) - 300, (1080 / 2) + 14, 600, 600, 3)

local leftwiper = Wiper(580, 4, math.pi-0.02, 0.08, 0.5, 1.15)
local rightwiper = Wiper(1340, 4, 0.05, math.pi-0.05, 0, 1.15)

local wiperSwitch = Switch("wipers", (1920/2) - 200 - 16, 630)
local radarSoundsSwitch = Switch("beep", (1920/2) - 100 - 16, 630)
local lightSwitch = Switch("lights", (1920/2) - 16, 630)

local isDebugging = false

local windowtranslation = {0, 0}
local consoletranslation = {0, 0}
local roll = 0

local shadowFactor = 0.5

local desktop_w, desktop_h = love.window.getDesktopDimensions()
local mainCanvas = love.graphics.newCanvas(desktop_w*Rendering.factor, desktop_h*Rendering.factor)

local checkpoints = Checkpoints(vec2toVector(ship.location))

function debugMapState:enter()
    mainCanvas:setFilter("linear", "linear")
    Sounds.ambient:play()
    DepthMap:debugDrawUpdate(0, 0, 400, 400)

    compass.markers =
        { {color = {255,0,0}, rotation=2, width=2, text="F"}
        }
end

function debugMapState.drawScene()

    love.graphics.push()
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

    debugMapState.drawSwitch(wiperSwitch)
    debugMapState.drawSwitch(radarSoundsSwitch)
    debugMapState.drawSwitch(lightSwitch)

    depthLed:draw()
    depthLabel:draw()


    rudderGauge:draw()
    rollGauge:draw()
    pitchGauge:draw()
    fuelGauge:draw()
    fuelLed:draw()
    pitchLed:draw()
    rollLed:draw()

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

    love.graphics.push()
    local xrudderScale = 1.0
    local yrudderScale = 1.1
    local xoff = -10 / xrudderScale
    local yoff = 40 / yrudderScale
    love.graphics.translate((1-xrudderScale)*rudder.screenPos.x+xoff,(1-yrudderScale)*rudder.screenPos.y + yoff)
    love.graphics.scale(xrudderScale, yrudderScale)
    love.graphics.setColor(0,0,0, 255 * shadowFactor)
    rudder:draw()
    love.graphics.pop()
    love.graphics.setColor(255,255,255)
    rudder:draw()

    if lightSwitch.enabled then
        Rendering.light(true)
        love.graphics.draw(imgLightBig, 1920/2, 0, 0, 1, 1, 0, 200)
        love.graphics.draw(imgLightBig, 1920/2, 0, 0, -1, 1, 0, 200)
        Rendering.light(false)
    end

    love.graphics.pop() -- console
    love.graphics.pop() -- window
    love.graphics.pop() -- scale
end

function debugMapState.drawSwitch(switch)
    love.graphics.push()
    local xrudderScale = 1.0
    local yrudderScale = 1.1
    local xoff = 3 / xrudderScale
    local yoff = 25 / yrudderScale
    love.graphics.translate((1-xrudderScale)*rudder.screenPos.x+xoff,(1-yrudderScale)*rudder.screenPos.y + yoff)
    love.graphics.scale(xrudderScale, yrudderScale)
    love.graphics.setColor(0,0,0, 255 * shadowFactor)
    switch:draw()
    love.graphics.pop()
    love.graphics.setColor(255,255,255)
    switch:draw()
    switch.label:draw()
end

function debugMapState.draw()
    local bgBrightness = 128

    love.graphics.setBlendMode("alpha")
    radar:prerender()
    love.graphics.setColor(255,255,255)


    love.graphics.setCanvas(mainCanvas)
    love.graphics.setShader(Rendering.kiviLightShader)
    rendering.setBgColor({bgBrightness, bgBrightness, bgBrightness, 255})
    Rendering.light(false)
    love.graphics.clear(0,0,0,256)

    debugMapState.drawScene()


    love.graphics.setCanvas()
    love.graphics.clear()
    love.graphics.setShader()

    love.graphics.setColor(255,255,255)
    love.graphics.scale(1/Rendering.factor, 1/Rendering.factor)
    love.graphics.draw(mainCanvas)
end

local accumulator = 0
local draws = 0

function debugMapState.update(self, dt)
    accumulator = accumulator + dt

    Sounds.ui:update(dt)

    radar:update(dt, ship, radarSoundsSwitch.enabled)
    rudder:update(dt)
    ship.turnspeed = ship.maxturnspeed * (rudder.angle / rudder.maxangle)
    ship:update(dt)
    fuelLed.blinking = ship.fuel < 0.2
    fuelLed:update(dt)

    depthLed.blinking = DepthMap:getDepth(ship.location.x, ship.location.y) < 0.2
    depthLed:update(dt)

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

    rollGauge.val = -ship:getRoll()*2/(2*math.pi) + 0.5
    pitchGauge.val = ship:getPitch()*2/(2*math.pi) + 0.5

    rollGauge:update(dt)
    pitchGauge:update(dt)

    rudderGauge.val = (ship.turnspeed * 25) + 0.5
    rudderGauge:update(dt)

    compass:update(dt, ship:angle())

    fuelGauge.val = ship.fuel
    fuelGauge:update(dt)

    Sounds.misc:update(dt)
    Background:update(canvas_w, canvas_h/4 * 4)

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

    local playerLoc = vec2toVector(ship.location)
    local ang = checkpoints:getAngleTo(playerLoc)
    compass.markers[1].rotation = -ang + math.pi
    if checkpoints:checkCollision(playerLoc) then
        checkpoints:createCheckpoint(playerLoc)
        ship.fuel = ship.fuel + ship.fuelConsumptionMultiplier*ship.velocity*2500
        local c = {{255,0,255},{255,255,0}}
        compass.markers[1].color = c[checkpoints.counter % 2 + 1]
    end

    if lightSwitch.enabled then
        shadowFactor = 0.5
    else
        shadowFactor = 0.3
    end


    rollLed.blinking = rollGauge.val < 0.2 or rollGauge.val > 0.8
    pitchLed.blinking = pitchGauge.val < 0.2 or pitchGauge.val > 0.8

    rollLed:update(dt)
    pitchLed:update(dt)

end

function debugMapState:mousereleased(x,y, mouse_btn)
    local screen_to_console_space = function(x, y)
        local xb, yb = x/scx, y/scy
        xb, yb = xb - 1920/2, yb - 1080/2
        xb = xb * math.cos(-roll) - yb * math.sin(-roll)
        yb = xb * math.sin(-roll) + yb * math.cos(-roll)
        xb, yb = xb + 1920/2, yb + 1080/2
        xb, yb = xb - (consoletranslation[1]+windowtranslation[1]), yb - (consoletranslation[2]+windowtranslation[2])
        return xb, yb
    end
    if mouse_btn == 1 then
        rudder:mouseReleased(x,y)
        wiperSwitch:mouseReleased(screen_to_console_space(x,y))
        radarSoundsSwitch:mouseReleased(screen_to_console_space(x,y))
        lightSwitch:mouseReleased(screen_to_console_space(x,y))
        leftwiper:enable(wiperSwitch.enabled)
        rightwiper:enable(wiperSwitch.enabled)
    end
end

function debugMapState:keyreleased(key)
    if key == "f3" then
        isDebugging = not isDebugging
    end
end

return debugMapState
