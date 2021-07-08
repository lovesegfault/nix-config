require("lovesegfault")
require("lovesegfault.compe")
require("lovesegfault.indent-blankline")
require("lovesegfault.lightline")
require("lovesegfault.lsp")
require("lovesegfault.rust-tools")
require("lovesegfault.telescope")
require("lovesegfault.treesitter")
require("lovesegfault.trouble")

-- ayu colorscheme
vim.g.ayucolor = "dark"
vim.g.cmd "colorscheme ayu"

-- bufferline
require("bufferline").setup({options = {diagnostics = "nvim_lsp"}})

-- editorconfig
vim.g.EditorConfig_exclude_patterns = {"fugitive://.*", "scp://.*"}

-- gitsigns
require("gitsigns").setup()

-- numb
-- require('numb').setup()

-- todo-comments
require("todo-comments").setup()
