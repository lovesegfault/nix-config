{ lib, pkgs, ... }:
with lib;
{
  services.geoclue2.appConfig.localtimed = {
    isAllowed = true;
    isSystem = true;
    users = [ "325" ];
  };

  # Install the polkit rules.
  environment.systemPackages = [ pkgs.localtime ];

  systemd.services.localtimed = {
    wantedBy = [ "multi-user.target" ];
    partOf = [ "localtimed-geoclue-agent.service" ];
    after = [ "localtimed-geoclue-agent.service" ];
    serviceConfig = {
      ExecStart = "${pkgs.localtime}/bin/localtimed";
      Restart = "on-failure";
      Type = "exec";
      User = "localtimed";
    };
  };

  systemd.services.localtimed-geoclue-agent = {
    wantedBy = [ "multi-user.target" ];
    partOf = [ "geoclue.service" ];
    after = [ "geoclue.service" ];
    serviceConfig = {
      ExecStart = "${pkgs.geoclue2-with-demo-agent}/libexec/geoclue-2.0/demos/agent";
      Restart = "on-failure";
      Type = "exec";
      User = "localtimed";
    };
  };

  users.users.localtimed.uid = 325;
  users.users.localtimed.group = "localtimed";
}
