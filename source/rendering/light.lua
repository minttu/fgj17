class = require "hump.class"

light = class{
    init = function(self, pos, color, intensity)
        self.pos = pos
        self.color = color
        self.intensity = intensity
    end
}

return light
