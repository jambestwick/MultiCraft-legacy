--From Better HUD mod
--Copyright (C) BlockMen (2013-2016)

--This program is free software; you can redistribute it and/or modify
--it under the terms of the GNU Lesser General Public License as published by
--the Free Software Foundation; either version 3.0 of the License, or
--(at your option) any later version.
--
--This program is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--GNU Lesser General Public License for more details.
--
--You should have received a copy of the GNU Lesser General Public License along
--with this program; if not, write to the Free Software Foundation, Inc.,
--51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

hud, hud_id = {}, {}

-- keep id handling internal
local sb_bg = {} -- statbar background ids

-- localize often used table
local items = {}

local function throw_error(msg)
	minetest.log("error", "HUD[error]: " .. msg)
end

--
-- API
--

function hud.register(name, def)
	if not name or not def then
		throw_error("not enough parameters given")
		return false
	end

	--TODO: allow other elements
	if def.hud_elem_type ~= "statbar" then
		throw_error("The given HUD element is no statbar")
		return false
	end
	if items[name] ~= nil then
		throw_error("A statbar with that name already exists")
		return false
	end

	-- actually register
	-- add background first since draworder is based on id :\
	if def.hud_elem_type == "statbar" and def.background ~= nil then
		sb_bg[name] = table.copy(def)
		sb_bg[name].text = def.background
		if not def.autohide_bg and def.max then
			sb_bg[name].number = def.max
		end
	end
	-- add item itself
	items[name] = def

	-- no error so far, return success
	return true
end

function hud.change_item(player, name, def)
	if not player or not player:is_player() or not name or not def then
		throw_error("Not enough parameters given to change HUD item")
		return false
	end
	local i_name = player:get_player_name().."_"..name
	local elem = hud_id[i_name]
	if not elem then
		throw_error("Given HUD element " .. dump(name) .. " does not exist")
		return false
	end

	-- Only update if values supported and value actually changed
	-- update supported values (currently number and text only)
	if def.number and elem.number then
		if def.number ~= elem.number then
			if elem.max and def.number > elem.max and not def.max then
				def.number = elem.max
			end
			if def.max then
				elem.max = def.max
			end
			player:hud_change(elem.id, "number", def.number)
			elem.number = def.number
			-- hide background when set
			local bg = hud_id[i_name.."_bg"]
			if elem.autohide_bg then
				if def.number < 1 then
					player:hud_change(bg.id, "number", 0)
				else
					local num = bg.number
					if bg.max then
						num = bg.max
					end
					player:hud_change(bg.id, "number", num)
				end
			else
				if bg and bg.max and bg.max < 1 and def.max and def.max > bg.max then
					player:hud_change(bg.id, "number", def.max)
					bg.max = def.max
					bg.number = def.max
				end
			end
		end
	end
	if def.text and elem.text then
		if def.text ~= elem.text then
			player:hud_change(elem.id, "text", def.text)
			elem.text = def.text
		end
	end

	if def.offset and elem.offset then
		if def.item_name and def.offset == "item" then
			-- for legacy reasons
			--[[if def.item_name then
				hud.swap_statbar(player, name, def.item_name)
			end]]
		else
			player:hud_change(elem.id, "offset", def.offset)
			elem.offset = def.offset
		end
	end

	return true
end

function hud.remove_item(player, name)
	if not player or not name then
		throw_error("Not enough parameters given")
		return false
	end
	local i_name = player:get_player_name().."_"..name
	if hud_id[i_name] == nil then
		throw_error("Given HUD element " .. dump(name) .. " does not exist")
		return false
	end
	player:hud_remove(hud_id[i_name].id)
	hud_id[i_name] = nil

	return true
end

--
-- Add registered HUD items to joining players
--

-- Following code is placed here to keep HUD ids internal
local function add_hud_item(player, name, def)
	if not player or not name or not def then
		throw_error("not enough parameters given")
		return false
	end
	local i_name = player:get_player_name().."_"..name
	hud_id[i_name] = def
	hud_id[i_name].id = player:hud_add(def)
end

minetest.register_on_joinplayer(function(player)
	-- add the backgrounds for statbars
	for _,item in pairs(sb_bg) do
		add_hud_item(player, _.."_bg", item)
	end
	-- and finally the actual HUD items
	for _,item in pairs(items) do
		add_hud_item(player, _, item)
	end
end)
