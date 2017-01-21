require "util"
vector = require "hump.vector"
Class = require 'hump.class'

Rudder = Class
    { imageScale = 0.25
    , screenPos = vector(0,0) -- Center of the rudder
    , angle = 0 -- Radians
    , mouseButtonDown = false
    , lastMousePos = nil -- last mouse position when holding mbutton
    , maxMouseTrail = 60 -- for getting the momentum to the rudder (eventually)
    , mouseTrailIndex = 0 -- Pointers ":D"
    , mouseTrail = {} -- new array of vector
    , currentTrailLen = 0
    , w = 0 -- Rotation velocity
    --, momentOfInertia = 0.25
    , friction = 0.995
    , maxangle = math.pi*6
}

function Rudder:init(x, y)
    self.screenPos = vector(x,y)
    self.image = love.graphics.newImage("assets/graphics/wheel.png")
    -- assume that rudder is stationary in screen coords
    self.originOffset = vector(self.image:getWidth()/2, self.image:getHeight()/2)
    --return self
end

function Rudder:mouseReleased(x,y)
    local lastPos = self:getLastMousePos() or vector(0)
    local goalDtForMoment = 0.9
    local refPosition = lastPos
    local dt = 0
    -- Sieniä
    -- loop newest to oldest
    for i=math.max(self.maxMouseTrail-1, self.currentTrailLen),0,-1 do
        local tmp = self.mouseTrail[(self.mouseTrailIndex+i)%self.maxMouseTrail] or 0
        if tmp ~= 0 then
            dt = dt + tmp.dt
            refPosition = tmp
            if dt > goalDtForMoment then
                break
            end
        end
    end
    if refPosition:len2() == 0 or lastPos:len2() == 0 then return end
    local dRot = - refPosition:angleTo(lastPos)
    -- Problems when x negative and y changes sign
    -- fix:
    dRot = fixAtan2Angle(dRot)

    self.w = dRot / dt

    self.mouseTrail = {}
    self.currentTrailLen = 0
    self.lastMousePos = nil
end

function Rudder:getLastMousePos()
    --return self.mouseTrail[self.mouseTrailIndex-1] or vector(0)
    return self.lastMousePos
end
function Rudder:getOldestMousePos()
    return self.mouseTrail[self.mouseTrailIndex] or self.mouseTrail[0]
end

function Rudder:update(dt)
    if love.mouse.isDown(1) then
        self.w = 0
        self.currentTrailLen = self.currentTrailLen + 1

        x,y = love.mouse.getPosition()
        newMousePos = vector(x*(1/scx),y*(1/scy)) - self.screenPos
        newMousePos.dt = dt
        oldMousePos = self:getLastMousePos() or newMousePos

        moveAngle = oldMousePos:angleTo(newMousePos)
        self.angle = self.angle - fixAtan2Angle(moveAngle)

        self.lastMousePos = newMousePos
        -- RRD Array
        self.mouseTrail[self.mouseTrailIndex] = newMousePos
        self.mouseTrailIndex = self.mouseTrailIndex + 1
        if self.mouseTrailIndex >= self.maxMouseTrail then
            self.mouseTrailIndex = 0
        end

        if self.angle > self.maxangle then
            self.angle = self.maxangle
        elseif self.angle < -self.maxangle then
            self.angle = -self.maxangle
        end

    else
        self.angle = self.angle + self.w * dt
        self.w = self.w * self.friction
        if self.angle > self.maxangle then
            self.angle = self.maxangle
            self.w = 0
        elseif self.angle < -self.maxangle then
            self.angle = -self.maxangle
            self.w = 0
        end
    end

end

function Rudder:draw()
    love.graphics.draw(self.image, self.screenPos.x, self.screenPos.y,
        self.angle, self.imageScale, self.imageScale,
        self.originOffset.x, self.originOffset.y)
end

return Rudder
