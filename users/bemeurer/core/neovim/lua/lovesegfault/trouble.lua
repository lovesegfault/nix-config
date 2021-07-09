local utils = require("lovesegfault.utils")
local map = utils.map

require("trouble").setup()

map("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { silent = true })
map("n", "<leader>xw", "<cmd>Trouble lsp_workspace_diagnostics<cr>", { silent = true })
map("n", "<leader>xd", "<cmd>Trouble lsp_document_diagnostics<cr>", { silent = true })
map("n", "<leader>xl", "<cmd>Trouble loclist<cr>", { silent = true })
map("n", "<leader>xq", "<cmd>Trouble quickfix<cr>", { silent = true })
map("n", "gR", "<cmd>Trouble lsp_references<cr>", { silent = true })
