import "CoreLibs/timer"
import "CoreLibs/ui"
import "game_over"
import "tutorial"
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

-- local font_pixieval = gfx.font.new("fonts/font-Bitmore-Medieval-Outlined")
-- assert(font_pixieval)

-- gfx.setFont(font_pixieval)

Game = {}
-- Last minute hack
Game.anim_counter = 1

local function draw_label(text, offset_x, offset_y)
    local x, y = gfx.getTextSize(text)
    gfx.setColor(gfx.kColorBlack)
    gfx.fillRect(offset_x, offset_y, x, y)
    gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
    gfx.drawText(text, offset_x, offset_y)
    gfx.setImageDrawMode(gfx.kDrawModeCopy)
end

local function reset_state()
    Guardian:init()

    SfxManager:menu_stop()
    SfxManager:game_over_stop()
    SfxManager:loop_start()

    SfxManager:crank_sfx_start()
    SfxManager:crank_sfx_stop()
end

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
    -- Guardian:init()
    SfxManager:init()

    Events.on_game_over:connect(function()
        SceneManager:change_scene(GameOver)
    end)

    Events.on_victory:connect(function()
        SceneManager:change_scene(VictoryScreen)
    end)

    Events.on_canvas_next:connect(function()
        if Tutorial.state == TUTORIAL_MOVE_FORWARD then
            Tutorial.moved_forward_wrong_way = false
            Tutorial.move_forward_count -= 1
            if Tutorial.move_forward_count <= 0 then
                Tutorial.state += 1
            end
            return
        end
        if Tutorial.state == TUTORIAL_MOVE_BACKWARD then
            Tutorial.moved_backward_wrong_way = true
            return
        end
        if Tutorial.state == TUTORIAL_MOVE_FORWARD_WITH_CANVAS then
            Guardian.suspiciousness = 0
            Tutorial.state += 1
            return
        end
        if Tutorial.state == TUTORIAL_MOVE_FORWARD_WITH_CANVAS_SECOND then
            Guardian.suspiciousness = 0
            Tutorial.state += 1
            return
        end
    end)

    Events.on_canvas_back:connect(function()
        if Tutorial.state == TUTORIAL_MOVE_FORWARD then
            Tutorial.moved_forward_wrong_way = true
            return
        end
        if Tutorial.state == TUTORIAL_MOVE_BACKWARD then
            Tutorial.moved_backward_wrong_way = false
            Tutorial.move_backward_count -= 1
            if Tutorial.move_backward_count <= 0 then
                Tutorial.state += 1
            end
            return
        end
        if Tutorial.state == TUTORIAL_MOVE_BACKWARD_WITH_CANVAS then
            -- Reset everything after tutorial state
            reset_state()

            Tutorial.state += 1
            return
        end
    end)

    if Tutorial.state ~= 1 then
        reset_state()
    end

    -- Last minute hack
    self.anim_counter = 1
end

function Game:update()
    gfx.clear(gfx.kColorBlack)

    local dt = pd.getElapsedTime()
    pd.resetElapsedTime()

    if Tutorial.state == TUTORIAL_KEYS then
        ButtonQueue:update(dt)

        local current, _, _ = pd.getButtonState()
        if ButtonQueue.current_button == current then
            Tutorial.state += 1
        end
        if ButtonQueue.current_button ~= current and current ~= 0 then
            Tutorial.pressed_wrong_button = true
        end

        UIElements:draw_faded_bg()
        ButtonQueue:draw()

        if Tutorial.pressed_wrong_button == false then
            draw_label("Hold the button below", 10, 10)
        else
            draw_label("That's not the correct button!", 10, 10)
        end
    elseif Tutorial.state == TUTORIAL_MOVE_FORWARD then
        ButtonQueue:update(dt)

        UIElements:draw_faded_bg()
        ButtonQueue:draw()

        Guardian.current_animation_id = 1
        Guardian:draw(self.anim_counter, true, true)

        if Tutorial.moved_forward_wrong_way == false and Tutorial.move_forward_count < 3 then
            draw_label("Good! Let's do it again!", 10, 10)
        elseif Tutorial.moved_forward_wrong_way == false then
            draw_label("Hold the button below and turn the crank forward", 10, 10)
        else
            draw_label("That's the wrong way, turn the crank forward!", 10, 10)
        end

        pd.ui.crankIndicator:draw(
            -312 + 100 - (88 / 2),
            -184 + 120 - (52 / 2)
        )
    elseif Tutorial.state == TUTORIAL_MOVE_BACKWARD then
        ButtonQueue:update(dt)

        UIElements:draw_faded_bg()
        ButtonQueue:draw()

        Guardian.current_animation_id = 4
        Guardian:draw(self.anim_counter, true, true)

        if Tutorial.moved_backward_wrong_way == false and Tutorial.move_backward_count < 3 then
            draw_label("Nice! Do it again as well!", 10, 10)
        elseif Tutorial.moved_backward_wrong_way == false then
            draw_label("Now turn it backwards", 10, 10)
        else
            draw_label("That's the wrong way, turn the crank backwards!", 10, 10)
        end

        pd.ui.crankIndicator.clockwise = false
        pd.ui.crankIndicator:draw(
            -312 + 100 - (88 / 2),
            -184 + 120 - (52 / 2)
        )
    elseif Tutorial.state == TUTORIAL_MOVE_FORWARD_WITH_CANVAS then
        ButtonQueue:update(dt)
        Canvas:update(dt)

        UIElements:draw_faded_bg()
        ButtonQueue:draw()

        Guardian.current_animation_id = 1
        Guardian.suspiciousness += dt * 10
        Guardian.suspiciousness = Utils:clamp(Guardian.suspiciousness, 0, Guardian:get_max_suspiciousness())
        Guardian:draw(self.anim_counter, true)

        Canvas:draw()

        draw_label("WARNING: Eye is open! When time passes", 10, 10)
        draw_label("or canvas is unwinded, it will get irritated!", 10, 10 + 16)
    elseif Tutorial.state == TUTORIAL_MOVE_FORWARD_WITH_CANVAS_SECOND then
        ButtonQueue:update(dt)
        Canvas:update(dt)

        UIElements:draw_faded_bg()
        ButtonQueue:draw()

        Guardian.current_animation_id = 1
        Guardian.suspiciousness += dt * 10
        Guardian.suspiciousness = Utils:clamp(Guardian.suspiciousness, 0, Guardian:get_max_suspiciousness())
        Guardian:draw(self.anim_counter, true)

        Canvas:draw()

        draw_label("WARNING: You don't want to complete the canvas", 10, 10)
        draw_label("or you will have to get married!", 10, 10 + 16)
    elseif Tutorial.state == TUTORIAL_MOVE_BACKWARD_WITH_CANVAS then
        ButtonQueue:update(dt)
        Canvas:update(dt)

        UIElements:draw_faded_bg()
        ButtonQueue:draw()

        Guardian.current_animation_id = 4
        Guardian:draw(self.anim_counter, true)

        Canvas:draw()

        draw_label("It's distracted, finally!", 10, 10)
        draw_label("quickly, unwind the canvas!", 10, 10 + 16)
    else
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
    end

    -- All the code written below is a last minute hack
    self.anim_counter += dt * 6.6

    local current, _, _ = pd.getButtonState()
    if current == 0 then
        UIElements:draw_hold(self.anim_counter)
    end

    local crank_change, _ = playdate.getCrankChange()

    if crank_change ~= 0 then
        SfxManager:crank_sfx_play()
    else
        SfxManager:crank_sfx_stop()
    end
end

local menu = pd.getSystemMenu()

local _, _ = menu:addMenuItem("Reset", function()
    Tutorial:reset()
    Game:init()

    SfxManager:loop_stop()
end)
