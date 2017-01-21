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

local gradientShaderCode = [[

]]

rendering.fader = love.graphics.newShader(faderShader)

function rendering.scale()
    local desktop_w, desktop_h = love.window.getDesktopDimensions()
    scx = desktop_w / canvas_w
    scy = desktop_h / canvas_h

    love.graphics.scale(scx,scy)
end

return rendering
