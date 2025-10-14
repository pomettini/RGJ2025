local gfx <const> = playdate.graphics

Utils = {}

function Utils:hash32(x)
    x = (x * 1103515245 + 12345) % 16777216
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

function Utils:bounded_increment(number, max, delta)
    return ((number - 1 + delta) % max) + 1
end

function Utils:bounded_decrement(number, max, delta)
    return ((number - 1 - delta) % max) + 1
end

function Utils:clamp(x, min, max)
    return math.max(math.min(x, max), min)
end

function Utils:ease(t)
    if t < 0.4 then
        return 0
    else
        return ((t - 0.4) / 0.6) ^ 4
    end
end

function Utils:cache_faded_frame(image, alpha, dither_type)
    return image:fadedImage(alpha, dither_type)
end

function Utils:cache_faded_frames(image, frames, dither_type)
    local temp_frames = {}
    for i = 1, frames do
        temp_frames[i] = self:cache_faded_frame(image, (1 / frames) * i, dither_type)
    end
    return temp_frames
end

function Utils:cache_blurred_frame(image, radius, num_passes, dither_type)
    return image:blurredImage(radius, num_passes, dither_type)
end

function Utils:cache_blurred_frames(image, frames, radius, num_passes, dither_type)
    local temp_frames = {}
    for i = 1, frames do
        temp_frames[i] = self:cache_blurred_frame(image, (radius / frames) * i, num_passes, dither_type)
    end
    return temp_frames
end
