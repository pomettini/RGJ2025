import "CoreLibs/timer"
import "events"

local pd <const> = playdate
local snd <const> = playdate.sound

local music_menu = snd.fileplayer.new("music/menu")
assert(music_menu)

local music_loop = snd.fileplayer.new("music/loop")
assert(music_loop)

local music_loop_creepy = snd.fileplayer.new("music/loop_creepy")
assert(music_loop_creepy)

local music_game_over = snd.fileplayer.new("music/game_over")
assert(music_game_over)

local crank_sfx = snd.fileplayer.new("music/crank_sfx")
assert(crank_sfx)

local FADE_TIME <const> = 1000

SfxManager = {}

function SfxManager:init()
    Events.on_watching:connect(function()
        local fade = pd.timer.new(FADE_TIME, 0, 1)
        fade.updateCallback = function(timer)
            music_loop_creepy:setVolume(timer.value)
        end
    end)

    Events.on_ignoring:connect(function()
        local fade = pd.timer.new(FADE_TIME, 1, 0)
        fade.updateCallback = function(timer)
            music_loop_creepy:setVolume(timer.value)
        end
    end)
end

function SfxManager:loop_start()
    music_loop:play(0)
    music_loop:setVolume(1)

    music_loop_creepy:play(0)
    music_loop_creepy:setVolume(0)
end

function SfxManager:loop_stop()
    music_loop:stop()
    music_loop_creepy:stop()
end

function SfxManager:menu_start()
    music_menu:play(0)
end

function SfxManager:menu_stop()
    music_menu:stop()
end

function SfxManager:game_over_start()
    music_game_over:play(1)
end

function SfxManager:game_over_stop()
    music_game_over:stop()
end

function SfxManager:crank_sfx_start()
    crank_sfx:play(0)
end

function SfxManager:crank_sfx_play()
    crank_sfx:setVolume(0.5)
end

function SfxManager:crank_sfx_stop()
    crank_sfx:setVolume(0)
end
