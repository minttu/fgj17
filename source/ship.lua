cpml = require "cpml"

local Ship = {}
Ship.__index = Ship

Ship.location = cpml.vec2.new(0,0)
Ship.velocity = 1
Ship.orientation = cpml.quat.new(0, 0, 0, 1)
Ship.turnrate = 0.1 -- radians/tick

function Ship.new()
    local self = setmetatable({}, Ship)
    self.orientation = cpml.quat.new(1, 0, 0, 1)
    return self
end

function Ship.angle(self)
    ang = rot:to_vec3()
    ang1 = math.atan2(0, 1)
    ang2 = math.atan2(ang.y, ang.x)
    angle = (ang1 - ang2) % (2*math.pi)
    return angle
end

function Ship.updateLocation(self)

    rot = self.orientation

    if love.keyboard.isDown( "left" ) then
        turn = cpml.quat.from_angle_axis(-Ship.turnrate, cpml.vec3.unit_z)
        rot = rot * turn
    end

    if love.keyboard.isDown( "right" ) then
        turn = cpml.quat.from_angle_axis(Ship.turnrate, cpml.vec3.unit_z)
        rot = rot * turn
    end

    rot = rot:normalize()
    angle = self:angle()

    velocityVector = cpml.vec2.new(1 * math.cos(angle), 1 * math.sin(angle))
    self.location = self.location + velocityVector

    self.orientation = rot
end

function Ship.checkProblems(self)
    if DepthMap.isRockAt(self.location.x, self.location.y) then
        -- TODO: HIT ROCK
    end
end

function Ship.update(self)
    self:updateLocation()
    --self:checkProblems()
end

function Ship.draw(self)
    local vertices = {-10, -10, 10, -10, 10, 10, -10, 10}
    angle = self:angle()
    for i = 1, (#vertices)/2 do
        x = vertices[2*i-1]
        y = vertices[2*i]
        vertices[2*i-1] = x * math.cos(angle) - y * math.sin(angle)
        vertices[2*i] = x * math.sin(angle) + y * math.cos(angle)
        vertices[2*i-1] = vertices[2*i-1] + self.location.x;
        vertices[2*i] = vertices[2*i] + self.location.y;
    end

    angle = self:angle()
    love.graphics.polygon('fill', vertices)
end

return Ship
