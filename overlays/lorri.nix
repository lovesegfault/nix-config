self: super: {
  lorri = (import ../nix).lorri { pkgs = super; };
}
