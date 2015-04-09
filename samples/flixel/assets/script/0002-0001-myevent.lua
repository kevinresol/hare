music.play(1, 1, 0.7)

log(getGameVar("globalVar"))

local callbackForSelection2 = function ()
	local selected = message.showChoices("You selected 2, now please choose again", 
	{
	  {
		text = "Choice 1", 
		disabled = false, 
		hidden = true
	  },
	  {
		text = "Choice 2"
	  }
	}) 
	message.showText("", "You selected " .. selected)
end

local selected2 = message.showChoices("Please choose one", 
{
	{
		text = "Choice 1"
	},
	{
		text = "Choice 2"
	},
	{
		text = "Choice 3"
	}
})

if selected2 == 1 then message.showText("", "You selected 1")
elseif selected2 == 2 then callbackForSelection2()
elseif selected2 == 3 then message.showText("", "You selected 3")
end


message.showText("", "Going to teleport you to another map\n(pos: top, bg: dimmed)", {position="top", background="dimmed"})

sound.play(1, 1, 1)
movement.teleportPlayer(3, 5, 5, {facing="up"})

message.showText("", "Welcome to the new map!\n(pos: center, bg: transparent)", {position="center", background="transparent"})

message.showText("", "Current item:" .. item.get(1))

item.change(1, 1)

message.showText("", "Current item:" .. item.get(1))

message.showText("", "After this message, \nthe script will wait for 1 second\nMusic will pause for 1 second")

music.fadeOut(200, {wait=true})
music.pause()
sleep(1000)
music.resume()
music.fadeIn(200, {wait=true})

message.showText("", "The waiting has ended\nYou can move now")

log("end event")


