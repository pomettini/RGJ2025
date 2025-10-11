import "CoreLibs/graphics"
import "CoreLibs/animation"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local spr_guardian_away = gfx.imagetable.new("img/spr_guardian_away")
assert(spr_guardian_away)

local spr_guardian_idle = gfx.imagetable.new("img/spr_guardian_idle")
assert(spr_guardian_idle)

local spr_guardian_sus = gfx.imagetable.new("img/spr_guardian_sus")
assert(spr_guardian_sus)

Guardian = {}
Guardian.watching = false
Guardian.suspiciousness = 0

function Guardian:init()
    self.suspiciousness = 0
end

function Guardian:update(dt)
end

function Guardian:draw()
    -- gfx.drawText("Guardian: " .. self.suspiciousness, 0, 40)
    spr_guardian_away:drawImage(1, 255, 0)
end
