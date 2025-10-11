import "CoreLibs/graphics"
import "CoreLibs/animation"
import "events"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local spr_penelope = gfx.imagetable.new("img/spr_penelope")
assert(spr_penelope)

local spr_penelope_v2 = gfx.image.new("img/spr_penelope_v2")
assert(spr_penelope_v2)

local spr_canvas = gfx.imagetable.new("img/spr_canvas")
assert(spr_canvas)

local COMPLETENESS_MAX <const> = 50
local FRAMES_MAX <const> = 6

Canvas = {}
Canvas.completeness = 1
Canvas.current_frame = 1

function Canvas:init()
    self.completeness = 1
    self.current_frame = 1

    Events.on_canvas_back:connect(function()
        Utils:bounded_decrement(self.current_frame, FRAMES_MAX, 1)

        if self.completeness > 0 then
            self.completeness -= 1
        end
    end)

    Events.on_canvas_next:connect(function()
        Utils:bounded_increment(self.current_frame, FRAMES_MAX, 1)

        self.completeness += 1

        if self.completeness >= COMPLETENESS_MAX then
            Events.on_game_over.emit()
        end
    end)
end

function Canvas:update(dt)
end

function Canvas:draw()
    -- gfx.drawText("Canvas: " .. self.completeness, 0, 20)
    -- spr_penelope:drawImage(self.current_frame, 0, 0)
    spr_penelope_v2:draw(0, 0)
    spr_canvas:drawImage(self.completeness, 100, 10)
end
