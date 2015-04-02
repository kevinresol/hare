message = {}

message.showText = function(characterId, message, options)
	host_showText(characterId, message, options)
	coroutine.yield()
end

message.showChoices = function(prompt, choices, options)
	for i, choice in ipairs(choices) do
		if choice.hidden == nil then choice.hidden = false end
		if choice.disabled == nil then choice.disabled = false end
	end
	
	host_showChoices(prompt, choices, options)
	return coroutine.yield()
end

message.inputNumber = function(prompt, numDigit, options)
	host_inputNumber(prompt, numDigit, options)
	return coroutine.yield()
end