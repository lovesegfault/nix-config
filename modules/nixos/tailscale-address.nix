# Custom option for Tailscale address used by various services
{ lib, ... }:
{
  options.networking.tailscaleAddress = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    description = "Tailscale IP address for this host, used for CORS and service bindings";
  };
}
