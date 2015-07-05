-- Minetest: builtin/detached_inventory.lua

multicraft.detached_inventories = {}

function multicraft.create_detached_inventory(name, callbacks)
	local stuff = {}
	stuff.name = name
	if callbacks then
		stuff.allow_move = callbacks.allow_move
		stuff.allow_put = callbacks.allow_put
		stuff.allow_take = callbacks.allow_take
		stuff.on_move = callbacks.on_move
		stuff.on_put = callbacks.on_put
		stuff.on_take = callbacks.on_take
	end
	multicraft.detached_inventories[name] = stuff
	return multicraft.create_detached_inventory_raw(name)
end

