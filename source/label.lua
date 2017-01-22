Class = require "hump.class"

fonts = require "fonts"

Label = Class{
    init = function(self, text, pos, rev)
        self.text = text
        self.pos = pos
        self.rev = rev or false
    end,
    draw = function(self)
        if self.rev then
            love.graphics.setFont(fonts.labelR)
        else
            love.graphics.setFont(fonts.label)
        end

        love.graphics.printf(self.text, self.pos.x, self.pos.y, 100, "center")
    end
}

return Label
