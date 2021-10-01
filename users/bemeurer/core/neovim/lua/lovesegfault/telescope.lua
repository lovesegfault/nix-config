local utils = require("lovesegfault.utils")
local map = utils.map

require("telescope").setup({
  defaults = {
    mappings = { i = { ["<C-u>"] = false, ["<C-d>"] = false } },
    generic_sorter = require("telescope.sorters").get_fzy_sorter,
    file_sorter = require("telescope.sorters").get_fzy_sorter,
  },
})

-- Add leader shortcuts
map("n", "<leader><space>", [[<cmd>lua require("telescope.builtin").buffers()<cr>]], { silent = true })
map("n", "<leader>ff", [[<cmd>lua require("telescope.builtin").find_files()<cr>]], { silent = true })
map("n", "<leader>fb", [[<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find()<cr>]], { silent = true })
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
