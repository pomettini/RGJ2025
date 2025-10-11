import "CoreLibs/graphics"
import "game"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local spr_victory = gfx.image.new("img/spr_victory")
assert(spr_victory)

VictoryScreen = {}

function VictoryScreen:init()
end

function VictoryScreen:update()
    gfx.clear(gfx.kColorBlack)
    spr_victory:draw(0, 0)

    if pd.buttonJustReleased(pd.kButtonA) then
        SceneManager:change_scene(Game)
    end
end
