-- Minetest: builtin/privileges.lua

--
-- Privileges
--

multicraft.registered_privileges = {}

function multicraft.register_privilege(name, param)
	local function fill_defaults(def)
		if def.give_to_singleplayer == nil then
			def.give_to_singleplayer = true
		end
		if def.description == nil then
			def.description = "(no description)"
		end
	end
	local def = {}
	if type(param) == "table" then
		def = param
	else
		def = {description = param}
	end
	fill_defaults(def)
	multicraft.registered_privileges[name] = def
end

multicraft.register_privilege("interact", "Can interact with things and modify the world")
multicraft.register_privilege("teleport", "Can use /teleport command")
multicraft.register_privilege("bring", "Can teleport other players")
multicraft.register_privilege("settime", "Can use /time")
multicraft.register_privilege("privs", "Can modify privileges")
multicraft.register_privilege("basic_privs", "Can modify 'shout' and 'interact' privileges")
multicraft.register_privilege("server", "Can do server maintenance stuff")
multicraft.register_privilege("shout", "Can speak in chat")
multicraft.register_privilege("ban", "Can ban and unban players")
multicraft.register_privilege("kick", "Can kick players")
multicraft.register_privilege("give", "Can use /give and /giveme")
multicraft.register_privilege("password", "Can use /setpassword and /clearpassword")
multicraft.register_privilege("fly", {
	description = "Can fly using the free_move mode",
	give_to_singleplayer = false,
})
multicraft.register_privilege("fast", {
	description = "Can walk fast using the fast_move mode",
	give_to_singleplayer = false,
})
multicraft.register_privilege("noclip", {
	description = "Can fly through walls",
	give_to_singleplayer = false,
})
multicraft.register_privilege("rollback", "Can use the rollback functionality")

