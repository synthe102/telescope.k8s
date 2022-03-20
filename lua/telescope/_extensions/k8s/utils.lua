local utils = require "telescope.utils"

local K = {}

K._get_resources = function(opts)
	local resource_list = utils.get_os_command_output({"kubectl", "get", opts["resource"], "-A"})
	table.remove(resource_list, 1)
	return resource_list
end

K._describe_resource = function(entry, opts)
	local tmp_table = vim.split(entry.value, " +")
	if vim.tbl_isempty(tmp_table) then
		return { "echo", "Empty resource"}
	end
	return { "kubectl", "describe", opts["resource"], tmp_table[2], "-n", tmp_table[1] }
end

K._list_api_resources = function()
	local resource_types = utils.get_os_command_output({"kubectl", "api-resources"})
	table.remove(resource_types , 1)
	return resource_types
end

return K
