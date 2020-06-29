{ buildPythonPackage
, fetchPypi
, pythonPackages
}: buildPythonPackage rec {
  pname = "confuse";
  version = "1.3.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "07rbsd9l5widsirbn6rcfadh7gb2bdy2frhlga7bhxdizmhir2pn";
  };
  propagatedBuildInputs = with pythonPackages; [ pyyaml ];
}
