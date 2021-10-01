-- Setup Environment -------------------------------------------------------------------------------
local vim = vim

-- Clear environment
local _ENV = {} -- luacheck: ignore

-- Init module
local M = {}

function M.map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function M.show_documentation()
  local filetype = vim.bo.filetype
  if vim.tbl_contains({ "vim", "help" }, filetype) then
    vim.cmd("h " .. vim.fn.expand("<cword>"))
  elseif vim.tbl_contains({ "man" }, filetype) then
    vim.cmd("Man " .. vim.fn.expand("<cword>"))
  elseif vim.fn.expand("%:t") == "Cargo.toml" then
    require("crates").show_popup()
  else
    vim.lsp.buf.hover()
  end
end

return M
