message = {}

message.showText = function(image, message, options)
	host_showText(image, message, options)
	coroutine.yield()
end

message.showChoices = function(image, prompt, choices, options)
	for i, choice in ipairs(choices) do
		if choice.hidden == nil then choice.hidden = false end
		if choice.disabled == nil then choice.disabled = false end
	end
	
	host_showChoices(image, prompt, choices, options)
	return coroutine.yield()
end

message.inputNumber = function(image, prompt, numDigit, options)
	host_inputNumber(image, prompt, numDigit, options)
	return coroutine.yield()
end