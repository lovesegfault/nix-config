-- enable experimental lua loader
vim.loader.enable()

-- base configuration, independent of plugins (keymaps, etc)
require("base")

-- ayu colorscheme
vim.o.background = "dark"
require("ayu").colorscheme()

-- register nvim-notify
local notify = require("notify")
notify.setup({
  timeout = 2000,
})
vim.notify = notify
vim.keymap.set("n", "<C-d>", notify.dismiss, { desc = "Dismiss notifications", silent = true })

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
require("indent_blankline").setup({
  char = "▏",
  show_current_context = true,
  show_current_context_start = true,
  filetype_exclude = { "lspinfo", "packer", "checkhealth", "help", "man", "dashboard", "" },
})
require("leap").add_default_mappings()
require("numb").setup()
require("nvim-autopairs").setup({ map_cr = true, map_complete = true })
require("nvim-surround").setup()
require("tmux").setup()
require("true-zen").setup({ modes = { ataraxis = { minimum_writing_area = { width = 80, height = 48 } } } })

-- bufdelete
require("bufdelete")
vim.keymap.set("n", "<leader>bd", "<cmd>Bdelete<cr>", { desc = "Delete buffer", silent = true })

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
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { desc = "Toggle Trouble", silent = true, noremap = true })
vim.keymap.set(
  "n",
  "<leader>xw",
  "<cmd>TroubleToggle workspace_diagnostics<cr>",
  { desc = "Toggle Trouble workspace workspace_diagnostics", silent = true, noremap = true }
)
vim.keymap.set(
  "n",
  "<leader>xd",
  "<cmd>TroubleToggle document_diagnostics<cr>",
  { desc = "Toggle Trouble document diagnostics", silent = true, noremap = true }
)
vim.keymap.set(
  "n",
  "<leader>xl",
  "<cmd>TroubleToggle loclist<cr>",
  { desc = "Toggle Trouble location list", silent = true, noremap = true }
)
vim.keymap.set(
  "n",
  "<leader>xq",
  "<cmd>TroubleToggle quickfix<cr>",
  { desc = "Toggle Trouble quickfix list", silent = true, noremap = true }
)
vim.keymap.set(
  "n",
  "gR",
  "<cmd>TroubleToggle lsp_references<cr>",
  { desc = "Toggle Trouble LSP references", silent = true, noremap = true }
)

-- telescope
local telescope = require("telescope")
telescope.setup({
  extensions = {
    file_browser = {
      hijack_netrw = true,
    },
    frecency = {
      auto_validate = false,
    },
  },
})
telescope.load_extension("file_browser")
telescope.load_extension("frecency")
telescope.load_extension("notify")

local ts_builtin = require("telescope.builtin")
vim.keymap.set(
  "n",
  "<leader>fb",
  ts_builtin.buffers,
  { desc = "Lists open buffers in current neovim instance", silent = true }
)
vim.keymap.set(
  "n",
  "<leader>fc",
  ts_builtin.current_buffer_fuzzy_find,
  { desc = "Live fuzzy search inside of the currently open buffer", silent = true }
)
vim.keymap.set("n", "<leader>ff", function()
  telescope.extensions.frecency.frecency({ workspace = "CWD" })
end, { desc = "Search for files", silent = true })
vim.keymap.set(
  "n",
  "<leader>fl",
  ts_builtin.live_grep,
  { desc = "Search for a string and get results live as you type", silent = true }
)
vim.keymap.set(
  "n",
  "<leader>fg",
  ts_builtin.git_files,
  { desc = "Fuzzy search for files tracked by Git", silent = true }
)

vim.keymap.set(
  "n",
  "<leader>gc",
  ts_builtin.git_commits,
  { desc = "Lists commits for current directory with diff preview", silent = true }
)
vim.keymap.set(
  "n",
  "<leader>gb",
  ts_builtin.git_bcommits,
  { desc = "Lists commits for current buffer with diff preview", silent = true }
)
vim.keymap.set(
  "n",
  "<leader>gs",
  ts_builtin.git_status,
  { desc = "Lists git status for current directory", silent = true }
)

-- which-key
vim.o.timeout = true
vim.o.timeoutlen = 300
require("which-key").setup()

-- whitespace
local whitespace = require("whitespace-nvim")
whitespace.setup({
  ignored_filetypes = { "TelescopePrompt", "Trouble", "dashboard", "help" },
})
vim.keymap.set("n", "<leader>tw", whitespace.trim, { desc = "Trim leading/trailing whitespace", silent = true })
