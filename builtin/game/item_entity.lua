-- Minetest: builtin/item_entity.lua

local abs, min, random, pi = math.abs, math.min, math.random, math.pi
local vnormalize = vector.normalize

function core.spawn_item(pos, item)
	-- Take item in any format
	local stack = ItemStack(item)
	local obj = core.add_entity(pos, "__builtin:item")
	-- Don't use obj if it couldn't be added to the map.
	if obj then
		obj:get_luaentity():set_item(stack:to_string())
	end
	return obj
end

-- If item_entity_ttl is not set, enity will have default life time
-- Setting it to -1 disables the feature

local time_to_live = tonumber(core.settings:get("item_entity_ttl")) or 600
local gravity = tonumber(core.settings:get("movement_gravity")) or 9.81
local collection = core.settings:get_bool("item_collection") ~= false
local water_flow = core.settings:get_bool("item_water_flow") ~= false
local lava_destroy = core.settings:get_bool("item_lava_destroy") ~= false

-- Water flow functions, based on QwertyMine3 (WTFPL), and TenPlus1 (MIT) mods
local function quick_flow_logic(node, pos_testing, dir)
	local node_testing = core.get_node_or_nil(pos_testing)
	if not node_testing then return 0 end
	local liquid = core.registered_nodes[node_testing.name] and core.registered_nodes[node_testing.name].liquidtype

	if not liquid or liquid ~= "flowing" and liquid ~= "source" then
		return 0
	end

	local sum = node.param2 - node_testing.param2

	return (sum < -6 or (sum < 6 and sum > 0) or sum == 0) and dir or -dir
end

local function quick_flow(pos, node)
	local x, z = 0, 0

	x = x + quick_flow_logic(node, {x = pos.x - 1.01, y = pos.y, z = pos.z}, -1)
	x = x + quick_flow_logic(node, {x = pos.x + 1.01, y = pos.y, z = pos.z},  1)
	z = z + quick_flow_logic(node, {x = pos.x, y = pos.y, z = pos.z - 1.01}, -1)
	z = z + quick_flow_logic(node, {x = pos.x, y = pos.y, z = pos.z + 1.01},  1)
	return vnormalize({x = x, y = 0, z = z})
end

core.register_entity(":__builtin:throwing_item", {
	physical = false,
	visual = "wielditem",
	collisionbox = {0, 0, 0, 0, 0, 0},
	textures = {""},
	visual_size = {x = 0.4, y = 0.4},
	is_visible = false,
	on_activate = function(self, staticdata)
		if staticdata == "expired" then
			self.object:remove()
		end
	end,
	get_staticdata = function()
		return "expired"
	end
})

core.register_entity(":__builtin:item", {
	initial_properties = {
		hp_max = 1,
		physical = true,
		collide_with_objects = false,
		collisionbox = {-0.3, -0.3, -0.3, 0.3, 0.3, 0.3},
		visual = "wielditem",
		visual_size = {x = 0.4, y = 0.4},
		textures = {""},
		spritediv = {x = 1, y = 1},
		initial_sprite_basepos = {x = 0, y = 0},
		is_visible = false,
	},

	itemstring = "",
	moving_state = true,
	slippery_state = false,
	stuck = false,
	age = 0,

	set_item = function(self, item)
		local stack = ItemStack(item or self.itemstring)
		self.itemstring = stack:to_string()
		if self.itemstring == "" then
			-- item not yet known
			return
		end

		-- Backwards compatibility: old clients use the texture
		-- to get the type of the item
		local itemname = stack:is_known() and stack:get_name() or "unknown"

		local max_count = stack:get_stack_max()
		local count = min(stack:get_count(), max_count)
		local size = 0.2 + 0.1 * (count / max_count) ^ (1 / 3)
		local coll_height = size * 0.75
		local def = core.registered_nodes[itemname]

		self.object:set_properties({
			is_visible = true,
			visual = "wielditem",
			textures = {itemname},
			visual_size = {x = size, y = size},
			collisionbox = {-size, -coll_height, -size,
				size, coll_height, size},
			selectionbox = {-size, -size, -size, size, size, size},
			automatic_rotate = pi * 0.5 * 0.15 / size,
			wield_item = self.itemstring,
			glow = def and def.light_source,
			infotext = core.registered_items[itemname].description
		})

	end,

	get_staticdata = function(self)
		return core.serialize({
			itemstring = self.itemstring,
			age = self.age,
			dropped_by = self.dropped_by
		})
	end,

	on_activate = function(self, staticdata, dtime_s)
		if staticdata:sub(1, 6) == "return" then
			local data = core.deserialize(staticdata)
			if data and type(data) == "table" then
				self.itemstring = data.itemstring
				self.age = (data.age or 0) + dtime_s
				self.dropped_by = data.dropped_by
			end
		else
			self.itemstring = staticdata
		end
		self.object:set_armor_groups({immortal = 1, silent = 1})
		self.object:set_velocity({x = 0, y = 2, z = 0})
		self.object:set_acceleration({x = 0, y = -gravity, z = 0})
		self:set_item()
	end,

	try_merge_with = function(self, own_stack, object, entity)
		if self.age == entity.age then
			-- Can not merge with itself
			return false
		end

		local stack = ItemStack(entity.itemstring)
		local name = stack:get_name()
		if own_stack:get_name() ~= name or
				own_stack:get_meta() ~= stack:get_meta() or
				own_stack:get_wear() ~= stack:get_wear() or
				own_stack:get_free_space() == 0 then
			-- Can not merge different or full stack
			return false
		end

		local count = own_stack:get_count()
		local total_count = stack:get_count() + count
		local max_count = stack:get_stack_max()

		if total_count > max_count then
			return false
		end
		-- Merge the remote stack into this one

		local pos = object:get_pos()
		pos.y = pos.y + ((total_count - count) / max_count) * 0.15
		self.object:move_to(pos)

		self.age = 0 -- Handle as new entity
		own_stack:set_count(total_count)
		self:set_item(own_stack)

		entity.itemstring = ""
		object:remove()
		return true
	end,

	on_step = function(self, dtime)
		self.age = self.age + dtime
		if time_to_live > 0 and self.age > time_to_live then
			self.itemstring = ""
			self.object:remove()
			return
		end

		local pos = self.object:get_pos()
		local node = core.get_node_or_nil({
			x = pos.x,
			y = pos.y + self.object:get_properties().collisionbox[2] - 0.05,
			z = pos.z
		})
		local node_inside = core.get_node_or_nil(pos)
		-- Delete in 'ignore' nodes
		if node and node.name == "ignore" then
			self.itemstring = ""
			self.object:remove()
			return
		end

		local vel = self.object:get_velocity()
		local def = node and core.registered_nodes[node.name]
		local def_inside = node_inside and core.registered_nodes[node_inside.name]
		local is_moving = (def and not def.walkable) or
			vel.x ~= 0 or vel.y ~= 0 or vel.z ~= 0
		local is_slippery = false

		-- Destroy item when dropped into lava
		if lava_destroy and def_inside
				and def_inside.groups and def_inside.groups.lava then
			core.sound_play("default_cool_lava", {
				pos = pos, max_hear_distance = 10})
			self.object:remove()
			core.add_particlespawner({
				amount = 3,
				time = 0.1,
				minpos = {x = pos.x - 0.1, y = pos.y + 0.1, z = pos.z - 0.1},
				maxpos = {x = pos.x + 0.1, y = pos.y + 0.2, z = pos.z + 0.1},
				minvel = {x = 0, y = 2.5, z = 0},
				maxvel = {x = 0, y = 2.5, z = 0},
				minacc = {x = -0.15, y = -0.02, z = -0.15},
				maxacc = {x = 0.15, y = -0.01, z = 0.15},
				minexptime = 4,
				maxexptime = 6,
				minsize = 2,
				maxsize = 4,
				texture = "item_smoke.png"
			})
			return
		end

		-- Moving items in the water flow (TenPlus1, MIT)
		if water_flow and def_inside and def_inside.liquidtype == "flowing" then
			local vec = quick_flow(pos, node_inside)
			self.object:set_velocity({x = vec.x, y = vel.y, z = vec.z})
			return
		end

		-- Move item inside node to free space (TenPlus1, MIT)
		if not self.stuck and def_inside and def_inside.walkable and
				not def_inside.liquid and node_inside.name ~= "air" and
				def_inside.drawtype == "normal" then
			local npos = core.find_node_near(pos, 1, "air")
			if npos then
				self.object:move_to(npos)
			else
				self.stuck = true
			end
		end

		if def and def.walkable then
			local slippery = core.get_item_group(node.name, "slippery")
			is_slippery = slippery ~= 0
			if is_slippery and (abs(vel.x) > 0.2 or abs(vel.z) > 0.2) then
				-- Horizontal deceleration
				local slip_factor = 4.0 / (slippery + 4)
				self.object:set_acceleration({
					x = -vel.x * slip_factor,
					y = 0,
					z = -vel.z * slip_factor
				})
			elseif vel.y == 0 then
				is_moving = false
			end
		end

		self.moving_state = is_moving
		self.slippery_state = is_slippery

		if is_moving then
			self.object:set_acceleration({x = 0, y = -gravity, z = 0})
		else
			self.object:set_acceleration({x = 0, y = 0, z = 0})
			self.object:set_velocity({x = 0, y = 0, z = 0})
		end

		-- Collect the items around to merge with
		local own_stack = ItemStack(self.itemstring)
		if own_stack:get_free_space() == 0 then
			return
		end
		local objects = core.get_objects_inside_radius(pos, 0.5)
		for _, obj in pairs(objects) do
			local entity = obj:get_luaentity()
			if entity and entity.name == "__builtin:item" then
				if self:try_merge_with(own_stack, obj, entity) then
					own_stack = ItemStack(self.itemstring)
					if own_stack:get_free_space() == 0 then
						return
					end
				end
			end
		end
	end,

	on_punch = function(self, hitter)
		local inv = hitter:get_inventory()
		if inv and self.itemstring ~= "" then
			local left = inv:add_item("main", self.itemstring)
			if left and not left:is_empty() then
				self:set_item(left)
				return
			end
		end
		self.itemstring = ""
		self.object:remove()
	end
})

-- Item Collection
if collection then
	local function collect_items(player)
		local ppos = player:get_pos()
		ppos.y = ppos.y + 1.3
		if not core.is_valid_pos(ppos) then
			return
		end
		-- Detect
		local objects = core.get_objects_inside_radius(ppos, 2)
		for _, obj in pairs(objects) do
			local entity = obj:get_luaentity()
			if entity and entity.name == "__builtin:item" and
					not entity.collectioner and
					entity.age and entity.age > 0.5 then
				local item = ItemStack(entity.itemstring)
				local inv = player:get_inventory()
				if item:get_name() ~= "" and
						inv and inv:room_for_item("main", item) then
					-- Magnet
					obj:move_to(ppos)
					entity.collectioner = true
					-- Collect
					if entity.collectioner == true then
						core.after(0.05, function()
							core.sound_play("item_drop_pickup", {
								pos = ppos,
								max_hear_distance = 10,
								gain = 0.2,
								pitch = random(60,100)/100
							})
							entity.itemstring = ""
							obj:remove()
							item = inv:add_item("main", item)
							if not item:is_empty() then
								core.item_drop(item, player, ppos)
							end
						end)
					end
				end
			end
		end
	end

	core.register_playerstep(function(dtime, playernames)
		for _, name in pairs(playernames) do
			local player = core.get_player_by_name(name)
			if player and player:is_player() and player:get_hp() > 0 then
				collect_items(player)
			end
		end
	end, core.is_singleplayer()) -- Force step in singlplayer mode only
end
