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
    self.mapCenterX = (minX+maxX)/2
    self.mapCenterY = (minY+maxY)/2
    self.mapWidth = maxX-minX + 100
    self.mapHeight = maxY-minY + 100
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
        local iStep = love.keyboard.isDown("left") and 1 or (love.keyboard.isDown("right") and 4 or 2)
        if (self.trail.n >= 4) then
            love.graphics.line(unpack(self.trail))
        end
        love.graphics.draw(boat, 800+self.mapWidth/2+(shipState.pos.x-self.mapCenterX), 160+self.mapHeight/2+(shipState.pos.y-self.mapCenterY), shipState.yaw+math.pi/2
                         , 0.35-0.15*(math.abs(shipState.roll)/math.pi*2), 0.35-0.1*(math.abs(shipState.pitch)/math.pi*2), boat:getWidth()/2, boat:getHeight()/2)
        if self.pathI < self.shipPath.n then
            for i=self.pathI,math.min(self.pathI + iStep, self.shipPath.n)-1 do
                table.insert(self.trail, 800+self.mapWidth/2+(self.shipPath[i].pos.x-self.mapCenterX))
                table.insert(self.trail, 160+self.mapHeight/2+(self.shipPath[i].pos.y-self.mapCenterY))
                self.trail.n = self.trail.n + 2
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
