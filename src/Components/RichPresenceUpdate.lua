return function(_state, _details, _largeImage, _smallImage, _largeImageText, _smallImageText)
    local presence = {
        state = _state or "Sample State",
        details = _details or "Sample Detail",
        largeImageKey = _largeImage or "icon",
        largeImageText = _largeImageText or "In the Game",
    }

    discordrpc.updatePresence(presence)
end