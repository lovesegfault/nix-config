let
  inherit (builtins) attrNames attrValues mapAttrs listToAttrs;

  nameValuePair = name: value: { inherit name value; };

  mapAttrs' = f: set:
    listToAttrs (map (attr: f attr set.${attr}) (attrNames set));

  bemeurer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIQgTWfmR/Z4Szahx/uahdPqvEP/e/KQ1dKUYLenLuY2";

  hosts = mapAttrs (_: v: v.pubkey) (import ./nix/hosts.nix).nixosHosts;
in
with hosts;
{
  "hosts/kant/ddclient.age".publicKeys = [ bemeurer kant ];
  "hardware/nixos-aarch64-builder/key.age".publicKeys = [ bemeurer aurelius camus deleuze foucault hegel ];
  "users/bemeurer/password.age".publicKeys = [ bemeurer ] ++ (attrValues hosts);
} // (
  mapAttrs'
    (host: _:
      nameValuePair "hosts/${host}/password.age" { publicKeys = [ bemeurer hosts.${host} ]; })
    hosts
)
