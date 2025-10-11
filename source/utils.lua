Utils = {}

local MOD = 16777216

function Utils:hash32(x)
    x = (x * 1103515245 + 12345) % MOD
    return x
end

function Utils:rand_at(seed, index, min, max)
    local mixed = seed + index * 97
    local h = self:hash32(mixed)

    local range_min = min or 0
    local range_max = max or 1
    local range = range_max - range_min + 1

    local n = (h % range) + range_min
    return n
end
