{ config, lib, pkgs, ... }:

{
  networking = {
    hostName              = "nix-server";
    wireless.enable       = false;
    networkmanager.enable = false;

    # Static IP on LAN interface
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
    nameservers = [ "1.1.1.1" "8.8.8.8" ];

    firewall = {
      enable = true;

      allowedTCPPorts = [
        22    # SSH
        # 80  # HTTP  — uncomment if you expose a web server
        # 443 # HTTPS — uncomment if you expose a web server
      ];

      # Trust the Docker bridge interface.
      # Without this, the firewall's FORWARD DROP policy can interfere with
      # container-to-container traffic and internet access from inside containers.
      # tailscale0 is auto-trusted by services.tailscale, listed here for clarity.
      trustedInterfaces = [ "docker0" "tailscale0" ];

      # "loose" lets Tailscale (and Docker NAT) work correctly.
      # "strict" (the default) drops packets whose return path doesn't match
      # the incoming interface — which breaks both Tailscale routing and
      # Docker's masquerade NAT.
      checkReversePath = "loose";

      # Allow all traffic from your LAN — covers Samba, mDNS, code-server,
      # and anything else you run that you haven't explicitly opened above.
      extraCommands = ''
        iptables -I INPUT -s 192.168.1.0/24 -j ACCEPT
      '';
      extraStopCommands = ''
        iptables -D INPUT -s 192.168.1.0/24 -j ACCEPT || true
      '';
    };
  };
}

