showText = function(message)
	host_showText(message)
	coroutine.yield()
end

teleportPlayer = function(mapId, x, y)
	host_teleportPlayer(mapId, x, y)
	coroutine.yield()
end