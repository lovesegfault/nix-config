{ stdenv
, fetchFromGitHub
, lib
, spawn
, fzf
, terminal
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
  buildInputs = [ fzf spawn ];

  postPatch = ''
    substituteInPlace sway-launcher-desktop.sh \
      --replace 'bash -c "''${CMD}"' 'spawn "''${CMD}"' \
      --replace '/bin/sh' '${stdenv.shell}'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp sway-launcher-desktop.sh $out/bin/sway-launcher-desktop
    wrapProgram $out/bin/sway-launcher-desktop \
      --set TERMINAL_COMMAND "${terminal} -e" \
      --prefix PATH : ${lib.makeBinPath [ spawn fzf ]}

    runHook postInstall
  '';
}
