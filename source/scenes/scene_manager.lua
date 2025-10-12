import "intro"
import "game"

SceneManager = {}
SceneManager.current = Intro

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
