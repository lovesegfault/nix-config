local lualine = require("lualine")
local navic = require("nvim-navic")

local sections = {
  diagnostics = {
    "diagnostics",
    sources = { "nvim_lsp" },
    symbols = { error = "", warn = "", info = "", hint = "" },
  },
  diff = {
    "diff",
    symbols = { added = "", modified = "柳", removed = "" },
  },
  filename = {
    "filename",
    symbols = {
      modified = "●", -- Text to show when the file is modified.
      readonly = "🔒", -- Text to show when the file is non-modifiable or readonly.
      unnamed = "[No Name]", -- Text to show for unnamed buffers.
      newfile = "[New]", -- Text to show for newly created file before first write
    },
  },
  filetype = {
    icon_only = true,
  },
  navic = {
    function()
      return navic.get_location()
    end,
    cond = function()
      return navic.is_available()
    end,
  },
}

lualine.setup({
  options = {
    section_separators = "",
    component_separators = "",
  },
  extensions = {
    "quickfix",
    "trouble",
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { sections.filetype, sections.filename, sections.navic },
    lualine_c = { sections.diagnostics },
    lualine_x = { "searchcount", sections.diff, "branch" },
    lualine_y = { "encoding", "fileformat" },
    lualine_z = { "location", "progress" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { sections.filetype, sections.filename },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
})
