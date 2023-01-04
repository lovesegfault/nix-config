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
        bufferline-nvim
        feline-nvim
        gitsigns-nvim
        indent-blankline-nvim
        lsp-colors-nvim
        lsp_signature-nvim
        neovim-ayu
        numb-nvim
        nvim-lightbulb
        nvim-navic
        nvim-treesitter-context
        nvim-web-devicons
        stabilize-nvim
        todo-comments-nvim
        trouble-nvim
        true-zen-nvim

        # tooling
        nvim-bufdel
        (rust-tools-nvim.overrideAttrs (old: {
          # https://github.com/simrat39/rust-tools.nvim/issues/309
          patches = (old.patches or [ ]) ++ [
            (pkgs.fetchpatch {
              url = "https://github.com/simrat39/rust-tools.nvim/commit/c813f21402bfaa55da839c4ca6f9ff3f62ebb089.patch";
              hash = "sha256-3dWNwQyPZR3+1U+GSS+PpuElqy/KFAzyh/Le3o/vkIg=";
            })
          ];
        }))
        suda-vim
        tabular
        telescope-frecency-nvim
        telescope-nvim
        vim-better-whitespace
        vim-commentary
        vim-fugitive
        vim-gist
        vim-rhubarb
        vim-sleuth
        vim-surround
        vim-tmux-navigator
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

        # syntax
        (nvim-treesitter.withPlugins
          (_:
            with builtins;
            filter
              (drv:
                !elem
                  drv.pname
                  (map (v: "tree-sitter-${v}-grammar") [
                    "agda"
                    "bash"
                    "fluent"
                    "kotlin"
                    "ql-dbscheme"
                    "sql"
                  ])
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
      ++ lib.optional (lib.elem pkgs.hostPlatform.system pkgs.tabnine.meta.platforms) cmp-tabnine
      ;
    };
  };

  xdg.configFile."nvim/lua".source = ./lua;
  xdg.configFile."nvim/init.lua".source = ./init.lua;
}
