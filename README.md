# Telescope.k8s

View and describe k8s resources using Telescope.nvim 🔭

## Getting started

Install telescope.k8s as a requirement for telescope.nvim using Packer:
``` lua
return require('packer').startup(function()
  use {
  'nvim-telescope/telescope.nvim',
	  requires = {
		  { 'nvim-lua/plenary.nvim' },
		  { 'synthe102/telescope.k8s' }
	  }
  }
```

Add this to your `init.lua`:
``` lua
require('telescope').load_extension('k8s')
```

## Using Telescope.k8s

You can list all the kubernetes resources types available in by your cluster:
```
:Telescope k8s api_resources
```

You can then search and select a resource type.
This will list all the resources of the type you selected in all namespaces, and describe the one you're hovering.
