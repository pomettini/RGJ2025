import "CoreLibs/object"
import "CoreLibs/graphics"
import "Utils"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local QUEUE_LENGTH <const> = 7
local BUTTON_PREV_ID <const> = 3
local BUTTON_NEXT_ID <const> = 5
local BUTTONS <const> =
{
    pd.kButtonA,
    pd.kButtonB,
    pd.kButtonDown,
    pd.kButtonLeft,
    pd.kButtonRight,
    pd.kButtonUp
}

local spr_button_a = gfx.image.new("img/0_A")
assert(spr_button_a)

local spr_button_b = gfx.image.new("img/0_B")
assert(spr_button_b)

local spr_button_down = gfx.image.new("img/P_FrecciaDown")
assert(spr_button_down)

local spr_button_left = gfx.image.new("img/P_FrecciaSx")
assert(spr_button_left)

local spr_button_right = gfx.image.new("img/P_FrecciaDx")
assert(spr_button_right)

local spr_button_up = gfx.image.new("img/P_FrecciaUp")
assert(spr_button_up)

local SPRITE_BUTTONS <const> =
{
    [pd.kButtonA] = spr_button_a,
    [pd.kButtonB] = spr_button_b,
    [pd.kButtonDown] = spr_button_down,
    [pd.kButtonLeft] = spr_button_left,
    [pd.kButtonRight] = spr_button_right,
    [pd.kButtonUp] = spr_button_up
}

ButtonQueue = {}
ButtonQueue.rng_seed = nil
ButtonQueue.current_index = 0
ButtonQueue.queue = {}

function ButtonQueue:update_queue()
    for i = 1, QUEUE_LENGTH do
        local rand_button = Utils:rand_at(self.rng_seed, i + self.current_index, 1, #BUTTONS)
        self.queue[i] = BUTTONS[rand_button]
    end
end

function ButtonQueue:move_back()
    self.current_index -= 1
    self:update_queue()
end

function ButtonQueue:move_next()
    self.current_index += 1
    self:update_queue()
end

function ButtonQueue:init()
    self.rng_seed = 1
    self.current_index = 0
    self.queue = {}

    self:update_queue()

    printTable(self.queue)
end

function ButtonQueue:update(dt)
end

function ButtonQueue:draw()
    for i = 1, QUEUE_LENGTH do
        local delta_x = ((32 / QUEUE_LENGTH) * (i - 1)) + (400 / QUEUE_LENGTH) * (i - 1)
        SPRITE_BUTTONS[self.queue[i]]:draw(delta_x, 208)
    end
end
