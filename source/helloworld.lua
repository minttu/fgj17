Rudder = require "rudder"
local hello = {}

rudder = Rudder()
function hello.load()
end

function hello:mousereleased(x,y, mouse_btn)
    if mouse_btn == 1 then
        rudder:mouseReleased(x,y)
    end
end

function hello.draw()
    love.graphics.print("Hello Rudder!", 960, 540)
    rudder:draw()
end

function hello:update(dt)
    rudder:update(dt)
end

return hello
