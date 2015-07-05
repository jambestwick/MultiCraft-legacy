
multicraft.async_jobs = {}

local function handle_job(jobid, serialized_retval)
	local retval = multicraft.deserialize(serialized_retval)
	assert(type(multicraft.async_jobs[jobid]) == "function")
	multicraft.async_jobs[jobid](retval)
	multicraft.async_jobs[jobid] = nil
end

if multicraft.register_globalstep then
	multicraft.register_globalstep(function(dtime)
		for i, job in ipairs(multicraft.get_finished_jobs()) do
			handle_job(job.jobid, job.retval)
		end
	end)
else
	multicraft.async_event_handler = handle_job
end

function multicraft.handle_async(func, parameter, callback)
	-- Serialize function
	local serialized_func = string.dump(func)

	assert(serialized_func ~= nil)

	-- Serialize parameters
	local serialized_param = multicraft.serialize(parameter)

	if serialized_param == nil then
		return false
	end

	local jobid = multicraft.do_async_callback(serialized_func, serialized_param)

	multicraft.async_jobs[jobid] = callback

	return true
end

