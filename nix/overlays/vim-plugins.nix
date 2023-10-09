final: prev: {
  vimPlugins = prev.vimPlugins // {
    lsp-progress-nvim = final.vimUtils.buildVimPlugin {
      name = "lsp-progress-nvim";
      src = final.fetchFromGitHub {
        owner = "linrongbin16";
        repo = "lsp-progress.nvim";
        rev = "d4c5440e6bccfcd0aeb3070a53290272cf5a332a";
        hash = "sha256-DHMnOngdm9ql/w7eyD4MXfYTO3iSkDLK8Go3OEKARnw=";
      };
    };
  };
}
