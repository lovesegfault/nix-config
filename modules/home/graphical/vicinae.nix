# Vicinae itself comes from homebrew on darwin; home-manager's programs.vicinae
# is Linux-only.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  settingsFile = "${config.xdg.configHome}/vicinae/settings.json";
  initialSettings = (pkgs.formats.json { }).generate "vicinae-settings.json" {
    global_shortcuts.toggle = "cmd+space";
  };
in
{
  # Vicinae rewrites settings.json whenever favorites, aliases or preferences
  # change in the app, so a read-only store symlink would make those silently
  # fail. Seed it once so Vicinae takes over ⌘Space; after that the app owns it.
  home.activation.seedVicinaeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [[ ! -e ${lib.escapeShellArg settingsFile} ]]; then
      run mkdir -p ${lib.escapeShellArg (dirOf settingsFile)}
      run install -m 0644 ${initialSettings} ${lib.escapeShellArg settingsFile}
    fi
  '';
}
