playBackgroundMusic(1, 1, 1)

log(getGameVar("globalVar"))

local callbackForSelection2 = function ()
	showChoices("You selected 2, now please choose again", 
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
		callback = callbackForSelection2
	},
	{
		text = "Choice 3", 
		diableCondition = function() return false end, 
		hideCondition = function() return true end,
		callback = function() showText("", "You selected 3") end
	},
})



showText("", "Going to teleport you to another map\n(pos: top, bg: dimmed)", {position="top", background="dimmed"})

playSound(1, 1, 1)
teleportPlayer(3, 5, 5, {facing="up"})

showText("", "Welcome to the new map!\n(pos: center, bg: transparent)", {position="center", background="transparent"})

showText("", "After this message, \nthe script will wait for 1 second\nMusic will pause for 1 second")

fadeOutBackgroundMusic(200, {wait=true})
saveBackgroundMusic()
sleep(1000)
restoreBackgroundMusic()
fadeInBackgroundMusic(200, {wait=true})

showText("", "The waiting has ended\nYou can move now")

showSaveScreen()

log("end event")


