import "CoreLibs/graphics"
import "CoreLibs/ui"
import "scenes/scene_manager"

local pd <const> = playdate
local gfx <const> = playdate.graphics

pd.display.setRefreshRate(50)

SceneManager:init()

function pd.update()
    SceneManager:update()
end
