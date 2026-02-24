{ config, lib, pkgs, ... }:

{
  # ── Automatic flake-aware system upgrades ─────────────────────────────────
  system.autoUpgrade = {
    enable      = true;
    flake       = "/etc/nixos";          # required for flake-based configs
    flags       = [ "--update-input" "nixpkgs" "--commit-lock-file" ];
    dates       = "Sun 03:00";           # every Sunday at 3 AM
    allowReboot = false;                 # flip to true for unattended reboots
  };

  # ── Nix daemon settings ────────────────────────────────────────────────────
  nix = {
    # Garbage-collect old generations daily; keep the last 7 days
    gc = {
      automatic = true;
      dates     = "daily";
      options   = "--delete-older-than 7d";
    };

    # Run store optimisation (hard-link dedup) on a systemd timer
    # instead of inline during builds – safer on multi-core machines.
    optimise.automatic = true;

    settings = {
      # NOTE: experimental-features is declared in configuration.nix
      keep-outputs     = true;   # keep build-time deps so dev shells stay fast
      keep-derivations = true;   # keep .drv files for nix-store queries
      max-jobs         = "auto"; # use all cores for builds
      cores            = 0;      # 0 = all available cores per job
    };
  };
}

