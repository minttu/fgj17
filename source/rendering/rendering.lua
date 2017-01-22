local rendering = {}

local faderShader = [[
    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
    {
        vec4 texturecolor = Texel(texture, texture_coords);
        vec4 ocolor = texturecolor * color;
        //ocolor.w = clamp(ocolor.w-0.001,0,1);
        ocolor.w *= 0.97;
        return ocolor;
    }
]]

local kiviLightShaderCode = [[
    uniform vec2 masks;
    uniform vec4 bgColor;
    void effects(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
    {
        vec4 texturecolor = Texel(texture, texture_coords);
        vec4 ocolor = texturecolor * color;

        love_Canvases[0] = (masks.x * ocolor * bgColor) + (masks.y * ocolor);
    }

]]

rendering.fader = love.graphics.newShader(faderShader)

rendering.factor = 1

rendering.kiviLightShader = love.graphics.newShader(kiviLightShaderCode)

function rendering.scale()
    local desktop_w, desktop_h = love.window.getDesktopDimensions()
    scx = desktop_w / canvas_w
    scy = desktop_h / canvas_h

    love.graphics.scale(scx*rendering.factor,scy*rendering.factor)
end

function rendering.setBgColor(color)
    rendering.kiviLightShader:sendColor("bgColor", color)
end

function rendering.light(isLight)
    if isLight then
        love.graphics.setBlendMode("add")
        rendering.kiviLightShader:send("masks", {0, 1})
    else
        love.graphics.setBlendMode("alpha")
        rendering.kiviLightShader:send("masks", {1, 0})
    end
end

return rendering
