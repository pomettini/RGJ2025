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

local spr_arrow_up = gfx.imagetable.new("img/spr_arrow_up")
assert(spr_arrow_up)

local spr_arrow_down = gfx.imagetable.new("img/spr_arrow_down")
assert(spr_arrow_down)

local spr_waves = gfx.imagetable.new("img/spr_waves")
assert(spr_waves)

local spr_seafoam = gfx.imagetable.new("img/spr_seafoam")
assert(spr_seafoam)

local MAX_SUSPICIOUSNESS <const> = 100

Guardian = {}
Guardian.watching = false
Guardian.suspiciousness = 0
Guardian.current_animation_id = 1

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
    self.current_animation_id = 4

    Events.on_watching:emit()

    local timer = pd.timer.new(math.random(1000, 5000), function()
        self:set_ignore()
    end)
end

function Guardian:set_ignore()
    self.watching = false
    self.current_animation_id = 1

    Events.on_ignoring:emit()

    local timer = pd.timer.new(math.random(1000, 5000), function()
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
end

function Guardian:draw()
    local anim_id = Utils:clamp(math.ceil(self.current_animation_id), 1, 4)

    local shakiness = math.ceil(Utils:ease(self.suspiciousness / MAX_SUSPICIOUSNESS) * 3)

    spr_guardian_idle:drawImage(anim_id, 255 + math.random(-shakiness, shakiness),
        15 + math.random(-shakiness, shakiness))

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

    spr_waves:drawImage(math.ceil(self.current_animation_id / 2 % 2), 398 - 160, 206 - 60)
    spr_seafoam:drawImage(math.ceil(self.current_animation_id / 2 % 2), 398 - 160 - 86, 206 - 60)

    --[[
    gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
    gfx.drawRect(255, 102, 145, 10)
    gfx.fillRect(255, 102, (self.suspiciousness / MAX_SUSPICIOUSNESS) * 145, 10)
    gfx.setImageDrawMode(gfx.kDrawModeCopy)
    ]] --
end
