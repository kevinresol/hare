message = {}

message.showText = function(characterId, message, options)
	host_showText(characterId, message, options)
	coroutine.yield()
end

message.showChoices = function(prompt, choices, options)
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