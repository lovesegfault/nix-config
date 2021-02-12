{ stdenv
, fetchFromGitHub
, lib
, spawn
, fzf
, terminal
, util-linux
, makeWrapper
}: stdenv.mkDerivation rec {
  name = "sway-launcher-desktop";
  version = "unstable-2021-01-21";

  src = fetchFromGitHub {
    owner = "Biont";
    repo = name;
    rev = "fda862a4d5958fa4fbc9668b99339c7a1e584584";
    sha256 = "sha256-CePiZhNQkZxXZ6bbmUgsrgwnLxlH6o2oV9W/UKb3V1c=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ fzf spawn util-linux ];

  postPatch = ''
    substituteInPlace sway-launcher-desktop.sh \
      --replace 'bash' '${stdenv.shell}' \
      --replace '/bin/sh' '${stdenv.shell}' \
      --replace '${stdenv.shell} -c "''${CMD}"' 'spawn ''${CMD}'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp sway-launcher-desktop.sh $out/bin/sway-launcher-desktop
    wrapProgram $out/bin/sway-launcher-desktop \
      --set TERMINAL_COMMAND "${terminal} -e" \
      --prefix PATH : ${lib.makeBinPath [ spawn fzf util-linux ]}

    runHook postInstall
  '';
}
