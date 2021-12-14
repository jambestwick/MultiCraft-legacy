--Minetest
--Copyright (C) 2020-2021 MultiCraft Development Team
--Copyright (C) 2013 sapier
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

--------------------------------------------------------------------------------

local labels = {
	leaves = {
		fgettext("Opaque"),
		fgettext("Simple"),
		fgettext("Fancy")
	},
	node_highlighting = {
		fgettext("Outlining"),
		fgettext("Highlighting"),
		fgettext("None")
	}
}

local dd_options = {
	leaves = {
		table.concat(labels.leaves, ","),
		{"opaque", "simple", "fancy"}
	},
	node_highlighting = {
		table.concat(labels.node_highlighting, ","),
		{"box", "halo", "none"}
	}
}

local getSettingIndex = {
	Leaves = function()
		local style = core.settings:get("leaves_style")
		for idx, name in pairs(dd_options.leaves[2]) do
			if style == name then return idx end
		end
		return 1
	end,
	NodeHighlighting = function()
		local style = core.settings:get("node_highlighting")
		for idx, name in pairs(dd_options.node_highlighting[2]) do
			if style == name then return idx end
		end
		return 1
	end
}

local function formspec(tabview, name, tabdata)
	local fps = tonumber(core.settings:get("fps_max"))
	local range = tonumber(core.settings:get("viewing_range"))
	local touchthreshold = tonumber(core.settings:get("touchscreen_threshold")) or 0
	local touchtarget = core.settings:get_bool("touchtarget") or false
	local sound = tonumber(core.settings:get("sound_volume")) ~= 0 and true or false

	local tab_string =
		"box[0,0;3.75,5.5;#999999]" ..
		"checkbox[0.25,-0.05;cb_smooth_lighting;" .. fgettext("Smooth Lighting") .. ";"
				.. dump(core.settings:get_bool("smooth_lighting")) .. "]" ..
		"checkbox[0.25,0.5;cb_particles;" .. fgettext("Particles") .. ";"
				.. dump(core.settings:get_bool("enable_particles")) .. "]" ..
		"checkbox[0.25,1.1;cb_3d_clouds;" .. fgettext("3D Clouds") .. ";"
				.. dump(core.settings:get_bool("enable_3d_clouds")) .. "]" ..
	--[["checkbox[0.25,1.7;cb_opaque_water;" .. fgettext("Opaque Water") .. ";"
				.. dump(core.settings:get_bool("opaque_water")) .. "]" ..
		"checkbox[0.25,2.0;cb_connected_glass;" .. fgettext("Connected Glass") .. ";"
				.. dump(core.settings:get_bool("connected_glass")) .. "]" ..]]
		"checkbox[0.25,1.7;cb_fog;" .. fgettext("Fog") .. ";"
				.. dump(core.settings:get_bool("enable_fog")) .. "]" ..
		"checkbox[0.25,2.3;cb_inventory_items_animations;" .. fgettext("Inv. animations") .. ";"
				.. dump(core.settings:get_bool("inventory_items_animations")) .. "]" ..
		"checkbox[0.25,2.9;cb_touchtarget;" .. fgettext("Touchtarget") .. ";"
				.. dump(touchtarget) .. "]" ..
		"checkbox[0.25,3.5;cb_sound;" .. fgettext("Sound") .. ";"
				.. dump(sound) .. "]" ..
		"label[0.25,4.2;" .. fgettext("Leaves Style:") .. "]" ..
		"dropdown[0.25,4.65;3.5;dd_leaves_style;" .. dd_options.leaves[1] .. ";"
				.. getSettingIndex.Leaves() .. "]" ..
		"box[4,0;3.75,5.5;#999999]" ..

		"label[4.25,0.15;" .. fgettext("Max FPS:") .. "]" ..
		"dropdown[4.25,0.6;3.5;dd_fps_max;30,35,45,60;" ..
			tonumber(fps <= 30 and 1 or fps == 35 and 2 or fps == 45 and 3 or 4) .. "]" ..

		"label[4.25,1.5;" .. fgettext("View Range:") .. "]" ..
		"dropdown[4.25,1.95;3.5;dd_viewing_range;25,30,40,60,80,100,125,150,175,200;" ..
			tonumber(range <= 25 and 1 or range == 30 and 2 or range == 40 and 3 or
			range == 60 and 4 or range == 80 and 5 or range == 100 and 6 or range == 125 and 7 or
			range == 150 and 8 or range == 175 and 9 or 10) .. "]" ..

		"label[4.25,2.85;" .. fgettext("Node Selection:") .. "]" ..
		"dropdown[4.25,3.3;3.5;dd_node_highlighting;" .. dd_options.node_highlighting[1] .. ";"
				.. getSettingIndex.NodeHighlighting() .. "]" ..

		"label[4.25,4.2;" .. fgettext("Touchthreshold: (px)") .. "]" ..
		"dropdown[4.25,4.65;3.5;dd_touchthreshold;0,10,20,30,40,50;" ..
			(touchthreshold / 10) + 1 .. "]" ..

	--	"box[8,0;3.75,4.5;#999999]"
		"box[8,0;3.75,5.5;#999999]"

	local video_driver = core.settings:get("video_driver")
	local shaders_enabled = core.settings:get_bool("enable_shaders")
	if video_driver == "opengl" or video_driver == "ogles2" then
		tab_string = tab_string ..
			"checkbox[8.25,-0.05;cb_shaders;" .. fgettext("Shaders") .. ";"
					.. tostring(shaders_enabled) .. "]"
	else
		core.settings:set_bool("enable_shaders", false)
		shaders_enabled = false
		tab_string = tab_string ..
			"label[8.38,0.15;" .. core.colorize("#888888",
					fgettext("Shaders (unavailable)")) .. "]"
	end

--[[tab_string = tab_string ..
		"button[8,3.22;3.95,1;btn_change_keys;"
		.. fgettext("Change Keys") .. "]"

	tab_string = tab_string ..
		"button[8,4.57;3.95,1;btn_advanced_settings;"
		.. fgettext("All Settings") .. "]"]]

	if shaders_enabled then
		tab_string = tab_string ..
			"checkbox[8.25,0.55;cb_tonemapping;" .. fgettext("Tone Mapping") .. ";"
					.. dump(core.settings:get_bool("tone_mapping")) .. "]" ..
			"checkbox[8.25,1.15;cb_waving_water;" .. fgettext("Waving Liquids") .. ";"
					.. dump(core.settings:get_bool("enable_waving_water")) .. "]" ..
			"checkbox[8.25,1.75;cb_waving_leaves;" .. fgettext("Waving Leaves") .. ";"
					.. dump(core.settings:get_bool("enable_waving_leaves")) .. "]" ..
			"checkbox[8.25,2.35;cb_waving_plants;" .. fgettext("Waving Plants") .. ";"
					.. dump(core.settings:get_bool("enable_waving_plants")) .. "]"
	else
		tab_string = tab_string ..
			"label[8.38,0.75;" .. core.colorize("#888888",
					fgettext("Tone Mapping")) .. "]" ..
			"label[8.38,1.35;" .. core.colorize("#888888",
					fgettext("Waving Liquids")) .. "]" ..
			"label[8.38,1.95;" .. core.colorize("#888888",
					fgettext("Waving Leaves")) .. "]" ..
			"label[8.38,2.55;" .. core.colorize("#888888",
					fgettext("Waving Plants")) .. "]"
	end

	return tab_string
end

--------------------------------------------------------------------------------
local function handle_settings_buttons(this, fields, tabname, tabdata)
--[[if fields["btn_advanced_settings"] ~= nil then
		local adv_settings_dlg = create_adv_settings_dlg()
		adv_settings_dlg:set_parent(this)
		this:hide()
		adv_settings_dlg:show()
		return true
	end]]
	if fields["cb_smooth_lighting"] then
		core.settings:set("smooth_lighting", fields["cb_smooth_lighting"])
		return true
	end
	if fields["cb_particles"] then
		core.settings:set("enable_particles", fields["cb_particles"])
		return true
	end
	if fields["cb_3d_clouds"] then
		core.settings:set("enable_3d_clouds", fields["cb_3d_clouds"])
		return true
	end
	if fields["cb_opaque_water"] then
		core.settings:set("opaque_water", fields["cb_opaque_water"])
		return true
	end
--[[if fields["cb_connected_glass"] then
		core.settings:set("connected_glass", fields["cb_connected_glass"])
		return true
	end]]
	if fields["cb_fog"] then
		core.settings:set("enable_fog", fields["cb_fog"])
		return true
	end
	if fields["cb_inventory_items_animations"] then
		core.settings:set("inventory_items_animations", fields["cb_inventory_items_animations"])
		return true
	end
	if fields["cb_touchtarget"] then
		core.settings:set("touchtarget", fields["cb_touchtarget"])
		return true
	end
	if fields["cb_sound"] then
		core.settings:set("sound_volume", (minetest.is_yes(fields["cb_sound"]) and "1.0") or "0.0")
		return true
	end
	if fields["cb_shaders"] then
		core.settings:set("enable_shaders", fields["cb_shaders"])
		return true
	end
	if fields["cb_tonemapping"] then
		core.settings:set("tone_mapping", fields["cb_tonemapping"])
		return true
	end
	if fields["cb_waving_water"] then
		core.settings:set("enable_waving_water", fields["cb_waving_water"])
		return true
	end
	if fields["cb_waving_leaves"] then
		core.settings:set("enable_waving_leaves", fields["cb_waving_leaves"])
	end
	if fields["cb_waving_plants"] then
		core.settings:set("enable_waving_plants", fields["cb_waving_plants"])
		return true
	end
--[[if fields["btn_change_keys"] then
		core.show_keys_menu()
		return true
	end]]

	-- Note dropdowns have to be handled LAST!
	local ddhandled = false

	for i = 1, #labels.leaves do
		if fields["dd_leaves_style"] == labels.leaves[i] then
			core.settings:set("leaves_style", dd_options.leaves[2][i])
			ddhandled = true
		end
	end
	if fields["cb_touchscreen_target"] then
		core.settings:set("touchtarget", fields["cb_touchscreen_target"])
		ddhandled = true
	end
	for i = 1, #labels.node_highlighting do
		if fields["dd_node_highlighting"] == labels.node_highlighting[i] then
			core.settings:set("node_highlighting", dd_options.node_highlighting[2][i])
			ddhandled = true
		end
	end
	if fields["dd_fps_max"] then
		core.settings:set("fps_max", fields["dd_fps_max"])
		ddhandled = true
	end
	if fields["dd_viewing_range"] then
		core.settings:set("viewing_range", fields["dd_viewing_range"])
		ddhandled = true
	end
	if fields["dd_touchthreshold"] then
		core.settings:set("touchscreen_threshold", fields["dd_touchthreshold"])
		ddhandled = true
	end

	return ddhandled
end

return {
	name = "settings",
	caption = fgettext("Settings"),
	cbf_formspec = formspec,
	cbf_button_handler = handle_settings_buttons
}
