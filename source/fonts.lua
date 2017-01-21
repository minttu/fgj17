local smallFont = love.graphics.newFont(18)
local menuFont = love.graphics.newFont("assets/fonts/impact_label/Impact Label.ttf", 32)
local labelFont = love.graphics.newFont("assets/fonts/impact_label/Impact Label Reversed.ttf", 24)
local bigMenuFont = love.graphics.newFont("assets/fonts/impact_label/Impact Label Reversed.ttf", 128)


return {
    small = smallFont,
    menu = menuFont,
    label = labelFont,
    bigMenu = bigMenuFont
}
