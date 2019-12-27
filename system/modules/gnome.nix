{ pkgs, ... }: { environment.systemPackages = with pkgs; [ qgnomeplatform ]; }
