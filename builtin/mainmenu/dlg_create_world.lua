--Minetest
--Copyright (C) 2014 sapier
--
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

local function create_world_formspec()
	local mapgens = core.get_mapgen_names()

	local current_seed = core.formspec_escape(core.settings:get("fixed_map_seed")) or ""
	local current_mg   = core.settings:get("mg_name")

	local mglist = ""
	local selindex = 1
	local i = 1
	for _, v in pairs(mapgens) do
		if current_mg == v then
			selindex = i
		end
		i = i + 1
		mglist = mglist .. v .. ","
	end
	mglist = mglist:sub(1, -2)

	local retval =
		"size[12,6,false]" ..
		"bgcolor[#00000000]" ..
		"background[0,0;0,0;" .. core.formspec_escape(defaulttexturedir ..
		"bg_dialog.png") .. ";true]" ..
		"label[1.5,1.2;" .. fgettext("World name") .. ":" .. "]"..
		"field[4.5,1.5;6,0.5;te_world_name;;]" ..

		"label[1.5,2.2;" .. fgettext("Seed") .. ":" .. "]"..
		"field[4.5,2.5;6,0.5;te_seed;;".. current_seed .. "]" ..

		"label[1.5,3.2;" .. fgettext("Mapgen") .. ":".."]"..
		"dropdown[4.2,3.05;6.3;dd_mapgen;" .. mglist .. ";" .. selindex .. "]" ..

		"button[3.5,4.8;2.5,0.5;world_create_confirm;" .. mt_green_button .. fgettext("Create") .. "]" ..
		"button[6,4.8;2.5,0.5;world_create_cancel;" .. fgettext("Cancel") .. "]"

	return retval

end

local function create_world_buttonhandler(this, fields)
	if fields["world_create_confirm"] or fields["key_enter"] then
		local worldname = fields["te_world_name"]
		local gameindex = 1

		if gameindex ~= nil then
			if worldname == "" then
				worldname = "World " .. math.random(1000, 9999)
			end
			core.settings:set("fixed_map_seed", fields["te_seed"])

			local message
			if not menudata.worldlist:uid_exists_raw(worldname) then
				core.settings:set("mg_name",fields["dd_mapgen"])
				message = core.create_world(worldname,gameindex)
			else
				message = fgettext("A world named \"$1\" already exists", worldname)
			end

			if message ~= nil then
				gamedata.errormessage = message
			else
				core.settings:set("menu_last_game",gamemgr.games[gameindex].id)
				if this.data.update_worldlist_filter then
					menudata.worldlist:set_filtercriteria(gamemgr.games[gameindex].id)
				end
				menudata.worldlist:refresh()
				core.settings:set("mainmenu_last_selected_world",
									menudata.worldlist:raw_index_by_uid(worldname))
			end
		else
			gamedata.errormessage = fgettext("No game selected")
		end

		this:delete()
		return true
	end

	if fields["games"] then
		local gameindex = 1
		core.settings:set("menu_last_game", gamemgr.games[gameindex].id)
		return true
	end

	if fields["world_create_cancel"] then
		this:delete()
		return true
	end

	return false
end


function create_create_world_dlg(update_worldlistfilter)
	local retval = dialog_create("sp_create_world",
					create_world_formspec,
					create_world_buttonhandler,
					nil)
	retval.update_worldlist_filter = update_worldlistfilter

	return retval
end
