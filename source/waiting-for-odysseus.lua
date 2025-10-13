import "CoreLibs/graphics"
import "CoreLibs/ui"
import "scenes/scene_manager"

local pd <const> = playdate
local gfx <const> = playdate.graphics

pd.display.setRefreshRate(30)

SceneManager:init()

function pd.update()
    SceneManager:update()

    gfx.sprite.update()
    pd.timer.updateTimers()

    pd.drawFPS(0, 228)
end
