import "CoreLibs/graphics"
import "CoreLibs/ui"
import "boat"
import "button_queue"
import "canvas"
import "guardian"

local pd <const> = playdate
local gfx <const> = playdate.graphics

Boat:init()
ButtonQueue:init()
Canvas:init()
Guardian:init()

pd.display.setRefreshRate(50)

function pd.update()
    gfx.clear(gfx.kColorBlack)

    local dt = 0

    Boat:update(dt)
    ButtonQueue:update(dt)
    Canvas:update(dt)
    Guardian:update(dt)

    Boat:draw()
    ButtonQueue:draw()
    Canvas:draw()
    Guardian:draw()

    gfx.sprite.update()
    pd.timer.updateTimers()

    pd.drawFPS(0, 228)
end
