import "CoreLibs/crank"
import "CoreLibs/object"
import "CoreLibs/graphics"
import "Utils"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local QUEUE_LENGTH <const> = 5
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
ButtonQueue.current_button = 1
ButtonQueue.current_tick = 0
ButtonQueue.offset_x = 0
ButtonQueue.queue = {}

function ButtonQueue:update_queue()
    for i = 1, QUEUE_LENGTH do
        local rand_button = Utils:rand_at(self.rng_seed, i + self.current_index, 1, #BUTTONS)
        self.queue[i] = BUTTONS[rand_button]
    end
    self.current_button = self.queue[3]
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
    self.rng_seed = math.random(1, 256)
    self.current_index = 0
    self.current_button = 1
    self.current_tick = 0
    self.offset_x = 0
    self.queue = {}

    self:update_queue()
end

function ButtonQueue:update(dt)
    local change, acceleratedChange = pd.getCrankChange()
    local current, pressed, released = pd.getButtonState()

    if current == self.current_button then
        self.offset_x -= change

        if change > 0 then
            self.current_tick += change
        end
    end

    if self.current_tick > 8 then
        Events.on_crank_tick:emit()
        self.current_tick = 0
    end

    if self.offset_x > 32 then
        Events.on_canvas_back:emit()
        self:move_back()
        self.offset_x = 0
    elseif self.offset_x < -32 then
        Events.on_canvas_next:emit()
        self:move_next()
        self.offset_x = 0
    end
end

function ButtonQueue:draw()
    for i = 1, QUEUE_LENGTH do
        -- local delta_x = (432 / QUEUE_LENGTH) * (i - 1)
        local start_x = 200 - ((32 * QUEUE_LENGTH) / 2)
        local x = start_x + ((i - 1) * 32) + self.offset_x

        local alpha = 0.25
        if i == 2 or i == 4 then
            alpha = 0.5
        elseif i == 3 then
            alpha = 1
        end

        SPRITE_BUTTONS[self.queue[i]]:drawFaded(x, 208, alpha, gfx.image.kDitherTypeBayer2x2)
    end

    gfx.setColor(gfx.kColorWhite)
    gfx.drawRect(185, 208, 32, 32)
end
