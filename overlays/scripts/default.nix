final: _:
let
  emoji_json = final.fetchurl {
    url = "https://raw.githubusercontent.com/github/gemoji/0eca75db9301421efc8710baf7a7576793ae452a/db/emoji.json";
    hash = "sha256-sXSuKusyG1L2Stuf9BL5ZqfzOIOdeAeE3RXcrXAsLdY=";
  };
  emoji_list =
    final.runCommand "emoji_list.txt"
      {
        nativeBuildInputs = with final; [
          jq
          gnused
        ];
      }
      ''
        jq -r '.[] | "\(.emoji) \t   \(.description)"' '${emoji_json}' | sed -e 's,\\t,\t,g' > $out
      '';

  writeShellApp =
    args:
    let
      pname = args.name;
      src = args.src or (./. + "/${args.name}.sh");
      solutions = final.lib.filterAttrs (n: _: n != "name" && n != "src") args;
    in
    final.resholve.mkDerivation {
      inherit pname src;
      version = "0.0.0";

      dontUnpack = true;
      dontConfigure = true;
      dontBuild = true;

      installPhase = ''
        runHook preInstall
        mkdir -p $out/bin
        cp $src $out/bin/${args.name}
        runHook postInstall
      '';

      doInstallCheck = true;
      installCheckPhase = ''
        runHook preInstallCheck
        ${final.stdenv.shellDryRun} "$out/bin/${args.name}"
        ${final.shellcheck}/bin/shellcheck "$out/bin/${args.name}"
        ${final.shfmt}/bin/shfmt --diff -s -ln bash -i 0 -ci "$out/bin/${args.name}"
        runHook postInstallCheck
      '';

      solutions.default = {
        interpreter = "${final.bash}/bin/bash";
        scripts = [ "bin/${args.name}" ];
      }
      // solutions;
    };
in
{
  checkart = writeShellApp {
    name = "checkart";
    inputs = with final; [
      coreutils
      findutils
    ];
  };

  drunmenu-wayland = writeShellApp {
    name = "drunmenu";
    src = ./drunmenu-wayland.sh;
    inputs = with final; [
      gnused
      spawn
      wofi
    ];
    execer = [
      "cannot:${final.wofi}/bin/wofi"
      "cannot:${final.spawn}/bin/spawn"
    ];
  };

  drunmenu-x11 = writeShellApp {
    name = "drunmenu";
    src = ./drunmenu-x11.sh;
    inputs = with final; [
      rofi
      spawn
    ];
    execer = [
      "cannot:${final.rofi}/bin/rofi"
      "cannot:${final.spawn}/bin/spawn"
    ];
  };

  emojimenu-wayland = writeShellApp {
    name = "emojimenu";
    src = ./emojimenu-wayland.sh;
    inputs = with final; [
      coreutils
      wl-clipboard
      wofi
    ];
    execer = [
      "cannot:${final.wofi}/bin/wofi"
      "cannot:${final.wl-clipboard}/bin/wl-copy"
    ];
    prologue =
      (final.writeText "export-emoji-list" ''
        export emoji_list="${emoji_list}"
      '').outPath;
  };

  emojimenu-x11 = writeShellApp {
    name = "emojimenu";
    src = ./emojimenu-x11.sh;
    inputs = with final; [
      coreutils
      rofi
      xclip
    ];
    execer = [
      "cannot:${final.rofi}/bin/rofi"
      "cannot:${final.xclip}/bin/xclip"
    ];
    prologue =
      (final.writeText "export-emoji-list" ''
        export emoji_list="${emoji_list}"
      '').outPath;
  };

  fixart = writeShellApp {
    name = "fixart";
    inputs = with final; [
      coreutils
      findutils
    ];
    fake.external = [ "beet" ];
  };

  nix-closure-size = writeShellApp {
    name = "nix-closure-size";
    inputs = with final; [
      coreutils
      gawk
    ];
    fake.external = [ "nix-store" ];
  };

  screenshot = writeShellApp {
    name = "screenshot";
    inputs = with final; [
      grim
      slurp
      swappy
    ];
    execer = [
      "cannot:${final.swappy}/bin/swappy"
    ];
  };

  spawn = writeShellApp {
    name = "spawn";
    inputs = with final; [
      coreutils
      systemd
      util-linux
    ];
    execer = [ "cannot:${final.systemd}/bin/systemd-run" ];
  };

  ccinit = writeShellApp {
    name = "ccinit";
    inputs = with final; [
      coreutils
      gawk
      gnugrep
    ];
    fake.external = [ "claude" ];
  };
}
