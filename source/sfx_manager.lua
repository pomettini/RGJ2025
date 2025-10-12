local snd <const> = playdate.sound

local music_menu_loop = snd.fileplayer.new()

local music_loop = snd.fileplayer.new("music/loop")
assert(music_loop)

local music_loop_creepy = snd.fileplayer.new("music/loop_creepy")
assert(music_loop_creepy)

SfxManager = {}

function SfxManager:init()
    music_loop:play(0)
    music_loop:setVolume(0, 0)

    music_loop_creepy:play(0)
    music_loop_creepy:setVolume(0, 0)
end
