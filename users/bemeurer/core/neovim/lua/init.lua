require("lovesegfault")

-- ayu colorscheme
vim.g.ayucolor = "dark"
vim.cmd("colorscheme ayu")

require("lovesegfault.compe")
require("lovesegfault.galaxyline")
require("lovesegfault.indent-blankline")
require("lovesegfault.lsp")
require("lovesegfault.rust-tools")
require("lovesegfault.telescope")
require("lovesegfault.treesitter")
require("lovesegfault.trouble")

-- bufferline
require("bufferline").setup({ options = { diagnostics = "nvim_lsp" } })

-- editorconfig
vim.g.EditorConfig_exclude_patterns = { "fugitive://.*", "scp://.*" }

-- gitsigns
require("gitsigns").setup()

-- numb
-- require('numb').setup()

-- todo-comments
require("todo-comments").setup()
