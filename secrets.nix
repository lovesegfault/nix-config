let
  inherit (builtins) attrNames attrValues concatMap mapAttrs listToAttrs;

  nameValuePair = name: value: { inherit name value; };

  filterAttrs = pred: set:
    listToAttrs (concatMap (name: let v = set.${name}; in if pred name v then [ (nameValuePair name v) ] else [ ]) (attrNames set));

  mapAttrs' = f: set:
    listToAttrs (map (attr: f attr set.${attr}) (attrNames set));

  bemeurer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIQgTWfmR/Z4Szahx/uahdPqvEP/e/KQ1dKUYLenLuY2";

  hosts = mapAttrs
    (_: v: v.pubkey)
    (filterAttrs
      (_: v: !(v.hmOnly or false))
      (import ./nix/hosts.nix));
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
