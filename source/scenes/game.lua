import "CoreLibs/timer"
import "CoreLibs/ui"
import "game_over"
import "victory_screen"
import "../boat"
import "../button_queue"
import "../canvas"
import "../guardian"
import "../sfx_manager"
import "../ui_elements"
import "../utils"

local pd <const> = playdate
local gfx <const> = playdate.graphics

Game = {}
-- Last minute hack
Game.anim_counter = 1

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
    SfxManager:game_over_stop()
    SfxManager:loop_start()

    SfxManager:crank_sfx_start()
    SfxManager:crank_sfx_stop()

    -- Last minute hack
    self.anim_counter = 1
end

function Game:update()
    gfx.clear(gfx.kColorBlack)

    local dt = pd.getElapsedTime()
    pd.resetElapsedTime()

    Boat:update(dt)
    ButtonQueue:update(dt)
    Canvas:update(dt)
    Guardian:update(dt)

    Boat:draw()

    UIElements:draw_top_elements(self.anim_counter)
    UIElements:draw_bg()
    UIElements:draw_lighthouse(self.anim_counter)

    Guardian:draw(self.anim_counter)
    ButtonQueue:draw()
    Canvas:draw()

    -- All the code written below is a last minute hack
    self.anim_counter += dt * 6.6

    local current, _, _ = pd.getButtonState()
    if current ~= 0 then
        UIElements:draw_hold(self.anim_counter)
    end

    local crank_change, _ = playdate.getCrankChange()

    if crank_change ~= 0 then
        SfxManager:crank_sfx_play()
    else
        SfxManager:crank_sfx_stop()
    end
end
