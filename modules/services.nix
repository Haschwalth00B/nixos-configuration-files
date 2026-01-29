{ config, lib, pkgs, ... }:

{
  # Samba file sharing
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    settings = {
      global = {
        workgroup = "WORKGROUP";
        "server string" = "Wandenreich";
        "log file" = "/var/log/samba/log.%m";
        "max log size" = 50;
        "map to guest" = "Bad User";
      };
      homes = {
        comment = "Home Directories";
        browseable = "yes";
        writable = "yes";
      };
    };
  };

  # Tailscale VPN
  services.tailscale.enable = true;

  # SSH server
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  # Laptop lid behavior (server mode)
  services.logind = {
    lidSwitch = "ignore";
    lidSwitchExternalPower = "ignore";
    lidSwitchDocked = "ignore";
  };
}
