local cmd = vim.cmd
local g = vim.g
local keymap = vim.keymap
local opt = vim.opt

-- general --------------------------------------------------------------------
---- sets how many lines of history vim has to remember
opt.history = 500

---- enable filetype plugins
cmd("filetype plugin on")
cmd("filetype indent on")

---- set to auto read when a file is changed from the outside
opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  command = "checktime",
})

---- with a map leader it's possible to do extra key combinations
---- like <leader>w saves the current file
g.mapleader = ","

---- fast saving
keymap.set("n", "<leader>w", ":w!<cr>")

---- disable unused providers
g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_python_provider = 0
g.loaded_ruby_provider = 0

-- ui -------------------------------------------------------------------------
---- enable the sign column
vim.wo.signcolumn = "yes"

---- incremental live completion
opt.inccommand = "nosplit"

---- enable line numbers
opt.number = true

---- highlight the cursor's line
opt.cursorline = true

---- set 7 lines to the cursor - when moving vertically using j/k
opt.so = 7

---- turn on the wild menu
opt.wildmenu = true

---- ignore compiled/garbage files
opt.wildignore = "*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store"

---- always show current position
opt.ruler = true

---- height of the command bar
opt.cmdheight = 2

---- a buffer becomes hidden when it is abandoned
opt.hidden = true

---- configure backspace so it acts as it should act
-- opt.backspace = "eol,start,indent"
-- opt.whichwrap += "<,>,h,l"

---- ignore case when searching
opt.ignorecase = true

---- when searching try to be smart about cases
opt.smartcase = true

---- highlight search results
opt.hlsearch = true

---- makes search act like search in modern browsers
opt.incsearch = true

---- don't redraw while executing macros (good performance config)
-- opt.lazyredraw = true

---- for regular expressions turn magic on
opt.magic = true

---- show matching brackets when text indicator is over them
opt.showmatch = true
---- how many tenths of a second to blink when matching brackets
opt.mat = 2

---- no annoying sound on errors
opt.errorbells = false
opt.visualbell = false
opt.tm = 500

---- add a bit extra margin to the left
opt.foldcolumn = "1"

---- stabilize window open/close events
opt.splitkeep = "screen"

-- colors and fonts -----------------------------------------------------------
---- Enable 24-bit colors
opt.termguicolors = true

---- Set utf8 as standard encoding and en_US as the standard language
opt.encoding = "utf8"

---- Use Unix as the standard file type
opt.ffs = "unix,dos,mac"

-- files, backups, and undo ---------------------------------------------------
---- Turn backup off, since most stuff is in SVN, git etc. anyway...
opt.updatetime = 250
opt.backup = false
opt.wb = false
opt.swapfile = false
cmd("try | set undodir=~/.cache/nvim | set undofile | catch | endtry")

-- text, tab, and indent related ----------------------------------------------
---- Use spaces instead of tabs
opt.expandtab = true

---- Be smart when using tabs ;)
opt.smarttab = true

---- 1 tab == 4 spaces
opt.shiftwidth = 4
opt.tabstop = 4

---- Linebreak on 80 characters
opt.lbr = true
opt.tw = 80

---- auto-indent
opt.ai = true
---- smart-indent
opt.si = true

-- clipboard related ----------------------------------------------------------
---- Map ,y/p to yank/paste to/from system clipboard
keymap.set("", "<leader>y", '"+y')
keymap.set("", "<leader>p", '"+p')

-- moving around, tabs, windows and buffers -----------------------------------
---- Disable highlight when <leader><cr> is pressed
keymap.set("", "<leader><cr>", ":nohl<cr>", { silent = true })

---- Smart way to move between windows
keymap.set("", "<C-j>", "<C-W>j")
keymap.set("", "<C-k>", "<C-W>k")
keymap.set("", "<C-h>", "<C-W>h")
keymap.set("", "<C-l>", "<C-W>l")

---- Close the current buffer
keymap.set("n", "<leader>bd", ":bdelete<cr>")

---- Close all the buffers
keymap.set("n", "<leader>ba", ":bufdo bd<cr>")

keymap.set("n", "<leader>l", ":bnext<cr>")
keymap.set("n", "<leader>h", ":bprevious<cr>")

---- Useful mappings for managing tabs
keymap.set("n", "<leader>tn", ":tabnew<cr>")
keymap.set("n", "<leader>to", ":tabonly<cr>")
keymap.set("n", "<leader>tc", ":tabclose<cr>")
keymap.set("n", "<leader>tm", ":tabmove")
keymap.set("n", "<leader>t<leader>", ":tabnext")

---- Let 'tl' toggle between this and the last accessed tab
g.lasttab = 1
keymap.set("n", "<Leader>tl", ':exe "tabn ".g:lasttab<CR>')
vim.api.nvim_create_autocmd("TabLeave", {
  callback = function()
    vim.g.lasttab = vim.fn.tabpagenr()
  end,
})

---- Opens a new tab with the current buffer's path
---- Super useful when editing files in the same directory
keymap.set("", "<leader>te", ':tabedit <C-r>=expand("%:p:h")<cr>/')

---- Switch CWD to the directory of the open buffer
keymap.set("", "<leader>cd", ":cd %:p:h<cr>:pwd<cr>")

---- Specify the behavior when switching between buffers
opt.switchbuf = "useopen,usetab,newtab"
opt.stal = 2

---- Return to last edit position when opening files (You want this!)
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- status line ----------------------------------------------------------------
---- Always show the status line
opt.laststatus = 2

---- Format the status line
opt.statusline = [[ %F%m%r%h %w  CWD: %r%{getcwd()}%h   Line: %l  Column: %c]]

-- editing mappings -----------------------------------------------------------
---- Remap VIM 0 to first non-blank character
keymap.set("", "0", "^")

---- Move a line of text using ALT+[jk] or Command+[jk] on mac
keymap.set("n", "<M-j>", "mz:m+<cr>`z")
keymap.set("n", "<M-k>", "mz:m-2<cr>`z")
keymap.set("v", "<M-j>", ":m'>+<cr>`<my`>mzgv`yo`z")
keymap.set("v", "<M-k>", ":m'<-2<cr>`>my`<mzgv`yo`z")

-- spell checking--------------------------------------------------------------
---- Pressing ,ss will toggle and untoggle spell checking
keymap.set("", "<leader>ss", ":setlocal spell!<cr>")

---- Shortcuts using <leader>
keymap.set("", "<leader>sn", "]s")
keymap.set("", "<leader>sp", "[s")
keymap.set("", "<leader>sa", "zg")
keymap.set("", "<leader>s?", "z=")

-- misc -----------------------------------------------------------------------
---- Remove the Windows ^M - when the encodings gets messed up
keymap.set("", "<Leader>m", "mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm")

---- Toggle paste mode on and off
keymap.set("n", "<leader>pp", ":setlocal paste!<cr>")
