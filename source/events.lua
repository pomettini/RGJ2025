import "signal"

Events = {
    on_crank_tick = Signal(),
    on_crank_mistake_back = Signal(),
    on_crank_mistake_next = Signal(),
    on_canvas_back = Signal(),
    on_canvas_next = Signal(),
    on_watching = Signal(),
    on_ignoring = Signal(),
    on_victory = Signal(),
    on_game_over = Signal()
}
