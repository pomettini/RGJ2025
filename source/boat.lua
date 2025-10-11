import "CoreLibs/graphics"

local pd <const> = playdate
local gfx <const> = playdate.graphics

Boat = {}
Boat.completeness = 0

function Boat:init()
    self.completeness = 0
end

function Boat:update(dt)
    self.completeness += dt
end

function Boat:draw()
    gfx.drawText("Boat: " .. self.completeness, 0, 0)
end
