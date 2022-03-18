local has_telescope, telescope = pcall(require, 'telescope')
local main = require('telescope._extensions.k8s.main')

if not has_telescope then
	error('This plugin requires nvim-telescope/telescope.nvim')
end

return telescope.register_extension{
	exports = {
		get = main.get
	}
}
