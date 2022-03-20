-- telescope modules
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local previewers = require("telescope.previewers")
local conf = require("telescope.config").values
local utils = require "telescope.utils"

-- telescope k8s modules

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

K.get = function(opts)
  vim.api.nvim_echo({{'Hello k8s !' .. opts["resource"] ,'None'}}, false, {})
	pickers.new(opts or {}, {
		prompt_title = 'Select a ' .. opts["resource"],
		results_title = opts["resource"] .. 's',
		finder = finders.new_table {
			results = K._get_resources(opts),
			entry_maker = make_entry.gen_from_string(opts)
		},
		sorter = conf.file_sorter(opts),
		previewer = previewers.new_termopen_previewer {
			get_command = function(entry)
				return K._describe_resource(entry,opts)
			end,
		}
	}):find()
end

return K
