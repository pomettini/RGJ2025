import "CoreLibs/graphics"
import "CoreLibs/math"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local spr_boat = gfx.image.new("img/spr_boat")
assert(spr_boat)

local COMPLETENESS_MAX <const> = 100

Boat = {}
Boat.completeness = 0

function Boat:init()
    self.completeness = 0
end

function Boat:update(dt)
    self.completeness += dt

    if self.completeness >= COMPLETENESS_MAX then
        Events.on_victory:emit()
    end
end

function Boat:draw()
    local x = pd.math.lerp(334, 150, self.completeness / 100)
    spr_boat:draw(x, 100)
end
