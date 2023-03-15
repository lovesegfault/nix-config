final: prev: {
  vimPlugins = prev.vimPlugins // {
    ltex_extra = final.vimUtils.buildVimPlugin {
      name = "ltex_extra";
      src = final.fetchFromGitHub {
        owner = "barreiroleo";
        repo = "ltex_extra.nvim";
        rev = "1d2f288ceedc70d5a9c00f55c0d0cc788b5164f2";
        hash = "sha256-2knrqgDTSxT4ZGjZvO7RbFdvrVmTWOLS3OoGPfy4du4=";
      };
    };
  };
}
