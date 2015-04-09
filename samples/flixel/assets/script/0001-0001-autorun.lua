setEventVar("varName", "varValue")

local test = getEventVar("varName")
log(test)

setGameVar("globalVar", "hello, world!")

message.showText("", "this is autorun event\nwhich will just teleport to next map")

movement.teleportPlayer(2, 15, 11, {facing="down"})