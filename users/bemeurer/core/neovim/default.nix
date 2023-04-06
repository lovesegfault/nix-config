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
        tmux-nvim
        vim-visual-multi

        # completion
        cmp-buffer
        cmp-cmdline
        cmp-latex-symbols
        cmp-nvim-lsp
        cmp-nvim-lua
        cmp-path
        cmp-treesitter
        cmp_luasnip
        crates-nvim
        null-ls-nvim
        lspkind-nvim
        luasnip
        nvim-autopairs
        nvim-cmp
        nvim-lspconfig
        snippets-nvim
        ltex_extra

        # syntax
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
                    "bibtex"
                    "c-sharp"
                    "clojure"
                    "cmake"
                    "cpp"
                    "cuda"
                    "eex"
                    "elixir"
                    "erlang"
                    "fish"
                    "fortran"
                    "gdscript"
                    "heex"
                    "java"
                    "julia"
                    "kotlin"
                    "latex"
                    "nickel"
                    "nix"
                    "python"
                    "ql-dbscheme"
                    "regex"
                    "ruby"
                    "scala"
                    "smithy"
                    "tsx"
                    "typescript"
                    "zig"
                  ]) ++ [ "markdown_inline-grammar" ])
              )
              pkgs.tree-sitter.allGrammars
          )
        )
        editorconfig-vim
        gentoo-syntax
        lalrpop-vim
        vim-nix
        vim-polyglot
      ]
      ++ lib.optional (lib.elem pkgs.stdenv.hostPlatform.system pkgs.tabnine.meta.platforms) cmp-tabnine
      ;
    };
  };

  xdg.configFile."nvim/lua".source = ./lua;
  xdg.configFile."nvim/init.lua".source = ./init.lua;
}
