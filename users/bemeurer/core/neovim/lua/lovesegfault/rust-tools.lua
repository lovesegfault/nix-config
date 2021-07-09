local lsp = require("lovesegfault.lsp")

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
