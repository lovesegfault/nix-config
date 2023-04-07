local lsp_signature = require("lsp_signature")
local navic = require("nvim-navic")
local null_ls = require("null-ls")
local nvim_lightbulb = require("nvim-lightbulb")
local nvim_lsp = require("lspconfig")
local rust_tools = require("rust-tools")

null_ls.setup({
  sources = {
    null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.code_actions.statix,
    null_ls.builtins.diagnostics.actionlint,
    null_ls.builtins.diagnostics.checkmake,
    null_ls.builtins.diagnostics.chktex,
    null_ls.builtins.diagnostics.cppcheck,
    null_ls.builtins.diagnostics.editorconfig_checker,
    null_ls.builtins.diagnostics.luacheck,
    null_ls.builtins.diagnostics.ruff,
    null_ls.builtins.diagnostics.shellcheck,
    null_ls.builtins.diagnostics.statix,
    null_ls.builtins.formatting.shfmt,
  },
})

local flags = { debounce_text_changes = 150 }

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- support crates and LSP
vim.api.nvim_set_keymap(
  "n",
  "K",
  [[<cmd>lua require("utils").show_documentation()<CR>]],
  { noremap = true, silent = true }
)

-- bindings
local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  local map = vim.api.nvim_buf_set_keymap
  local opts = { noremap = true, silent = true }
  map(bufnr, "n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  map(bufnr, "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
  map(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  map(bufnr, "n", "<C-s>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  map(bufnr, "n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  map(bufnr, "n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  map(bufnr, "n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
  map(bufnr, "n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  map(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  map(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  map(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  map(bufnr, "n", "<leader>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
  map(bufnr, "n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
  map(bufnr, "n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
  map(bufnr, "n", "<leader>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)

  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
  lsp_signature.on_attach({}, bufnr)
  nvim_lightbulb.setup({ autocmd = { enabled = true } })
end

-- Enable the following language servers
local servers = { "clangd", "pyright", "texlab", "tsserver", "nil_ls", "metals" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup({ on_attach = on_attach, capabilities = capabilities, flags = flags })
end

nvim_lsp["ltex"].setup({
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    require("ltex_extra").setup({
      load_langs = { "en-US" },
      init_check = true,
      path = "./.ltex/", -- string : path to store dictionaries. Relative path uses current working directory
      log_level = "none",
    })
  end,
  capabilities = capabilities,
  flags = flags,
})

nvim_lsp["lua_ls"].setup({
  on_attach = on_attach,
  capabilities = capabilities,
  flags = flags,
  cmd = { "lua-language-server" },
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
        -- Setup your lua path
        -- path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})

nvim_lsp["nil_ls"].setup({
  on_attach = on_attach,
  capabilities = capabilities,
  flags = flags,
  settings = {
    ["nil"] = {
      formatting = {
        command = { "nixpkgs-fmt" },
      },
    },
  },
})

rust_tools.setup({
  server = {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = flags,
  },
})

-- Map :Format to vim.lsp.buf.formatting()
vim.cmd([[ command! Format execute "lua vim.lsp.buf.format({ async = true })" ]])
