let
  inherit (builtins) attrValues mapAttrs;
  bemeurer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIQgTWfmR/Z4Szahx/uahdPqvEP/e/KQ1dKUYLenLuY2";

  hosts = mapAttrs (_: v: v.pubkey) (import ./nix/hosts.nix);
in
with hosts;
{
  "hosts/aurelius/password.age".publicKeys = [ bemeurer aurelius ];
  "hosts/kant/ddclient.age".publicKeys = [ bemeurer kant ];
  "hardware/nixos-aarch64-builder/key.age".publicKeys = [ bemeurer aurelius camus deleuze foucault hegel ];
  "users/bemeurer/password.age".publicKeys = [ bemeurer ] ++ (attrValues hosts);
}
