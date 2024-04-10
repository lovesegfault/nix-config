final: prev: {
  vimPlugins = prev.vimPlugins // {
    lsp-progress-nvim = final.vimUtils.buildVimPlugin {
      name = "lsp-progress-nvim";
      src = final.fetchFromGitHub {
        owner = "linrongbin16";
        repo = "lsp-progress.nvim";
        rev = "36c84b33bed21f33e62e778b0567eb59ec21dc38";
        hash = "sha256-njUl/TBjjuvcz8tPktQbuJuofe25X36hR+vzLWMqFl0=";
      };
    };
  };
}
