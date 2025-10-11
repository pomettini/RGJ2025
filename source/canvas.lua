import "CoreLibs/graphics"
import "CoreLibs/animation"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local spr_penelope = gfx.imagetable.new("img/spr_penelope")
assert(spr_penelope)

Canvas = {}
Canvas.completeness = 0
Canvas.current_frame = 1

function Canvas:init()
    self.completeness = 0
    self.current_frame = 1
end

function Canvas:update(dt)
end

function Canvas:draw()
    -- gfx.drawText("Canvas: " .. self.completeness, 0, 20)
    spr_penelope:drawImage(1, 0, 0)
end
