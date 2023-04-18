final: prev: {
  vimPlugins = prev.vimPlugins // {
    nvim-lsp-notify = final.vimUtils.buildVimPlugin {
      name = "nvim-lsp-notify";
      src = final.fetchFromGitHub {
        owner = "mrded";
        repo = "nvim-lsp-notify";
        rev = "9986955e0423f2f5cdb3bd4f824bc980697646a0";
        hash = "sha256-J6PRYS62r4edMO6UDZKrOv2x6RFox5k3pqvVqlnz6hs=";
      };
    };
  };
}
