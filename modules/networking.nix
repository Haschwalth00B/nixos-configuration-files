{ config, lib, pkgs, ... }:
{
  networking = {
    hostName = "nix-server";
    wireless.enable       = false;
    networkmanager.enable = false;

    # ── Static IP ───────────────────────────────────────────────────────────
    interfaces.enp2s0 = {
      ipv4.addresses = [{
        address      = "192.168.1.34";
        prefixLength = 24;
      }];
      ipv4.routes = [{
        address      = "0.0.0.0";
        prefixLength = 0;
        via          = "192.168.1.1";
      }];
    };

    resolvconf.enable = true;
    nameservers       = [ "1.1.1.1" "8.8.8.8" "8.8.4.4" ];

    # ── Firewall ─────────────────────────────────────────────────────────────
    # Disabled for now — fail2ban handles SSH brute-force protection.
    # To re-enable: set enable = true and open only the ports you need.
    firewall.enable = false;
  };

  # ── Network diagnostic tools ──────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    mtr          # traceroute + ping combined (TUI)
    nmap         # network scanner
    iftop        # live bandwidth by host
    tcpdump      # packet capture
    dig          # DNS lookup
    whois        # domain info
    ipcalc       # subnet calculator
    openssl      # TLS/cert inspection
  ];
}

