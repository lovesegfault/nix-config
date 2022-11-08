local colors = require("ayu.colors")
local lsp = require("feline.providers.lsp")
local vi_mode_utils = require("feline.providers.vi_mode")
local navic = require("nvim-navic")

local vi_mode_colors = {
  NORMAL = colors.entity,
  INSERT = colors.string,
  VISUAL = colors.func,
  OP = colors.entity,
  BLOCK = colors.accent,
  REPLACE = colors.tag,
  ["V-REPLACE"] = colors.tag,
  ENTER = colors.special,
  MORE = colors.special,
  SELECT = colors.keyword,
  COMMAND = colors.constant,
  SHELL = colors.constant,
  TERM = colors.constant,
  NONE = colors.error,
}

local icons = {
  linux = " ",
  macos = " ",
  windows = " ",

  errs = " ",
  warns = " ",
  infos = " ",
  hints = " ",

  lsp = " ",
  git = "",
}

local function file_osinfo()
  local os = vim.bo.fileformat:upper()
  local icon
  if os == "UNIX" then
    icon = icons.linux
  elseif os == "MAC" then
    icon = icons.macos
  else
    icon = icons.windows
  end
  return icon .. os
end

local function lsp_diagnostics_info()
  return {
    errs = lsp.get_diagnostics_count(vim.diagnostic.severity.ERROR),
    warns = lsp.get_diagnostics_count(vim.diagnostic.severity.WARN),
    infos = lsp.get_diagnostics_count(vim.diagnostic.severity.INFO),
    hints = lsp.get_diagnostics_count(vim.diagnostic.severity.HINT),
  }
end

local function diag_enable(f, s)
  return function()
    local diag = f()[s]
    return diag and diag ~= 0
  end
end

local function diag_of(f, s)
  local icon = icons[s]
  return function()
    local diag = f()[s]
    return icon .. diag
  end
end

local function vimode_hl()
  return {
    name = vi_mode_utils.get_mode_highlight_name(),
    fg = colors.bg,
    bg = vi_mode_utils.get_mode_color(),
    style = "bold",
  }
end

local comps = {
  vi_mode = {
    provider = "vi_mode",
    hl = vimode_hl,
    right_sep = " ",
    icon = "",
  },
  file = {
    info = {
      provider = "file_info",
      hl = {
        fg = colors.keyword,
        style = "bold",
      },
    },
    encoding = {
      provider = "file_encoding",
      left_sep = " ",
      hl = {
        fg = colors.constant,
        style = "bold",
      },
    },
    type = {
      provider = "file_type",
    },
    os = {
      provider = file_osinfo,
      left_sep = " ",
      hl = {
        fg = colors.constant,
        style = "bold",
      },
    },
  },
  position = {
    provider = "position",
    left_sep = " ",
    hl = {
      fg = colors.tag,
      style = "bold",
    },
  },
  line_percentage = {
    provider = "line_percentage",
    left_sep = " ",
    hl = {
      style = "bold",
    },
  },
  scroll_bar = {
    provider = "scroll_bar",
    left_sep = " ",
    hl = {
      fg = colors.entity,
      style = "bold",
    },
  },
  diagnos = {
    err = {
      provider = diag_of(lsp_diagnostics_info, "errs"),
      left_sep = " ",
      enabled = diag_enable(lsp_diagnostics_info, "errs"),
      hl = {
        fg = colors.error,
      },
    },
    warn = {
      provider = diag_of(lsp_diagnostics_info, "warns"),
      left_sep = " ",
      enabled = diag_enable(lsp_diagnostics_info, "warns"),
      hl = {
        fg = colors.warning,
      },
    },
    info = {
      provider = diag_of(lsp_diagnostics_info, "infos"),
      left_sep = " ",
      enabled = diag_enable(lsp_diagnostics_info, "infos"),
      hl = {
        fg = colors.tag,
      },
    },
    hint = {
      provider = diag_of(lsp_diagnostics_info, "hints"),
      left_sep = " ",
      enabled = diag_enable(lsp_diagnostics_info, "hints"),
      hl = {
        fg = colors.regexp,
      },
    },
  },
  lsp = {
    name = {
      provider = "lsp_client_names",
      left_sep = " ",
      icon = icons.lsp,
      hl = {
        fg = colors.string,
      },
    },
  },
  navic = {
    provider = navic.get_location,
    left_sep = " ",
    enabled = navic.is_available,
    hl = {
      fg = colors.constant,
    },
  },
  git = {
    branch = {
      provider = "git_branch",
      icon = icons.git,
      left_sep = " ",
      hl = {
        fg = colors.keyword,
        style = "bold",
      },
    },
    add = {
      provider = "git_diff_added",
      hl = {
        fg = colors.vcs_added,
      },
    },
    change = {
      provider = "git_diff_changed",
      hl = {
        fg = colors.vcs_modified,
      },
    },
    remove = {
      provider = "git_diff_removed",
      hl = {
        fg = colors.vcs_removed,
      },
    },
  },
}

local properties = {
  force_inactive = {
    filetypes = {
      "NvimTree",
      "dbui",
      "packer",
      "startify",
      "fugitive",
      "fugitiveblame",
    },
    buftypes = { "terminal" },
    bufnames = {},
  },
}

local components = {
  active = {},
  inactive = {},
}

table.insert(components.active, {})
table.insert(components.active, {})
table.insert(components.active, {})

table.insert(components.inactive, {})
table.insert(components.inactive, {})

-- left
table.insert(components.active[1], comps.vi_mode)
table.insert(components.active[1], comps.file.info)
table.insert(components.active[1], comps.lsp.name)
table.insert(components.active[1], comps.navic)
table.insert(components.inactive[1], comps.vi_mode)
table.insert(components.inactive[1], comps.file.info)

-- mid
table.insert(components.active[2], comps.diagnos.err)
table.insert(components.active[2], comps.diagnos.warn)
table.insert(components.active[2], comps.diagnos.hint)
table.insert(components.active[2], comps.diagnos.info)

-- right
table.insert(components.active[3], comps.git.add)
table.insert(components.active[3], comps.git.change)
table.insert(components.active[3], comps.git.remove)
table.insert(components.active[3], comps.git.branch)
table.insert(components.active[3], comps.file.os)
table.insert(components.active[3], comps.position)
table.insert(components.active[3], comps.line_percentage)

require("feline").setup({
  default_bg = colors.bg,
  default_fg = colors.fg,
  components = components,
  properties = properties,
  vi_mode_colors = vi_mode_colors,
})
