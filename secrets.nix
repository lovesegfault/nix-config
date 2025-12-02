let
  inherit (builtins)
    attrNames
    attrValues
    mapAttrs
    listToAttrs
    ;

  bemeurer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIQgTWfmR/Z4Szahx/uahdPqvEP/e/KQ1dKUYLenLuY2";

  # Host pubkeys for agenix encryption
  hosts = import ./lib/host-pubkeys.nix;

  secrets = with hosts; {
    "services/acme.age" = [
      hegel
      jung
      plato
    ];
    "services/oauth2.age" = [
      hegel
      jung
      plato
    ];
    "services/github-runner.age" = [ jung ];
    "users/bemeurer/password.age" = attrValues hosts;
  };

  secrets' = mapAttrs (_: v: { publicKeys = [ bemeurer ] ++ v; }) secrets;

  allHostSecret =
    secretName:
    listToAttrs (
      map (host: {
        name = "hosts/${host}/${secretName}.age";
        value.publicKeys = [
          bemeurer
          hosts.${host}
        ];
      }) (attrNames hosts)
    );
in
secrets' // allHostSecret "password"
