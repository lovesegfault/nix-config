local g = vim.g
local utils = require("utils")
local map = utils.map

require("base")

-- ayu colorscheme
vim.o.background = "dark"
require("ayu").colorscheme()

-- crates
require("crates").setup()

require("completion")
local lsp = require("lsp")
require("statusline")
require("treesitter")

-- autopair
require("nvim-autopairs").setup({ map_cr = true, map_complete = true })

-- bufferline
require("bufferline").setup({ options = { diagnostics = "nvim_lsp" } })

-- editorconfig
g.EditorConfig_exclude_patterns = { "fugitive://.*", "scp://.*" }

-- gitsigns
require("gitsigns").setup()

-- numb
require("numb").setup()

-- todo-comments
require("todo-comments").setup()

-- stabilize
require("stabilize").setup({
  nested = "QuickFixCmdPost,DiagnosticChanged *",
})

-- indent-blankline
g.indent_blankline_char = "▏"
g.indent_blankline_filetype_exclude = { "help" }
g.indent_blankline_buftype_exclude = { "terminal", "nofile" }
g.indent_blankline_char_highlight = "LineNr"

-- rust-tools
require("rust-tools").setup({
  server = {
    on_attach = lsp.on_attach,
    capabilities = lsp.capabilities,
    flags = lsp.flags,
    settings = {
      ["rust-analyzer"] = {
        assist = { importGranularity = "crate" },
        cargo = { allFeatures = true },
        checkOnSave = { allTargets = true, command = "clippy" },
        procMacro = { enable = true },
      },
    },
  },
})

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

-- true-zen
require("true-zen").setup()
