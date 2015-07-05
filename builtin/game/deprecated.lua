-- Minetest: builtin/deprecated.lua

--
-- Default material types
--
function digprop_err()
	multicraft.log("info", debug.traceback())
	multicraft.log("info", "WARNING: The multicraft.digprop_* functions are obsolete and need to be replaced by item groups.")
end

multicraft.digprop_constanttime = digprop_err
multicraft.digprop_stonelike = digprop_err
multicraft.digprop_dirtlike = digprop_err
multicraft.digprop_gravellike = digprop_err
multicraft.digprop_woodlike = digprop_err
multicraft.digprop_leaveslike = digprop_err
multicraft.digprop_glasslike = digprop_err

multicraft.node_metadata_inventory_move_allow_all = function()
	multicraft.log("info", "WARNING: multicraft.node_metadata_inventory_move_allow_all is obsolete and does nothing.")
end

multicraft.add_to_creative_inventory = function(itemstring)
	multicraft.log('info', "WARNING: multicraft.add_to_creative_inventory: This function is deprecated and does nothing.")
end

--
-- EnvRef
--
multicraft.env = {}
local envref_deprecation_message_printed = false
setmetatable(multicraft.env, {
	__index = function(table, key)
		if not envref_deprecation_message_printed then
			multicraft.log("info", "WARNING: multicraft.env:[...] is deprecated and should be replaced with multicraft.[...]")
			envref_deprecation_message_printed = true
		end
		local func = core[key]
		if type(func) == "function" then
			rawset(table, key, function(self, ...)
				return func(...)
			end)
		else
			rawset(table, key, nil)
		end
		return rawget(table, key)
	end
})

function multicraft.rollback_get_last_node_actor(pos, range, seconds)
	return multicraft.rollback_get_node_actions(pos, range, seconds, 1)[1]
end

