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

mt_color_grey  = "#AAAAAA"
mt_color_blue  = "#6389FF"
mt_color_green = "#72FF63"
mt_color_dark_green = "#25C191"

mt_red_button = core.get_color_escape_sequence("#FF3333")
mt_green_button = core.get_color_escape_sequence("#00CC00")

local menupath = core.get_mainmenu_path()
local basepath = core.get_builtin_path()
defaulttexturedir = core.get_texturepath_share() .. DIR_DELIM .. "base" .. DIR_DELIM
local mobile = PLATFORM == "Android" or PLATFORM == "iOS"

dofile(basepath .. "common" .. DIR_DELIM .. "async_event.lua")
dofile(basepath .. "common" .. DIR_DELIM .. "filterlist.lua")
dofile(basepath .. "fstk" .. DIR_DELIM .. "dialog.lua")
dofile(basepath .. "fstk" .. DIR_DELIM .. "tabview.lua")
dofile(basepath .. "fstk" .. DIR_DELIM .. "ui.lua")
dofile(menupath .. DIR_DELIM .. "common.lua")
dofile(menupath .. DIR_DELIM .. "gamemgr.lua")
--dofile(menupath .. DIR_DELIM .. "textures.lua")

dofile(menupath .. DIR_DELIM .. "dlg_create_world.lua")
--dofile(menupath .. DIR_DELIM .. "dlg_delete_mod.lua")
dofile(menupath .. DIR_DELIM .. "dlg_delete_world.lua")
--dofile(menupath .. DIR_DELIM .. "dlg_rename_modpack.lua")
--dofile(menupath .. DIR_DELIM .. "dlg_config_world.lua")

if not mobile then
	dofile(menupath .. DIR_DELIM .. "modmgr.lua")
--	dofile(menupath .. DIR_DELIM .. "store.lua")
	dofile(menupath .. DIR_DELIM .. "dlg_settings_advanced.lua")
end

local tabs = {}

if not mobile then
	tabs.settings = dofile(menupath .. DIR_DELIM .. "tab_settings.lua")
--	tabs.mods = dofile(menupath .. DIR_DELIM .. "tab_mods.lua")
--	tabs.texturepacks = dofile(menupath .. DIR_DELIM .. "tab_texturepacks.lua")
end

tabs.credits = dofile(menupath .. DIR_DELIM .. "tab_credits.lua")
local hpath = menupath .. DIR_DELIM .. "tab_hosting.lua"
local hosting = io.open(hpath, "r")
if hosting then
	tabs.hosting = dofile(hpath)
	io.close(hosting)
end
tabs.local_game = dofile(menupath .. DIR_DELIM .. "tab_local.lua")
tabs.play_online = dofile(menupath .. DIR_DELIM .. "tab_online.lua")

--------------------------------------------------------------------------------
local function main_event_handler(_, event)
	if event == "MenuQuit" then
		core.close()
	end
	return true
end

--------------------------------------------------------------------------------
local function init_globals()
	-- Init gamedata
	gamedata.worldindex = 0

	menudata.worldlist = filterlist.create(
		core.get_worlds,
		compare_worlds,
		-- Unique id comparison function
		function(element, uid)
			return element.name == uid
		end,
		-- Filter function
		function(element, gameid)
			return element.gameid == gameid
		end
	)

	menudata.worldlist:add_sort_mechanism("alphabetic", sort_worlds_alphabetic)
	menudata.worldlist:set_sortmode("alphabetic")

--	mm_texture.init()

	-- Create main tabview
	local tv_main = tabview_create("maintab", {x = 12, y = 5.4}, {x = 0, y = 0})

	tv_main:add(tabs.local_game)
	tv_main:add(tabs.play_online)
	if tabs.hosting then
		tv_main:add(tabs.hosting)
	end

if not mobile then
	tv_main:add(tabs.settings)
--	tv_main:add(tabs.texturepacks)
end

--	tv_main:add(tabs.mods)
	tv_main:add(tabs.credits)

	tv_main:set_autosave_tab(true)
	tv_main:set_global_event_handler(main_event_handler)
	tv_main:set_fixed_size(false)

	local last_tab = core.settings:get("maintab_LAST")
	if last_tab and tv_main.current_tab ~= last_tab then
		tv_main:set_tab(last_tab)
	end
	ui.set_default("maintab")
	tv_main:show()

	ui.update()

	core.set_clouds(false)
--	mm_texture.set_dirt_bg()
	core.set_background("background", defaulttexturedir .. "bg.png", true, 256)
--	core.sound_play("main_menu", true)
end

init_globals()
