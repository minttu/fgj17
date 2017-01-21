Class = require "hump.class"
vector = require "hump.vector"


local Checkpoints = Class
    { GenerationRange = 40
    , CollisionDistance = 15
    , locations = {}
    , current = nil
    }

-- startLocation is vector
function Checkpoints:init(startLocation, seed)
    --self.seed = seed or os.clock()
    self:createCheckpoint(startLocation)
end

function Checkpoints:createCheckpoint(origin)
    local phi = math.random()*2*math.pi
    local new = origin:rotated(phi)
    table.insert(self.locations,new)
    self.current = new
    return new
end

function Checkpoints:getAngleTo(location)
    return vector(1,0):angleTo(self.current-location)
end

function Checkpoints:checkCollision(location)
    return (location - self.current):len() < self.CollisionDistance
end

return Checkpoints
