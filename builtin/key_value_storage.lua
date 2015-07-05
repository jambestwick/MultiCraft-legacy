--
-- Key-value storage stuff
--

function multicraft.kv_put(key, data)
    local json = multicraft.write_json(data)
    if not json then
        multicraft.log("error", "kv_put: Error in json serialize key=".. key .. " luaized_data=" .. multicraft.serialize(data))
        return
    end
    return multicraft.kv_put_string(key, json)
end

function multicraft.kv_get(key)
    local data = multicraft.kv_get_string(key)
    if data ~= nil then
        data = multicraft.parse_json(data)
    end
    return data
end

function multicraft.kv_rename(key1, key2)
    local data = multicraft.kv_get_string(key1)
    multicraft.kv_delete(key1)
    multicraft.kv_put_string(key2, data)
end
