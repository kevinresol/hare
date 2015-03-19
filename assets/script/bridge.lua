showText = function(message)
	host_showText(message)
	coroutine.yield()
end

teleportPlayer = function(mapId, x, y, options)
	host_teleportPlayer(mapId, x, y, options)
	coroutine.yield()
end

sleep = function(ms)
	host_sleep(ms)
	coroutine.yield()
end