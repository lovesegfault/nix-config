{
  programs.nixvim = {
    enable = true;
    imports = [ ./config.nix ];
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.git.settings.core.editor = "nvim";
}
