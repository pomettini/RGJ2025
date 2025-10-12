import "CoreLibs/timer"
import "CoreLibs/ui"
import "game_over"
import "victory_screen"
import "../boat"
import "../button_queue"
import "../canvas"
import "../guardian"
import "../sfx_manager"
import "../utils"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local spr_bg = gfx.image.new("img/spr_bg")
assert(spr_bg)

local spr_hold = gfx.imagetable.new("img/spr_hold")
assert(spr_hold)

Game = {}
-- Last minute hack
Game.anim_counter = 0

function Game:init()
    pd.resetElapsedTime()

    Events.on_crank_tick:disconnect_all()
    Events.on_canvas_back:disconnect_all()
    Events.on_canvas_next:disconnect_all()
    Events.on_watching:disconnect_all()
    Events.on_ignoring:disconnect_all()
    Events.on_game_over:disconnect_all()
    Events.on_victory:disconnect_all()

    for _, timer in pairs(pd.timer.allTimers()) do
        timer:remove()
    end

    Boat:init()
    ButtonQueue:init()
    Canvas:init()
    Guardian:init()
    SfxManager:init()

    Events.on_game_over:connect(function()
        SceneManager:change_scene(GameOver)
    end)

    Events.on_victory:connect(function()
        SceneManager:change_scene(VictoryScreen)
    end)

    SfxManager:menu_stop()
    SfxManager:loop_start()

    -- Last minute hack
    self.anim_counter = 0
end

function Game:update()
    gfx.clear(gfx.kColorBlack)

    local dt = pd.getElapsedTime()
    pd.resetElapsedTime()

    Boat:update(dt)
    ButtonQueue:update(dt)
    Canvas:update(dt)
    Guardian:update(dt)

    spr_bg:draw(0, 0)

    Boat:draw()
    Guardian:draw()
    ButtonQueue:draw()
    Canvas:draw()

    -- All the code written below is a last minute hack
    self.anim_counter += dt * 10

    local current, _, _ = pd.getButtonState()
    if current ~= 0 then
        spr_hold:drawImage(math.ceil(self.anim_counter / 2 % 2), 200 - 31, 206 - 24 - 12)
    end
end
