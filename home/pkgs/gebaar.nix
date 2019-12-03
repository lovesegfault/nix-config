{ gcc8Stdenv, fetchFromGitHub
, pkgconfig, cmake
, libinput, zlib
}:
gcc8Stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "gebaar";
  version = "v0.0.5";

  src = fetchFromGitHub {
    owner = "Coffee2CodeNL";
    repo = "gebaar-libinput";
    rev = version;
    sha256 = "1kqcgwkia1p195xr082838dvj1gqif9d63i8a52jb0lc32zzizh6";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [
    libinput zlib
  ];

  enableParallelBuilding = true;

  meta = with gcc8Stdenv.lib; {
    description = "Gebaar, A Super Simple WM Independent Touchpad Gesture Daemon for libinput";
    homepage    = "https://github.com/Coffee2CodeNL/gebaar-libinput";
    license     = licenses.gpl3;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
