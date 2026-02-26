{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./modules/boot.nix
    ./modules/networking.nix
    ./modules/users.nix
    ./modules/packages.nix
    ./modules/services.nix
    ./modules/security.nix
    ./modules/power.nix
    ./modules/virtualization.nix
    ./modules/monitoring.nix
    ./modules/maintenance.nix
    ./modules/fonts.nix
    ./modules/shell.nix
  ];

  # ── Home Manager ──────────────────────────────────────────────────────────
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs   = true;
    backupFileExtension = "backup";
    users.haschwalth = import ./home/default.nix;
  };


  # ── Localization ──────────────────────────────────────────────────────────
  time.timeZone = "Asia/Kolkata";
  i18n = {
    defaultLocale    = "en_US.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" ];
  };
  # ── Nix ───────────────────────────────────────────────────────────────────
  nixpkgs.config.allowUnfree = true;

  # ── System state version (DO NOT CHANGE) ─────────────────────────────────
  system.stateVersion = "24.11";
}

