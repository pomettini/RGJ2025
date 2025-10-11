-- Signal.lua
-- Minimal Godot-style signal implementation for Playdate
Signal = function()
    local slots = {}
    return {
        connect = function(_, callback)
            table.insert(slots, callback)
        end,
        disconnect = function(_, callback)
            for i, slot in ipairs(slots) do
                if slot == callback then
                    table.remove(slots, i)
                    break
                end
            end
        end,
        disconnect_all = function(_)
            slots = {}
        end,
        emit = function(_, ...)
            for _, slot in ipairs(slots) do
                slot(...)
            end
        end
    }
end
