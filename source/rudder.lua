vector = require "hump.vector"

Rudder = {}
Rudder.imageScale = 0.25
Rudder.screenPos = vector(400,400) -- Center of the rudder
Rudder.angle = 0 -- Radians
Rudder.mouseButtonDown = false
Rudder.maxMouseTrail = 30 -- for getting the momentum to the rudder (eventually)
Rudder.mouseTrailIndex = 0 -- Pointers ":D"
Rudder.mouseTrail = {} -- new array of vector

function Rudder.new()
    local self = setmetatable({}, {__index = Rudder})
    self.image = love.graphics.newImage("assets/graphics/wheel.png")
    -- assume that rudder is stationary in screen coords
    self.originOffset = vector(self.image:getWidth()/2, self.image:getHeight()/2)
    return self
end

function Rudder:mouseReleased(x,y)
    -- math
end

function Rudder:getLastMousePos()
    return self.mouseTrail[self.mouseTrailIndex]
end

function Rudder:update()
    if love.mouse.isDown(1) then
        x,y = love.mouse.getPosition()
        newMousePos = vector(x*(1/scx),y*(1/scy)) - self.screenPos
        oldMousePos = self:getLastMousePos() or newMousePos

        moveAngle = oldMousePos:angleTo(newMousePos)
        self.angle = self.angle - moveAngle

        -- RRD Array
        self.mouseTrailIndex = self.mouseTrailIndex + 1
        if self.mouseTrailIndex > self.maxMouseTrail then
            self.mouseTrailIndex = 0
        end
        self.mouseTrail[self.mouseTrailIndex] = newMousePos

    end
end

function Rudder:draw()
    love.graphics.setColor(255,255,255)
    love.graphics.draw(self.image, self.screenPos.x, self.screenPos.y,
        self.angle, self.imageScale, self.imageScale,
        self.originOffset.x, self.originOffset.y)

    love.graphics.rectangle("fill", self.screenPos.x, self.screenPos.y, 5, 5)
end

return Rudder
