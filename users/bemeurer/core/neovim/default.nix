{ lib, pkgs, ... }: {
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

      extraConfig = "lua require('init')";

      plugins = with pkgs.vimPlugins; [
        # ui
        gitsigns-nvim
        indent-blankline-nvim
        lsp-colors-nvim
        lsp_signature-nvim
        feline-nvim
        neovim-ayu
        numb-nvim
        bufferline-nvim
        nvim-lightbulb
        nvim-web-devicons
        todo-comments-nvim
        trouble-nvim

        # tooling
        nvim-bufdel
        rust-tools-nvim
        telescope-nvim
        vim-better-whitespace
        vim-commentary
        vim-fugitive
        vim-gist
        vim-rhubarb
        vim-sleuth
        vim-surround
        vim-visual-multi

        # completion
        cmp-buffer
        cmp-nvim-lsp
        cmp-nvim-lua
        cmp-path
        cmp_luasnip
        crates-nvim
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
                    "fluent"
                    "svelte"
                    "swift"
                    "verilog"
                  ])
              )
              pkgs.tree-sitter.allGrammars
          )
        )
        nvim-treesitter-textobjects
        editorconfig-vim
        gentoo-syntax
        lalrpop-vim
        vim-nix
        vim-polyglot
      ] ++ lib.optionals (pkgs.hostPlatform.system == "x86_64-linux") [
        cmp-tabnine
      ];
    };
  };

  xdg.configFile."nvim/lua".source = ./lua;
}
