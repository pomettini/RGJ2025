import "CoreLibs/graphics"
import "game"
import "../sfx_manager"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local spr_victory = gfx.image.new("img/spr_victory")
assert(spr_victory)

VictoryScreen = {}
VictoryScreen.timer = 0

function VictoryScreen:init()
    self.timer = 0

    SfxManager:loop_stop()
end

function VictoryScreen:update()
    gfx.clear(gfx.kColorBlack)
    spr_victory:draw(0, 0)

    self.timer += 0.01

    if pd.buttonJustReleased(pd.kButtonA) and self.timer > 0.66 then
        SceneManager:change_scene(Game)
    end
end
