Class = require "hump.class"

fonts = require "fonts"

Label = Class{
    init = function(self, text, pos)
        self.text = text
        self.pos = pos
    end,
    draw = function(self)
        love.graphics.setFont(fonts.label)
        love.graphics.printf(self.text, self.pos.x, self.pos.y, 100, "center")
    end
}

return Label
