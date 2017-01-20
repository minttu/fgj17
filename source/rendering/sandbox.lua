gauge = require "rendering.gauge"

sandbox = {}

light = require "rendering.light"

local image
local lights = {}

local colorCanvas

local ambientLight = { 128, 128, 128}

local lightShader
local lightFragmentCode = [[
    varying vec3 vpos;
    uniform vec3 light_pos;
    uniform float intensity;
    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
    {
        vec4 texcolor = Texel(texture, texture_coords);
        vec3 surface_to_light = light_pos - vpos;
		float d = length(surface_to_light);
        surface_to_light /= d;
        vec3 normal = vec3(0.0, 0.0, -1.0);
        float a = 1.0 / pow((d/intensity)+1, 2);
        return texcolor * color * max(0,dot(normal, surface_to_light)) * a;
    }
]]

local lightVertexCode = [[
    varying vec3 vpos;
    vec4 position(mat4 transform_projection, vec4 vertex_position)
    {
        vpos = vertex_position.xyz;
        return transform_projection * vertex_position;
    }
]]

local gauge0 = gauge(1);

function sandbox.init()
    image = love.graphics.newImage("assets/graphics/testbg.png")
    colorCanvas = love.graphics.newCanvas()
    lightShader = love.graphics.newShader(lightFragmentCode, lightVertexCode)

    table.insert(lights, light({100, 100, -10}, {255, 255, 255}, 200))
end

function sandbox.draw()
    love.graphics.setCanvas(colorCanvas)
    love.graphics.clear()

    love.graphics.setShader()
    love.graphics.setColor(ambientLight[1], ambientLight[2], ambientLight[3])
    love.graphics.draw(image)

    local light = lights[1]
    love.graphics.setShader(lightShader)
    love.graphics.setColor(light.color[1], light.color[2], light.color[3])
    light.pos[3] = -math.abs(math.cos(love.timer.getTime()) * 150);
    lightShader:send("light_pos", light.pos)
    lightShader:send("intensity", light.intensity)
    love.graphics.draw(image)

    love.graphics.setShader()
    love.graphics.setColor(255, 255, 255)
    love.graphics.setCanvas()
    love.graphics.clear()
    love.graphics.draw(colorCanvas)
end

return sandbox
