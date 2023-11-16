function love.load(args)
    love.math.setRandomSeed(os.time())
    math.randomseed(os.time())

    love.filesystem.load("src/Components/ErrorState.lua")()
    love.graphics.setNewFont("resources/fonts/vcr.ttf", 20)

    -- control --
    gamestate = require 'libraries.control.gamestate'
    gamera = require 'libraries.control.gamera'
    camera = require 'libraries.control.camera'
    timer = require 'libraries.control.timer'
    loveconsole = require 'libraries.control.loveconsole'
    clove = require 'libraries.control.clove'
    -- filesystem --
    json = require 'libraries.filesystem.json'
    nativefs = require 'libraries.filesystem.nativefs'
    lip = require 'libraries.filesystem.lip'
    xml = require 'libraries.filesystem.xml'
    -- interface --
    suit = require 'libraries.interface.suit'
    gui = require 'libraries.interface.gspot'
    slab = require 'libraries.interface.slab'
    -- post processing --
    moonshine = require 'libraries.post-processing.moonshine'
    shaderchain = require 'libraries.post-processing.chainshader'
    sunlight = require 'libraries.post-processing.sunlight'
    -- physics --
    bump = require 'libraries.physics.bump'
    -- utilities --
    collision = require 'libraries.utilities.collision'
    object = require 'libraries.utilities.object'
    gamejolt = require 'libraries.utilities.gamejolt'
    discordrpc = require 'libraries.utilities.discordRPC'
    lollipop = require 'libraries.utilities.lollipop'
    fpsgraph = require 'libraries.utilities.fpsgraph'
    parallax = require 'libraries.utilities.parallax'
    -- Basic 3D engine --
    g3d = require 'libraries.3D.g3d'

    --% Resources %--
    tools = require 'src.Components.Tools'
    subtitle = require 'src.Components.Subtitles'
    require("src.Components.Initialize")()
    updatePresence = require 'src.Components.RichPresenceUpdate'
    apikeys = require 'src.Components.APIKeys'

    lollipop.initializeSlot("polus")
    lollipop.currentSave.settings = {
        graphics = {
            shaders = true,
            fullscreen = false
        },
        audio = {
            masterVolume = 100
        },
        misc = {
            subtitles = true,
            language = "pt",
        },
        gamejoltApi = {
            username = "",
            token = ""
        }
    }

    lang = require("resources.data.Langs." .. lollipop.currentSave.settings.misc.language)

    --% Initialize rich presence and gamejolt apis %--
    discordrpc.initialize(apikeys.discordPresenceID, true)
    updatePresence("Initializing...", "ver 0.0.1", "unknown_rpc", "hey :3")

    gamejolt.init(apikeys.gamejoltGameID, apikeys.gamejoltKey)
    pcall(gamejolt.authUser, lollipop.currentSave.settings.gamejoltApi.username, lollipop.currentSave.settings.gamejoltApi.token)
    gamejoltSucess = gamejolt.isLoggedIn


    if gamejoltSucess then
        local userInfo = gamejolt.fetchUserByName(lollipop.currentSave.settings.gamejoltApi.username)
        local id, usrtype, usname, avatar, signed_up, last_logged, status = userInfo.id,userInfo.type,userInfo.username,userInfo.avatar_url,userInfo.signed_up,userInfo.last_logged_in,userInfo.status
        print("user ID: " .. id)
        print("user type: " .. usrtype)
        print("username: " .. usname)
        print("avatar url: " .. avatar)
        print("signed up: " .. signed_up)
        print("last login: " .. last_logged)
        print("status : " .. status)
    else
        print("Failed to auth user...")
    end

    -- Initialize a new console --
    loveconsole:init()

    -- addons loader --
    Addons = love.filesystem.getDirectoryItems("libraries/addons")
    for addon = 1, #Addons, 1 do
        require("libraries.addons." .. string.gsub(Addons[addon], ".lua", ""))
    end

    print(debug.getTableContent(lang))

    -- default filter --
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- state loader--
    States = love.filesystem.getDirectoryItems("src/States")
    for state = 1, #States, 1 do
        require("src.States." .. string.gsub(States[state], ".lua", ""))
    end

    -- every argument passed to the game will direct to console
    if #args > 0 then
        loveconsole:run(table.concat(args, " "))
    end

    gamestate.registerEvents({'update', 'textinput', 'keypressed', 'mousepressed', 'mousereleased'})
    gamestate.switch(configstate)
end

function love.draw()
    gamestate.current():draw()
    suit.draw()
    loveconsole:render()
end

function love.update(elapsed)
    loveconsole:update()
end

function love.textinput(text)
    suit.textinput(text)
    loveconsole:textinput(text)
end

function love.textedited(text)
    suit.textedited(text)
end

function love.keypressed(k)
    suit.keypressed(k)
    loveconsole:keypressed(k)
    if k == "f12" then
        error("sus")
    end
end

function love.mousepressed(x, y, button)
    loveconsole:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    loveconsole:mousereleased(x, y, button)
end