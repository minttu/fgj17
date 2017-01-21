require "util"
cpml = require "cpml"

Sounds = require "sounds"

local Ship = {}
Ship.__index = Ship

Ship.location = cpml.vec2.new(100, 100)
Ship.velocity = 8
Ship.orientation = cpml.quat.new(0, 0, 0, 1)
Ship.turnrate = 0.01
Ship.maxturnspeed = 0.1
Ship.turnspeed = 0

function Ship.new()
    local self = setmetatable({}, Ship)
    self.orientation = cpml.quat.new(1, 0, 0, 1)
    return self
end

function Ship.angle(self)
    local rot = self.orientation
    ang = rot:to_vec3()
    return -math.atan2(ang.y, ang.x)
end


function Ship:getRoll()
    local rot = self.orientation:to_vec3()
    local ang = math.atan2(rot.y, rot.z)
    return fixAtan2Angle(ang)
end
function Ship:getPitch()
    local rot = self.orientation:to_vec3()
    local ang = math.atan2(rot.x, rot.z)
    return fixAtan2Angle(ang)
end

function Ship.updateLocation(self, dt)

    rot = self.orientation

    if love.keyboard.isDown( "left" ) then
        self.turnspeed = self.turnspeed - self.turnrate*dt
        if self.turnspeed < -self.maxturnspeed then
            self.turnspeed = -self.maxturnspeed
        end
    end

    if love.keyboard.isDown( "right" ) then
        self.turnspeed = self.turnspeed + self.turnrate*dt
        if self.turnspeed > self.maxturnspeed then
            self.turnspeed = self.maxturnspeed
        end
    end

    self.turnspeed = self.turnspeed / 1.01 -- slowly normalize

    turn = cpml.quat.from_angle_axis(self.turnspeed, cpml.vec3.unit_z)
    rot = rot * turn
    print(rot)
    print(turn)

    rot = rot:normalize()
    angle = self:angle()

    velocityVector = cpml.vec2.new(self.velocity * math.cos(angle), self.velocity * math.sin(angle))*dt
    self.location = self.location + velocityVector

    self.orientation = rot
end

function Ship.checkProblems(self)
    if DepthMap.isRockAt(self.location.x, self.location.y) then
        -- TODO: HIT ROCK
    end
end

function Ship.update(self, dt)
    self:updateLocation(dt)
    Sounds.ui:update(dt)
    Sounds.ui:depthWarning(DepthMap:getDepth(self.location.x, self.location.y))
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
