-- Minetest: builtin/auth.lua

--
-- Builtin authentication handler
--

core.auth_file_path = core.get_worldpath().."/auth.txt"
local core_auth = {}

local function read_auth_file()
	local file, errmsg = io.open(core.auth_file_path, 'rb')
	if not file then
		core.log("info", core.auth_file_path.." could not be opened for reading ("..errmsg.."); assuming new world")
		return
	end
	for line in file:lines() do
		if line ~= "" then
			local fields = line:split(":", true)
			local name, password, privilege_string, last_login = unpack(fields)
			last_login = tonumber(last_login)
			if not (name and password and privilege_string) then
				error("Invalid line in auth.txt: "..dump(line))
			end
			local privileges = core.string_to_privs(privilege_string)
			core_auth[name] = {password=password, privileges=privileges, last_login=last_login}
		end
	end
	file:close()
	core.notify_authentication_modified()
end

local table_concat = table.concat
local privs_to_string = core.privs_to_string
local function save_auth_file()
	-- Check table for validness before attempting to save
	for name, stuff in pairs(core_auth) do
		assert(type(name) == "string")
		assert(name ~= "")
		assert(type(stuff) == "table")
		assert(type(stuff.password) == "string")
		assert(type(stuff.privileges) == "table")
		assert(stuff.last_login == nil or type(stuff.last_login) == "number")
	end
	local file, errmsg = io.open(core.auth_file_path, 'w+b')
	if not file then
		error(core.auth_file_path.." could not be opened for writing: "..errmsg)
	end
	for name, stuff in pairs(core_auth) do
		file:write(table_concat({
			name,
			stuff.password,
			privs_to_string(stuff.privileges),
			stuff.last_login or ""
		}, ":") .. "\n")
	end
	file:close()
end

core.builtin_auth_handler = {
	get_auth = function(name)
		assert(type(name) == "string")
		local auth_entry = core_auth[name]
		-- If no such auth found, return nil
		if not auth_entry then
			return nil
		end
		-- Figure out what privileges the player should have.
		-- Take a copy of the privilege table
		local privileges = {}
		for priv, _ in pairs(auth_entry.privileges) do
			privileges[priv] = true
		end
		-- If singleplayer, give all privileges except those marked as give_to_singleplayer = false
		if core.is_singleplayer() then
			for priv, def in pairs(core.registered_privileges) do
				if def.give_to_singleplayer then
					privileges[priv] = true
				end
			end
		-- For the admin, give everything
		elseif name == core.settings:get("name") then
			for priv, def in pairs(core.registered_privileges) do
				if def.give_to_admin then
					privileges[priv] = true
				end
			end
		end
		-- All done
		return {
			password = auth_entry.password,
			privileges = privileges,
			-- Is set to nil if unknown
			last_login = auth_entry.last_login,
		}
	end,
	create_auth = function(name, password)
		core.log("action", "[AUTH] Adding entry for new player " .. name)
		assert(type(name) == "string")
		assert(type(password) == "string")
		core_auth[name] = {
			password = password,
			privileges = core.string_to_privs(core.settings:get("default_privs")),
			last_login = os.time(),
		}
	end,
	set_password = function(name, password)
		assert(type(name) == "string")
		assert(type(password) == "string")
		local auth_entry = core_auth[name]
		if not auth_entry then
			core.log("action", "[AUTH] Setting password for new player " .. name)
			core.builtin_auth_handler.create_auth(name, password)
		else
			core.log("action", "[AUTH] Setting password for existing player " .. name)
			auth_entry.password = password
		end
		return true
	end,
	set_privileges = function(name, privileges)
		core.log("action", "[AUTH] Setting privileges for player " .. name)
		assert(type(name) == "string")
		assert(type(privileges) == "table")
		local auth_entry = core_auth[name]
		if not auth_entry then
			auth_entry = core.builtin_auth_handler.create_auth(name,
				core.get_password_hash(name,
					core.settings:get("default_password")))
		end

		-- Run grant callbacks
		for priv, _ in pairs(privileges) do
			if not auth_entry.privileges[priv] then
				core.run_priv_callbacks(name, priv, nil, "grant")
			end
		end

		-- Run revoke callbacks
		for priv, _ in pairs(auth_entry.privileges) do
			if not privileges[priv] then
				core.run_priv_callbacks(name, priv, nil, "revoke")
			end
		end

		auth_entry.privileges = privileges
		core.notify_authentication_modified(name)
	end,
	reload = function()
		core.log("action", "[AUTH] Reading authentication data from disk")
		read_auth_file()
		return true
	end,
	commit = function()
		core.log("action", "[AUTH] Writing authentication data to disk")
		save_auth_file()
		return true
	end,
	record_login = function(name)
		assert(type(name) == "string")
		local auth_entry = core_auth[name]
		assert(auth_entry)
		auth_entry.last_login = os.time()
	end,
}

core.register_on_prejoinplayer(function(name)
	if core.registered_auth_handler ~= nil then
		return -- Don't do anything if custom auth handler registered
	end
	local auth_entry = core_auth
	if auth_entry[name] ~= nil then
		return
	end

	local name_lower = name:lower()
	for k in pairs(auth_entry) do
		if k:lower() == name_lower then
			return ("\nYou can not register as '%s'! "..
					"Another player called '%s' is already registered. "..
					"Please check the spelling if it's your account "..
					"or use a different name."):format(name, k)
		end
	end
end)

--
-- Authentication API
--

function core.register_authentication_handler(handler)
	if core.registered_auth_handler then
		error("Add-on authentication handler already registered by "..core.registered_auth_handler_modname)
	end
	core.registered_auth_handler = handler
	core.registered_auth_handler_modname = core.get_current_modname()
	handler.mod_origin = core.registered_auth_handler_modname
end

function core.get_auth_handler()
	return core.registered_auth_handler or core.builtin_auth_handler
end

local function auth_pass(name)
	return function(...)
		local auth_handler = core.get_auth_handler()
		if auth_handler[name] then
			return auth_handler[name](...)
		end
		return false
	end
end

core.set_player_password = auth_pass("set_password")
core.set_player_privs    = auth_pass("set_privileges")
core.auth_reload         = auth_pass("reload")
core.auth_commit         = auth_pass("commit")

core.auth_reload()

local record_login = auth_pass("record_login")
core.register_on_joinplayer(function(player)
	record_login(player:get_player_name())
end)

core.register_on_shutdown(function()
	core.auth_commit()
end)

-- Autosave
if not core.is_singleplayer() then
	local save_interval = 600
	local function auto_save()
		core.auth_commit()
		collectgarbage()
		core.after(save_interval, auto_save)
	end
	core.after(save_interval, auto_save)
end
