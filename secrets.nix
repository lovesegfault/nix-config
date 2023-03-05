let
  inherit (builtins) attrNames attrValues mapAttrs listToAttrs;

  bemeurer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIQgTWfmR/Z4Szahx/uahdPqvEP/e/KQ1dKUYLenLuY2";

  hosts = mapAttrs (_: v: v.pubkey) (import ./nix/hosts.nix).nixos;

  secrets = with hosts; {
    "hardware/nixos-aarch64-builder/key.age" = [ aurelius jung spinoza ];
    "hosts/nozick/ddns.age" = [ nozick ];
    "hosts/nozick/nextcloud.age" = [ nozick ];
    "services/acme.age" = [ bohr fourier jung nozick ];
    "services/oauth2.age" = [ bohr fourier jung nozick ];
    "services/pihole.age" = [ ];
    "users/bemeurer/password.age" = attrValues hosts;
  };

  secrets' = mapAttrs (_: v: { publicKeys = [ bemeurer ] ++ v; }) secrets;

  allHostSecret = secretName:
    listToAttrs (
      map
        (host: {
          name = "hosts/${host}/${secretName}.age";
          value.publicKeys = [ bemeurer hosts.${host} ];
        })
        (attrNames hosts)
    );
in
secrets' // allHostSecret "password"
