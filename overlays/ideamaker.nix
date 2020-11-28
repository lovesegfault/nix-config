self: _: {
  libcork = self.callPackage
    (
      { stdenv, fetchFromGitHub, cmake, lib, pkgconfig, check }: stdenv.mkDerivation rec {
        pname = "libcork";
        version = "1.0.0--rc3";

        src = fetchFromGitHub {
          owner = "dcreager";
          repo = pname;
          rev = version;
          sha256 = "152gqnmr6wfmflf5l6447am4clmg3p69pvy3iw7yhaawjqa797sk";
        };

        # N.B. We need to create this file, otherwise it tries to use git to
        # determine the package version, which we do not want.
        postPatch = ''
          echo "${version}" > .version-stamp
          echo "${version}" > .commit-stamp
          sed -i '/add_subdirectory(tests)/d' ./CMakeLists.txt
        '';

        nativeBuildInputs = [ cmake pkgconfig ];
        buildInputs = [ check ];

        postInstall = ''
          ln -s $out/lib/libcork.so $out/lib/libcork.so.1
        '';

        meta = with lib; {
          homepage = "https://github.com/dcreager/libcork";
          description = "A simple, easily embeddable cross-platform C library";
          license = licenses.bsd3;
          platforms = platforms.unix;
          maintainers = with maintainers; [ lovesegfault ];
        };
      }
    )
    { };
  ideamaker = self.callPackage
    (
      { stdenv
      , autoPatchelfHook
      , dpkg
      , fetchurl
      , lib
      , libGLU
      , gcc
      , zlib
      , curl
      , qt5
      , quazip_qt4
      , libcork
      }:
      stdenv.mkDerivation {
        pname = "ideamaker";
        version = "4.0.1";

        src = fetchurl {
          # N.B. Unfortunately ideamaker adds a number after the patch number in
          # their release scheme which is not referenced anywhere other than in
          # the download URL. Because of this, I have chosen to not use ${version}
          # and just handwrite the correct values in the following URL, hopefully
          # avoiding surprises for the next person that comes to update this
          # package.
          url = "https://download.raise3d.com/ideamaker/release/4.0.1/ideaMaker_4.0.1.4802-ubuntu_amd64.deb";
          sha256 = "0a1jcakdglcr4kz0kyq692dbjk6aq2yqcp3i6gzni91k791h49hp";
        };

        nativeBuildInputs = [ autoPatchelfHook dpkg qt5.wrapQtAppsHook ];
        buildInputs = [
          curl
          gcc.cc.lib
          libGLU
          libcork
          qt5.qtbase
          qt5.qtserialport
          quazip_qt4
          zlib
        ];

        unpackPhase = ''
          runHook preUnpack
          dpkg-deb -x $src .
          runHook postUnpack
        '';

        installPhase = ''
          runHook preInstall

          mkdir -p $out/bin
          cp usr/lib/x86_64-linux-gnu/ideamaker/ideamaker $out/bin

          runHook postInstall
        '';

        meta = with lib; {
          homepage = "https://www.raise3d.com/ideamaker/";
          description = "Raise3D's 3D slicer software";
          license = licenses.unfree;
          platforms = [ "x86_64-linux" ];
          maintainers = with maintainers; [ lovesegfault ];
        };
      }
    )
    { };
}
