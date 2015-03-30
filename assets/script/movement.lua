movement = {}

movement.teleportPlayer = function(mapId, x, y, options)
	options = options or {}
	options.fading = options.fading or "normal"
	if options.fading == "normal" then screen.fadeOut(200) end
	host_teleportPlayer(mapId, x, y, options)
	if options.fading == "normal" then screen.fadeIn(200) end
end

movement.setMoveRoute = function(object, route)
	host_setMoveRoute(object, route);
	coroutine.yield()
end