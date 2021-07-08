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

      extraPackages = with pkgs; [
        ctags
        gcc
        nodejs
        tree-sitter
      ];

      plugins =
        let
          vimPlugins = pkgs.vimPlugins // {
            tree-sitter-grammars = pkgs.vimUtils.buildVimPluginFrom2Nix rec {
              pname = "tree-sitter-grammars";
              version = pkgs.tree-sitter.version;
              # INFO: These are either buggy or just entirely broken
              banned = (map (v: "tree-sitter-${v}") [
                "agda"
                "fluent"
                "svelte"
                "swift"
                "verilog"
              ]);
              src = pkgs.runCommandNoCC "tree-sitter-grammars" { } ''
                mkdir -p $out/parser
                ${builtins.concatStringsSep "\n" (builtins.attrValues (builtins.mapAttrs
                  (n: v: "ln -s ${v}/parser $out/parser/${
                      builtins.replaceStrings ["-"] ["_"] (pkgs.lib.removePrefix "tree-sitter-" n)
                    }.so")
                  (lib.filterAttrs (n: _: !builtins.elem n banned) pkgs.tree-sitter.builtGrammars)
                ))}
              '';
              dependencies = [ ];
            };
          };
        in
        with vimPlugins; [
          # ui
          ayu-vim
          gitsigns-nvim
          indent-blankline-nvim-lua
          lightline-vim
          lsp-colors-nvim
          lsp_signature-nvim
          numb-nvim
          nvim-bufferline-lua
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
          nvim-compe
          nvim-lspconfig
          snippets-nvim
          vim-vsnip

          # syntax
          editorconfig-vim
          gentoo-syntax
          lalrpop-vim
          nvim-treesitter
          tree-sitter-grammars
          vim-nix
          vim-polyglot
        ] ++ lib.optionals (pkgs.hostPlatform.system == "x86_64-linux") [
          compe-tabnine
        ];
    };
  };

  xdg.configFile."nvim/lua".source = ./lua;
}
