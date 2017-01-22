gamestate = require "hump.gamestate"
Rendering = require "rendering.rendering"

fonts = require "fonts"
Sounds = require "sounds"

seaDepthMap = require "seaDepthMap"

local boat = love.graphics.newImage("assets/graphics/boat.png")

local gameover = {}

gameover.shipPath = {n=0}
gameover.first_draw_done = false
gameover.mapCenterX = 0
gameover.mapCenterY = 0
gameover.mapWidth = 0
gameover.mapHeight = 0
gameover.pathI = 1
gameover.trail = {n=0}
gameover.trailSegmentLen = 120
gameover.mapscale = 1
gameover.mapLeftX = 800
gameover.mapTopY = 160

function gameover:shipCrashed(pathlog)
    self.shipPath = pathlog
    self.message = "You shipped over a rock\npress Space or Enter to restart\npress Esc to quit"
    gamestate.switch(gameover)
end

function gameover:noFuel(pathlog)
    self.shipPath = pathlog
    self.message = "You shipped out of fuel\npress Space or Enter to restart\npress Esc to quit"
    gamestate.switch(gameover)
end
function gameover:shipCapsized(pathlog)
    self.shipPath = pathlog
    self.message = "You shipped upside down\npress Space or Enter to restart\npress Esc to quit"
    gamestate.switch(gameover)
end

function gameover:enter()
    love.graphics.setFont(fonts.menu)
    love.audio.stop()
    Sounds.ui:play("gameover")
end

local minX, maxX, minY, maxY
function gameover:render_map()
    for i=1,self.shipPath.n do
        local pos = self.shipPath[i].pos
        minX = math.min(minX or math.huge, pos.x)
        minY = math.min(minY or math.huge, pos.y)
        maxX = math.max(maxX or -math.huge, pos.x)
        maxY = math.max(maxY or -math.huge, pos.y)
    end
    self.mapCenterX = math.floor((minX+maxX)/2)
    self.mapCenterY = math.floor((minY+maxY)/2)
    self.mapWidth = math.floor(maxX-minX + 180)
    self.mapHeight = math.floor(maxY-minY + 180)
    self.mapscale = math.min(1, math.min((1820-self.mapLeftX)/self.mapWidth, (980-self.mapTopY)/self.mapHeight))
    seaDepthMap:debugDrawUpdate(self.mapCenterX, self.mapCenterY, self.mapWidth, self.mapHeight, 2)
end

function gameover:draw()
    love.graphics.push()
    Rendering.scale()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print(self.message, 100, 200)
    if not self.first_draw_done then
        self.first_draw_done = true
        self:render_map()
    else
        local mapscale = self.mapscale
        love.graphics.print("map (press right/left)", gameover.mapLeftX+4, gameover.mapTopY-40)
        seaDepthMap:debugDraw(gameover.mapLeftX,gameover.mapTopY,mapscale)
        local shipState = self.shipPath[self.pathI]
        local iStep = love.keyboard.isDown("left") and 2 or (love.keyboard.isDown("right") and 8 or 4)
        local r,g,b = love.graphics.getColor()
        for i,val in ipairs(self.trail) do
            love.graphics.setLineWidth(math.ceil(3*mapscale))
            love.graphics.setColor(120,0,20)
            love.graphics.line(val.x0,val.y0,val.x1,val.y1)
        end
        for i=1,self.shipPath.checkpoints.n do
            love.graphics.setColor(80,200,20)
            love.graphics.circle("fill", gameover.mapLeftX+mapscale*(self.mapWidth/2+(self.shipPath.checkpoints[i].x-self.mapCenterX))
                                   , gameover.mapTopY+mapscale*(self.mapHeight/2+(self.shipPath.checkpoints[i].y-self.mapCenterY)), mapscale*12, 5)
        end
        love.graphics.setColor(r,g,b)
        love.graphics.draw(boat, gameover.mapLeftX+mapscale*(self.mapWidth/2+(shipState.pos.x-self.mapCenterX)), gameover.mapTopY+mapscale*(self.mapHeight/2+(shipState.pos.y-self.mapCenterY)), shipState.yaw+math.pi/2
                         , mapscale*(0.35-0.15*(math.abs(shipState.roll)/math.pi*2)), mapscale*(0.35-0.1*(math.abs(shipState.pitch)/math.pi*2)), boat:getWidth()/2, boat:getHeight()/2)
        if self.pathI < self.shipPath.n then
            for i=self.pathI,math.min(self.pathI + iStep, self.shipPath.n)-1 do
                if ((i-1)%(self.trailSegmentLen*2)) < self.trailSegmentLen then
                    table.insert(self.trail, {x0 = gameover.mapLeftX+mapscale*(self.mapWidth/2+(self.shipPath[i].pos.x-self.mapCenterX)), y0 = gameover.mapTopY+mapscale*(self.mapHeight/2+(self.shipPath[i].pos.y-self.mapCenterY))
                                        ,x1 = gameover.mapLeftX+mapscale*(self.mapWidth/2+(self.shipPath[i+1].pos.x-self.mapCenterX)), y1 = gameover.mapTopY+mapscale*(self.mapHeight/2+(self.shipPath[i+1].pos.y-self.mapCenterY))})
                    self.trail.n = self.trail.n + 1
                end
            end
            self.pathI = math.min(self.pathI + iStep, self.shipPath.n)
        end
    end
    love.graphics.pop()
end

function gameover:keyreleased(key)
    if key == "space" or key == "return" then
        love.event.quit("restart")
    end
    if key == "escape" then
        love.event.quit("exit")
    end
end

return gameover
