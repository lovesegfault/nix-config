{ buildPythonPackage
, fetchPypi
, pythonPackages
}: buildPythonPackage rec {
  pname = "mediafile";
  version = "0.5.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "14vqvv4n0d93hbz9xpazcy3k7bfz3lapicp0qamjm656bi77j6fs";
  };
  propagatedBuildInputs = with pythonPackages; [ mutagen six ];
  doCheck = false;
}
