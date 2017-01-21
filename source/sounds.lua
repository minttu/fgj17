Class = require "hump.class"

SoundPlayer = Class{
    soundPath = "assets/",
    init = function(self, soundNames)
        self.sources = {}
        self.volume = 1

        self.soundNames = soundNames

        for i, soundName in ipairs(soundNames) do
            self.sources[soundName] = love.audio.newSource(self.soundPath .. soundName)
        end
    end,
    stopAll = function(sel)
        for name, source in pairs(self.sources) do
            source:stop()
        end
    end
}

AmbientPlayer = Class{
    __includes = SoundPlayer,
    init = function(self, soundNames)
        SoundPlayer.init(self, soundNames)

    end,
    play = function(self)
        for name, source in pairs(self.sources) do
            source:setLooping(true)
            source:play()
        end
    end,
    stop = function(self)
        self.stopAll()
    end
}


return {
    ambient = AmbientPlayer({"bg_humm_01.ogg", "rain_01.ogg"})
}
