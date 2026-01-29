{ config, lib, pkgs, ... }:

{
  powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor = "schedutil";
  };

  # Custom ASPM power management service
  systemd.services.autoaspm = {
    description = "Run autoaspm.py script at startup";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.python3}/bin/python3 /home/haschwalth/autoaspm/autoaspm.py";
      Restart = "on-failure";
      User = "root";
    };
    enable = true;
  };
}
