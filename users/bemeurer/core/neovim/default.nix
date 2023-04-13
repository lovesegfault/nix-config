{ lib, pkgs, ... }: {
  home = {
    sessionVariables = rec {
      EDITOR = "nvim";
      VISUAL = EDITOR;
    };
    shellAliases = { vi = "nvim"; vim = "nvim"; };
  };

  programs = {
    git.extraConfig.core.editor = "nvim";

    neovim = {
      enable = true;

      plugins = with pkgs.vimPlugins; [
        # ui
        bufferline-nvim # bufferline
        dashboard-nvim # nice init screen
        gitsigns-nvim # git status sign decorations
        indent-blankline-nvim # indentation guides
        lualine-nvim # statusline
        neovim-ayu # colorscheme
        numb-nvim # peek lines in non-obtrusive way
        nvim-navic # status/bufferline component to show LSP context
        nvim-web-devicons # file icons for trouble-nvim
        todo-comments-nvim # highlight, list and search todo comments
        trouble-nvim # list for showing LSP diagnostics
        true-zen-nvim # distraction-free writing
        which-key-nvim # popups for keybindings for commands

        # lsp
        fidget-nvim # ui for nvim-lsp progress
        lsp_signature-nvim # function signature pop-ups
        nvim-lightbulb # lightbulb sign when LSP actions are available
        nvim-lspconfig # LSP

        # tooling
        bufdelete-nvim # delete buffers without losing window layout
        guess-indent-nvim # automatic indentation style detection
        nvim-surround # add/change/delete surrounding delimiter pairs with ease
        rust-tools-nvim
        suda-vim # sudo write
        telescope-frecency-nvim
        telescope-nvim
        tmux-nvim # tmux integration (copy buffer, navigation)
        vim-visual-multi # multiple cursors
        whitespace-nvim # highlight and strip trailing whitespace

        # completion
        cmp-buffer # completion source for buffer words
        cmp-cmdline # completion for vim's command line
        cmp-latex-symbols # completion source for latex symbols
        cmp-nvim-lsp # completion source for LSP
        cmp-nvim-lsp-signature-help # completion fn signature info
        cmp-nvim-lua # completion source for nvim's lua API
        cmp-path # completion source for paths
        cmp-treesitter # completion source for tree-sitter
        crates-nvim # crates.io dependency version info
        lspkind-nvim # pictograms for lsp completion items
        ltex_extra # ltex LSP configuration
        null-ls-nvim # inject LSP diagnostics, code actions
        nvim-autopairs # automatic pairing of delimiters
        nvim-cmp # completion engine

        # debugging
        nvim-dap

        # snippets
        cmp_luasnip # completion source for snippets
        friendly-snippets
        luasnip # snippet engine

        # syntax
        editorconfig-nvim
        gentoo-syntax
        lalrpop-vim
        vim-nix
        vim-polyglot
        (nvim-treesitter.withPlugins
          (_:
            with builtins;
            filter
              (drv:
                !elem
                  drv.pname
                  (map (v: "tree-sitter-${v}-grammar") [
                    "bash"
                    "c-sharp"
                    "cpp"
                    "cuda"
                    "erlang"
                    "gdscript"
                    "java"
                    "kotlin"
                    "ql-dbscheme"
                    "ruby"
                    "scala"
                    "smithy"
                    "sql"
                  ])
              )
              pkgs.tree-sitter.allGrammars
          )
        )
      ]
      ++ lib.optional (lib.elem pkgs.stdenv.hostPlatform.system pkgs.tabnine.meta.platforms) cmp-tabnine
      ;
    };
  };

  xdg.configFile."nvim/lua".source = ./lua;
  xdg.configFile."nvim/init.lua".source = ./init.lua;
}
