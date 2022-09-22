let
  inherit (builtins) attrNames attrValues mapAttrs listToAttrs;

  bemeurer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIQgTWfmR/Z4Szahx/uahdPqvEP/e/KQ1dKUYLenLuY2";

  hosts = mapAttrs (_: v: v.pubkey) (import ./nix/hosts.nix).nixos.all;

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
  "hosts/nozick/acme.age".publicKeys = [ bemeurer nozick ];
  "hosts/nozick/ddns.age".publicKeys = [ bemeurer nozick ];
  "hosts/nozick/nextcloud.age".publicKeys = [ bemeurer nozick ];
  "hosts/nozick/oauth2.age".publicKeys = [ bemeurer nozick ];
  "hardware/nixos-aarch64-builder/key.age".publicKeys = [ bemeurer aurelius jung spinoza ];
  "users/bemeurer/password.age".publicKeys = [ bemeurer ] ++ (attrValues hosts);
  "users/bemeurer/activate-token.age".publicKeys = [ bemeurer ];
} // allHostSecret "password"
  // allHostSecret "agent"
