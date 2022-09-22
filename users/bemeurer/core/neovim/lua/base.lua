local utils = require("utils")
local map = utils.map

-- local fn = vim.fn
local cmd = vim.cmd
local g = vim.g
local opt = vim.opt
local wo = vim.wo

-- general --------------------------------------------------------------------
---- sets how many lines of history vim has to remember
opt.history = 500

---- enable filetype plugins
cmd("filetype plugin on")
cmd("filetype indent on")

---- set to auto read when a file is changed from the outside
opt.autoread = true
cmd("au FocusGained,BufEnter * checktime")

---- with a map leader it's possible to do extra key combinations
---- like <leader>w saves the current file
g.mapleader = ","

---- fast saving
map("n", "<leader>w", ":w!<cr>")

---- :W sudo saves the file
---- (useful for handling the permission-denied error)
cmd("command! W execute 'w !sudo tee % > /dev/null' <bar> edit!")

---- disable unused providers
g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_python_provider = 0
g.loaded_ruby_provider = 0

-- ui -------------------------------------------------------------------------
---- enable the sign column
wo.signcolumn = "yes"

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

-- colors and fonts -----------------------------------------------------------
---- Enable syntax highlighting
cmd("syntax enable")

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
map("", "<leader>y", '"+y')
map("", "<leader>p", '"+p')

-- moving around, tabs, windows and buffers -----------------------------------
---- Disable highlight when <leader><cr> is pressed
map("", "<leader><cr>", ":nohl<cr>", { silent = true })

---- Smart way to move between windows
map("", "<C-j>", "<C-W>j")
map("", "<C-k>", "<C-W>k")
map("", "<C-h>", "<C-W>h")
map("", "<C-l>", "<C-W>l")

---- Close the current buffer
require("bufdel")
map("", "<leader>bd", ":BufDel<cr>")

---- Close all the buffers
map("", "<leader>ba", ":bufdo bd<cr>")

map("", "<leader>l", ":bnext<cr>")
map("", "<leader>h", ":bprevious<cr>")

---- Useful mappings for managing tabs
map("", "<leader>tn", ":tabnew<cr>")
map("", "<leader>to", ":tabonly<cr>")
map("", "<leader>tc", ":tabclose<cr>")
map("", "<leader>tm", ":tabmove")
map("", "<leader>t<leader>", ":tabnext")

---- Let 'tl' toggle between this and the last accessed tab
g.lasttab = 1
map("n", "<Leader>tl", ':exe "tabn ".g:lasttab<CR>')
cmd("au TabLeave * let g:lasttab = tabpagenr()")

---- Opens a new tab with the current buffer's path
---- Super useful when editing files in the same directory
map("", "<leader>te", ':tabedit <C-r>=expand("%:p:h")<cr>/')

---- Switch CWD to the directory of the open buffer
map("", "<leader>cd", ":cd %:p:h<cr>:pwd<cr>")

---- Specify the behavior when switching between buffers
opt.switchbuf = "useopen,usetab,newtab"
opt.stal = 2

---- Return to last edit position when opening files (You want this!)
cmd([[au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]])

-- status line ----------------------------------------------------------------
---- Always show the status line
opt.laststatus = 2

---- Format the status line
opt.statusline = [[ %F%m%r%h %w  CWD: %r%{getcwd()}%h   Line: %l  Column: %c]]

-- editing mappings -----------------------------------------------------------
---- Remap VIM 0 to first non-blank character
map("", "0", "^")

---- Move a line of text using ALT+[jk] or Command+[jk] on mac
map("n", "<M-j>", "mz:m+<cr>`z")
map("n", "<M-k>", "mz:m-2<cr>`z")
map("v", "<M-j>", ":m'>+<cr>`<my`>mzgv`yo`z")
map("v", "<M-k>", ":m'<-2<cr>`>my`<mzgv`yo`z")

-- spell checking--------------------------------------------------------------
---- Pressing ,ss will toggle and untoggle spell checking
map("", "<leader>ss", ":setlocal spell!<cr>")

---- Shortcuts using <leader>
map("", "<leader>sn", "]s")
map("", "<leader>sp", "[s")
map("", "<leader>sa", "zg")
map("", "<leader>s?", "z=")

-- misc -----------------------------------------------------------------------
---- Remove the Windows ^M - when the encodings gets messed up
map("", "<Leader>m", "mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm")

---- Toggle paste mode on and off
map("", "<leader>pp", ":setlocal paste!<cr>")
