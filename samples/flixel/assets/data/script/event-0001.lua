showChoices("Please choose one", 
{
	{
		text = "Choice 1", 
		diableCondition = function() return false end, 
		hideCondition = function() return true end,
		callback = function() showText("", "You selected 1") end
	},
	{
		text = "Choice 2", 
		callback = function() 
			showChoices("Choose again", 
			{
			  {
				text = "Choice 1", 
				diableCondition = function() return false end, 
				hideCondition = function() return true end,
				callback = function() showText("", "You selected 1") end
			  },
			  {
				text = "Choice 2", 
				callback = function() showText("", "You selected 2") end
			  }
			}) 
		end
	},
	{
		text = "Choice 3", 
		diableCondition = function() return false end, 
		hideCondition = function() return true end,
		callback = function() showText("", "You selected 3") end
	},
})



showText("", "Going to teleport you to another map\n(pos: top, bg: dimmed)", {position="top", background="dimmed"})

teleportPlayer("template2", 12, 20, {facing="up"})

showText("", "Welcome to the new map!\n(pos: center, bg: transparent)", {position="center", background="transparent"})

showText("", "After this message, the script will wait for 3 second")

sleep(3000)

showText("", "The waiting has ended\nYou can move now")

log("end event")

