setEventVar("varName", "varValue")

local test = getEventVar("varName")
log(test)

setGameVar("globalVar", "hello, world!")

showText("", "this is autorun event\nwhich will just teleport to next map")

teleportPlayer(2, 9, 11, {facing="down"})