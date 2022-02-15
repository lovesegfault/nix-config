final: _: {
  glinux-sway = final.writeShellApplication {
    name = "glinux-sway";
    runtimeInputs = [ final.nixgl.nixGLIntel ];
    text = ''
      set +o nounset
      # shellcheck disable=SC1091
      source "$HOME/.profile"
      set -x -a
      # shellcheck disable=SC1091
      source "$HOME/.config/environment.d/10-home-manager.conf"
      set +a +x
      exec nixGLIntel "$HOME/.nix-profile/bin/sway"
    '';
  };
}
