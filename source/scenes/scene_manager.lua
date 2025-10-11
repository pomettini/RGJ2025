import "game_over"
import "game"
import "title_screen"
import "victory_screen"

SceneManager = {}
SceneManager.current = TitleScreen

function SceneManager:init()
    self.current:init()
end

function SceneManager:update()
    self.current:update()
end

function SceneManager:change_scene(new_scene)
    self.current = new_scene
    new_scene:init()
end
