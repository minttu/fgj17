vector = require "hump.vector"

-- fix angle from atan2 between [-pi, pi]
function fixAtan2Angle(angle)
    if angle > math.pi then return angle - 2*math.pi
    elseif angle < -math.pi then return angle + 2*math.pi
    else return angle
    end
end

function vec2toVector(vec)
    return vector(vec.x, vec.y)
end
