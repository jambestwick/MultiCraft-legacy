
multicraft.log("info", "Initializing Asynchronous environment")

function multicraft.job_processor(serialized_func, serialized_param)
	local func = loadstring(serialized_func)
	local param = multicraft.deserialize(serialized_param)
	local retval = nil

	if type(func) == "function" then
		retval = multicraft.serialize(func(param))
	else
		multicraft.log("error", "ASYNC WORKER: Unable to deserialize function")
	end

	return retval or multicraft.serialize(nil)
end

