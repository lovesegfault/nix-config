{ config, pkgs, ... }: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      coc-nvim
      vim-plug
      ale
      ayu-vim
      fzf-vim
      gentoo-syntax
      gist-vim
      tagbar
      goyo
      lalrpop-vim
      lightline-ale
      lightline-vim
      meson
      rainbow
      rust-vim
      vim-flatbuffers
      vim-indent-guides
      vim-multiple-cursors
      vim-nftables
      vim-nix
      vim-protobuf
      vim-surround
      vim-toml
      vim-trailing-whitespace
      vimtex
      webapi-vim
    ];
    extraConfig = ''
      " ---- CoC
      " Some servers have issues with backup files, see #649
      set nobackup
      set nowritebackup

      " Better display for messages
      set cmdheight=2

      " You will have bad experience for diagnostic messages when it's default 4000.
      set updatetime=300

      " don't give |ins-completion-menu| messages.
      set shortmess+=c

      " always show signcolumns
      set signcolumn=yes

      " Use tab for trigger completion with characters ahead and navigate.
      " Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
      inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ coc#refresh()
      inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

      function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
      endfunction

      " Use <c-space> to trigger completion.
      inoremap <silent><expr> <c-space> coc#refresh()

      " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
      " Coc only does snippet and additional edit on confirm.
      inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
      " Or use `complete_info` if your vim support it, like:
      " inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

      " Use `[g` and `]g` to navigate diagnostics
      nmap <silent> [g <Plug>(coc-diagnostic-prev)
      nmap <silent> ]g <Plug>(coc-diagnostic-next)

      " Remap keys for gotos
      nmap <silent> gd <Plug>(coc-definition)
      nmap <silent> gy <Plug>(coc-type-definition)
      nmap <silent> gi <Plug>(coc-implementation)
      nmap <silent> gr <Plug>(coc-references)

      " Use K to show documentation in preview window
      nnoremap <silent> K :call <SID>show_documentation()<CR>

      function! s:show_documentation()
        if (index(['vim','help'], &filetype) >= 0)
          execute 'h '.expand('<cword>')
        else
          call CocAction('doHover')
        endif
      endfunction

      " Highlight symbol under cursor on CursorHold
      autocmd CursorHold * silent call CocActionAsync('highlight')

      " Remap for rename current word
      nmap <leader>rn <Plug>(coc-rename)

      " Remap for format selected region
      xmap <leader>f  <Plug>(coc-format-selected)
      nmap <leader>f  <Plug>(coc-format-selected)

      augroup mygroup
        autocmd!
        " Setup formatexpr specified filetype(s).
        autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
        " Update signature help on jump placeholder
        autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
      augroup end

      " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
      xmap <leader>a  <Plug>(coc-codeaction-selected)
      nmap <leader>a  <Plug>(coc-codeaction-selected)

      " Remap for do codeAction of current line
      nmap <leader>ac  <Plug>(coc-codeaction)
      " Fix autofix problem of current line
      nmap <leader>qf  <Plug>(coc-fix-current)

      " Create mappings for function text object, requires document symbols feature of languageserver.
      xmap if <Plug>(coc-funcobj-i)
      xmap af <Plug>(coc-funcobj-a)
      omap if <Plug>(coc-funcobj-i)
      omap af <Plug>(coc-funcobj-a)

      " Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
      nmap <silent> <C-d> <Plug>(coc-range-select)
      xmap <silent> <C-d> <Plug>(coc-range-select)

      " Use `:Format` to format current buffer
      command! -nargs=0 Format :call CocAction('format')

      " Use `:Fold` to fold current buffer
      command! -nargs=? Fold :call     CocAction('fold', <f-args>)

      " use `:OR` for organize import of current buffer
      command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

      " Add status line support, for integration with other plugin, checkout `:h coc-status`
      set statusline^=%{coc#status()}%{get(b:,'coc_current_function',''')}

      " Using CocList
      " Show all diagnostics
      nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
      " Manage extensions
      nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
      " Show commands
      nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
      " Find symbol of current document
      nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
      " Search workspace symbols
      nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
      " Do default action for next item.
      nnoremap <silent> <space>j  :<C-u>CocNext<CR>
      " Do default action for previous item.
      nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
      " Resume latest coc list
      nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

      " ----------------------------------------------------------------------

      " ---- Line numbers
      set number
      set cursorline
      " ---- Hide files in the background instad of closing them
      set hidden
      " ---- Undo limit
      set history=1000
      " ---- Automatically re-read files if unmodified inside vim
      set autoread
      " ---- Leader
      let mapleader = ","
      let g:mapleader = ","
      nmap <leader>w :w!<cr>
      " ---- :W sudo-save file
      command W w !sudo tee % > /dev/null
      " ---- Filetype specific plugins and indentation rules
      filetype plugin on
      filetype indent on
      " ---- Cursor lines
      set so=10
      " ---- Show cursor position
      set ruler
      " ---- Allow backspacing over indentation, line breaks, and insertion start
      set backspace=eol,start,indent
      " ---- Automatically wrap left and right
      set whichwrap+=<,>,h,l,[,]
      " ---- Ignore case when searching
      set ignorecase
      " ---- Make search case-sensitive when using uppercase letters
      set smartcase
      " ---- Search highlighting
      set hlsearch
      " ---- Incremental searches: show partial results
      set incsearch
      " ---- Turn off search highlighting
      nnoremap <leader><space> :nohlsearch<CR>
      " ---- Don't update screen during macro/script execution
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
      let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
      let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
      set termguicolors
      " ---- UTF-8
      set encoding=utf8
      " ---- Unix filetypes
      set ffs=unix,dos,mac
      " ---- Spaces, never tabs
      set expandtab
      set smarttab
      set shiftwidth=4
      set tabstop=4
      " ---- Linebreak at 80 chars
      set lbr
      set tw=80
      " ---- Automatic indentation
      set ai " Auto indent
      set si " Smart indent
      set wrap " Wrap lines
      " ---- When in visual mode, * or # searches
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
      map <leader>y "+y
      map <leader>p "+p
      noremap <leader>f :ALEFix <CR>
      " ---- Undo settings
      try
          set undodir=~/.cache/nvim/undodir
          set undofile
      catch
      endtry
      " ---- Set cursor to bar in tmux
      if exists('$TMUX')
          let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
          let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
      else
          let &t_SI = "\<Esc>]50;CursorShape=1\x7"
          let &t_EI = "\<Esc>]50;CursorShape=0\x7"
      endif
      " Plugin settings
      " ---- luochen1990/rainbow
      let g:rainbow_active = 1
      " ---- lotabout/skim.vim
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
      " ---- lervag/vimtex
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
      let g:vimtex_compiler_progname = 'nvr'
      let g:vimtex_view_general_viewer = 'evince'
      " ---- nathanaelkane/vim-indent-guides
      let g:indent_guides_enable_on_vim_startup = 1
      " ---- ayu-theme/ayu-vim
      let g:ayucolor="dark"
      colorscheme ayu
      " ---- majutsushi/tagbar
      noremap <leader>t :TagbarToggle<CR>
      " ---- wellle/tmux-complete.vim
      let g:tmuxcomplete#trigger = '''
      " ---- dense-analysis/ale
      let g:ale_fix_on_save = 1
      nmap <silent> <C-j> <Plug>(ale_next_wrap)
      let g:ale_linters = {
          \ 'c':['clangd', 'cppcheck', 'flawfinder'],
          \ 'cpp':['clangd', 'cppcheck', 'flawfinder'],
          \ 'ebuild':['shellcheck'],
          \ 'python': ['bandit', 'pylama', 'vulture'],
          \ 'rust': ['cargo', 'rls'],
          \ 'text':['proselint', 'languagetool'],
      \ }
      let g:ale_fixers = {
          \ 'c':['remove_trailing_lines', 'trim_whitespace', 'clang-format'],
          \ 'cpp':['remove_trailing_lines', 'trim_whitespace', 'clang-format'],
          \ 'ebuild':['remove_trailing_lines', 'trim_whitespace'],
          \ 'fish':['remove_trailing_lines', 'trim_whitespace'],
          \ 'gentoo-metadata':['remove_trailing_lines', 'trim_whitespace'],
          \ 'i3':['remove_trailing_lines', 'trim_whitespace'],
          \ 'json':['remove_trailing_lines', 'trim_whitespace', 'prettier', 'fixjson'],
          \ 'markdown':['remove_trailing_lines', 'trim_whitespace', 'prettier'],
          \ 'nix':['remove_trailing_lines', 'trim_whitespace'],
          \ 'python':['remove_trailing_lines', 'trim_whitespace', 'isort', 'autopep8'],
          \ 'rust':['remove_trailing_lines', 'trim_whitespace','rustfmt'],
          \ 'sh':['shfmt','remove_trailing_lines','trim_whitespace'],
          \ 'toml':['remove_trailing_lines', 'trim_whitespace'],
          \ 'vim':['remove_trailing_lines', 'trim_whitespace'],
          \ 'xml':['remove_trailing_lines', 'trim_whitespace'],
      \ }
      " ---- itchyny/lightline.vim
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
  };
}
