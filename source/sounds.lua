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
        love.audio.stop()
        for name, source in pairs(self.sources) do
            source:seek(0)
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
        local played = self.soundDefinitions[math.random(#self.soundDefinitions)].name
        source = self.sources[played]
        source:seek(0)
        source:play()
        return played
    end,
    update = function(self, dt)
        if self.nextPlayTime - dt < 0 then
            self:generateNextPlayTime()
            return self:playRandom()
        end

        self.nextPlayTime = self.nextPlayTime - dt
        return ""
    end,
}

UIEffectsPlayer = Class{
    __includes = SoundPlayer,
    init = function(self, soundGroups)
        self.soundGroups = soundGroups
        self.warningGap = 0.4
        self.warningPossible = self.warningGap

        snds = {}
        for i, group in ipairs(soundGroups) do
            for i2, sound in ipairs(group.sounds) do
                table.insert(snds, sound)
            end
        end

        SoundPlayer.init(self, snds)
    end,
    play = function(self, name, volume)
        sounds = {}
        for i,v in ipairs(self.soundGroups) do
            if v.name == name then
                sounds = v.sounds
                break
            end
        end

        soundName = sounds[math.random(#sounds)].name
        sound = self.sources[soundName]:clone()
        sound:setVolume(sound:getVolume() * (volume or 1))
        sound:play()

        return sound
    end,
    warning = function(self, depth)
        if self.warningPossible > 0 then
            return
        end

        self:play("alarm")
        self.warningPossible = self.warningGap
    end,
    update = function(self, dt)
        self.warningPossible = self.warningPossible - dt
    end,
    startRudderRotation = function(self)
        if self.rudderSound ~= nil then
            return
        end
        sound = self:play("rudder")
        sound:setLooping(true)
        self.rudderSound = sound
    end,
    endRudderRotation = function(self)
        if self.rudderSound ~= nil then
            self.rudderSound:stop()
            self.rudderSound = nil
        end
    end
}


return {
    menu = AmbientPlayer({
            {name = "menu.ogg", volume = 1}
    }),
    gameoverbgm = AmbientPlayer({
            {name = "gameoverbgm.ogg", volume = 1}
    }),
    ambient = AmbientPlayer({
            {name = "bg_humm_01.ogg", volume = 0.4},
            {name = "rain_01.ogg", volume = 1}
    }),
    misc = MiscPlayer({
            {name = "rattling_01.ogg", volume = 0.2},
            {name = "rattling_02.ogg", volume = 0.2},
            {name = "thunder_01.ogg", volume = 1},
            {name = "thunder_02.ogg", volume = 1}
    }),
    ui = UIEffectsPlayer({
            {name = "switch", sounds = {
                 {name = "switch_01.ogg", volume = 1},
                 {name = "switch_02.ogg", volume = 1},
                 {name = "switch_03.ogg", volume = 1},
                 {name = "switch_04.ogg", volume = 1}
            }},
            {name = "alarm", sounds = {
                 {name = "alarm_01.ogg", volume = 1}
            }},
            {name = "radar", sounds = {
                 {name = "radar_01.ogg", volume = 0.5}
            }},
            {name = "rudder", sounds = {
                 {name = "rudder_01.ogg", volume = 0.5},
                 {name = "rudder_02.ogg", volume = 0.5}
            }},
            {name = "gameover", sounds = {
                 {name = "gameover.ogg", volume = 1}
            }}
    }),
}
