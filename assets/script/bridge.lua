getGameVar = function(name)
	return game.variables[name]
end

setGameVar = function(name, value)
	game.variables[name] = value
end

sleep = function(ms)
	host_sleep(ms)
	coroutine.yield()
end

log = function(message)
	host_log(message)
end

showSaveScreen = function()
	host_showSaveScreen()
end