final: prev: {
  hqplayerd = prev.hqplayerd.overrideAttrs (_: {
    version = "4.32.2-92";
    src = final.fetchurl {
      url = "https://www.signalyst.eu/bins/hqplayerd/fc35/hqplayerd-4.32.2-92.fc35.x86_64.rpm";
      hash = "sha256-chgzu5r35VTSc1xOVTPCWCRrjABOy+vs57SsKOSzvkM=";
    };
  });

  roon-server = prev.roon-server.overrideAttrs (_: {
    version = "1.8-988";
    src = final.fetchurl {
      url = "http://download.roonlabs.com/builds/RoonServer_linuxx64_100800988.tar.bz2";
      hash = "sha256-e8hSvHKeyJOIp6EWy1JLOWnj6HE2McFk9bw5vVZ96/I=";
    };
  });
}
