local function __NULL__() end

 -- default gamestate produces error on every callback
local state_init = setmetatable({leave = __NULL__},
		{__index = function() error("Gamestate not initialized. Use Gamestate.switch()") end})
local stack = {state_init}
local initialized_states = setmetatable({}, {__mode = "k"})
local state_is_dirty = true

local GS = {}
function GS.new(t) return t or {} end -- constructor - deprecated!

local function change_state(stack_offset, to, ...)
	local pre = stack[#stack]

	-- initialize only on first call
	;(initialized_states[to] or to.init or __NULL__)(to)
	initialized_states[to] = __NULL__

	stack[#stack+stack_offset] = to
	state_is_dirty = true
	return (to.enter or __NULL__)(to, pre, ...)
end

function GS.switch(to, ...)
	assert(to, "Missing argument: Gamestate to switch to")
	assert(to ~= GS, "Can't call switch with colon operator")
	;(stack[#stack].leave or __NULL__)(stack[#stack])
	return change_state(0, to, ...)
end

function GS.push(to, ...)
	assert(to, "Missing argument: Gamestate to switch to")
	assert(to ~= GS, "Can't call push with colon operator")
	return change_state(1, to, ...)
end

function GS.pop(...)
	assert(#stack > 1, "No more states to pop!")
	local pre, to = stack[#stack], stack[#stack-1]
	stack[#stack] = nil
	;(pre.leave or __NULL__)(pre)
	state_is_dirty = true
	return (to.resume or __NULL__)(to, pre, ...)
end

function GS.current()
	return stack[#stack]
end

-- XXX: don't overwrite love.errorhandler by default:
--      this callback is different than the other callbacks
--      (see http://love2d.org/wiki/love.errorhandler)
--      overwriting thi callback can result in random crashes (issue #95)
local all_callbacks = { 'draw', 'update' }

-- fetch event callbacks from love.handlers
for k in ipairs(love.handlers) do
	all_callbacks[#all_callbacks+1] = k
end

function GS.registerEvents(callbacks)
	local registry = {}
	callbacks = callbacks or all_callbacks
	for _, f in ipairs(callbacks) do
		registry[f] = love[f] or __NULL__
		love[f] = function(...)
			registry[f](...)
			return GS[f](...)
		end
	end
end

-- forward any undefined functions
setmetatable(GS, {__index = function(_, func)
	-- call function only if at least one 'update' was called beforehand
	-- (see issue #46)
	if not state_is_dirty or func == 'update' then
		state_is_dirty = false
		return function(...)
			return (stack[#stack][func] or __NULL__)(stack[#stack], ...)
		end
	end
	return __NULL__
end})

return GS