self: super:
with self;
{
  mfcl2750cupswrapper = stdenv.mkDerivation rec {
    pname = "mfcl2750dwpdrv";
    version = "4.0.0-1";

    src = fetchurl {
      url =
        "https://download.brother.com/welcome/dlf103530/${pname}-${version}.i386.deb";
      sha256 = "0dyjh9b7izd8a4frdccm174jnkl68qlfr6f1nvswl5qknk6g1q6y";
    };

    nativeBuildInputs = [ dpkg makeWrapper ];

    unpackPhase = "dpkg-deb -x $src $out";

    # We do this manually
    dontWrap = true;

    installPhase = ''
    dir=$out/opt/brother/Printers/MFCL2750DW
    # first we place the bin garbage in the correct place
    mv $dir/lpd/x86_64/* $dir/lpd/
    # then we remove the other arches (and the now empty x86_64)
    rm -r $dir/lpd/armv7l $dir/lpd/i686 $dir/lpd/x86_64

    substituteInPlace $dir/lpd/lpdfilter \
      --replace /usr/bin/perl ${perl}/bin/perl \
      --replace "BR_PRT_PATH =~" "BR_PRT_PATH = \"$dir\"; #" \
      --replace "PRINTER =~" "PRINTER = \"MFCL2750DW\"; #"

    substituteInPlace $dir/cupswrapper/lpdwrapper \
      --replace /usr/bin/perl ${perl}/bin/perl \
      --replace "PRINTER =~" "PRINTER = \"MFCL2750DW\"; #"

    substituteInPlace $dir/cupswrapper/paperconfigml2 \
      --replace /usr/bin/perl ${perl}/bin/perl

    wrapProgram $dir/lpd/lpdfilter \
      --prefix PATH : ${stdenv.lib.makeBinPath [
        coreutils ghostscript gnugrep gnused which
      ]}

    wrapProgram $dir/cupswrapper/lpdwrapper \
      --prefix PATH : ${stdenv.lib.makeBinPath [ coreutils gnugrep gnused ]}

    mkdir -p $out/lib/cups/filter
    mkdir -p $out/share/cups/model

    ln $dir/cupswrapper/lpdwrapper $out/lib/cups/filter/brother_lpdwrapper_MFCL2750DW
    ln $dir/cupswrapper/brother-MFCL2750DW-cups-en.ppd $out/share/cups/model
    '';

    meta = {
      description = "Brother MFC-L2750DW lpr driver";
      homepage = http://www.brother.com/;
      license = stdenv.lib.licenses.unfree;
      platforms = [ "x86_64-linux" ];
      maintainers = [ stdenv.lib.maintainers.lovesegfault ];
    };
    };
}
