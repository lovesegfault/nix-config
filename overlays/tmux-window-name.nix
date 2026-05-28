# tmux-window-name is not packaged in nixpkgs; build it with mkTmuxPlugin and
# bake in a python interpreter that has libtmux available, mirroring how
# nixpkgs wraps python-based tmux plugins (extrakto, tmux-which-key).
final: prev:
let
  pythonEnv = final.python3.withPackages (ps: [ ps.libtmux ]);
in
{
  tmuxPlugins = prev.tmuxPlugins // {
    tmux-window-name = prev.tmuxPlugins.mkTmuxPlugin {
      pluginName = "tmux-window-name";
      rtpFilePath = "tmux_window_name.tmux";
      version = "0-unstable-2026-04-20";
      src = final.fetchFromGitHub {
        owner = "ofirgall";
        repo = "tmux-window-name";
        rev = "e98189f9a9487d2cdaa2d207b06780d1f5f58a41";
        hash = "sha256-YI2s/OtywKJQAPpb07dCbWA/6+sWAl+DB+QQbvZOG5k=";
      };
      postPatch = ''
        substituteInPlace tmux_window_name.tmux \
          --replace-fail 'python -c' '${pythonEnv}/bin/python -c'
        substituteInPlace scripts/rename_session_windows.py \
          --replace-fail '#!/usr/bin/env python3' '#!${pythonEnv}/bin/python3'
      '';
      meta = {
        description = "Name your tmux windows smartly, like IDE tabs";
        homepage = "https://github.com/ofirgall/tmux-window-name";
        license = final.lib.licenses.mit;
        platforms = final.lib.platforms.unix;
      };
    };
  };
}
