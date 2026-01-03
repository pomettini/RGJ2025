Tutorial = {}
Tutorial.state = 1
Tutorial.move_forward_count = 3
Tutorial.move_backward_count = 3
Tutorial.pressed_wrong_button = false
Tutorial.moved_forward_wrong_way = false
Tutorial.moved_backward_wrong_way = false

TUTORIAL_KEYS = 1
TUTORIAL_MOVE_FORWARD = 2
TUTORIAL_MOVE_BACKWARD = 3
TUTORIAL_MOVE_FORWARD_WITH_CANVAS = 4
TUTORIAL_MOVE_FORWARD_WITH_CANVAS_SECOND = 5
TUTORIAL_MOVE_BACKWARD_WITH_CANVAS = 6
-- TUTORIAL_SHOW_BOAT = 7
TUTORIAL_END = 7

function Tutorial:reset()
    self.state = 1
    self.move_forward_count = 3
    self.move_backward_count = 3
    self.pressed_wrong_button = false
    self.moved_forward_wrong_way = false
    self.moved_backward_wrong_way = false
end

function Tutorial:init()
end

function Tutorial:update()
end
