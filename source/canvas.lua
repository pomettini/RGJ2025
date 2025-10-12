import "CoreLibs/graphics"
import "CoreLibs/animation"
import "events"
import "utils"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local spr_penelope = gfx.imagetable.new("img/spr_penelope")
assert(spr_penelope)

local spr_canvas = gfx.imagetable.new("img/spr_canvas")
assert(spr_canvas)

local spr_skull = gfx.image.new("img/spr_skull")
assert(spr_skull)

local spr_penelope_missing_bit = gfx.image.new("img/spr_penelope_missing_bit")
assert(spr_penelope_missing_bit)

local COMPLETENESS_MAX <const> = 50
local FRAMES_MAX <const> = 6

Canvas = {}
Canvas.completeness = 1
Canvas.current_frame = 1

function Canvas:init()
    self.completeness = 1
    self.current_frame = 1

    Events.on_canvas_back:connect(function()
        self.current_frame = Utils:bounded_decrement(self.current_frame, FRAMES_MAX, 1)

        if self.completeness > 0 then
            self.completeness -= 1
        end
    end)

    Events.on_crank_tick:connect(function()
        self.current_frame = Utils:bounded_increment(self.current_frame, FRAMES_MAX, 1)

        self.completeness += 1

        if self.completeness >= COMPLETENESS_MAX then
            Events.on_game_over:emit()
        end
    end)
end

function Canvas:update(dt)
end

function Canvas:draw()
    local temp = gfx.image.new(165, 179)
    gfx.pushContext(temp)
    spr_canvas:drawImage(50, 0, 0)
    gfx.popContext()

    temp:drawFaded(100, 17, 0.2, gfx.image.kDitherTypeFloydSteinberg)

    spr_penelope:drawImage(self.current_frame, 0, 7)
    spr_canvas:drawImage(self.completeness, 100, 17)

    spr_skull:drawFaded(180 - 19, 110 - 21, 0.5, gfx.image.kDitherTypeFloydSteinberg)
    spr_penelope_missing_bit:draw(173, 206 - 14)
end
