-- telescope modules
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local previewers = require("telescope.previewers")
local conf = require("telescope.config").values

-- telescope k8s modules

local k8s_utils = require("telescope._extensions.k8s.utils")

local K = {}

K.get = function(opts)
	pickers.new(opts or {}, {
		prompt_title = 'Select a ' .. opts["resource"],
		results_title = opts["resource"],
		finder = finders.new_table {
			results = k8s_utils._get_resources(opts),
			entry_maker = make_entry.gen_from_string(opts)
		},
		sorter = conf.file_sorter(opts),
		previewer = previewers.new_termopen_previewer {
			get_command = function(entry)
				return k8s_utils._describe_resource(entry,opts)
			end,
		}
	}):find()
end

K.api_resources = function(opts)
	pickers.new(opts or {}, {
		prompt_title = 'Select a resource type',
		results_title = 'Resources types',
		finder = finders.new_table {
			results = k8s_utils._list_api_resources(),
			entry_maker = make_entry.gen_from_string(opts)
		},
		sorter = conf.file_sorter(opts),
		attach_mappings = function()

      local on_resource_selected = function()
				local entry = action_state.get_selected_entry()
				local tmp_table = vim.split(entry.value, " +")
				local get_opts = {}
				if vim.tbl_isempty(tmp_table) then
					return { "echo", ""}
				end
				get_opts["resource"] = tmp_table[1]
        K.get(get_opts)
      end
      actions.select_default:replace(on_resource_selected)
      return true
    end
	}):find()
end


return K
