vim.g.lightline = {
    colorscheme = "ayu",
    enable = {tabline = 0},
    active = {
        left = {{"mode", "paste"}, {"readonly", "filename"}},
        right = {
            {"lineinfo"}, {"percent"},
            {"fileformat", "fileencoding", "filetype"}, {"modified"}
        }
    }
}
