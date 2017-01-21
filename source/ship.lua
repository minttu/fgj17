vector = require "hump.vector"
DepthMap = require "seaDepthMap"

local Ship = {}

Ship.location = vector(0,0)
Ship.velocity = 1
Ship.orintation = "insert quaternion here" -- TODO


function Ship.updateLocation(self)
    angleOnXYPlane = 0 -- TODO
    velocityVector = vector(1,0)
    velocityVector:rotateInplace(angleOnXYPlane)
    self.location = self.location + velocityVector
end

function Ship.checkProblems(self)
    if DepthMap.isRockAt(self.location.x, self.location.y) then
        -- TODO: HIT ROCK
    end
end

function Ship.update(self)
    self.updateLocation()
    self.checkProblems()
end

return Ship
