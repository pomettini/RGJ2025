import "CoreLibs/crank"
import "CoreLibs/graphics"
import "scene_manager"
import "game"
import "../utils"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local spr_tutorial = {}

spr_tutorial[1] = gfx.image.new("img/spr_tutorial_1")
assert(spr_tutorial[1])

spr_tutorial[2] = gfx.image.new("img/spr_tutorial_2")
assert(spr_tutorial[2])

spr_tutorial[3] = gfx.image.new("img/spr_tutorial_3")
assert(spr_tutorial[3])

spr_tutorial[4] = gfx.image.new("img/spr_tutorial_4")
assert(spr_tutorial[4])

local spr_tutorial_eye = gfx.image.new("img/spr_tutorial_eye")
assert(spr_tutorial_eye)

local spr_screenshot = gfx.image.new("img/spr_screenshot")
assert(spr_screenshot)

local spr_screenshot_blurred = Utils:cache_blurred_frame(spr_screenshot, 3, 2, gfx.image.kDitherTypeBayer2x2)

Tutorial = {}
Tutorial.offset_x = 0

function Tutorial:init()
    self.offset_x = 0
end

function Tutorial:update()
    gfx.clear(gfx.kColorBlack)

    spr_screenshot_blurred:draw(0, 0)

    spr_tutorial[1]:draw(self.offset_x, 0)
    spr_tutorial[2]:draw(self.offset_x + 400, 0)
    spr_tutorial[3]:draw(self.offset_x + 800, 0)
    spr_tutorial[4]:draw(self.offset_x + 1200, 0)

    local change, _ = pd.getCrankChange()
    self.offset_x = Utils:clamp(self.offset_x - change, -1600, 0)

    -- local x = 800 + 286 + self.offset_x + math.random(-3, 3)
    -- local y = 134 + math.random(-3, 3)
    -- spr_tutorial_eye:drawCentered(x, y)

    if self.offset_x > -200 then
        playdate.ui.crankIndicator:draw(0, 0)
    end

    if self.offset_x <= -1600 then
        SceneManager:change_scene(Game)
    end
end
