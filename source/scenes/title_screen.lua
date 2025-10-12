import "scene_manager"
import "tutorial"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local spr_title_screen = gfx.image.new("img/spr_title_screen")
assert(spr_title_screen)

TitleScreen = {}

function TitleScreen:init()
end

function TitleScreen:update()
    gfx.clear(gfx.kColorBlack)
    spr_title_screen:draw(0, 0)

    if pd.buttonJustReleased(pd.kButtonA) then
        SceneManager:change_scene(Tutorial)
    end
end
