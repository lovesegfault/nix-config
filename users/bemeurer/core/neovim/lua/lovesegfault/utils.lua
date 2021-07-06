-- Setup Environment -------------------------------------------------------------------------------
local vim = vim

-- Clear environment
local _ENV = {} -- luacheck: ignore

-- Init module
local M = {}

function M.map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

return M
