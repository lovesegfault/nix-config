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
    rev = "1ac6d768619aab8e80c63d47e69aa65f27aa47ce";
    sha256 = "sha256-0uK00NyRTCB9V4KxjAWtjF/R5ivoot4l8amLy0t8bfE=";
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
