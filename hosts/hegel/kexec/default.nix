{ lib, pkgs, ... }:
{
  environment.systemPackages = [
    (lib.hiPrio (pkgs.writeShellScriptBin "reboot" "systemctl start kexec.target"))
  ];
  systemd.services."kexec-load" = {
    unitConfig.DefaultDependencies = false;
    before = [ "prepare-kexec.service" ];
    path = with pkgs; [
      cpio
      gzip
      kexec-tools
    ];
    script = builtins.readFile ./kexec-load.sh;
    postStop = builtins.readFile ./kexec-load-cleanup.sh;
    serviceConfig.Type = "oneshot";
    wantedBy = [ "kexec.target" ];
  };
}
