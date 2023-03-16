{ hostType, lib, ... }: {
  imports = [
    ./fonts.nix
  ]
  ++ lib.optional (hostType == "nixos") ./nixos.nix
  ++ lib.optional (hostType == "darwin") ./darwin.nix
  ;
}
