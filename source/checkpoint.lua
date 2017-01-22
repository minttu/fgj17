Class = require "hump.class"
vector = require "hump.vector"
DepthMap = require "seaDepthMap"


local Checkpoints = Class
    { GenerationRange = 30*8
    , CollisionDistance = 18
    , locations = {}
    , current = nil
    , counter = 0
    }

-- startLocation is vector
function Checkpoints:init(startLocation, seed)
    --self.seed = seed or os.clock()
    self:createCheckpoint(startLocation)
end

function Checkpoints:createCheckpoint(origin)
    while true do
        local phi = math.random()*2*math.pi
        local new = origin + (vector(self.GenerationRange,0):rotated(phi))
        if not DepthMap:isRockAt(new.x, new.y) then
            table.insert(self.locations,new)
            self.current = new
            self.counter = self.counter + 1
            return new
        end
    end
end

function Checkpoints:getAngleTo(location)
    return vector(1,0):angleTo(self.current-location)
end

function Checkpoints:checkCollision(location)
    return (location - self.current):len() < self.CollisionDistance
end

return Checkpoints
