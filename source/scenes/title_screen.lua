import "scene_manager"
import "game"

local pd <const> = playdate
local gfx <const> = playdate.graphics

TitleScreen = {}

function TitleScreen:init()
end

function TitleScreen:update()
    gfx.clear(gfx.kColorBlack)
    gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
    gfx.drawText("Press A to start", 0, 0)
    gfx.setImageDrawMode(gfx.kDrawModeCopy)

    if pd.buttonJustReleased(pd.kButtonA) then
        SceneManager:change_scene(Game)
    end
end
