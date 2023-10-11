{ pkgs, ... }: {
  programs = {
    git.extraConfig.core.editor = "nvim";

    neovim = {
      enable = true;

      defaultEditor = true;
      withNodeJs = false;
      withPython3 = true;
      withRuby = false;
      vimdiffAlias = true;
      vimAlias = true;
      viAlias = true;

      extraPackages = with pkgs; [
        universal-ctags
      ];

      plugins = with pkgs.vimPlugins; [
        # ui
        bufferline-nvim # bufferline
        dressing-nvim # improve the default vim.ui interfaces
        gitsigns-nvim # git status sign decorations
        indent-blankline-nvim # indentation guides
        lualine-nvim # statusline
        neovim-ayu # colorscheme
        numb-nvim # peek lines in non-obtrusive way
        nvim-highlight-colors # highlight color codes
        nvim-navic # status/bufferline component to show LSP context
        nvim-notify # fancy notifications
        nvim-web-devicons # file icons for trouble-nvim
        todo-comments-nvim # highlight, list and search todo comments
        trouble-nvim # list for showing LSP diagnostics
        true-zen-nvim # distraction-free writing
        which-key-nvim # popups for keybindings for commands

        # lsp
        ltex_extra-nvim # ltex LSP configuration
        nvim-lightbulb # lightbulb sign when LSP actions are available
        nvim-lspconfig # LSP
        lsp-progress-nvim # Progress indicator for statusbar

        # tooling
        bufdelete-nvim # delete buffers without losing window layout
        guess-indent-nvim # automatic indentation style detection
        nvim-surround # add/change/delete surrounding delimiter pairs with ease
        rust-tools-nvim
        suda-vim # sudo write
        telescope-frecency-nvim
        telescope-nvim
        telescope-file-browser-nvim
        tmux-nvim # tmux integration (copy buffer, navigation)
        vim-visual-multi # multiple cursors
        whitespace-nvim # highlight and strip trailing whitespace
        nix-develop-nvim # run nix shell/develop within neovim
        leap-nvim # easy motions

        # completion
        coq_nvim # completion engine
        crates-nvim # crates.io dependency version info
        lspkind-nvim # pictograms for lsp completion items
        nvim-autopairs # automatic pairing of delimiters

        # debugging
        nvim-dap

        # syntax
        nvim-treesitter.withAllGrammars
      ];
    };
  };

  xdg.configFile."nvim/lua".source = ./lua;
  xdg.configFile."nvim/init.lua".source = ./init.lua;
}
