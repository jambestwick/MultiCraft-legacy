-- Minetest: builtin/item_entity.lua

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
local collection = core.settings:get_bool("item_collection") or true

-- Water flow functions by QwertyMine3 (WTFPL), and TenPlus1 (MIT)
local function to_unit_vector(dir_vector)
	local inv_roots = {
		[0] = 1,
		[1] = 1,
		[2] = 0.70710678118655,
		[4] = 0.5,
		[5] = 0.44721359549996,
		[8] = 0.35355339059327
	}
	local sum = dir_vector.x * dir_vector.x + dir_vector.z * dir_vector.z
	return {
		x = dir_vector.x * inv_roots[sum],
		y = dir_vector.y,
		z = dir_vector.z * inv_roots[sum]
	}
end

local function quick_flow_logic(node, pos_testing, direction)
	local node_testing = core.get_node_or_nil(pos_testing)
	if node_testing and
	core.registered_nodes[node_testing.name] and
	core.registered_nodes[node_testing.name].liquidtype ~= "flowing" and
	core.registered_nodes[node_testing.name].liquidtype ~= "source" then
		return 0
	end
	local param2_testing = node_testing.param2
	if param2_testing < node.param2 then
		if (node.param2 - param2_testing) > 6 then
			return -direction
		else
			return direction
		end
	elseif param2_testing > node.param2 then
		if (param2_testing - node.param2) > 6 then
			return direction
		else
			return -direction
		end
	end
	return 0
end

local function quick_flow(pos, node)
	if not core.registered_nodes[node.name].groups.liquid then
		return {x = 0, y = 0, z = 0}
	end
	local x, z = 0, 0
	x = x + quick_flow_logic(node, {x = pos.x - 1, y = pos.y, z = pos.z}, -1)
	x = x + quick_flow_logic(node, {x = pos.x + 1, y = pos.y, z = pos.z},  1)
	z = z + quick_flow_logic(node, {x = pos.x, y = pos.y, z = pos.z - 1}, -1)
	z = z + quick_flow_logic(node, {x = pos.x, y = pos.y, z = pos.z + 1},  1)
	return to_unit_vector({x = x, y = 0, z = z})
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
		local count = math.min(stack:get_count(), max_count)
		local size = 0.2 + 0.1 * (count / max_count) ^ (1 / 3)
		local coll_height = size * 0.75

		self.object:set_properties({
			is_visible = true,
			visual = "wielditem",
			textures = {itemname},
			visual_size = {x = size, y = size},
			collisionbox = {-size, -coll_height, -size,
				size, coll_height, size},
			selectionbox = {-size, -size, -size, size, size, size},
			automatic_rotate = math.pi * 0.5 * 0.15 / size,
			wield_item = self.itemstring,
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
		if string.sub(staticdata, 1, string.len("return")) == "return" then
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
		self.node_inside = core.get_node_or_nil(pos)
		self.def_inside = self.node_inside
				and core.registered_nodes[self.node_inside.name]
		self.node_under = core.get_node_or_nil({
			x = pos.x,
			y = pos.y + self.object:get_properties().collisionbox[2] - 0.05,
			z = pos.z
		})
		self.def_under = self.node_under
				and core.registered_nodes[self.node_under.name]

		local node = self.node_inside
		-- Delete in 'ignore' nodes
		if node and node.name == "ignore" then
			self.itemstring = ""
			self.object:remove()
			return
		end

		local vel = self.object:get_velocity()
		local def = self.def_inside
		local is_moving = (def and not def.walkable) or
			vel.x ~= 0 or vel.y ~= 0 or vel.z ~= 0
		local is_slippery = false

		-- Destroy item when dropped into lava
		if def and def.groups and def.groups.lava then
			core.sound_play("default_cool_lava", {pos = pos, max_hear_distance = 10})
			self.object:remove()
			core.add_particlespawner({
				amount = 3,
				time = 0.1,
				minpos = {x = pos.x - 0.1, y = pos.y + 0.1, z = pos.z - 0.1 },
				maxpos = {x = pos.x + 0.1, y = pos.y + 0.2, z = pos.z + 0.1 },
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

		-- Moving items in the water flow
		if def and def.liquidtype == "flowing" then
			local vec = quick_flow(pos, node)
			self.object:set_velocity({x = vec.x, y = vel.y, z = vec.z})
			return
		end

		node = self.node_under
		def = self.def_under
		if def and def.walkable then
			local slippery = core.get_item_group(node.name, "slippery")
			is_slippery = slippery ~= 0
			if is_slippery and (math.abs(vel.x) > 0.2 or math.abs(vel.z) > 0.2) then
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

		if self.moving_state == is_moving and
				self.slippery_state == is_slippery then
			-- Do not update anything until the moving state changes
			return
		end

		self.moving_state = is_moving
		self.slippery_state = is_slippery

		if is_moving then
			self.object:set_acceleration({x = 0, y = -gravity, z = 0})
		else
			self.object:set_acceleration({x = 0, y = 0, z = 0})
			self.object:set_velocity({x = 0, y = 0, z = 0})
		end

		-- Only collect items if not moving
		if is_moving then
			return
		end

		-- Collect the items around to merge with
		local own_stack = ItemStack(self.itemstring)
		if own_stack:get_free_space() == 0 then
			return
		end
		local objects = core.get_objects_inside_radius(pos, 0.25)
		for k, obj in pairs(objects) do
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
local function collect_items(player)
	local pos = player:get_pos()
	if not core.is_valid_pos(pos) then
		return
	end
	-- Detect
	local col_pos = vector.add(pos, {x = 0, y = 1.3, z = 0})
	local objects = core.get_objects_inside_radius(col_pos, 2)
	for k, obj in pairs(objects) do
		local entity = obj:get_luaentity()
		if entity and entity.name == "__builtin:item" and
				not entity.collectioner and entity.age > 0.5 then
			local item = ItemStack(entity.itemstring)
			local inv = player:get_inventory()
			if inv and inv:room_for_item("main", item) and
					item:get_name() ~= "" then
				-- Magnet
				obj:move_to(col_pos)
				entity.collectioner = true
				-- Collect
				if entity.collectioner == true then
					core.after(0.05, function()
						core.sound_play("item_drop_pickup", {
							pos = col_pos,
							max_hear_distance = 10,
							gain = 0.2
						})
						entity.itemstring = ""
						obj:remove()
						inv:add_item("main", item)
					end)
				end
			end
		end
	end
end

-- Item collection
if collection then
	core.register_playerstep(function(dtime, playernames)
		for _, name in pairs(playernames) do
			local player = core.get_player_by_name(name)
			if player and player:is_player() and player:get_hp() > 0 then
				collect_items(player)
			end
		end
	end, core.is_singleplayer()) -- Force step in singlplayer mode only
end
