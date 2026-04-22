{ config, lib, pkgs, ... }:
{
  # ── Samba file sharing ────────────────────────────────────────────────────
  services.samba = {
    enable      = true;
    openFirewall = true;
    settings = {
      global = {
        security         = "user";
        workgroup        = "WORKGROUP";
        "server string"  = "Wandenreich";
        "log file"       = "/var/log/samba/log.%m";

        "max log size"   = 50;
        "map to guest"   = "Bad User";
        # Improve discovery on modern clients
        "min protocol"   = "SMB2";


        # ── Unicode / filename mangling fix ───────────────────────────────
        "mangled names"  = "no";
        "unix charset"   = "UTF-8";
        "vfs objects"    = "catia fruit streams_xattr";
        "catia:mappings" = "0x22:0xa8,0x2a:0xa4,0x2f:0xf8,0x3a:0xf7,0x3c:0xab,0x3e:0xbb,0x3f:0xbf,0x5c:0xff,0x7c:0xa6";
      };
      homes = {
        comment    = "Home Directories";
        browseable = "yes";
        writable   = "yes";
        # Restrict to local network only
        "hosts allow" = "192.168.1.0/24 127.0.0.1";
      };
    };
  };

  # Samba NetBIOS discovery
  services.samba-wsdd = {
    enable    = true;
    openFirewall = true;
  };

  # ── Tailscale VPN ─────────────────────────────────────────────────────────
  services.tailscale.enable = true;

  # ── SSH ───────────────────────────────────────────────────────────────────
  # Hardening options are in modules/security.nix
  services.openssh = {
    enable = true;
    openFirewall = true;
  };

  # ── Avahi mDNS (LAN hostname discovery: nix-server.local) ─────────────────
  services.avahi = {
    enable   = true;
    nssmdns4 = true;
    publish = {
      enable      = true;
      addresses   = true;
      workstation = true;
    };
  };

  # ── Laptop lid in server mode ─────────────────────────────────────────────
  services.logind.settings.Login = {

    HandleLidSwitch              = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked        = "ignore";
  };

  # ── Cron (handy for scheduled tasks) ─────────────────────────────────────
  services.cron.enable = true;
}
