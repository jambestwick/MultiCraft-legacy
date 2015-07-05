-- Minetest: builtin/misc.lua

--
-- Misc. API functions
--

multicraft.timers_to_add = {}
multicraft.timers = {}
multicraft.register_globalstep(function(dtime)
	for _, timer in ipairs(multicraft.timers_to_add) do
		table.insert(multicraft.timers, timer)
	end
	multicraft.timers_to_add = {}
	local end_ms = os.clock() * 1000 + 50
	local index = 1
	while index <= #multicraft.timers do
		local timer = multicraft.timers[index]
		timer.time = timer.time - dtime
		if timer.time <= 0 then
			timer.func(unpack(timer.args or {}))
			table.remove(multicraft.timers,index)
		else
			index = index + 1
		end
		if os.clock() * 1000 > end_ms then return end
	end
end)

function multicraft.after(time, func, ...)
	assert(tonumber(time) and type(func) == "function",
			"Invalid multicraft.after invocation")
	table.insert(multicraft.timers_to_add, {time=time, func=func, args={...}})
end

function multicraft.check_player_privs(name, privs)
	local player_privs = multicraft.get_player_privs(name)
	local missing_privileges = {}
	for priv, val in pairs(privs) do
		if val then
			if not player_privs[priv] then
				table.insert(missing_privileges, priv)
			end
		end
	end
	if #missing_privileges > 0 then
		return false, missing_privileges
	end
	return true, ""
end

local player_list = {}

multicraft.register_on_joinplayer(function(player)
	player_list[player:get_player_name()] = player
end)

multicraft.register_on_leaveplayer(function(player)
	player_list[player:get_player_name()] = nil
end)

function multicraft.get_connected_players()
	local temp_table = {}
	for index, value in pairs(player_list) do
		if value:is_player_connected() then
		table.insert(temp_table, value)
	end
	end
	return temp_table
end

function multicraft.hash_node_position(pos)
	return (pos.z+32768)*65536*65536 + (pos.y+32768)*65536 + pos.x+32768
end

function multicraft.get_position_from_hash(hash)
	local pos = {}
	pos.x = (hash%65536) - 32768
	hash = math.floor(hash/65536)
	pos.y = (hash%65536) - 32768
	hash = math.floor(hash/65536)
	pos.z = (hash%65536) - 32768
	return pos
end

function multicraft.get_item_group(name, group)
	if not multicraft.registered_items[name] or not
			multicraft.registered_items[name].groups[group] then
		return 0
	end
	return multicraft.registered_items[name].groups[group]
end

function multicraft.get_node_group(name, group)
	multicraft.log("deprecated", "Deprecated usage of get_node_group, use get_item_group instead")
	return multicraft.get_item_group(name, group)
end

function multicraft.setting_get_pos(name)
	local value = multicraft.setting_get(name)
	if not value then
		return nil
	end
	return multicraft.string_to_pos(value)
end

-- To be overriden by protection mods
function multicraft.is_protected(pos, name)
	return false
end

function multicraft.record_protection_violation(pos, name)
	for _, func in pairs(multicraft.registered_on_protection_violation) do
		func(pos, name)
	end
end

local raillike_ids = {}
local raillike_cur_id = 0
function multicraft.raillike_group(name)
	local id = raillike_ids[name]
	if not id then
		raillike_cur_id = raillike_cur_id + 1
		raillike_ids[name] = raillike_cur_id
		id = raillike_cur_id
	end
	return id
end
