{ config, lib, pkgs, ... }:

{
  networking = {
    hostName = "nix-server";
    wireless.enable = false;
    networkmanager.enable = false;
    
    # Static IP configuration for enp2s0
    interfaces.enp2s0 = {
      ipv4.addresses = [{
        address = "192.168.1.34";
        prefixLength = 24;
      }];
      ipv4.routes = [{
        address = "0.0.0.0";
        prefixLength = 0;
        via = "192.168.1.1";  # Gateway
      }];
    };
    
    resolvconf.enable = true;
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    firewall.enable = false;
  };
}
