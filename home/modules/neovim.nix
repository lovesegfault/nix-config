{ pkgs, ... }: {
  home = {
    packages = with pkgs; [ nodejs yarn ];
    sessionVariables = rec {
      EDITOR = "nvim";
      VISUAL = EDITOR;
    };
  };

  programs.git.extraConfig = rec {
    core.editor = "nvim";
    merge.tool = "nvimdiff";
    "mergetool \"nvimdiff\"" = { cmd = "${core.editor} -d $LOCAL $REMOTE"; };
    diff.tool = "nvimdiff";
  };

  programs.zsh.shellAliases = { v = "nvim"; };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      ale
      ayu-vim
      coc-nvim
      fugitive
      fzf-vim
      gentoo-syntax
      gist-vim
      goyo
      lalrpop-vim
      lightline-ale
      lightline-vim
      meson
      rust-vim
      tagbar
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
    extraConfig = let
    cocConfig = ''
      """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      " => CoC
      """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      " if hidden is not set, TextEdit might fail.
      set hidden

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

      " Use <TAB> for select selections ranges, needs server support, like: coc-tsserver, coc-python
      nmap <silent> <TAB> <Plug>(coc-range-select)
      xmap <silent> <TAB> <Plug>(coc-range-select)

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

    '';
    basic = ''
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
      " Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
      map <space> /
      map <C-space> ?

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

    in ''
      ${basic}
      ${cocConfig}
      " ---- Shortcuts using <leader>
      noremap <leader>f :ALEFix <CR>

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
          \ 'text':['mdl', 'proselint', 'languagetool'],
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
