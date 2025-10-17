import "CoreLibs/graphics"
import "CoreLibs/math"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local spr_boat = gfx.image.new("img/spr_boat")
assert(spr_boat)

local COMPLETENESS_MAX <const> = 100
local BOAT_X_START <const> = 237
local BOAT_X_END <const> = 132

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
    local boat_x = pd.math.lerp(BOAT_X_START, BOAT_X_END, self.completeness / 100)
    spr_boat:draw(boat_x, 3)
end
