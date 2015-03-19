showText = function(characterId, message, options)
	host_showText(characterId, message, options)
	coroutine.yield()
end

showChoices = function(prompt, choices, options)
	local host_choices = {}
	for i, choice in ipairs(choices) do
		local disableCondition = choice.disableCondition or function() return false end
		local hideCondition = choice.hideCondition or function() return false end
		
		host_choices[i] = 
		{
			text = choice.text,
			disabled = disableCondition(),
			hidden = hideCondition()
		}
	end
	
	host_showChoices(prompt, host_choices, options)
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