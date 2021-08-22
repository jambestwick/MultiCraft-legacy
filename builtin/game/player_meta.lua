local floor, tostring = math.floor, tostring
local getmetatable, setmetatable = getmetatable, setmetatable
local PlayerMetaRef = {}

function PlayerMetaRef:contains(key)
	return self.player:get_attribute(key) ~= nil
end

function PlayerMetaRef:get(key)
	return self.player:get_attribute(key)
end

function PlayerMetaRef:set_string(key, value)
	if value == "" then
		value = nil
	end
	self.player:set_attribute(key, value)
end

function PlayerMetaRef:get_string(key)
	return self.player:get_attribute(key) or ""
end

function PlayerMetaRef:set_int(key, value)
	self:set_float(key, floor(value))
end

function PlayerMetaRef:get_int(key)
	return floor(self:get_float(key))
end

function PlayerMetaRef:set_float(key, value)
	self.player:set_attribute(key, tostring(value))
end

function PlayerMetaRef:get_float(key)
	return tonumber(self:get_string(key)) or 0
end

local mt = {__index = PlayerMetaRef}
local function get_player_meta(player)
	return setmetatable({player = player}, mt)
end

minetest.register_on_joinplayer(function(player)
	if not player.get_meta then
		getmetatable(player).get_meta = get_player_meta
	end
end)
