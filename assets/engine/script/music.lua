music = {}

music.play = function(id, volume, pitch)
	host_playBackgroundMusic(id, volume, pitch)
end

music.pause = function()
	host_saveBackgroundMusic()
end

music.resume = function()
	host_restoreBackgroundMusic()
end

music.fadeOut = function(ms, options)
	host_fadeOutBackgroundMusic(ms)
	if options and options.wait then sleep(ms) end
end

music.fadeIn = function(ms, options)
	host_fadeInBackgroundMusic(ms)
	if options and options.wait then sleep(ms) end
end