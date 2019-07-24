-- cache setting
local enable_damage = core.settings:get_bool("enable_damage")

local health_bar_definition = {
	hud_elem_type = "statbar",
	position      = {x =  0.5, y =  1},
	alignment     = {x = -1,   y = -1},
	offset        = {x = -247, y = -108},
	size          = {x =  24,  y =  24},
	text          = "heart.png",
	background    = "heart_bg.png",
	number        = 20
}

local breath_bar_definition = {
	hud_elem_type = "statbar",
	position      = {x =  0.5, y = 1},
	alignment     = {x = -1,   y = -1},
	offset        = {x =  8,  y = -134},
	size          = {x =  24,  y = 24},
	text          = "bubble.png",
	number        = 20
}

local hud_ids = {}

local function initialize_builtin_statbars(player)

	if not player:is_player() then
		return
	end

	local name = player:get_player_name()

	if name == "" then
		return
	end

	if (hud_ids[name] == nil) then
		hud_ids[name] = {}
		-- flags are not transmitted to client on connect, we need to make sure
		-- our current flags are transmitted by sending them actively
		player:hud_set_flags(player:hud_get_flags())
	end

	if player:hud_get_flags().healthbar then
 		--if hud_ids[name].id_healthbar == nil then
			--hud_ids[name].id_healthbar = hud.register("health", health_bar_definition)
			minetest.after(0, function()
				hud.change_item(player, "health", {number = player:get_hp()})
			end)
		--end
	else
		if hud_ids[name].id_healthbar ~= nil then
			player:hud_remove(hud_ids[name].id_healthbar)
			hud_ids[name].id_healthbar = nil
		end
	end

	if (player:get_breath() < 11) then
		if player:hud_get_flags().breathbar then
			if hud_ids[name].id_breathbar == nil then
				hud_ids[name].id_breathbar = player:hud_add(breath_bar_definition)
			end
		else
			if hud_ids[name].id_breathbar ~= nil then
				player:hud_remove(hud_ids[name].id_breathbar)
				hud_ids[name].id_breathbar = nil
			end
		end
	elseif hud_ids[name].id_breathbar ~= nil then
		player:hud_remove(hud_ids[name].id_breathbar)
		hud_ids[name].id_breathbar = nil
	end
end

local function cleanup_builtin_statbars(player)

	if not player:is_player() then
		return
	end

	local name = player:get_player_name()

	if name == "" then
		return
	end

	hud_ids[name] = nil
end

local function player_event_handler(player, eventname)
	assert(player:is_player())

	local name = player:get_player_name()

	if name == "" then
		return
	end

	if eventname == "health_changed" then
		initialize_builtin_statbars(player)

		if hud_id[name.."_".."health"] ~= nil then
			hud.change_item(player, "health", {number = player:get_hp()})
			return true
		end
	end

	if eventname == "breath_changed" then
		initialize_builtin_statbars(player)

		if hud_ids[name].id_breathbar ~= nil then
			player:hud_change(hud_ids[name].id_breathbar,"number",player:get_breath()*2)
			return true
		end
	end

	if eventname == "hud_changed" then
		initialize_builtin_statbars(player)
		return true
	end

	return false
end

--[[function core.hud_replace_builtin(name, definition)

	if definition == nil or
		type(definition) ~= "table" or
		definition.hud_elem_type ~= "statbar" then
		return false
	end

	if name == "health" then
		health_bar_definition = definition

		for name,ids in pairs(hud_ids) do
			local player = core.get_player_by_name(name)
			if  player and hud_ids[name].id_healthbar then
				player:hud_remove(hud_ids[name].id_healthbar)
				initialize_builtin_statbars(player)
			end
		end
		return true
	end

	if name == "breath" then
		breath_bar_definition = definition

		for name,ids in pairs(hud_ids) do
			local player = core.get_player_by_name(name)
			if  player and hud_ids[name].id_breathbar then
				player:hud_remove(hud_ids[name].id_breathbar)
				initialize_builtin_statbars(player)
			end
		end
		return true
	end

	return false
end]]

if enable_damage then
	hud.register("health", health_bar_definition)
	core.register_on_joinplayer(initialize_builtin_statbars)
	core.register_on_leaveplayer(cleanup_builtin_statbars)
	core.register_playerevent(player_event_handler)
end

-- Hud Item name
local timer, wield = {}, {}
local timeout = 2

hud.register("itemname", {
	hud_elem_type = "text",
	position      = {x = 0.5,  y =  1},
	alignment     = {x = 0,    y = -10},
	offset        = {x = 0,    y = -25},
	number        = 0xFFFFFF,
	text          = ""
})

minetest.register_playerstep(function(dtime, playernames)
	for _, name in pairs(playernames) do
		local player = minetest.get_player_by_name(name)
		if player and player:is_player() then
			local wielded_item = player:get_wielded_item()
			local wielded_item_name = wielded_item:get_name()

			timer[player] = timer[player] and timer[player] + dtime or 0
			wield[player] = wield[player] or ""

			if timer[player] > timeout then
				hud.change_item(player, "itemname", {text = ""})
				timer[player] = 0
				return
			end

			if player and wielded_item_name ~= wield[player] then
				wield[player] = wielded_item_name
				timer[player] = 0

				local def = core.registered_items[wielded_item_name]
				local meta = wielded_item:get_meta()
				local meta_desc = meta:get_string("description")
				meta_desc = meta_desc:gsub("\27", ""):gsub("%(c@#%w%w%w%w%w%w%)", "")

				local description = meta_desc ~= "" and meta_desc or
					(def and (def.description:match("(.-)\n") or def.description) or "")

				hud.change_item(player, "itemname", {text = description})
			end
		end
	end
end, true)
