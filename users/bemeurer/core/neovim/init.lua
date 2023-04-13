require("base")

-- ayu colorscheme
vim.o.background = "dark"
require("ayu").colorscheme()

-- modularized / complex configs
require("completion")
require("lsp")
require("status")

-- simple / no-config plugins
require("bufferline").setup({ options = { diagnostics = "nvim_lsp" } })
require("crates").setup()
require("dap")
require("gitsigns").setup()
require("guess-indent").setup()
require("indent_blankline").setup({ char = "▏", show_current_context = true, show_current_context_start = true })
require("numb").setup()
require("nvim-autopairs").setup({ map_cr = true, map_complete = true })
require("nvim-surround").setup()
require("tmux").setup()
require("true-zen").setup({ modes = { ataraxis = { minimum_writing_area = { width = 80, height = 48 } } } })

-- bufdelete
require("bufdelete")
vim.keymap.set("n", "<leader>bd", "<cmd>Bdelete<cr>", { silent = true })

-- dashboard
require("dashboard").setup({
  theme = "hyper",
  config = {
    week_header = {
      enable = true,
    },
    shortcut = {
      {
        icon = " ",
        icon_hl = "@variable",
        desc = "Files",
        group = "Label",
        action = "Telescope frecency",
        key = "f",
      },
    },
  },
})

-- todo-comments
local todo_comments = require("todo-comments")
todo_comments.setup()
vim.keymap.set("n", "<leader>tt", "<cmd>TodoTelescope<cr>", { desc = "Search todo with Telescope", silent = true })
vim.keymap.set("n", "[t", todo_comments.jump_prev, { desc = "Previous todo comment" })
vim.keymap.set("n", "]t", todo_comments.jump_next, { desc = "Next todo comment" })

-- treesitter
require("nvim-treesitter.configs").setup({
  auto_install = false,
  highlight = { enable = true },
  incremental_selection = { enable = true },
  indent = { enable = true },
})

-- trouble
require("trouble").setup()
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", { silent = true, noremap = true })

-- telescope
local telescope = require("telescope")
telescope.setup({
  extensions = {
    frecency = {
      auto_validate = false,
    },
  },
})
telescope.load_extension("frecency")

local ts_builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>fb", ts_builtin.buffers, { silent = true })
vim.keymap.set("n", "<leader>fc", ts_builtin.current_buffer_fuzzy_find, { silent = true })
vim.keymap.set("n", "<leader>ff", telescope.extensions.frecency.frecency, { silent = true })
vim.keymap.set("n", "<leader>fl", ts_builtin.live_grep, { silent = true })
vim.keymap.set("n", "<leader>fg", ts_builtin.git_files, { silent = true })

vim.keymap.set("n", "<leader>ld", ts_builtin.lsp_definitions, { silent = true })
vim.keymap.set("n", "<leader>li", ts_builtin.lsp_implementations, { silent = true })
vim.keymap.set("n", "<leader>lr", ts_builtin.lsp_references, { silent = true })
vim.keymap.set("n", "<leader>ls", ts_builtin.lsp_workspace_symbols, { silent = true })
vim.keymap.set("n", "<leader>lt", ts_builtin.lsp_type_definitions, { silent = true })

vim.keymap.set("n", "<leader>gc", ts_builtin.git_commits, { silent = true })
vim.keymap.set("n", "<leader>gb", ts_builtin.git_bcommits, { silent = true })
vim.keymap.set("n", "<leader>gs", ts_builtin.git_status, { silent = true })

-- which-key
vim.o.timeout = true
vim.o.timeoutlen = 300
require("which-key").setup()

-- whitespace
local whitespace = require("whitespace-nvim")
whitespace.setup({
  ignored_filetypes = { "TelescopePrompt", "Trouble", "dashboard", "help" },
})
vim.keymap.set("n", "<leader>tw", whitespace.trim, { silent = true })
