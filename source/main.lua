import "CoreLibs/graphics"
import "CoreLibs/ui"

local pd <const> = playdate
local gfx <const> = playdate.graphics

pd.display.setRefreshRate(50)

function pd.update()
    gfx.clear(gfx.kColorBlack)
    pd.drawFPS(0, 0)
end
