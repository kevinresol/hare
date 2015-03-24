getGameVar = function(name)
	return game.variables[name]
end

setGameVar = function(name, value)
	game.variables[name] = value
end

playSound = function(id, volume, pitch)
	host_playSound(id, volume, pitch)
end

playBackgroundMusic = function(id, volume, pitch)
	host_playBackgroundMusic(id, volume, pitch)
end

saveBackgroundMusic = function()
	host_saveBackgroundMusic()
end

restoreBackgroundMusic = function()
	host_restoreBackgroundMusic()
end

fadeOutBackgroundMusic = function(ms)
	host_fadeOutBackgroundMusic(ms)
end

fadeInBackgroundMusic = function(ms)
	host_fadeInBackgroundMusic(ms)
end

showText = function(characterId, message, options)
	host_showText(characterId, message, options)
	coroutine.yield()
end

showChoices = function(prompt, choices, options)
	local host_choices = {}
	local defaultCondition = function() return false end
	
	for i, choice in ipairs(choices) do
		local disableCondition = choice.disableCondition or defaultCondition
		local hideCondition = choice.hideCondition or defaultCondition
		
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
	options = options or {}
	options.fading = options.fading or "normal"
	if options.fading == "normal" then fadeOutScreen(200) end
	host_teleportPlayer(mapId, x, y, options)
	if options.fading == "normal" then fadeInScreen(200) end
end

fadeOutScreen = function(ms)
	host_fadeOutScreen(ms)
	sleep(ms)
end

fadeInScreen = function(ms)
	host_fadeInScreen(ms)
	sleep(ms)
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

return true