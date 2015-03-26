item = {}

item.change = function(id, quantity)
	host_changeItem(id, quantity)
end

item.get = function(id)
	return host_getItem(id)
end