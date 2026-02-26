{ config, lib, pkgs, ... }:
{
  # ── Nix daemon settings ────────────────────────────────────────────────────
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store   = true;

      # Speed up builds — use all available cores
      max-jobs = "auto";
      cores    = 0;         # 0 = use all cores for each job

      # Binary caches
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCUSPDI="
      ];
    };

    # ── Garbage collection ───────────────────────────────────────────────────
    gc = {
      automatic = true;
      dates     = "weekly";           # less aggressive — daily was overkill
      options   = "--delete-older-than 14d";  # keep 2 weeks of generations
    };
  };

  # ── Automatic system upgrades ─────────────────────────────────────────────
  system.autoUpgrade = {
    enable      = true;
    dates       = "Mon 03:00";    # weekly on Monday at 3am
    allowReboot = false;
  };
}

