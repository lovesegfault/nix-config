self: super:
with super;
{
  passh = stdenv.mkDerivation rec {
    pname = "passh";
    version = "2019-07-04";

    src = fetchFromGitHub {
      owner = "clarkwang";
      repo = pname;
      rev = "f1cc1403d29aa90128743cfac84ba61820a256e8";
      sha256 = "147cj4045yrwxrb0kz4pll2y40q9j82g5ibcibvx7q5833jmfydh";
    };

    installPhase = ''
      mkdir -p $out/bin
      cp passh $out/bin/
    '';

    meta = with stdenv.lib; {
      homepage = "https://github.com/clarkwang/passh";
      description = "sshpass alternative for non-interactive ssh auth";
      license = licenses.unfree; # Author does not set a license
      maintainers = [ maintainers.lovesegfault ];
      platforms = platforms.unix;
    };
  };
}
