import "CoreLibs/graphics"
import "game"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local spr_game_over = gfx.image.new("img/spr_game_over")
assert(spr_game_over)

GameOver = {}

function GameOver:init()
end

function GameOver:update()
    gfx.clear(gfx.kColorBlack)
    spr_game_over:draw(0, 0)

    if pd.buttonJustReleased(pd.kButtonA) then
        SceneManager:change_scene(Game)
    end
end
