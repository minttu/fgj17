require "util"
cpml = require "cpml"
quat = cpml.quat
vec3 = cpml.vec3
mat4 = cpml.mat4
vector = require "hump.vector"
Sounds = require "sounds"
Class = require "hump.class"
gameover = require "gameover"


Ship = Class
    { location = cpml.vec2.new(100, 100)
    , velocity = 8
    , orientation = cpml.quat.new(0, 0, 0, 1)
    , turnrate = 0.01
    , maxturnspeed = 0.02
    , turnspeed = 0
    , fuel = 1
    , fuelConsumptionMultiplier = 0.00001
    --, seaWaveDirection = vector(1,0).rotated(-math.pi/2)
    , waveAmplitude = 15
    , waveSpeed = 4
    , t = 0
    , waveFrequency = 0.1
    , turnSpeedTiltMultiplier = math.pi/2
    }
function Ship:init(x, y)
    self.location = cpml.vec2.new(x, y)
    self.orientation = vector(0,0) -- roll, pitch --quat.from_angle_axis(0, vec3.unit_z)
    self.yaw = 0
    return self
end

function Ship:angle()
    --local rot = self.orientation
    --ang = rot:to_vec3()
    --return -math.atan2(ang.y, ang.x)
    return self.yaw
end


function Ship:getRoll()
    --local rot = self.orientation:to_vec3()
    --local ang = math.atan2(rot.y, rot.z)
    --return fixAtan2Angle(ang)
    return self.orientation.x
end
function Ship:getPitch()
    --local rot = self.orientation:to_vec3()
    --local ang = math.atan2(rot.x, rot.z)
    --return fixAtan2Angle(ang)
    return self.orientation.y
end

function Ship:getWaveHeight(loc, dt)
    --return mat4.from_angle_axis(math.cos(x*0.01)*math.pi*1.2/2+math.pi/2, vec3(1,0,0))
    return math.cos((loc.x+dt*self.waveSpeed)*self.waveFrequency)*self.waveAmplitude
end

function Ship:updateLocation(dt)
    self.t = self.t + dt

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

    --self.turnspeed = self.turnspeed / 1.01 -- slowly normalize

    --rot = self.orientation
    --turn = quat.from_angle_axis(self.turnspeed, cpml.vec3.unit_z)
    --rot = rot * turn

    self.yaw = self.yaw + self.turnspeed


    angle = self:angle()

    velocityVector = cpml.vec2.new(self.velocity * math.cos(angle), self.velocity * math.sin(angle))*dt
    self.location = self.location + velocityVector

    -- Waves
    local l = self.location
    l = vec3(l.x, l.y, self:getWaveHeight(l,dt))
    local xDir = vec3(self.velocity,0,0):rotate(angle, vec3(0,0,1))
    local forwR = xDir + l
    local forwardPoint = vec3(forwR.x,forwR.y,self:getWaveHeight(forwR,dt))
    local forw = forwardPoint - l

    local yDir = vec3(0,self.velocity,0):rotate(angle, vec3(0,0,1))
    local leftR = yDir + l
    local leftPoint = vec3(leftR.x,leftR.y,self:getWaveHeight(leftR,dt))
    local left = leftPoint - l

    local pitch = math.acos(xDir:dot(forw) / (xDir:len() * forw:len()))
    local roll =  math.acos(yDir:dot(left) / (yDir:len() * left:len()))

    -- Fix sign, don't know why it's not preserved by above math
    if l.z < forwardPoint.z then pitch = -pitch end
    if l.z < leftPoint.z then roll = -roll end

    -- Tilt by turning
    roll = roll - self.turnspeed/self.maxturnspeed

    self.orientation = vector(roll,pitch)

    self.fuel = self.fuel - self.velocity * self.fuelConsumptionMultiplier
end

function Ship:checkProblems()
    if DepthMap:isRockAt(self.location.x, self.location.y) then
        gameover:shipCrashed()
    end
    if self.fuel < 0 then
        gameover:noFuel()
    end
    if math.abs(self:getRoll()) > math.pi/2 then
        gameover:shipCapsized()
    end
end

function Ship:update(dt)
    self:updateLocation(dt)
    Sounds.ui:update(dt)
    Sounds.ui:depthWarning(DepthMap:getDepth(self.location.x, self.location.y))
    self:checkProblems()
end

function Ship:draw()
    local vertices = {-10, -10, 10, -10, 10, 10, -10, 10}
    angle = self:angle()
    for i = 1, (#vertices)/2 do
        x = vertices[2*i-1]
        y = vertices[2*i]
        vertices[2*i-1] = x * math.cos(angle) - y * math.sin(angle)
        vertices[2*i] = x * math.sin(angle) + y * math.cos(angle)
        vertices[2*i-1] = vertices[2*i-1] + 200;
        vertices[2*i] = vertices[2*i] + 200;
    end

    angle = self:angle()
    love.graphics.polygon('fill', vertices)
end

return Ship
