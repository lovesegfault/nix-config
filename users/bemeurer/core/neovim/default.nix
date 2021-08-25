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
        indent-blankline-nvim-lua
        lsp-colors-nvim
        lsp_signature-nvim
        lualine-nvim
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
        snippets-nvim
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
        nvim-autopairs
        nvim-compe
        nvim-lspconfig
        snippets-nvim
        vim-vsnip

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
                    "c-sharp"
                    "embedded-template"
                    "fluent"
                    "ocaml-interface"
                    "svelte"
                    "swift"
                    "verilog"
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
      ] ++ lib.optionals (pkgs.hostPlatform.system == "x86_64-linux") [
        compe-tabnine
      ];
    };
  };

  xdg.configFile."nvim/lua".source = ./lua;
}
