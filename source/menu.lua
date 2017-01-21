gamestate = require "hump.gamestate"
debugMapState = require "debugMapState"
Rendering = require "rendering.rendering"

fonts = require "fonts"

local menu = {}

function play()
    gamestate.switch(debugMapState)
end

function exit()
    love.event.quit(0)
end

function menu:enter()
    self.options = {{"Play", play}, {"Exit", exit}}
    self.selected = 1
    love.graphics.setFont(fonts.menu)

    self:initLogo()
end

logo = {}

function menu:initLogo()
    name = "Tyrsky"
    for i = 1,#name do
        local c = name:sub(i,i)
        table.insert(logo, {c, 450 + 128 * i, 100})
    end
end

accumulator = 0

function menu:updateLogo(dt)
    accumulator = accumulator + dt
    for i = 1,#logo do
        logo[i][3] = 200 + 20 * math.sin(accumulator + i)
    end
end

function menu:drawLogo()
    love.graphics.setFont(fonts.bigMenu)
    for i = 1,#logo do
        love.graphics.print(logo[i][1], logo[i][2], logo[i][3])
    end
    love.graphics.setFont(fonts.menu)
end

function menu:draw()
    love.graphics.push()
    Rendering.scale()
    self:drawLogo()

    love.graphics.printf("\"game\" by\n\n\nNicklas Ahlskog\n\nJaakko Hannikainen\n\nTuomas Kinnunen\n\nAllan Palmu\n\nJuhani Imberg\n\nEsa Niemi", 350, 500, 500, "right")

    for i = 1,#self.options do
        if i == self.selected then
            love.graphics.setColor(200, 200, 200)
        end
        love.graphics.print(self.options[i][1], 1050, 400 + (i * 96))
        love.graphics.setColor(100, 100, 100)
    end
    love.graphics.pop()
end

function menu:update(dt)
    self:updateLogo(dt)
end

function menu:keyreleased(key)
    if key == "up" then
        self.selected = math.max(1, self.selected-1)
    end
    if key == "down" then
        self.selected = math.min(#self.options, self.selected+1)
    end
    if key == "space" or key == "return" then
        self.options[self.selected][2]()
    end
end

return menu
