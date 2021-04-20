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
    neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        # Completion/IDE
        coc-diagnostic
        coc-json
        coc-nvim
        coc-rust-analyzer
        coc-tabnine
        coc-texlab

        # Colorscheme
        ayu-vim

        # Tools
        editorconfig-vim # EditorConfig support
        fugitive # Git
        fzf-vim # Search
        goyo # Distraction-free writing
        lightline-vim # Statusbar
        tagbar # Code navigation
        vim-better-whitespace # Highlight trailing whitespaces
        vim-gist # Gist integration
        vim-indent-guides # Indentation highlighting
        vim-multiple-cursors # Sublime-like multipel cursors
        vim-surround
        webapi-vim # Gist dependency

        # Syntax
        gentoo-syntax # Ebuild and metadata syntax
        lalrpop-vim # LALRPOP syntax
        polyglot # Shitload of syntaxes
        rust-vim # Rust 2018 syntax
        vim-nix # Nix syntax highlighting
      ];
      withRuby = false;
      extraPackages = with pkgs; [ nodejs ];
      extraConfig =
        let
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
            set cmdheight=2

            " A buffer becomes hidden when it is abandoned
            set hidden

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
          ayuConfig = ''
            """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
            " => ayu-vim
            """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
            let g:ayucolor="dark"
            colorscheme ayu
          '';
          cocConfig = ''
            """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
            " => CoC
            """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
            " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
            " delays and poor user experience.
            set updatetime=300

            " Don't pass messages to |ins-completion-menu|.
            set shortmess+=c

            " Always show the signcolumn, otherwise it would shift the text each time
            " diagnostics appear/become resolved.
            if has("patch-8.1.1564")
              " Recently vim can merge signcolumn and number column into one
              set signcolumn=number
            else
              set signcolumn=yes
            endif

            " Use tab for trigger completion with characters ahead and navigate.
            " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
            " other plugin before putting this into your config.
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
            if has('nvim')
              inoremap <silent><expr> <c-space> coc#refresh()
            else
              inoremap <silent><expr> <c-@> coc#refresh()
            endif

            " Make <CR> auto-select the first completion item and notify coc.nvim to
            " format on enter, <cr> could be remapped by other vim plugin
            inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                                          \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

            " Use `[g` and `]g` to navigate diagnostics
            " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
            nmap <silent> [g <Plug>(coc-diagnostic-prev)
            nmap <silent> ]g <Plug>(coc-diagnostic-next)

            " GoTo code navigation.
            nmap <silent> gd <Plug>(coc-definition)
            nmap <silent> gy <Plug>(coc-type-definition)
            nmap <silent> gi <Plug>(coc-implementation)
            nmap <silent> gr <Plug>(coc-references)

            " Use K to show documentation in preview window.
            nnoremap <silent> K :call <SID>show_documentation()<CR>

            function! s:show_documentation()
              if (index(['vim','help'], &filetype) >= 0)
                execute 'h '.expand('<cword>')
              elseif (coc#rpc#ready())
                call CocActionAsync('doHover')
              else
                execute '!' . &keywordprg . " " . expand('<cword>')
              endif
            endfunction

            " Highlight the symbol and its references when holding the cursor.
            autocmd CursorHold * silent call CocActionAsync('highlight')

            " Symbol renaming.
            nmap <leader>rn <Plug>(coc-rename)

            " Formatting selected code.
            xmap <leader>f  <Plug>(coc-format-selected)
            nmap <leader>f  <Plug>(coc-format-selected)

            augroup mygroup
              autocmd!
              " Setup formatexpr specified filetype(s).
              autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
              " Update signature help on jump placeholder.
              autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
            augroup end

            " Applying codeAction to the selected region.
            " Example: `<leader>aap` for current paragraph
            xmap <leader>a  <Plug>(coc-codeaction-selected)
            nmap <leader>a  <Plug>(coc-codeaction-selected)

            " Remap keys for applying codeAction to the current buffer.
            nmap <leader>ac  <Plug>(coc-codeaction)
            " Apply AutoFix to problem on the current line.
            nmap <leader>qf  <Plug>(coc-fix-current)

            " Map function and class text objects
            " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
            xmap if <Plug>(coc-funcobj-i)
            omap if <Plug>(coc-funcobj-i)
            xmap af <Plug>(coc-funcobj-a)
            omap af <Plug>(coc-funcobj-a)
            xmap ic <Plug>(coc-classobj-i)
            omap ic <Plug>(coc-classobj-i)
            xmap ac <Plug>(coc-classobj-a)
            omap ac <Plug>(coc-classobj-a)

            " Remap <C-f> and <C-b> for scroll float windows/popups.
            if has('nvim-0.4.0') || has('patch-8.2.0750')
              nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
              nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
              inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
              inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
              vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
              vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
            endif

            " Use CTRL-S for selections ranges.
            " Requires 'textDocument/selectionRange' support of language server.
            nmap <silent> <C-s> <Plug>(coc-range-select)
            xmap <silent> <C-s> <Plug>(coc-range-select)

            " Add `:Format` command to format current buffer.
            command! -nargs=0 Format :call CocAction('format')

            " Add `:Fold` command to fold current buffer.
            command! -nargs=? Fold :call     CocAction('fold', <f-args>)

            " Add `:OR` command for organize imports of the current buffer.
            command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

            " Add (Neo)Vim's native statusline support.
            " NOTE: Please see `:h coc-status` for integrations with external plugins that
            " provide custom statusline: lightline.vim, vim-airline.
            set statusline^=%{coc#status()}%{get(b:,'coc_current_function',''')}

            " Mappings for CoCList
            " Show all diagnostics.
            nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
            " Manage extensions.
            nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
            " Show commands.
            nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
            " Find symbol of current document.
            nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
            " Search workspace symbols.
            nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
            " Do default action for next item.
            nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
            " Do default action for previous item.
            nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
            " Resume latest coc list.
            nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
          '';
          editorConfigConfig = ''
            """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
            " => editorconfig
            """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
            let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
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
          lightlineConfig = ''
            """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
            " => lightline
            """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
            let g:lightline = {
                \ 'colorscheme': 'ayu',
                \ 'active': {
                \   'left': [
                \     [ 'mode', 'paste' ],
                \     [ 'cocstatus', 'readonly', 'filename', 'modified' ]
                \   ],
                \   'right': [
                \     [ 'lineinfo' ],
                \     [ 'percent' ],
                \     [ 'fileformat', 'fileencoding', 'filetype' ]
                \   ]
                \ },
                \ 'component_function': {
                \   'cocstatus': 'coc#status'
                \ }
            \ }
            " Use auocmd to force lightline update.
            autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
          '';
          tagbarConfig = ''
            """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
            " => tagbar
            """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
            noremap <leader>t :TagbarToggle<CR>
          '';
        in
        ''
          ${baseConfig}

          ${ayuConfig}
          ${cocConfig}
          ${editorConfigConfig}
          ${fzfConfig}
          ${indentGuidesConfig}
          ${lightlineConfig}
          ${tagbarConfig}
        '';
    };
  };

  xdg.configFile."nvim/coc-settings.json".text = ''
    {
      "rust-analyzer.server.path": "rust-analyzer",
      "diagnostic-languageserver.filetypes": {
        "markdown": "mdl",
        "sh": "shellcheck"
      },
      "diagnostic-languageserver.formatFiletypes": {
        "sh": "shfmt"
      },
      "coc.preferences.formatOnSaveFiletypes": ["rust"],
      "texlab.path": "texlab",
      "languageserver": {
        "ccls": {
          "command": "ccls",
          "filetypes": ["c", "cc", "cpp", "c++", "objc", "objcpp"],
          "rootPatterns": [".ccls", "compile_commands.json", ".git/", ".hg/"],
          "initializationOptions": {
              "cache": {
                "directory": "/tmp/ccls"
              }
            }
        }
      },
      "latex.build.onSave": true,
      "latex.lint.onSave": true,
      "latex.forwardSearch.executable": "evince"
    }
  '';
}
