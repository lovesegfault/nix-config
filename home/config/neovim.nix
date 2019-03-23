{ config, pkgs, ... }:

{
  programs.neovim = if config.isArm then {
    enable = false;
  } else {
    enable = true;
    configure = {
      customRC = ''
        " ---- Line numbers
        set number
        set cursorline
        " ---- Hide files in the background instead of closing them.
        set hidden
        " ---- Undo limit
        set history=1000
        " ---- Automatically re-read files if unmodified inside Vim.
        set autoread
        " --- Leader
        let mapleader = ","
        let g:mapleader = ","
        nmap <leader>w :w!<cr>
        " ---- :W sudo saves file
        command W w !sudo tee % > /dev/null
        " ---- Filetype specific plugins and indentation rules
        filetype plugin on
        filetype indent on
        " ---- Cursor lines
        set so=10
        " ---- Show cursor position
        set ruler
        " ---- Allow backspacing over indention, line breaks and insertion start
        set backspace=eol,start,indent
        " ---- Automatically wrap left and right
        set whichwrap+=<,>,h,l,[,]
        " ---- Ignore case when searching
        set ignorecase
        " ---- Make search case-sensitive when using uppercase letters
        set smartcase
        " ---- Search highlighting
        set hlsearch
        " ---- Incremental searches, show partial results
        set incsearch
        " ---- Don't update screen during macro/script execution, for performance
        set lazyredraw
        " ---- Enable magic macros
        set magic
        " ---- Show matching brackets
        set showmatch
        " ---- No bells on errors
        set noerrorbells
        set novisualbell
        " ---- Syntax highlighting
        syntax enable
        " ---- True colors
        " set termguicolors
        " ---- UTF8
        set encoding=utf8
        " ---- UNIX filetypes
        set ffs=unix,dos,mac
        " ---- Use spaces, not tabs
        set expandtab
        set smarttab
        set shiftwidth=4
        set tabstop=4
        " ---- Linebreak on 80 characters
        set lbr
        set tw=80
        " ---- Automatic indentation
        set ai "Auto indent
        set si "Smart indent
        set wrap "Wrap lines
        " ---- When in visual, pressing * or # searches
        vnoremap <silent> * :<C-u>call VisualSelection(''', ''')<CR>/<C-R>=@/<CR><CR>
        vnoremap <silent> # :<C-u>call VisualSelection(''', ''')<CR>/<C-R>=@/<CR><CR>
        " ---- Moving between windows
        map <C-j> <C-W>j
        map <C-k> <C-W>k
        map <C-h> <C-W>h
        map <C-l> <C-W>l
        " ---- Close the current buffer
        map <leader>bd :bd<cr>:tabclose<cr>gT
        " ---- Close all buffers
        map <leader>ba :bufdo bd<cr>
        " ---- Next/Previous buffer
        map <leader>l :bnext<cr>
        map <leader>h :bprevious<cr>
        " ---- Managing tabs
        map <leader>tn :tabnew<cr>
        map <leader>to :tabonly<cr>
        map <leader>tc :tabclose<cr>
        map <leader>t<leader> :tabnext<cr>
        " ---- tl toggles tabs alt-tab style
        let g:lasttab = 1
        nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
        au TabLeave * let g:lasttab = tabpagenr()
        " ---- Opens a new tab with the current buffer's path
        " -- Super useful when editing files in the same directory
        map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/
        " ---- Switch CWD to the directory of the open buffer
        map <leader>cd :cd %:p:h<cr>:pwd<cr>
        " ---- Specify the behavior when switching between buffers
        try
            set switchbuf=useopen,usetab,newtab
            set stal=2
        catch
        endtry
        " ---- Return to last edit position when opening files (You want this!)
        au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
        " ---- Pressing ,ss will toggle and untoggle spell checking
        map <leader>ss :setlocal spell!<cr>
        " ---- Shortcuts using <leader>
        map <leader>sn ]s
        map <leader>sp [s
        map <leader>sa zg
        map <leader>s? z=
        noremap <leader>f :RustFmt <CR>
        xnoremap π "_dP
        try
            set undodir=~/${config.xdg.cacheHome}/neovim/undodir
            set undofile
        catch
        endtry
        " Plugin settings -------------------------------------------------------------
        " ---- LSP server commands
        let g:LanguageClient_serverCommands = {
                    \ 'c': ['clangd'],
                    \ 'cpp': ['clangd'],
                    \ 'python': ['pyls'],
                    \ 'rust': ['rls'],
                    \ }
        nnoremap <F5> :call LanguageClient_contextMenu()<CR>
        nnoremap <silent> gh :call LanguageClient_textDocument_hover()<CR>
        nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
        nnoremap <silent> gr :call LanguageClient_textDocument_references()<CR>
        nnoremap <silent> gs :call LanguageClient_textDocument_documentSymbol()<CR>
        nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
        nnoremap <silent> gf :call LanguageClient_textDocument_formatting()<CR>

        let g:rainbow_active = 1
        " ---- fzf
        let g:fzf_layout = { 'window': '60split enew' }
        let g:fzf_action = {
          \ 'ctrl-t': 'tab split',
          \ 'ctrl-x': 'split',
          \ 'ctrl-v': 'vsplit' }
        autocmd! FileType fzf
        autocmd  FileType fzf set laststatus=0 noshowmode noruler
          \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
        nnoremap <C-b> :Buffers<CR>
        nnoremap <C-p> :Files<CR>
        set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
        command -nargs=+ -complete=file -bar Rg silent! grep! <args>|cwindow|redraw!
        " ---- Deoplete
        let g:deoplete#enable_at_startup = 1

        let g:ale_completion_enabled = 0
        let g:ale_sign_column_always = 1
        let g:ale_rust_cargo_use_check = 1
        let g:ale_rust_cargo_check_tests = 1
        let g:ale_rust_cargo_check_examples = 1

        let g:neosnippet#enable_completed_snippet = 1

        " ---- VimTeX
        let g:vimtex_view_method = 'zathura'
        "let g:vimtex_compiler_progname = 'nvr'

        " ---- Airline
        let g:airline#extensions#tabline#enabled = 1
        let g:airline_powerline_fonts = 1
        let g:airline_highlighting_cache = 1
        let g:airline#extensions#ale#enabled = 1
        let g:airline_theme='cobalt2'

        " ---- Enable indent guides
        let g:indent_guides_enable_on_vim_startup = 1

        " ---- Always open NERD Tree on the left
        let g:NERDTreeWinPos = "left"

        " ---- Make supertab go top->bottom
        let g:SuperTabDefaultCompletionType = "<c-n>"

        " ---- Deoplete fix for vim-multiple-cursors
        func! Multiple_cursors_before()
          if deoplete#is_enabled()
            call deoplete#disable()
            let g:deoplete_is_enable_before_multi_cursors = 1
          else
            let g:deoplete_is_enable_before_multi_cursors = 0
          endif
        endfunc
        func! Multiple_cursors_after()
          if g:deoplete_is_enable_before_multi_cursors
            call deoplete#enable()
          endif
        endfunc
        " ---- Theme
        colorscheme cobalt2
      '';
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          LanguageClient-neovim
          agda-vim
          ale
          deoplete-nvim
          fzf-vim
          fzfWrapper
          gist-vim
          goyo
          idris-vim
          julia-vim
          neosnippet
          neosnippet-snippets
          nerdtree
          rainbow
          rust-vim
          supertab
          tabular
          vim-airline
          vim-airline-themes
          vim-colorschemes
          vim-fugitive
          vim-indent-guides
          vim-json
          vim-markdown
          vim-multiple-cursors
          vim-nix
          vim-surround
          vim-toml
          vim-trailing-whitespace
          vimtex
          webapi-vim
          zig-vim
        ];
        opt = [];
      };
    };
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython = true;
    withPython3 = true;
    withRuby = true;
  };
}
