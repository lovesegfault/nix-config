{
  programs.nixvim = {
    enable = true;
    imports = [ ./config.nix ];
    # Reuse the host's pkgs instead of letting nixvim instantiate its own
    # nixpkgs; with inputs.nixvim.inputs.nixpkgs.follows the default source
    # diverges from nixvim's pin and triggers an evaluation warning.
    nixpkgs.useGlobalPackages = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.git.settings.core.editor = "nvim";
}
