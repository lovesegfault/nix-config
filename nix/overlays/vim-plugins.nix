final: prev: {
  vimPlugins = prev.vimPlugins // {
    tmux-nvim = final.vimUtils.buildVimPlugin {
      name = "tmux.nvim";
      src = final.fetchFromGitHub {
        owner = "aserowy";
        repo = "tmux.nvim";
        rev = "9ba03cc5dfb30f1dc9eb50d0796dfdd52c5f454e";
        hash = "sha256-ZBnQFKe8gySFQ9v6j4C/F/mq+bCH1n8G42AlBx6MbXY=";
      };
    };

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
