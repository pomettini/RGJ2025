import "CoreLibs/graphics"
import "game"
import "../sfx_manager"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local spr_game_over = gfx.image.new("img/spr_game_over")
assert(spr_game_over)

GAME_OVER_CANVAS_COMPLETE = "You completed the canvas"
GAME_OVER_PATIENCE_LOST = "The guardian has lost the patience"

GameOver = {}
GameOver.timer = 0
GameOver.cause = nil

function GameOver:set_cause(cause)
    self.cause = cause
end

function GameOver:init()
    self.timer = 0

    SfxManager:loop_stop()
    SfxManager:game_over_start()
end

function GameOver:update()
    gfx.clear(gfx.kColorBlack)

    self.timer += 0.01

    SfxManager:crank_sfx_stop()

    if pd.buttonJustReleased(pd.kButtonA) and self.timer > 0.66 then
        SceneManager:change_scene(Game)
    end

    spr_game_over:draw(0, 0)

    if self.cause ~= nil then
        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
        gfx.drawTextAligned(self.cause, 200, 120, kTextAlignment.center)
        gfx.setImageDrawMode(gfx.kDrawModeCopy)
    end
end
