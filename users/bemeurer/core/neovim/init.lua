local utils = require("utils")
local map = utils.map

require("base")

-- ayu colorscheme
vim.o.background = "dark"
require("ayu").colorscheme()

-- modularized / complex configs
require("treesitter")
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
require("stabilize").setup({ nested = "QuickFixCmdPost,DiagnosticChanged *" })
require("tmux").setup()
require("true-zen").setup({ modes = { ataraxis = { minimum_writing_area = { width = 80, height = 48 } } } })

-- bufdelete
require("bufdelete")
map("", "<leader>bd", "<cmd>Bdelete<cr>")

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
        action = "Telescope find_files",
        key = "f",
      },
    },
  },
})

-- todo-comments
require("todo-comments").setup()
map("n", "<leader>tt", "<cmd>TodoTelescope<cr>", { silent = true })

-- trouble
require("trouble").setup()
map("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { silent = true })
map("n", "<leader>xw", "<cmd>Trouble lsp_workspace_diagnostics<cr>", { silent = true })
map("n", "<leader>xd", "<cmd>Trouble lsp_document_diagnostics<cr>", { silent = true })
map("n", "<leader>xl", "<cmd>Trouble loclist<cr>", { silent = true })
map("n", "<leader>xq", "<cmd>Trouble quickfix<cr>", { silent = true })
map("n", "gR", "<cmd>Trouble lsp_references<cr>", { silent = true })

-- telescope
local telescope = require("telescope")
telescope.setup({
  defaults = {
    mappings = { i = { ["<C-u>"] = false, ["<C-d>"] = false } },
    generic_sorter = require("telescope.sorters").get_fzy_sorter,
    file_sorter = require("telescope.sorters").get_fzy_sorter,
  },
  extensions = {
    frecency = {
      auto_validate = false,
    },
  },
})
telescope.load_extension("frecency")
map("n", "<leader><space>", [[<cmd>lua require("telescope.builtin").buffers()<cr>]], { silent = true })
map("n", "<leader>ff", [[<cmd>lua require("telescope.builtin").find_files()<cr>]], { silent = true })
map("n", "<leader>fb", [[<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find()<cr>]], { silent = true })
map("n", "<leader>fg", [[<cmd>lua require("telescope.builtin").git_files()<cr>]], { silent = true })
map("n", "<leader>fl", [[<cmd>lua require("telescope.builtin").live_grep()<cr>]], { silent = true })
map("n", "<leader>fs", [[<cmd>lua require("telescope.builtin").spell_suggest()<cr>]], { silent = true })
map("n", "<leader>lr", [[<cmd>lua require("telescope.builtin").lsp_references()<cr>]], { silent = true })
map("n", "<leader>ld", [[<cmd>lua require("telescope.builtin").lsp_document_symbols()<cr>]], { silent = true })
map("n", "<leader>lw", [[<cmd>lua require("telescope.builtin").lsp_workspace_symbols()<cr>]], { silent = true })
map("n", "<leader>dd", [[<cmd>lua require("telescope.builtin").lsp_document_diagnostics()<cr>]], { silent = true })
map("n", "<leader>dw", [[<cmd>lua require("telescope.builtin").lsp_workspace_diagnostics()<cr>]], { silent = true })
map("n", "<leader>gc", [[<cmd>lua require("telescope.builtin").git_commits()<cr>]], { silent = true })
map("n", "<leader>gb", [[<cmd>lua require("telescope.builtin").git_bcommits()<cr>]], { silent = true })
map("n", "<leader>gs", [[<cmd>lua require("telescope.builtin").git_status()<cr>]], { silent = true })
map("n", "<leader>gt", [[<cmd>lua require("telescope.builtin").git_stash()<cr>]], { silent = true })
map("n", "<leader>tr", [[<cmd>lua require("telescope.builtin").treesitter()<cr>]], { silent = true })

-- whitespace
require("whitespace-nvim").setup({
  ignored_filetypes = { "TelescopePrompt", "Trouble", "dashboard", "help" },
})
map("n", "<leader>tw", [[<cmd>lua require("whitespace-nvim").trim()<cr>]], { silent = true })
