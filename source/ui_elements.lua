import "utils"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local spr_faded_bg = gfx.image.new("img/spr_faded_bg_eye_closed.png")
assert(spr_faded_bg)

local spr_bg = gfx.image.new("img/spr_bg")
assert(spr_bg)

local spr_hold = gfx.imagetable.new("img/spr_hold")
assert(spr_hold)

local spr_tiny_waves = gfx.imagetable.new("img/spr_tiny_waves")
assert(spr_tiny_waves)

local spr_small_waves = gfx.imagetable.new("img/spr_small_waves")
assert(spr_small_waves)

local spr_medium_waves = gfx.imagetable.new("img/spr_medium_waves")
assert(spr_medium_waves)

local spr_lighthouse = gfx.imagetable.new("img/spr_lighthouse")
assert(spr_lighthouse)

local spr_faded_bg_cached = Utils:cache_faded_frame(spr_faded_bg, 0.2, gfx.image.kDitherTypeFloydSteinberg)

UIElements = {}

function UIElements:init()
end

function UIElements:update()
end

function UIElements:draw_faded_bg()
    spr_faded_bg_cached:draw(0, 0)
end

function UIElements:draw_bg()
    spr_bg:draw(0, 0)
end

function UIElements:draw_hold(anim_step)
    -- spr_hold:drawImage(math.ceil(anim_step / 2 % 2), 200 - 31, 206 - 24 - 12)
end

function UIElements:draw_top_elements(anim_step)
    local step_2 = math.ceil(anim_step / 2 % 2)
    local step_2_inv = 3 - step_2

    local step_4 = math.ceil(anim_step / 2 % 4)
    local step_4_inv = 5 - step_4

    spr_tiny_waves:drawImage(step_4, 136, 16)
    spr_tiny_waves:drawImage(step_4_inv, 136 + 40, 16)
    spr_tiny_waves:drawImage(step_4, 136 + 80, 16)
    spr_tiny_waves:drawImage(step_4_inv, 136 + 120, 16)

    spr_medium_waves:drawImage(step_2, 8, 10)
    spr_medium_waves:drawImage(step_2_inv, 8 + 32, 10)
    spr_medium_waves:drawImage(step_2, 8 + 64, 10)
    spr_small_waves:drawImage(step_2_inv, 102, 11)

    spr_medium_waves:drawImage(step_2, 400 - 8, 10)
    spr_medium_waves:drawImage(step_2_inv, 400 - 8 - 32, 10)
    spr_medium_waves:drawImage(step_2, 400 - 8 - 64, 10)
    spr_medium_waves:drawImage(step_2_inv, 400 - 8 - 94, 10)
    spr_small_waves:drawImage(step_2, 400 - 101 - 20 + 1, 11, gfx.kImageFlippedX)
    spr_small_waves:drawImage(step_2_inv, 400 - 117 - 20 + 1, 11, gfx.kImageFlippedX)
end

function UIElements:draw_lighthouse(anim_step)
    local step_13 = math.ceil(anim_step / 2 % 13)
    spr_lighthouse:drawImage(step_13, 112, -1)
end
