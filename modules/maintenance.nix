{ config, lib, pkgs, ... }:

{
  # Automatic system updates
  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
    allowReboot = false;  # Set to true if you want auto-reboot
  };

  # Automatic garbage collection
  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
    };
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
  };
}
