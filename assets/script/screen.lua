screen = {}

screen.fadeOut = function(ms)
	host_fadeOutScreen(ms)
	sleep(ms)
end

screen.fadeIn= function(ms)
	host_fadeInScreen(ms)
	sleep(ms)
end