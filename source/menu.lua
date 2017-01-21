gamestate = require "hump.gamestate"
debugMapState = require "debugMapState"

local menu = {}

creditsOpen = false

function play()
    gamestate.switch(debugMapState)
end

function credits()
    creditsOpen = true
end

function exit()
    love.event.quit(0)
end

function menu:enter()
    self.options = {{"Play", play}, {"Credits", credits}, {"Exit", exit}}
    self.selected = 1
    self.makers = {
        {"Nicklas Ahlskog", "Programming"},
        {"Jaakko Hannikainen", "Programming"},
        {"Tuomas Kinnunen", "Programming"},
        {"Allan Palmu", "Programming"},
        {"Juhani Imberg", "Sounds & Programming"},
        {"Esa Niemi", "Graphics"}
    }
end

function menu:draw()
    if creditsOpen then
        for i = 1,#self.makers do
            name = self.makers[i][1]
            role = self.makers[i][2]
            love.graphics.print(name, 100, 200 + i*70)
            love.graphics.print(role, 400, 200 + i*70)
        end
    else
        for i = 1,#self.options do
            if i == self.selected then
                love.graphics.setColor(200, 200, 200)
            end
            love.graphics.print(self.options[i][1], 100, 400 + i*100)
            love.graphics.setColor(100, 100, 100)
        end
    end
end

function menu:keyreleased(key)
    if creditsOpen then
        if key == "space" or key == "return" then
            creditsOpen = false
        end
    else
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
end

return menu
