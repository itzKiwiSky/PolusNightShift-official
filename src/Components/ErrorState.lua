local function error_printer(msg, layer)
    print((debug.traceback("Error: " .. tostring(msg), 1+(layer or 1)):gsub("\n[^\n]+$", "")))
end

function love.errorhandler(msg)
    errorScreen = love.graphics.newImage("resources/preload/images/error.png")
    love.graphics.setNewFont("resources/fonts/vcr.ttf", 20)

    msg = tostring(msg)
    error_printer(msg, 2)

    local trace = debug.traceback()

    local err = {}

	table.insert(err, msg.."\n\n")

	for l in string.gmatch(trace, "(.-)\n") do
		if not string.match(l, "boot.lua") then
			l = string.gsub(l, "stack traceback:", "Traceback\n")
			table.insert(err, l)
		end
	end

	local p = table.concat(err, "\n")

	p = string.gsub(p, "\t", "")
	p = string.gsub(p, "%{string \"(.-)\"%}", "%1")

    function draw()
        love.graphics.clear(0, 0, 0)
        love.graphics.draw(errorScreen, 0, 0)
        love.graphics.printf(p, 600, 300, love.graphics.getWidth() - 600)
        love.graphics.present()
    end
    return function()
		love.event.pump()

		for e, a, b, c in love.event.poll() do
			if e == "quit" then
				return 1
			elseif e == "keypressed" and a == "escape" then
				return 1
            end
		end

		draw()

		if love.timer then
			love.timer.sleep(0.1)
		end
	end
end