let
  inherit (builtins) attrNames attrValues mapAttrs listToAttrs;

  bemeurer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIQgTWfmR/Z4Szahx/uahdPqvEP/e/KQ1dKUYLenLuY2";

  hosts = mapAttrs (_: v: v.pubkey) (import ./nix/hosts.nix).nixos;

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
with hosts;
{
  "hardware/nixos-aarch64-builder/key.age".publicKeys = [ bemeurer jung spinoza ];
  "hosts/nozick/ddns.age".publicKeys = [ bemeurer nozick ];
  "hosts/nozick/nextcloud.age".publicKeys = [ bemeurer nozick ];
  "services/acme.age".publicKeys = [ bemeurer nozick ];
  "services/oauth2.age".publicKeys = [ bemeurer nozick ];
  "services/pihole.age".publicKeys = [ bemeurer jung ];
  "users/bemeurer/activate-token.age".publicKeys = [ bemeurer ];
  "users/bemeurer/password.age".publicKeys = [ bemeurer ] ++ (attrValues hosts);
} // allHostSecret "password"
  // allHostSecret "agent"
