import "CoreLibs/timer"
import "CoreLibs/ui"
import "game_over"
import "victory_screen"
import "../boat"
import "../button_queue"
import "../canvas"
import "../guardian"
import "../utils"

local pd <const> = playdate
local display <const> = pd.display
local gfx <const> = playdate.graphics
local menu <const> = pd.getSystemMenu()

local spr_bg = gfx.image.new("img/spr_bg")
assert(spr_bg)

Game = {}

function Game:init()
    Events.on_canvas_back:disconnect_all()
    Events.on_canvas_next:disconnect_all()
    Events.on_game_over:disconnect_all()
    Events.on_victory:disconnect_all()

    for _, timer in pairs(pd.timer.allTimers()) do
        timer:remove()
    end

    Boat:init()
    ButtonQueue:init()
    Canvas:init()
    Guardian:init()

    Events.on_game_over:connect(function()
        SceneManager:change_scene(GameOver)
    end)

    Events.on_victory:connect(function()
        SceneManager:change_scene(VictoryScreen)
    end)
end

function Game:update()
    spr_bg:draw(0, 0)

    local dt = pd.getElapsedTime()
    pd.resetElapsedTime()

    Boat:update(dt)
    ButtonQueue:update(dt)
    Canvas:update(dt)
    Guardian:update(dt)

    Boat:draw()
    ButtonQueue:draw()
    Canvas:draw()
    Guardian:draw()
end
