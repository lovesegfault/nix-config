{ config, ... }: {

  age.secrets.ddns.file = ./ddns.age;
  virtualisation.oci-containers.containers.ddns = {
    autoStart = true;
    image = "timothyjmiller/cloudflare-ddns:latest";
    volumes = [
      "${config.age.secrets.ddns.path}:/config.json"
    ];
    extraOptions = [ "--network=host" ];
  };
}
