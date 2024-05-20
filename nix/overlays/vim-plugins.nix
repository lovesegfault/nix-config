final: prev: {
  vimPlugins = prev.vimPlugins // {
    lsp-progress-nvim = final.vimUtils.buildVimPlugin {
      name = "lsp-progress-nvim";
      src = final.fetchFromGitHub {
        owner = "linrongbin16";
        repo = "lsp-progress.nvim";
        rev = "55a04895ea20c365b670051a3128265d43bdfa3d";
        hash = "sha256-lemswtWOf6O96YkUnIFZIsuZPO4oUTNpZRItsl/GSnU=";
      };
    };
    inlay-hints-nvim = final.vimUtils.buildVimPlugin {
      name = "inlay-hints-nvim";
      src = final.fetchFromGitHub {
        owner = "MysticalDevil";
        repo = "inlay-hints.nvim";
        rev = "0a8f5da759e756144335c962d4ec884713935b20";
        hash = "sha256-3XDCeQdx0EayetEDFD2TyUfOrTN8QTaTLxVDA35MPlU=";
      };
    };
  };
}
