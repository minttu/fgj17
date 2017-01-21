local rendering = {}

local faderShader = [[
    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
    {
        vec4 texturecolor = Texel(texture, texture_coords);
        vec4 ocolor = texturecolor * color;
        ocolor.w = clamp(ocolor.w-0.001,0,1);

        return ocolor;
    }
]]

rendering.fader = love.graphics.newShader(faderShader)

return rendering
