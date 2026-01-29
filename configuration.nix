{ config, lib, pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
in
{

  imports = [
    ./hardware-configuration.nix
    ./modules/boot.nix
    ./modules/networking.nix
    ./modules/users.nix
    ./modules/packages.nix
    ./modules/services.nix
    ./modules/power.nix
    ./modules/virtualization.nix
    ./modules/maintenance.nix
    (import "${home-manager}/nixos")
  ];

  # Home Manager configuration
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    users.haschwalth = import ./home.nix;
  };

  # Localization
  time.timeZone = "Asia/Kolkata";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System state version (DO NOT CHANGE)
  system.stateVersion = "24.11";
}
