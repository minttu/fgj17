gamestate = require "hump.gamestate"
Rendering = require "rendering.rendering"

fonts = require "fonts"

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
end

function gameover:render_map()
    local minX, maxX, minY, maxY
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
    print("map is ".. self.mapWidth .. " by ".. self.mapHeight)
    seaDepthMap:debugDrawUpdate(self.mapCenterX, self.mapCenterY, self.mapWidth, self.mapHeight, 2)
end

function gameover:draw()
    love.graphics.push()
    Rendering.scale()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print(self.message, 100, 200)
    love.graphics.pop()
    if not self.first_draw_done then
        self.first_draw_done = true
        self:render_map()
    else
        love.graphics.print("map (press right/left)", 804, 120)
        seaDepthMap:debugDraw(800,160)
        local shipState = self.shipPath[self.pathI]
        local iStep = love.keyboard.isDown("left") and 2 or (love.keyboard.isDown("right") and 8 or 4)
        for i,val in ipairs(self.trail) do
            love.graphics.setLineWidth(3)
            local r,g,b = love.graphics.getColor()
            love.graphics.setColor(120,0,20)
            love.graphics.line(val.x0,val.y0,val.x1,val.y1)
            love.graphics.setColor(r,g,b)
        end
        love.graphics.draw(boat, 800+self.mapWidth/2+(shipState.pos.x-self.mapCenterX), 160+self.mapHeight/2+(shipState.pos.y-self.mapCenterY), shipState.yaw+math.pi/2
                         , 0.35-0.15*(math.abs(shipState.roll)/math.pi*2), 0.35-0.1*(math.abs(shipState.pitch)/math.pi*2), boat:getWidth()/2, boat:getHeight()/2)
        if self.pathI < self.shipPath.n then
            for i=self.pathI,math.min(self.pathI + iStep, self.shipPath.n)-1 do
                if ((i-1)%(self.trailSegmentLen*2)) < self.trailSegmentLen then
                    table.insert(self.trail, {x0 = 800+self.mapWidth/2+(self.shipPath[i].pos.x-self.mapCenterX), y0 = 160+self.mapHeight/2+(self.shipPath[i].pos.y-self.mapCenterY)
                                        ,x1 = 800+self.mapWidth/2+(self.shipPath[i+1].pos.x-self.mapCenterX), y1 = 160+self.mapHeight/2+(self.shipPath[i+1].pos.y-self.mapCenterY)})
                    self.trail.n = self.trail.n + 1
                end
            end
            self.pathI = math.min(self.pathI + iStep, self.shipPath.n)
        end
    end
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
