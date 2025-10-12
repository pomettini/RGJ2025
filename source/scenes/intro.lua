import "scene_manager"
import "title_screen"
import "../sfx_manager"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local spr_intro = {}

spr_intro[1] = gfx.image.new("img/spr_intro_1")
assert(spr_intro[1])

spr_intro[2] = gfx.image.new("img/spr_intro_2")
assert(spr_intro[2])

spr_intro[3] = gfx.image.new("img/spr_intro_3")
assert(spr_intro[3])

Intro = {}
Intro.current_screen = 1

function Intro:init()
    self.current_screen = 1

    SfxManager:menu_start()
end

function Intro:update()
    if self.current_screen > 3 then
        SceneManager:change_scene(TitleScreen)
    else
        spr_intro[self.current_screen]:draw(0, 0)
    end

    local _, _, released = pd.getButtonState()

    if released == pd.kButtonA then
        self.current_screen += 1
    end
end
