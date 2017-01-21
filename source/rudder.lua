vector = require "hump.vector"

Rudder = {}
Rudder.screenPos = vector(200,200) -- Center of the rudder
Rudder.angle = 0 -- Radians
Rudder.mouseButtonDown = false
Rudder.maxMouseTrail = 30 -- for getting the momentum to the rudder (eventually)
Rudder.mouseTrailIndex = 0 -- Pointers ":D"
Rudder.mouseTrail = {} -- new array of vector

function Rudder:new()
    self.image = love.graphics.newImage("assets/graphics/ruori-tmp.png")
    -- assume that rudder is stationary in screen coords
    self.imagePos = self.screenPos - vector(self.image.getWidth()/2, self.image.getHeight()/2)
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
        newMousePos = vector(x,y) - self.screenPos
        oldMousePos = self.getLastMousePos()

        moveAngle = oldMousePos:angleTo(newMousePos)
        self.angle = self.angle + moveAngle

        -- RRD Array
        self.mouseTrail[self.mouseTrailIndex] = newMousePos
        self.mouseTrailIndex = self.mouseTrailIndex + 1
        if self.mouseTrailIndex > self.maxMouseTrail then
            self.mouseTrailIndex = 0
        end
    end
end

function Rudder:draw()
    love.graphics.draw(self.image, self.imagePos.x, self.imagePos.y, self.angle)
end

return Rudder
