local tools = {}

function tools:updatePresence(state,details,largeImageKey,largeImageText)
    local presence = {
        state = state or "Sample State",
        details = details or "Sample Detail",
        largeImageKey = largeImageKey or "icon",
        largeImageText = largeImageText or "In the Game",
    }
    discord.updatePresence(presence)
end

--Clamp number
function tools:clamp(n, low, high)
	return min(max(n, low), high)
end

function tools:ease(value, target, speed, _elapsed)
    return value - (value - target) * speed * _elapsed
end

function tools:toLast(t, value)
	t[#t+1] = value
end

return tools