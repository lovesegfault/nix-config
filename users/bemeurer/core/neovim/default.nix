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
        feline-nvim # statusline
        lualine-nvim # statusline
        gitsigns-nvim # git status sign decorations
        indent-blankline-nvim # indentation guides
        lsp_signature-nvim # function signature pop-ups
        neovim-ayu # colorscheme
        numb-nvim # peek lines in non-obtrusive way
        nvim-lightbulb # lightbulb sign when LSP actions are available
        nvim-navic # status/bufferline component to show LSP context
        nvim-web-devicons # file icons for trouble-nvim
        # TODO: Remove with Neovim 0.9, set splitkeep=screen instead.
        stabilize-nvim # stabilize window open/close events
        todo-comments-nvim # highlight, list and search todo comments
        trouble-nvim # list for showing LSP diagnostics
        true-zen-nvim # distraction-free writing

        # tooling
        bufdelete-nvim # delete buffers without losing window layout
        rust-tools-nvim
        suda-vim # sudo write
        telescope-frecency-nvim
        telescope-nvim
        vim-better-whitespace # highlight and strip trailing whitespace
        guess-indent-nvim # automatic indentation style detection
        nvim-surround # add/change/delete surrounding delimiter pairs with ease
        tmux-nvim # tmux integration (copy buffer, navigation)
        vim-visual-multi # multiple cursors

        # completion
        cmp-buffer # completion source for buffer words
        cmp-cmdline # completion for vim's command line
        cmp-latex-symbols # completion source for latex symbols
        cmp-nvim-lsp # completion source for LSP
        cmp-nvim-lua # completion source for nvim's lua API
        cmp-path # completion source for paths
        cmp-treesitter # completion source for tree-sitter
        cmp-nvim-lsp-signature-help # completion fn signature info
        crates-nvim # crates.io dependency version info
        null-ls-nvim # inject LSP diagnostics, code actions
        lspkind-nvim # pictograms for lsp completion items
        nvim-autopairs # automatic pairing of delimiters
        nvim-cmp # completion engine
        nvim-lspconfig # LSP
        ltex_extra # ltex LSP configuration

        # debugging
        nvim-dap

        # snippets
        cmp_luasnip # completion source for snippets
        luasnip # snippet engine
        friendly-snippets

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
                  ((map (v: "tree-sitter-${v}-grammar") [
                    "bash"
                    "beancount"
                    "c-sharp"
                    "clojure"
                    "cmake"
                    "cpp"
                    "cuda"
                    "erlang"
                    "fish"
                    "fortran"
                    "gdscript"
                    "java"
                    "julia"
                    "kotlin"
                    "nickel"
                    "python"
                    "ql-dbscheme"
                    "ruby"
                    "scala"
                    "smithy"
                    "sql"
                    "tsx"
                    "typescript"
                    "zig"
                  ]) ++ [ "markdown_inline-grammar" ])
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
