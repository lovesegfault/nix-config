{ pkgs, ... }: {

  home = {
    packages = with pkgs; [ neovim-remote ];
    sessionVariables = rec {
      EDITOR = "nvim";
      VISUAL = EDITOR;
    };
  };

  programs = {
    git.extraConfig = {
      core.editor = "nvim";
      merge.tool = "nvimdiff";
      "mergetool \"nvimdiff\"".cmd = "nvim -d $LOCAL $REMOTE";
      diff.tool = "nvimdiff";
    };
    zsh.shellAliases = { vi = "nvim"; vim = "nvim"; };
    neovim =
      let
        loadPlugin = plugin: ''
          set rtp^=${plugin.rtp}
          set rtp+=${plugin.rtp}/after
        '';
        brokenPlugins = with pkgs.vimPlugins; [ deoplete-nvim rust-vim vimtex ];
      in
      {
        enable = true;
        plugins = with pkgs.vimPlugins; [
          # Completion/IDE
          ale # Linting
          # deoplete-nvim # Completion
          LanguageClient-neovim # LSP

          # Colorscheme
          ayu-vim

          # Tools
          echodoc # Print documents in echo area.
          editorconfig-vim # EditorConfig support
          fugitive # Git
          fzf-vim # Search
          goyo # Distraction-free writing
          lightline-ale # Linter integration
          lightline-vim # Statusbar
          tagbar # Code navigation
          vim-gist # Gist integration
          vim-indent-guides # Indentation highlighting
          vim-multiple-cursors # Sublime-like multipel cursors
          vim-surround
          vim-trailing-whitespace # Highlight trailing whitespaces
          # vimtex # LaTeX integration
          webapi-vim # Gist dependency

          # Syntax
          polyglot # Shitload of syntaxes
          gentoo-syntax # Ebuild and metadata syntax
          lalrpop-vim # LALRPOP syntax
          # rust-vim # Rust 2018 syntax
          vim-nix # Nix syntax highlighting
        ];
        extraConfig =
          let
            # FIXME: Workaround for broken handling of packpath by vim8/neovim for ftplugins
            # https://github.com/NixOS/nixpkgs/issues/39364#issuecomment-425536054
            pluginConfig = ''
              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " => Plugins
              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              filetype off | syn off
              ${builtins.concatStringsSep "\n" (map loadPlugin brokenPlugins)}
              filetype indent plugin on | syn on
            '';
            baseConfig = ''
              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " => General
              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " Sets how many lines of history VIM has to remember
              set history=500

              " Enable filetype plugins
              filetype plugin on
              filetype indent on

              " Set to auto read when a file is changed from the outside
              set autoread
              au FocusGained,BufEnter * checktime

              " With a map leader it's possible to do extra key combinations
              " like <leader>w saves the current file
              let mapleader = ","

              " Fast saving
              nmap <leader>w :w!<cr>

              " :W sudo saves the file
              " (useful for handling the permission-denied error)
              command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " => VIM user interface
              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " Enable line numbers
              set number

              " Highlight the cursor's line
              set cursorline

              " Set 7 lines to the cursor - when moving vertically using j/k
              set so=7

              " Avoid garbled characters in Chinese language windows OS
              let $LANG='en'
              set langmenu=en
              source $VIMRUNTIME/delmenu.vim
              source $VIMRUNTIME/menu.vim

              " Turn on the Wild menu
              set wildmenu

              " Ignore compiled files
              set wildignore=*.o,*~,*.pyc
              if has("win16") || has("win32")
                  set wildignore+=.git\*,.hg\*,.svn\*
              else
                  set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
              endif

              " Always show current position
              set ruler

              " Height of the command bar
              set cmdheight=1

              " A buffer becomes hidden when it is abandoned
              set hid

              " Configure backspace so it acts as it should act
              set backspace=eol,start,indent
              set whichwrap+=<,>,h,l

              " Ignore case when searching
              set ignorecase

              " When searching try to be smart about cases
              set smartcase

              " Highlight search results
              set hlsearch

              " Makes search act like search in modern browsers
              set incsearch

              " Don't redraw while executing macros (good performance config)
              set lazyredraw

              " For regular expressions turn magic on
              set magic

              " Show matching brackets when text indicator is over them
              set showmatch
              " How many tenths of a second to blink when matching brackets
              set mat=2

              " No annoying sound on errors
              set noerrorbells
              set novisualbell
              set t_vb=
              set tm=500

              " Properly disable sound on errors on MacVim
              if has("gui_macvim")
                  autocmd GUIEnter * set vb t_vb=
              endif

              " Add a bit extra margin to the left
              set foldcolumn=1

              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " => Colors and Fonts
              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " Enable syntax highlighting
              syntax enable

              " Enable 256 colors palette in Gnome Terminal
              if $COLORTERM == 'gnome-terminal'
                  set t_Co=256
              endif

              " Enable 24-bit colors
              let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
              let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
              set termguicolors

              try
                  colorscheme desert
              catch
              endtry

              set background=dark

              " Set extra options when running in GUI mode
              if has("gui_running")
                  set guioptions-=T
                  set guioptions-=e
                  set t_Co=256
                  set guitablabel=%M\ %t
              endif

              " Set cursor to bar in tmux
              if exists('$TMUX')
                  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
                  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
              else
                  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
                  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
              endif

              " Set utf8 as standard encoding and en_US as the standard language
              set encoding=utf8

              " Use Unix as the standard file type
              set ffs=unix,dos,mac

              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " => Files, backups and undo
              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " Turn backup off, since most stuff is in SVN, git etc. anyway...
              set nobackup
              set nowb
              set noswapfile
              try
                  set undodir=~/.cache/nvim
                  set undofile
              catch
              endtry

              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " => Text, tab and indent related
              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " Use spaces instead of tabs
              set expandtab

              " Be smart when using tabs ;)
              set smarttab

              " 1 tab == 4 spaces
              set shiftwidth=4
              set tabstop=4

              " Linebreak on 80 characters
              set lbr
              set tw=80

              set ai "Auto indent
              set si "Smart indent
              set wrap "Wrap lines

              """"""""""""""""""""""""""""""
              " => Visual mode related
              """"""""""""""""""""""""""""""
              " Visual mode pressing * or # searches for the current selection
              " Super useful! From an idea by Michael Naumann
              vnoremap <silent> * :<C-u>call VisualSelection(''', ''')<CR>/<C-R>=@/<CR><CR>
              vnoremap <silent> # :<C-u>call VisualSelection(''', ''')<CR>?<C-R>=@/<CR><CR>

              """"""""""""""""""""""""""""""
              " => Clipboard related
              """"""""""""""""""""""""""""""
              " Map ,y/p to yank/paste to/from system clipboard
              map <leader>y "+y
              map <leader>p "+p

              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " => Moving around, tabs, windows and buffers
              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " Disable highlight when <leader><cr> is pressed
              map <silent> <leader><cr> :noh<cr>

              " Smart way to move between windows
              map <C-j> <C-W>j
              map <C-k> <C-W>k
              map <C-h> <C-W>h
              map <C-l> <C-W>l

              " Close the current buffer
              map <leader>bd :Bclose<cr>:tabclose<cr>gT

              " Close all the buffers
              map <leader>ba :bufdo bd<cr>

              map <leader>l :bnext<cr>
              map <leader>h :bprevious<cr>

              " Useful mappings for managing tabs
              map <leader>tn :tabnew<cr>
              map <leader>to :tabonly<cr>
              map <leader>tc :tabclose<cr>
              map <leader>tm :tabmove
              map <leader>t<leader> :tabnext

              " Let 'tl' toggle between this and the last accessed tab
              let g:lasttab = 1
              nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
              au TabLeave * let g:lasttab = tabpagenr()


              " Opens a new tab with the current buffer's path
              " Super useful when editing files in the same directory
              map <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/

              " Switch CWD to the directory of the open buffer
              map <leader>cd :cd %:p:h<cr>:pwd<cr>

              " Specify the behavior when switching between buffers
              try
                set switchbuf=useopen,usetab,newtab
                set stal=2
              catch
              endtry

              " Return to last edit position when opening files (You want this!)
              au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

              """"""""""""""""""""""""""""""
              " => Status line
              """"""""""""""""""""""""""""""
              " Always show the status line
              set laststatus=2

              " Format the status line
              set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c

              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " => Editing mappings
              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " Remap VIM 0 to first non-blank character
              map 0 ^

              " Move a line of text using ALT+[jk] or Command+[jk] on mac
              nmap <M-j> mz:m+<cr>`z
              nmap <M-k> mz:m-2<cr>`z
              vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
              vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

              if has("mac") || has("macunix")
                nmap <D-j> <M-j>
                nmap <D-k> <M-k>
                vmap <D-j> <M-j>
                vmap <D-k> <M-k>
              endif

              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " => Spell checking
              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " Pressing ,ss will toggle and untoggle spell checking
              map <leader>ss :setlocal spell!<cr>

              " Shortcuts using <leader>
              map <leader>sn ]s
              map <leader>sp [s
              map <leader>sa zg
              map <leader>s? z=

              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " => Misc
              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " Remove the Windows ^M - when the encodings gets messed up
              noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

              " Quickly open a buffer for scribble
              map <leader>q :e ~/buffer<cr>

              " Quickly open a markdown buffer for scribble
              map <leader>x :e ~/buffer.md<cr>

              " Toggle paste mode on and off
              map <leader>pp :setlocal paste!<cr>

              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " => Helper functions
              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " Returns true if paste mode is enabled
              function! HasPaste()
                  if &paste
                      return 'PASTE MODE  '
                  endif
                  return '''
              endfunction

              " Don't close window, when deleting a buffer
              command! Bclose call <SID>BufcloseCloseIt()
              function! <SID>BufcloseCloseIt()
                  let l:currentBufNum = bufnr("%")
                  let l:alternateBufNum = bufnr("#")

                  if buflisted(l:alternateBufNum)
                      buffer #
                  else
                      bnext
                  endif

                  if bufnr("%") == l:currentBufNum
                      new
                  endif

                  if buflisted(l:currentBufNum)
                      execute("bdelete! ".l:currentBufNum)
                  endif
              endfunction

              function! CmdLine(str)
                  call feedkeys(":" . a:str)
              endfunction

              function! VisualSelection(direction, extra_filter) range
                  let l:saved_reg = @"
                  execute "normal! vgvy"

                  let l:pattern = escape(@", "\\/.*'$^~[]")
                  let l:pattern = substitute(l:pattern, "\n$", "", "")

                  if a:direction == 'gv'
                      call CmdLine("Ack '" . l:pattern . "' " )
                  elseif a:direction == 'replace'
                      call CmdLine("%s" . '/'. l:pattern . '/')
                  endif

                  let @/ = l:pattern
                  let @" = l:saved_reg
              endfunction
            '';
            aleConfig = ''
              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " => ALE
              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " Always apply ALEFix on save
              let g:ale_fix_on_save = 1
              noremap <leader>f :ALEFix <CR>
              nmap <silent> <C-j> <Plug>(ale_next_wrap)
              let g:ale_linters = {
                  \ 'c':['clangd', 'cppcheck', 'flawfinder'],
                  \ 'cpp':['clangd', 'cppcheck', 'flawfinder'],
                  \ 'python': ['bandit', 'pylama', 'vulture'],
                  \ 'text':['mdl', 'proselint', 'languagetool'],
                  \ 'markdown':['mdl', 'proselint', 'languagetool'],
              \ }
              let g:ale_fixers = {
                  \ '*': ['remove_trailing_lines', 'trim_whitespace'],
                  \ 'c':['clang-format'],
                  \ 'cpp':['clang-format'],
                  \ 'json':['fixjson'],
                  \ 'python':['isort', 'autopep8'],
                  \ 'rust':['rustfmt'],
                  \ 'sh':['shfmt'],
              \ }
            '';
            ayuConfig = ''
              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " => ayu-vim
              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              let g:ayucolor="dark"
              colorscheme ayu
            '';
            echodocConfig = ''
              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " => echodot
              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              let g:echodoc#enable_at_startup = 1
              let g:echodoc#type = 'floating'
              " To use a custom highlight for the float window,
              " change Pmenu to your highlight group
              highlight link EchoDocFloat Pmenu
            '';
            editorConfigConfig = ''
              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " => editorconfig
              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
            '';
            deopleteConfig = ''
              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " => deoplete
              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              let g:deoplete#enable_at_startup = 1
              inoremap <silent><expr> <TAB>
                  \ pumvisible() ? "\<C-n>" :
                  \ <SID>check_back_space() ? "\<TAB>" :
                  \ deoplete#manual_complete()

              function! s:check_back_space() abort "{{{
              let col = col('.') - 1
              return !col || getline('.')[col - 1]  =~ '\s'
              endfunction"}}}

              function g:Multiple_cursors_before()
                  call deoplete#custom#buffer_option('auto_complete', v:false)
              endfunction
              function g:Multiple_cursors_after()
                  call deoplete#custom#buffer_option('auto_complete', v:true)
              endfunction

              " Disable the truncate feature.
              call deoplete#custom#source('_', 'max_abbr_width', 20)
              call deoplete#custom#source('_', 'max_menu_width', 80)
            '';
            fzfConfig = ''
              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " => fzf
              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " FZF selection window size
              let g:fzf_layout = { 'window': '60split enew' }
              " Different ways to open a new file/buffer
              let g:fzf_action = {
                  \ 'ctrl-t': 'tab split',
                  \ 'ctrl-x': 'split',
                  \ 'ctrl-v': 'vsplit' }
              autocmd! FileType fzf
              autocmd  FileType fzf set laststatus=0 noshowmode noruler
                  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
              " Map ctrp-p/b to search files/buffers
              nnoremap <C-p> :GitFiles<CR>
              nnoremap <C-b> :Buffers<CR>
              set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
              command -nargs=+ -complete=file -bar Rg silent! grep! <args>|cwindow|redraw!
            '';
            indentGuidesConfig = ''
              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " => vim-indent-guides
              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " Always show indent guides
              let g:indent_guides_enable_on_vim_startup = 1
            '';
            languageClientConfig = ''
              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " => LanguageClient-neovim
              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " Required for operations modifying multiple buffers like rename.
              set hidden

              let g:LanguageClient_serverCommands = {
                  \ 'c': ['ccls'],
                  \ 'cpp': ['ccls'],
                  \ 'haskell': ['ghcide', '--lsp'],
                  \ 'nix': ['rnix-lsp'],
                  \ 'python': ['pyls'],
                  \ 'rust': ['rust-analyzer'],
                  \ 'tex': ['texlab'],
              \ }

              nnoremap <space> :call LanguageClient_contextMenu()<CR>
              nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
              nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
              nnoremap <silent> gi :call LanguageClient#textDocument_implementation()<CR>
              nnoremap <silent> gr :call LanguageClient#textDocument_references()<CR>
              nnoremap <silent> gy :call LanguageClient#textDocument_typeDefinition()<CR>

              " Rename - rn => rename
              noremap <leader>rn :call LanguageClient#textDocument_rename()<CR>

              " Rename - rc => rename camelCase
              noremap <leader>rc :call LanguageClient#textDocument_rename(
                  \ {'newName': Abolish.camelcase(expand('<cword>'))})<CR>

              " Rename - rs => rename snake_case
              noremap <leader>rs :call LanguageClient#textDocument_rename(
                  \ {'newName': Abolish.snakecase(expand('<cword>'))})<CR>

              " Rename - ru => rename UPPERCASE
              noremap <leader>ru :call LanguageClient#textDocument_rename(
                  \ {'newName': Abolish.uppercase(expand('<cword>'))})<CR>
            '';
            lightlineConfig = ''
              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " => lightline
              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              let g:lightline = {
                  \ 'colorscheme': 'ayu',
                  \ 'active': {
                  \   'left': [
                  \       ['mode', 'paste'],
                  \       ['filename', 'modified']
                  \   ],
                  \   'right': [
                  \       ['lineinfo'],
                  \       ['percent'],
                  \       ['fileformat', 'fileencoding', 'filetype', 'readonly'],
                  \       ['linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok']
                  \   ]
                  \ },
                  \ 'component_expand': {
                  \   'linter_checking': 'lightline#ale#checking',
                  \   'linter_warnings': 'lightline#ale#warnings',
                  \   'linter_errors': 'lightline#ale#errors',
                  \   'linter_ok': 'lightline#ale#ok',
                  \ },
                  \ 'component_type': {
                  \   'linter_checking': 'left',
                  \   'linter_warnings': 'warning',
                  \   'linter_errors': 'error',
                  \   'linter_ok': 'left',
                  \ }
              \ }
            '';
            tagbarConfig = ''
              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " => tagbar
              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              noremap <leader>t :TagbarToggle<CR>
            '';
            vimtexConfig = ''
              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " => vimtex
              """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
              " Enable shellescape for the LaTeX compiler
              " NB: needed for syntax highlighting pkgs.
              let g:tex_flavor = 'latex'
              let g:vimtex_compiler_latexmk = {
                  \ 'options' : [
                  \   '-pdf',
                  \   '-shell-escape',
                  \   '-verbose',
                  \   '-file-line-error',
                  \   '-synctex=1',
                  \   '-interaction=nonstopmode',
                  \ ],
              \ }
              if has('nvim')
                let g:vimtex_compiler_progname = 'nvr'
              endif
              let g:vimtex_view_general_viewer = 'evince'
            '';
          in
          ''
            ${pluginConfig}
            ${baseConfig}

            ${aleConfig}
            ${ayuConfig}
            ${deopleteConfig}
            ${echodocConfig}
            ${editorConfigConfig}
            ${fzfConfig}
            ${indentGuidesConfig}
            ${languageClientConfig}
            ${lightlineConfig}
            ${tagbarConfig}
            ${vimtexConfig}
          '';
      };
  };
}
