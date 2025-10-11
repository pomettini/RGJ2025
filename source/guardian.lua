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

local anim_guardian_idle = gfx.animation.loop.new(100, spr_guardian_idle, true)

local MAX_SUSPICIOUSNESS <const> = 100

Guardian = {}
Guardian.watching = false
Guardian.suspiciousness = 0

function Guardian:init()
    self.watching = false
    self.suspiciousness = 0

    self:set_watch()

    Events.on_canvas_next:connect(function()
        if self.watching then
            self.suspiciousness = 0
        end
    end)

    Events.on_canvas_back:connect(function()
        if self.watching then
            Events.on_game_over.emit()
        end
    end)
end

function Guardian:set_watch()
    self.watching = true

    local timer = pd.timer.new(1000, function()
        self:set_ignore()
    end)
end

function Guardian:set_ignore()
    self.watching = false

    local timer = pd.timer.new(1000, function()
        self:set_watch()
    end)
end

function Guardian:update(dt)
    if self.watching then
        self.suspiciousness += dt * 10

        if self.suspiciousness > MAX_SUSPICIOUSNESS then
            Events.on_game_over.emit()
        end
    end
end

function Guardian:draw()
    if self.watching then
        anim_guardian_idle:draw(255, 0)
    end

    gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
    gfx.drawRect(255, 102, 145, 10)
    gfx.fillRect(255, 102, (self.suspiciousness / MAX_SUSPICIOUSNESS) * 145, 10)
    gfx.setImageDrawMode(gfx.kDrawModeCopy)
end
