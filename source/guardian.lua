import "CoreLibs/graphics"
import "CoreLibs/animation"
import "events"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local spr_guardian_away = gfx.imagetable.new("img/spr_guardian_away")
assert(spr_guardian_away)

local spr_guardian_idle = gfx.imagetable.new("img/spr_guardian_idle")
assert(spr_guardian_idle)

local spr_guardian_sus = gfx.imagetable.new("img/spr_guardian_sus")
assert(spr_guardian_sus)

local spr_eye_background = gfx.image.new("img/spr_eye_background")
assert(spr_eye_background)

local spr_iris = gfx.imagetable.new("img/spr_eye_iris")
assert(spr_iris)

local spr_veins = gfx.imagetable.new("img/spr_eye_veins")
assert(spr_veins)

local spr_arrow_up = gfx.imagetable.new("img/spr_arrow_up")
assert(spr_arrow_up)

local spr_arrow_down = gfx.imagetable.new("img/spr_arrow_down")
assert(spr_arrow_down)

local spr_waves = gfx.imagetable.new("img/spr_waves")
assert(spr_waves)

local spr_seafoam = gfx.imagetable.new("img/spr_seafoam")
assert(spr_seafoam)

local MAX_SUSPICIOUSNESS <const> = 100
local GUARDIAN_FRAME_START <const> = 1
local GUARDIAN_FRAME_END <const> = 4
local WAVES_FRAMES <const> = 2
local SEAFORM_FRAMES <const> = 2
local STATE_CHANGE_TIMER_MIN <const> = 1000
local STATE_CHANGE_TIMER_MAX <const> = 5000

Guardian = {}
Guardian.watching = false
Guardian.suspiciousness = 0
Guardian.current_animation_id = 1
Guardian.crank_moving = false

function Guardian:init()
    self.watching = false
    self.suspiciousness = 0
    self.current_animation_id = 1

    self:set_watch()

    Events.on_canvas_next:connect(function()
        if self.watching then
            self.suspiciousness = 0
        end
    end)

    Events.on_canvas_back:connect(function()
        if self.watching then
            self.suspiciousness += 10
        end
    end)
end

function Guardian:set_watch()
    self.watching = true
    self.current_animation_id = GUARDIAN_FRAME_END

    Events.on_watching:emit()

    local timer = pd.timer.new(math.random(STATE_CHANGE_TIMER_MIN, STATE_CHANGE_TIMER_MAX), function()
        self:set_ignore()
    end)
end

function Guardian:set_ignore()
    self.watching = false
    self.current_animation_id = GUARDIAN_FRAME_START

    Events.on_ignoring:emit()

    local timer = pd.timer.new(math.random(STATE_CHANGE_TIMER_MIN, STATE_CHANGE_TIMER_MAX), function()
        self:set_watch()
    end)
end

function Guardian:update(dt)
    if self.watching then
        self.current_animation_id -= dt * 6.6
    else
        self.current_animation_id += dt * 6.6
    end

    -- print(self.current_animation_id)

    if self.current_animation_id < 0 then
        self.suspiciousness += dt * 10

        if self.suspiciousness > MAX_SUSPICIOUSNESS then
            Events.on_game_over:emit()
        end
    end

    local crank_change, _ = playdate.getCrankChange()

    if crank_change < 0 then
        self.crank_moving = true
    else
        self.crank_moving = false
    end
end

function Guardian:draw_sus_bar()
    local SUS_BAR_WIDTH <const> = 80
    local SUS_BAR_HEIGHT <const> = 5
    local SUS_BAR_RADIUS <const> = 5
    local SUS_BAR_Y <const> = 52

    gfx.setStrokeLocation(gfx.kStrokeOutside)
    gfx.setLineWidth(3)
    gfx.setColor(gfx.kColorBlack)
    gfx.drawRoundRect(
        255 + 30,
        SUS_BAR_Y,
        SUS_BAR_WIDTH, SUS_BAR_HEIGHT, SUS_BAR_RADIUS)
    gfx.fillRoundRect(
        255 + 30,
        SUS_BAR_Y,
        SUS_BAR_WIDTH, SUS_BAR_HEIGHT, SUS_BAR_RADIUS)
    gfx.setColor(gfx.kColorWhite)
    gfx.setLineWidth(1)
    gfx.drawRoundRect(
        255 + 30,
        SUS_BAR_Y,
        SUS_BAR_WIDTH, SUS_BAR_HEIGHT, SUS_BAR_RADIUS)
    gfx.fillRoundRect(
        255 + 30,
        SUS_BAR_Y,
        SUS_BAR_WIDTH - (SUS_BAR_WIDTH * (self.suspiciousness / MAX_SUSPICIOUSNESS)),
        SUS_BAR_HEIGHT, SUS_BAR_RADIUS)
end

function Guardian:draw(anim_step)
    local anim_id = Utils:clamp(math.ceil(self.current_animation_id), GUARDIAN_FRAME_START, GUARDIAN_FRAME_END)
    local veins_state = 1 + math.ceil((self.suspiciousness / MAX_SUSPICIOUSNESS) * 9)

    -- local shakiness = math.ceil(Utils:ease(self.suspiciousness / MAX_SUSPICIOUSNESS) * 3)
    local shakiness = self.crank_moving and 3 or 0

    if anim_id ~= 1 then
        spr_guardian_idle:drawImage(anim_id, 252, 58)
    else
        spr_eye_background:draw(
            252 + math.random(-shakiness, shakiness),
            58 + math.random(-shakiness, shakiness)
        )
        spr_veins:drawImage(
            veins_state,
            252 + math.random(-shakiness, shakiness),
            58 + math.random(-shakiness, shakiness)
        )
        spr_iris:drawImage(
            5,
            252 + math.random(-shakiness, shakiness),
            58 + math.random(-shakiness, shakiness)
        )
    end

    --[[
    local temp = gfx.image.new(40, 40)

    gfx.pushContext(temp)
    if self.watching then
        spr_arrow_up:drawImage(math.ceil(self.current_animation_id / 2 % 2), 0, 0)
    else
        spr_arrow_down:drawImage(math.ceil(self.current_animation_id / 2 % 2), 0, 0)
    end
    gfx.popContext()

    temp:drawFaded(73, 37, 0.5, gfx.image.kDitherTypeBayer2x2)
    ]] --

    local step_2 = math.ceil(anim_step / 2 % WAVES_FRAMES)
    local step_2_inverted = 3 - step_2

    spr_waves:drawImage(step_2, 398 - 32, 206 - 40)
    spr_waves:drawImage(step_2_inverted, 398 - 64, 206 - 40)
    spr_waves:drawImage(step_2, 398 - 96, 206 - 40)
    spr_seafoam:drawImage(step_2, 216, 156)

    -- self:draw_sus_bar()
end
