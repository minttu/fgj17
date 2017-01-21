Rudder = require "rudder"
local hello = {}

rudder = Rudder.new()
function hello.load()
end

function hello:mousereleased(x,y, mouse_btn)
    if mouse_btn == 1 then
        Rudder.mouseReleased(x,y)
    end
end

function hello.draw()
    love.graphics.print("Hello Rudder!", 960, 540)
    rudder:draw()
end

function hello.update()
    rudder:update()
end

return hello
