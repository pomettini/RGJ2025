import "CoreLibs/graphics"
import "game"
import "../sfx_manager"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local spr_game_over = gfx.image.new("img/spr_game_over")
assert(spr_game_over)

GameOver = {}
GameOver.timer = 0

function GameOver:init()
    self.timer = 0

    SfxManager:loop_stop()
end

function GameOver:update()
    gfx.clear(gfx.kColorBlack)
    spr_game_over:draw(0, 0)

    self.timer += 0.01

    if pd.buttonJustReleased(pd.kButtonA) and self.timer > 0.66 then
        SceneManager:change_scene(Game)
    end
end
