{ config, lib, pkgs, ... }:

{
  # ── Samba file sharing ─────────────────────────────────────────────────────
  services.samba = {
    enable       = true;
    openFirewall = true;  # opens 139/445 TCP + 137/138 UDP
    settings = {
      global = {
        security        = "user";
        workgroup       = "WORKGROUP";
        "server string" = "Wandenreich";
        "log file"      = "/var/log/samba/log.%m";
        "max log size"  = 50;

        # Changed from "Bad User" which silently lets failed logins in as guest.
        # Run: sudo smbpasswd -a haschwalth   ← do this once after rebuild!
        "map to guest"  = "Never";

        # LAN only
        "hosts allow"   = "192.168.1. 127.0.0.1";
        "hosts deny"    = "0.0.0.0/0";
      };
      homes = {
        comment       = "Home Directories";
        browseable    = "no";
        writable      = "yes";
        "valid users" = "%S";
      };
    };
  };

  # mDNS — reach this box as nix-server.local from any device on your LAN
  services.avahi = {
    enable   = true;
    nssmdns4 = true;
    publish = {
      enable      = true;
      addresses   = true;
      workstation = true;
    };
  };

  # ── Tailscale VPN ──────────────────────────────────────────────────────────
  services.tailscale.enable = true;

  # ── SSH server ─────────────────────────────────────────────────────────────
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin              = "no";
      PasswordAuthentication       = true;  # kept on — you SSH from multiple devices
      KbdInteractiveAuthentication = true;
      MaxAuthTries                 = 4;     # still limit guesses per connection
      LoginGraceTime               = 30;    # 30s to authenticate before disconnect
    };
  };

  # ── Fail2ban — essential when password auth is on ─────────────────────────
  # Bans IPs after repeated failed logins. With password auth enabled this is
  # not optional — it's what keeps your server from being brute-forced.
  services.fail2ban = {
    enable    = true;
    maxretry  = 5;
    bantime   = "1h";
    bantime-increment = {
      enable     = true;
      multipliers = "1 2 4 8 16 32 64";
      maxtime    = "168h";  # cap at 1 week for persistent offenders
    };
    jails.sshd.settings = {

      enabled  = true;
      port     = "ssh";
      filter   = "sshd";
      logpath  = "/var/log/auth.log";
      maxretry = 3;
    };
  };

  # ── Disk health monitoring ─────────────────────────────────────────────────
  services.smartd = {
    enable     = true;
    autodetect = true;
    notifications.wall.enable = true;
  };

  # ── Laptop-as-server: ignore lid events ────────────────────────────────────
  services.logind.settings.Login = {
    HandleLidSwitch              = "ignore";
    HandleLidSwitchDocked        = "ignore";
    HandleLidSwitchExternalPower = "ignore";
  };
}

