Class = require "hump.class"

SoundPlayer = Class{
    soundPath = "assets/",
    init = function(self, soundDefinitions)
        self.sources = {}
        self.volume = 1

        self.soundDefinitions = soundDefinitions

        for i, soundDef in ipairs(soundDefinitions) do
            self.sources[soundDef.name] = love.audio.newSource(self.soundPath .. soundDef.name)
            self.sources[soundDef.name]:setVolume(soundDef.volume)
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
    init = function(self, soundDefinitions)
        SoundPlayer.init(self, soundDefinitions)
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

MiscPlayer = Class{
    __includes = SoundPlayer,
    init = function(self, soundDefinitions)
        SoundPlayer.init(self, soundDefinitions)
        self:generateNextPlayTime()
    end,
    generateNextPlayTime = function(self)
        self.nextPlayTime = 5 + math.random(15)
    end,
    playRandom = function(self)
        source = self.sources[self.soundDefinitions[math.random(#self.soundDefinitions)].name]
        source:seek(0)
        source:play()
    end,
    update = function(self, dt)
        if self.nextPlayTime - dt < 0 then
            self:generateNextPlayTime()
            self:playRandom()
        end

        self.nextPlayTime = self.nextPlayTime - dt
    end,
}


return {
    ambient = AmbientPlayer({
            {name = "bg_humm_01.ogg", volume = 0.4},
            {name = "rain_01.ogg", volume = 1}
    }),
    misc = MiscPlayer({
            {name = "rattling_01.ogg", volume = 0.2},
            {name = "rattling_02.ogg", volume = 0.2},
            {name = "thunder_01.ogg", volume = 2},
            {name = "thunder_02.ogg", volume = 1}
    })
}