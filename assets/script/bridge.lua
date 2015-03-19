showText = function(characterId, message, options)
	host_showText(characterId, message, options)
	coroutine.yield()
end

showChoices = function(choices)
	local host_choices = {}
	for i, choice in ipairs(choices) do
		host_choices[i] = 
		{
			text = choice.text,
			disabled = choice.disableCondition ~= nil and choice.disableCondition() or false,
			hidden = choice.hideCondition ~= nil and choice.hideCondition() or false
		}
	end
	
	host_showChoices(host_choices)
	local selected = coroutine.yield()
	choices[selected].callback()
end

teleportPlayer = function(mapId, x, y, options)
	host_teleportPlayer(mapId, x, y, options)
	coroutine.yield()
end

sleep = function(ms)
	host_sleep(ms)
	coroutine.yield()
end

log = function(message)
	host_log(message)
end