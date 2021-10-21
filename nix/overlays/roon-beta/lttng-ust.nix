{ lib, stdenv, fetchurl, pkg-config, liburcu, numactl, python3 }:

# NOTE:
#   ./configure ...
#   [...]
#   LTTng-UST will be built with the following options:
#
#   Java support (JNI): Disabled
#   sdt.h integration:  Disabled
#   [...]
#
# Debian builds with std.h (systemtap).

stdenv.mkDerivation rec {
  pname = "lttng-ust";
  version = "2.12.2";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-ust/${pname}-${version}.tar.bz2";
    sha256 = "sha256-vNDwZLbKiMcthOdg6sNHKuXIKEEcY0Q1kivun841n8c=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ numactl python3 ];

  preConfigure = ''
    patchShebangs .
  '';

  propagatedBuildInputs = [ liburcu ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "LTTng Userspace Tracer libraries";
    homepage = "https://lttng.org/";
    license = with licenses; [ lgpl21Only gpl2Only mit ];
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };

}
