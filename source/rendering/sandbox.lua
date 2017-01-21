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
    varying vec3 lpos;
    uniform vec4 light_color;
    uniform float intensity;
    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
    {
        vec4 texcolor = Texel(texture, texture_coords);
        vec3 surface_to_light = lpos - vpos;
		float d = length(surface_to_light);
        surface_to_light /= d;
        vec3 normal = vec3(0.0, 0.0, -1.0);
        float a = 1.0 / pow((d/intensity)+1, 2);
        return texcolor * color * light_color * max(0,dot(normal, surface_to_light)) * a;
    }
]]

local lightVertexCode = [[
    varying vec3 vpos;
    varying vec3 lpos;
    uniform vec3 light_pos;
    vec4 position(mat4 transform_projection, vec4 vertex_position)
    {
        vpos = (transform_projection * vertex_position).xyz;
        lpos = (transform_projection * vec4(light_pos, 0.0)).xyz;
        lpos.z = light_pos.z;
        return transform_projection * vertex_position;
    }
]]

local gauge0 = gauge(1);

function sandbox.init()
    image = love.graphics.newImage("assets/graphics/testbg.png")
    colorCanvas = love.graphics.newCanvas()
    lightShader = love.graphics.newShader(lightFragmentCode, lightVertexCode)

    table.insert(lights, light({200, 200, -2}, {0, 255, 0}, 2))
end

function sandbox.update()
    gauge0:update()
    gauge0.val = math.abs(math.sin(0.5 * love.timer.getTime()))
end

function sandbox.draw()
    love.graphics.setCanvas(colorCanvas)
    love.graphics.clear()

    love.graphics.setShader()
    love.graphics.setColor(ambientLight[1], ambientLight[2], ambientLight[3])
    love.graphics.draw(image)
    gauge0:draw()

    local light = lights[1]
    love.graphics.setShader(lightShader)
    love.graphics.setColor(light.color[1], light.color[2], light.color[3])
    lightShader:send("light_pos", light.pos)
    lightShader:send("light_color", {light.color[1], light.color[2], light.color[3], 1})
    lightShader:send("intensity", light.intensity)
    love.graphics.draw(image)
    gauge0:draw()

    love.graphics.setShader()
    love.graphics.setColor(255, 255, 255)
    love.graphics.setCanvas()
    love.graphics.clear()
    love.graphics.draw(colorCanvas)
end

return sandbox
