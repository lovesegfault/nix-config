{ hostType, ... }: {
  imports =
    let
      sysConfig =
        if hostType == "nixos" then ./nixos.nix
        else if hostType == "darwin" then ./darwin.nix
        else throw "Unknown hostType '${hostType}' for graphical"
      ;
    in
    [
      sysConfig
      ./fonts.nix
    ];
}
