function toboolean(str)
    local bool = false
    if string.lower(str) == "true" then
        bool = true
    end
    return bool
end

return toboolean